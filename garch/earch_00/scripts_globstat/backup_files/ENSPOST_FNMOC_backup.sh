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

mkdir $TMPDIR
cd $TMPDIR

ENSADD=$SHOME/$LOGNAME/earch/scripts/ensadd.sh
odir=/com/fnmoc/prod                
ndir=$GLOBAL/fno_ens

#set -x

for dd in $dd                                     
do

for hh in $hh   
do

>$ndir/z500.$yyyymm$dd$hh
>$ndir/z1000.$yyyymm$dd$hh
>$ndir/t850.$yyyymm$dd$hh
>$ndir/t2m.$yyyymm$dd$hh
>$ndir/u10m.$yyyymm$dd$hh
>$ndir/v10m.$yyyymm$dd$hh

for num in ctl p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 p11 p12 p13 p14 p15 p16 
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
   esac

>ge$num.z500
>ge$num.z1000
>ge$num.t850
>ge$num.t2m 
>ge$num.u10m
>ge$num.v10m

for fhr in 00 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 204 216 228 240 
do

if [ "$num" = "ctl" ]; then
 fhr3=$fhr
 if [ $fhr -eq 00 ]; then fhr3=000; fi
 if [ $fhr -le 99 ]; then fhr3=0$fhr; fi
 file=/com/fnmoc/prod/nogaps.$yyyymm$dd/nogaps_$yyyymm$dd$hh\f$fhr3 
 file=/global/shared/stat/fno/pgbf$fhr.$yyyymm$dd$hh 
else
 file=$odir/fens.$yyyymm$dd/$hh/pgrba/fnmoc_ge$num.t${hh}z.pgrbaf$fhr 
fi

$COPYGB -xg2 $file xge$num.t${hh}z.pgrbf$fhr

wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":HGT:" | grep "500 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.z500 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":HGT:" | grep "1000 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.z1000
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":TMP:" | grep "850 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.t850 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":TMP:" | grep ":2 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.t2m  
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":UGRD:" | grep ":10 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.u10m 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":VGRD:" | grep ":10 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.v10m  

rm xge*f$fhr

done   #for fhr

$ENSADD $e1 $e2  ge$num.z500 ge$num.z500.index ge$num.z500_ens
$ENSADD $e1 $e2  ge$num.z1000 ge$num.z1000.index ge$num.z1000_ens
$ENSADD $e1 $e2  ge$num.t850 ge$num.t850.index ge$num.t850_ens
$ENSADD $e1 $e2  ge$num.t2m ge$num.t2m.index ge$num.t2m_ens
$ENSADD $e1 $e2  ge$num.u10m ge$num.u10m.index ge$num.u10m_ens
$ENSADD $e1 $e2  ge$num.v10m ge$num.v10m.index ge$num.v10m_ens

cat ge$num.z500_ens >>$ndir/z500.$yyyymm$dd$hh
cat ge$num.z1000_ens >>$ndir/z1000.$yyyymm$dd$hh
cat ge$num.t850_ens >>$ndir/t850.$yyyymm$dd$hh
cat ge$num.t2m_ens >>$ndir/t2m.$yyyymm$dd$hh
cat ge$num.u10m_ens >>$ndir/u10m.$yyyymm$dd$hh
cat ge$num.v10m_ens >>$ndir/v10m.$yyyymm$dd$hh

done   #for num

rm ge*.z500* ge*.z1000* ge*.t850* ge*.t2m* ge*.u10m* ge*.v10m*

done   #for hh

done   #for dd

