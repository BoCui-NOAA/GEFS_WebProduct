
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
tmpdir=/gpfstmp/$uname/vfs   

if [ -s $tmpdir ]; then
# rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi
pwd

CDATE=2001040100

###
### 2. Set up the climate data, grib utility entry and verified data entry..
###

dat=/nfsuser/g01/wx20yz/gvrfy/data
windex=/nwprod/util/exec/grbindex           
nhours=/nwprod/util/exec/ndate
COPYGB=/nwprod/util/exec/copygb

fdir=/global/prs
ddir=/global/prs
#fdir=/emc3/wx23sm/datprcw             
#ddir=/emc3/wx23sm/datprcw             

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
if [ $ih -eq 0 ]; then
 ih=00
fi
YMDH=`$nhours +$ih $CDATE`

PGBLEN=`wgrib -V $fdir/pgbf00.$YMDH | grep nxny | sed -n '1 p' | awk '{print $9}'`
echo " $fdir/pgbf00.$YMDH has length of $PGBLEN "
if [ $PGBLEN -eq 10512 ]; then
 cp $ddir/pgbf00.$YMDH .
 $windex pgbf00.$YMDH pgbf00.$YMDH.index
elif [ $PGBLEN -eq 65160 ]; then
 echo " Reduceing resolution fron 1*1 to 2.5*2.5 "
 $COPYGB -g2 $ddir/pgbf00.$YMDH pgbf00.$YMDH.index pgbf00.$YMDH
 $windex pgbf00.$YMDH pgbf00.$YMDH.index
 ls -l pgbf00.$YMDH
else
 echo " The program is not support this resolution ($PGBLEN) yet "
# exit 8
fi


PGBLEN=`wgrib -V $fdir/pgbf$ih.$CDATE | grep nxny | sed -n '1 p' | awk '{print $9}'`
echo " $fdir/pgbf$ih.$CDATE has length of $PGBLEN "
cp $fdir/pgbf$ih.$CDATE .
$windex pgbf$ih.$CDATE pgbf$ih.$CDATE.index
if [ $PGBLEN -eq 10512 ]; then
 cp $fdir/pgbf$ih.$CDATE .
 $windex pgbf$ih.$CDATE pgbf$ih.$CDATE.index
elif [ $PGBLEN -eq 65160 ]; then
 echo " Reduceing resolution fron 1*1 to 2.5*2.5 "
 $COPYGB -g2 $fdir/pgbf$ih.$CDATE pgbf$ih.$CDATE.index pgbf$ih.$CDATE
 $windex pgbf$ih.$CDATE pgbf$ih.$CDATE.index
 ls -l pgbf$ih.$CDATE
else
 echo " The program is not support this resolution ($PGBLEN) yet "
# exit 8
fi

(( istep += 1 ))

echo " cfilea(1,$istep)='pgbf00.$YMDH', "      >>input1
echo " cfilea(2,$istep)='pgbf00.$YMDH.index'," >>input1
echo " cfilef(1,$istep)='pgbf$ih.$CDATE',  "     >>input1
echo " cfilef(2,$istep)='pgbf$ih.$CDATE.index'," >>input1

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

/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0006  <INPUT 
#/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0006  <INPUT  2>/dev/null
cat scores.out 

