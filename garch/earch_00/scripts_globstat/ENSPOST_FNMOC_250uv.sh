### example 1
#!/bin/sh
#@ job_type = parallel
#@ output = /tmp/wx20yz/earch.o$(jobid)
#@ error = /tmp/wx20yz/earch.e$(jobid)
#@ total_tasks = 30
#@ node = 30
#@ node_usage = shared
#@ requirements = Feature != "beta"
#@ network.MPI=switch,not_shared,us
#@ class = dev
#@ account_no = GEN-MTN
#
#@ queue
#

#set -xS

## This scripts to convert FNMOC pgrba file to enspost and archive
##  --- Yuejian Zhu (08/04/2008)

export CDATE=$CDATE
export yyyymm=`echo $CDATE | cut -c1-6`
export dd=`echo $CDATE | cut -c7-8`
export hh=`echo $CDATE | cut -c9-10`

TMPDIR=$PTMP/$LOGNAME/ENS_FNMOC_$hh

if [ ! -s $TMPDIR ]; then
mkdir -p $TMPDIR
fi
cd $TMPDIR;pwd;rm $TMPDIR/*

ENSADD=$SHOME/$LOGNAME/earch/scripts/ensadd.sh
odir=$COM/fnmoc/prod                
export odir=/com/fnmoc/prod                
export odir=/com/fnmoc/para                
ndir=$GLOBAL/fno_ens

if [ $hh -eq 12 ]; then
 odir=/com/fnmoc/prod                
 odir=/com/fnmoc/para                
fi
#set -x

for dd in $dd                                     
do

for hh in $hh   
do

>$ndir/u250.$yyyymm$dd$hh
>$ndir/v250.$yyyymm$dd$hh

for num in ctl p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 p11 p12 p13 p14 p15 p16 p17 p18 p19 p20
do

   case $num in
      ctl) e1=1;e2=1;echo $e1$e2;;
      p01) e1=3;e2=1;echo $e1$e2;;
      p02) e1=3;e2=2;echo $e1$e2;;
      p03) e1=3;e2=3;echo $e1$e2;;
      p04) e1=3;e2=4;echo $e1$e2;;
      p05) e1=3;e2=5;echo $e1$e2;;
      p06) e1=3;e2=6;echo $e1$e2;;
      p07) e1=3;e2=7;echo $e1$e2;;
      p08) e1=3;e2=8;echo $e1$e2;;
      p09) e1=3;e2=9;echo $e1$e2;;
      p10) e1=3;e2=10;echo $e1$e2;;
      p11) e1=3;e2=11;echo $e1$e2;;
      p12) e1=3;e2=12;echo $e1$e2;;
      p13) e1=3;e2=13;echo $e1$e2;;
      p14) e1=3;e2=14;echo $e1$e2;;
      p15) e1=3;e2=15;echo $e1$e2;;
      p16) e1=3;e2=16;echo $e1$e2;;
      p17) e1=3;e2=17;echo $e1$e2;;
      p18) e1=3;e2=18;echo $e1$e2;;
      p19) e1=3;e2=19;echo $e1$e2;;
      p20) e1=3;e2=20;echo $e1$e2;;
   esac

>ge$num.u250
>ge$num.v250

for fhr in 00 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 360 372 384
do

if [ "$num" = "ctl" ]; then
 fhr3=$fhr
 if [ $fhr -eq 00 ]; then fhr3=000; fi
 if [ $fhr -le 99 ]; then fhr3=0$fhr; fi
 file=$odir/nogaps.$yyyymm$dd/nogaps_$yyyymm$dd$hh\f$fhr3 
 file=/com/fnmoc/prod/nogaps.$yyyymm$dd/nogaps_$yyyymm$dd$hh\f$fhr3 
else
 file=$odir/fens.$yyyymm$dd/$hh/pgrba/fnmoc_ge$num.t${hh}z.pgrbaf$fhr 
fi

$COPYGB -xg2 $file xge$num.t${hh}z.pgrbf$fhr

wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":UGRD:" | grep "250 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.u250 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":VGRD:" | grep "250 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.v250 

rm xge*f$fhr

done   #for fhr

$ENSADD $e1 $e2  ge$num.u250 ge$num.u250.index ge$num.u250_ens
$ENSADD $e1 $e2  ge$num.v250 ge$num.v250.index ge$num.v250_ens

cat ge$num.u250_ens >>$ndir/u250.$yyyymm$dd$hh
cat ge$num.v250_ens >>$ndir/v250.$yyyymm$dd$hh

done   #for num

rm ge*.u250 ge*.v250 

done   #for hh

done   #for dd

