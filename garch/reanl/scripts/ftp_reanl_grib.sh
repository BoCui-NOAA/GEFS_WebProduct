#!/bin/sh
if [ $# -ne 4 ] ; then 
	echo "Usage: $0 output_directory yyyy mm pgb.f00|pgb.f06|grb2d|pgb.|ipvanl "
	echo " "
	echo "$0 ftp, untar monthly reanalysis grib files"
	echo " "
	echo "$0 first checks whether ~/.netrc is properly configured"
	echo "if the file or entry is missing, the requisite entry is described"
	echo ""
	echo "The sgi107 /dmf_archive tarfile name is assembled and ftp-ed"
	echo "Retrieval and ftping take several minutes...please be patient"
	echo "All 4xdaily {00,06,12,18} gribfiles for the requested yyyy/mm are untarred"
	echo "the tarfile and the internal scripts and tables are deleted"
	echo " "
	exit 1 
fi
if [ -s /u/wx20yz/.netrc ] ; then 
	grep '192.58.232.23' /u/wx20yz/.netrc >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
		echo "your /u/wx20yz/.netrc file must contain the following line"
		echo "machine 192.58.232.23 login 'login_id' password #####"
		exit 1
	fi
else
	echo "you must create file ~/.netrc with entry:"
	echo "machine 192.58.232.23 login 'login_id' password #####"
	echo " then run comand 'chmod 700 ~/.netrc'"
	exit 1
fi
set -euax

dir=$1
yyyy=$2
mm=$3
file=$4
match=0
griblist="pgb.f00 pgb.f06 ipvanl grb2d grb3d pgb." 
for grib in $griblist ;do
if [ $grib = $file ] ;then match=1;break;fi
done
if [ $match -eq 0 ] ; then 
	echo "requested grib file $file not one of: $griblist";exit 1
fi

cc=`echo $yyyy|cut -c1-2`
yy=`echo $yyyy|cut -c3-4`
yymm=$yy$mm

#. /nfsuser/g01/wx23bk/cdas/ush/EXP_ID.sh
cat <<\EOF >./EXP_ID.sh
	yy=`echo $yyyy|cut -c3-4`
	if [ $yyyy -le 1957 ] ; then EXP_ID=v57 ; fi
	if [ $yyyy -eq 1982 ] ; then EXP_ID=v42 ; fi
	if [ $yyyy -eq 1983 ] ; then EXP_ID=v42 ; fi
	if [ $yyyy -eq 1984 ] ; then EXP_ID=v50 ; fi
	#if [ $yyyy -ge 1985 ] ; then EXP_ID=v02 ; fi
	if [ $yyyy -ge 1985 ] ; then EXP_ID=v50 ; fi
	if [ $yyyy -ge 1986 ] ; then EXP_ID=v02 ; fi
	set +u
	if [ $yyyy -eq 1987 ] ; then
		if [ -z "$yymm" ] ; then     
			echo "yymm not f=defined for $yyyy" 
			echo "yymm not f=defined for $yyyy" | mail $LOGNAME
			exit 8
		else
			if [ $yymm -ge 8707 -a $yymm -le 8712 ] ; then 
				EXP_ID=v03 
			else
				EXP_ID=v02 
			fi
		fi
	fi
	set -u
	if [ $yyyy -eq 1988 ] ; then EXP_ID=v03 ; fi
	if [ $yyyy -eq 1989 ] ; then EXP_ID=v03 ; fi
	if [ $yyyy -eq 1990 ] ; then EXP_ID=v04 ; fi
	if [ $yyyy -eq 1991 ] ; then EXP_ID=v41 ; fi
	if [ $yyyy -eq 1992 ] ; then EXP_ID=v43 ; fi
	if [ $yyyy -eq 1993 ] ; then EXP_ID=v43 ; fi
	if [ $yyyy -eq 1994 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1995 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1996 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1997 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1998 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -ge 1999 ] ; then EXP_ID=v54 ; fi
	if [ $yyyy -eq 1979 ] ; then EXP_ID=v53 ; fi
	if [ $yyyy -eq 1980 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1981 ] ; then EXP_ID=v51 ; fi
	temp=$yy
	for yy in 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78
	do
		if [ $yyyy -eq 19$yy ] ; then EXP_ID=v51 ; fi
	done
	yy=$temp
EOF
chmod 755 ./EXP_ID.sh

cat <<\EOF >./volset_tapes
a01   grb3d  24672    grib   first   14  45 CART troom  nopole  	no   0
a02  prepqm  18277    bufr   first    3  34 CART troom  nopole		no   3
a03 grbsanl  12879    grib   second  11  24 CART troom  nopole		cac 03
a04 grbsf06  12889    grib   second  11  24 CART troom  nopole		no  03
a05    recv  11646  binary   first   14  22 CART troom  nopole		cac 03
a06    fcst   6993  binary   first   14  21 SILO silo   nopole		no  03
a07      2D   6045    grib   third    6  12 SILO troom  nopole		no   0
a08   theta   5121    grib   third    5  10 SILO troom  nopole		no   0
a09 pgb.f00   5494    grib   second  14  10 CART silo   pole_fix	cac 03
a10 pgb.f06   5492    grib   second  14  10 CART silo   pole_fix	cac 03
a11     prs   4869    grib   third    6   9 SILO troom  pole_fix	no   0
a12   grb2d   4476    grib   first    4   9 CART silo   nopole		cac  0
a13     cqc   3400   ascii   first    1   7 SILO troom  nopole		no   3
a14  ipvanl   3600    grib   second   4   7 CART silo   nopole		cac  0
a15    ieee   1163    ieee   third    2   3 SILO troom  pole_fix	no   0
a16    oiqc   1119  binary   first    1   3 CART troom  nopole		no   3
a17   print   1465   ascii   first    1   3 CART troom  nopole		no   3
a18   cdrom    610    grib   third    2   3 SILO troom  pole_fix	no   0
a19      3D    478    grib   second   1   1 SILO silo   nopole		no   0
a20     znl    204  binary   first    1   1 SILO troom  nopole		no  03
a21    grib    464    grib   third    1   1 SILO silo   pole_fix	no   0
a22    misc    327  binary   third    1   1 SILO troom  nopole		no   0
a23   daily    544    grib   third    2   1 SILO silo   pole_fix	no   0
a24   sigma     57  binary   third    1   1 SILO troom  nopole		no   0
a25  optavg     83  binary   second   1   1 SILO troom  nopole		no   3	
a26     mrf     83  binary   second   8   1 SILO silo   nopole		no   3
EOF
chmod 755 ./volset_tapes
cat <<\EOF >./volset_file
       cdrom       cdrom     610	grib	third   no      no
       daily       daily     544	grib	third   no      no
        grib        grib     464	grib	third   no      no
          2D          2D    6045	grib	third   no      no
          3D          3D     478	grib	third   no      no
         prs         prs    4869	grib	third   no      no
       theta       theta    5121	grib	third   no      no
        ieee        ieee    1163	ieee	third   no      no
        misc        misc     327	binary	third   no      no
       sigma       sigma      57	binary	third   no      no
      prepqm      prepqm   18277	bufr	first   backup	no
       print        OUT2    1465	ascii	first   no      compress
         cqc        cqb2       6	ascii	first   no      compress
         cqc        cqe2      76	ascii	first   no      compress
         cqc        cqo2    2376	ascii	first   no      compress
         cqc        cqt2    1133	ascii	first   no      compress
        recv        sges    6993	binary	first   no    	no
        recv        bges    4389	binary	first   no    	compress
        fcst        sanl    6993	binary	first   backup	no
        fcst      sfcanl    4389	binary	first   backup  compress
      optavg      optavg      83	binary	second  no      compress
         znl     znl.f00     204	binary	first   no      compress
         znl     znl.f06     204	binary	first   no      compress
        oiqc     tosscat    1119	binary	first   no      compress
        oiqc obogram.bin     190	binary	first   no      compress
       grb2d       grb2d    4476	grib	first   no      no
       grb3d       grb3d   24672	grib	first   no      compress
      ipvanl      ipvanl    3600	grib	second  no      no
     grbsanl     grbsanl   12879	grib	second  no      no
     grbsf06     grbsf06   12889	grib	second  no      no
     pgb.f00     pgb.f00    5494	grib	second  no      no
     pgb.f06     pgb.f06    5492	grib	second  no      no
EOF
chmod 755 ./volset_file
#. /nfsuser/g01/wx23bk/cdas/ush/file2volset.sh
cat <<\EOF >./file2volset.sh
#volsetlist=/nfsuser/g01/wx23bk/cdas/parm/volset_tapes
#filelist=/nfsuser/g01/wx23bk/cdas/parm/volset_file
volsetlist=./volset_tapes
filelist=./volset_file
#. /nfsuser/g01/wx23bk/cdas/ush/EXP_ID.sh
. ./EXP_ID.sh
nl=`cat $filelist|wc -l`
n=0;volname=""
while [ $n -lt $nl ]      
do
	n=`expr $n + 1`
	line=`sed -n $n,${n}p $filelist` 
	testfile=`echo $line | awk '{print $2}'`
	if [ "$file" = "$testfile" ] ; then 
		volname=`echo $line | awk '{print $1}'`
		break 
	fi
done
#. $SCRIPTS/CRL_ID.sh
if [ -n "$volname" ] ; then
	volindex=`awk '$2~/'"$volname"'/{print $1}' $volsetlist`
	#volset=$CRL_ID/$EXP_ID.$volindex.$yyyy
	volset=$EXP_ID.$volindex.$yyyy
else
	if [ $file = pgb. -o $file = flux. ] ; then
	#volset=$CRL_ID/$EXP_ID.a26.$yyyy
	volset=$EXP_ID.a26.$yyyy
	fi
fi
EOF
chmod 755 ./file2volset.sh

. ./file2volset.sh
tapefile=`echo $file$yy$mm|tr "[a-z]" "[A-Z]"`
tarfile=$file$yy$mm

cd $dir
ftp -vi 192.58.232.23 <<EOF
bin
cd /dmf_archive/cray5/dm/reanl1/$volset
get $tapefile
EOF
if [  -s $tapefile ] ; then
	tar -xvf $tapefile 
	rm $tapefile ./EXP_ID.sh ./volset_tapes ./volset_files ./file2volset.sh

else 
	echo "Uable to find sgi107:/dmf_archive/cray5/dm/reanl1/$volset"
	echo "Notify Bob Kistler bkistler@ncep.noaa.gov 301-763-8000x7232"
	exit 1
fi
