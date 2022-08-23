
###
### This script will RUN experiment verification
###      output format will be the same as operational
###      operational scores are stored in /global/vrfy/SCORESs.[yyyymmdd]
###
###      By Yuejian Zhu (08/03/00)
###
### Note: Input PGB file should be in 2.5*2.5 degree resolution

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

CDATE=2001011500

###
### 2. Set up the climate data, grib utility entry and verified data entry..
###

dat=/nfsuser/g01/wx20yz/gvrfy/data
windex=/nwprod/util/exec/grbindex           
nhours=/nwprod/util/exec/ndate

fdir=/global/prx
ddir=/global/prx

###
### 3. Set up the input file names and control parameters
###

###  Notes:
###        1. ihem                           
###           1=NH    20N-80N      0E-357.5E (la1=6,la2=29,lo1=1,lo2=144)
###           2=SH    20S-80S      0E-357.5E (la1=45,la2=68,lo1=1,lo2=144)
###           3=TP    20S-20N      0E-357.5E (la1=29,la2=45,lo1=1,lo2=144)
###           4=N Am  25N-65N    235E-295E   (la1=12,la2=27,lo1=95,lo2=119)
###           5=Europ 35N-70N      0E- 30E   (la1=10,la2=23,lo1=1,lo2=13)
###           6=Asia  25N-70N     65E-145E   (la1=10,la2=27,lo1=27,lo2=59)
###           7=JMA   15N-50N     90E-170E   (la1=18,la2=31,lo1=37,lo2=69)
###
###        2. lat   = (1=north pole 73=south pole )
###        3. iclim = (0=cpc climatology 1=reanlysis climatology)
###        4. ic    = (1=wave group 0=grid)
###        5. ifd   = (7=Z,33=u,34=v,101=wind speed,102=wind vector)


###
###  Example for operational verification setup.
###

iclime=0
iclimt=1

nh=192

### Assume you don't have index files

ndays=`expr $nh / 24`
nstep=`expr $ndays + 1`
istep=0

echo " &files "                                   >input1

cp $ddir/pgbf00.$CDATE .
$windex pgbf00.$CDATE pgbf00.$CDATE.index

while [ $istep -lt $nstep ]; do

ih=`expr $istep \* 24`
if [ $ih -eq 0 ]; then
 ih=00
fi
YMDH=`$nhours -$ih $CDATE`
YMD=`echo $CDATE | cut -c1-8`

cp $fdir/pgbf$ih.$YMDH .
$windex pgbf$ih.$YMDH pgbf$ih.$YMDH.index

(( istep += 1 ))

echo " cfilea(1,$istep)='pgbf00.$CDATE', "      >>input1
echo " cfilea(2,$istep)='pgbf00.$CDATE.index'," >>input1
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
 ihem=4,la1=12,la2=27,lo1=95,lo2=119,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclime,ic=0
 /
 &namin
 ihem=4,la1=12,la2=27,lo1=95,lo2=119,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclime,ic=0
 /
 &namin
 ihem=5,la1=10,la2=23,lo1=1,lo2=13,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclime,ic=0
 /
 &namin
 ihem=5,la1=10,la2=23,lo1=1,lo2=13,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclime,ic=0
 /
 &namin
 ihem=6,la1=10,la2=27,lo1=27,lo2=59,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclime,ic=0
 /
 &namin
 ihem=6,la1=10,la2=27,lo1=27,lo2=59,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclime,ic=0
 /
 &namin
 ihem=7,la1=18,la2=31,lo1=37,lo2=69,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclime,ic=0
 /
 &namin
 ihem=7,la1=18,la2=31,lo1=37,lo2=69,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclime,ic=0
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

/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_naos  <INPUT 
cat scores.out 
cp  scores.out  /global/naos/SCORESx.$YMD  

