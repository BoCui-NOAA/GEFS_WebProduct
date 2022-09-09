#!/bin/sh
if [ $# -lt 2 -o $# -gt 3 ] ; then echo "Usage: $0 dir cdate [cdate2] ";exit 1 ;fi
set -eux
NDATE=/nwprod/util/exec/ndate
FINC=${FINC:-24}
export FHMAX=${FHMAX:-240}
export FHOUT=${FHOUT:-12}
export FHINI=${FHINI:-00}
dir=$1
cd $dir
cdate=$2;if [ $# -eq 3 ] ; then cdate2=$3;else cdate2=$cdate;fi
while [ $cdate -le $cdate2 ] ;do
	file=/global/ecm/pgbanl.$cdate
	if [ ! -s $file ] ; then echo $file missing; exit 1 ;fi
	#ln -sf $file pgbf00.$cdate
	#/nfsuser/g01/wx20mi/bin/ecretag.x $file pgbf00.$cdate
	/nfsuser/g01/wx23bk/ecm/ecm_gfs_look_alike $file pgbanl.$cdate
	ln -sf  pgbanl.$cdate pgbf00.$cdate
	set +e;rm $(basename $file).ctl $(basename $file).idx ;set -e
	$WGRIB pgbf00.$cdate|head

	fhr=-$FHINI; while [ $((fhr=10#$fhr+$FHOUT)) -le $FHMAX ] ; do
		[ ${#fhr} -lt 2 ] && fhr=0$fhr
		file=/global/ecm/pgbf$fhr.$cdate
		if [ ! -s $file ] ; then echo $file missing; exit 1 ;fi
		#ln -sf $file pgbf$fhr.$cdate
		prev=""
		[ $fhr -ge 24 ] && prev=/global/ecm/pgbf$((fhr-12)).$cdate
		/nfsuser/g01/wx23bk/ecm/ecm_gfs_look_alike $file  pgbf$fhr.$cdate $prev
		$WGRIB pgbf$fhr.$cdate|head
		#read yn
	done

	$s1/grib2ctl.sh `pwd`/pgbf%f2.$cdate
	cdate=$($NDATE $FINC $cdate)
done
