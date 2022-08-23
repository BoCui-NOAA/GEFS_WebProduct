
###
### This script will RUN experiment verification
###      output format will be the same as operational
###      operational scores are stored in /global/vrfy/SCORESs.[yyyymmdd]
###
###      By Yuejian Zhu (08/03/00)
###
### Note: Input PGB file should be in 2.5*2.5 degree resolution
###       Adding option for high ( 1*1 degree) resolution input.
###        program will reduce resolution to 2.5*2.5 degree
###       --- Yuejian Zhu (04/17/2001)

#set -x
date;pwd

###
### 1. Set up the temperally directory and set up CDATE  
###

uname=` who am i | awk '{print $1}' `
tmpdir=/gpfstmp/wx20yz/vfs   
#tmpdir=/ptmp/wx20yz/vfs   

if [ -s $tmpdir ]; then
# rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi
pwd

CDATE=$CDATE          
YMD=`echo $CDATE | cut -c1-8`

###
### 2. Set up the climate data, grib utility entry and verified data entry..
###

dat=/nfsuser/g01/wx20yz/gvrfy/data
windex=/nwprod/util/exec/grbindex           
nhours=/nwprod/util/exec/ndate
COPYGB=/nwprod/util/exec/copygb

#fdir=/global/prs
#ddir=/global/prs
#fdir=/ptmp/wx20yz/comp/prs            
#ddir=/ptmp/wx20yz/comp/prs            
fdir=/global/pra                  
ddir=/global/pra                      

###
### 3. Set up the input file names and control parameters
###

###  Notes:
###        1. ihem  = (1=NH 2=SH 3=TP)       
###        2. lat   = (1=north pole 73=south pole )
###        3. iclim = (0=cpc climatology 1=reanlysis climatology)
###        4. ic    = (1=wave group 0=grid)
###        5. ifd   = (7=Z,33=u,34=v,101=wind speed,102=wind vector)

###
###  Example for operational verification setup.
###

iclime=0
iclimt=1

nh=384

### Assume you don't have index files

ndays=`expr $nh / 24`
nstep=`expr $ndays + 1`
istep=0

echo " &files "                                   >input1

while [ $istep -lt $nstep ]; do

ih=`expr $istep \* 24`
ihm1=`expr $istep \* 24` 
ihm1=`expr $ihm1 - 24`

if [ $ih -eq 0 ]; then
 ih=00
fi
if [ $ihm1 -le 0 ]; then
 ihm1=00
fi
YMDH=`$nhours -$ih $CDATE`
if [ $ih -le 0 ]; then
YMDHM1=$YMDH
else
YMDHM1=`$nhours +24 $YMDH`
fi

#echo step=$istep ih=$ih ymdh=$YMDH ihm1=$ihm1 ymdhm1=$YMDHM1

PGBLEN=`wgrib -V $ddir/pgbf$ihm1.$YMDHM1 | grep nxny | sed -n '1 p' | awk '{print $9}'`
echo " $ddir/pgbf$ihm1.$YMDHM1 has length of $PGBLEN "
if [ $PGBLEN -eq 10512 ]; then
 cp $ddir/pgbf$ihm1.$YMDHM1 pgaf$ihm1.${YMDHM1}
 $windex pgaf$ihm1.${YMDHM1} pgaf$ihm1.${YMDHM1}.index
elif [ $PGBLEN -eq 65160 ]; then
 echo " Reduceing resolution fron 1*1 to 2.5*2.5 "
 $COPYGB -g2 $ddir/pgbf$ihm1.$YMDHM1 pgbf$ihm1.$YMDHM1.index pgaf$ihm1.${YMDHM1}
 $windex pgaf$ihm1.${YMDHM1} pgaf$ihm1.${YMDHM1}.index
 ls -l pgaf$ihm1.${YMDHM1} 
else
 echo " The program is not support this resolution ($PGBLEN) yet "
# exit 8
fi

PGBLEN=`wgrib -V $fdir/pgbf$ih.$YMDH | grep nxny | sed -n '1 p' | awk '{print $9}'`
echo " $fdir/pgbf$ih.$YMDH has length of $PGBLEN "
if [ $PGBLEN -eq 10512 ]; then
 cp $fdir/pgbf$ih.$YMDH .
 $windex pgbf$ih.$YMDH pgbf$ih.$YMDH.index
elif [ $PGBLEN -eq 65160 ]; then
 echo " Reduceing resolution fron 1*1 to 2.5*2.5 "
 $COPYGB -g2 $fdir/pgbf$ih.$YMDH pgbf$ih.$YMDH.index pgbf$ih.$YMDH
 $windex pgbf$ih.$YMDH pgbf$ih.$YMDH.index
 ls -l pgbf$ih.$YMDH
else
 echo " The program is not support this resolution ($PGBLEN) yet "
# exit 8
fi

(( istep += 1 ))

echo " cfilea(1,$istep)='pgaf$ihm1.${YMDHM1}', "      >>input1
echo " cfilea(2,$istep)='pgaf$ihm1.${YMDHM1}.index'," >>input1
echo " cfilef(1,$istep)='pgbf$ih.$YMDH',  "     >>input1
echo " cfilef(2,$istep)='pgbf$ih.$YMDH.index'," >>input1

done

echo " / "                                      >>input1

cat <<paramEOF >input2
 &namin
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclime,ic=1
 /
 &namin
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclime,ic=1
 /
 &namin
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclime,ic=1
 /
 &namin
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclime,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=33,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=34,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=101,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=102,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=33,ilv=200,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=34,ilv=200,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=101,ilv=200,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=102,ilv=200,iclim=$iclimt,ic=1
 /
paramEOF

cat input1 input2 >INPUT
cat INPUT

ls -l pgbf*

cd $tmpdir

/nfsuser/g01/wx20yz/gvrfy/sorc/vrfy_0006_vs1d  <INPUT 
#/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0006  <INPUT  2>/dev/null
cat scores.out 
#cp scores.out  /global/help/wx20mi/SCOREShp.$YMD     

rm $tmpdir/pgbf*
rm $tmpdir/pgaf*

