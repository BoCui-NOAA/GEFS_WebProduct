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

## This scripts to convert Dick's experiment data to ours
##  --- Yuejian Zhu (12/06/2004)

export CDATE=$CDATE
export yyyymm=`echo $CDATE | cut -c1-6`
export dd=`echo $CDATE | cut -c7-8`
export hh=`echo $CDATE | cut -c9-10`

TMPDIR=$PTMP/$LOGNAME/ENSPARA_bc$hh

if [ ! -s $TMPDIR ]; then
mkdir -p $TMPDIR
fi
cd $TMPDIR;pwd;rm $TMPDIR/*

ENSADD=$SHOME/$LOGNAME/earch/scripts/ensadd.sh
ndir=$GLOBAL/ENSPARA_bc
export DFROM=$SCOM/gens/prod
export DFROM=/ptmp/wx22lu/ncep_data                

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
>$ndir/u250.$yyyymm$dd$hh
>$ndir/v250.$yyyymm$dd$hh
>$ndir/u850.$yyyymm$dd$hh
>$ndir/v850.$yyyymm$dd$hh

for num in gfs c00 p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 p11 p12 p13 p14 p15 p16 p17 p18 p19 p20
do

   case $num in
      gfs) iensi=11;echo $iensi;;
      c00) iensi=12;echo $iensi;;
      p01) iensi=01;echo $iensi;;
      p02) iensi=02;echo $iensi;;
      p03) iensi=03;echo $iensi;;
      p04) iensi=04;echo $iensi;;
      p05) iensi=05;echo $iensi;;
      p06) iensi=06;echo $iensi;;
      p07) iensi=07;echo $iensi;;
      p08) iensi=08;echo $iensi;;
      p09) iensi=09;echo $iensi;;
      p10) iensi=10;echo $iensi;;
      p11) iensi=11;echo $iensi;;
      p12) iensi=12;echo $iensi;;
      p13) iensi=13;echo $iensi;;
      p14) iensi=14;echo $iensi;;
      p15) iensi=15;echo $iensi;;
      p16) iensi=16;echo $iensi;;
      p17) iensi=17;echo $iensi;;
      p18) iensi=18;echo $iensi;;
      p19) iensi=19;echo $iensi;;
      p20) iensi=20;echo $iensi;;
   esac

>ge$num.z500
>ge$num.z1000
>ge$num.t850
>ge$num.t2m 
>ge$num.u10m
>ge$num.v10m
>ge$num.u250
>ge$num.v250
>ge$num.u850
>ge$num.v850

for fhr in 00 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 360 372 384 
do

if [ $fhr -eq 00 ]; then
 file=$DFROM/gefs.$yyyymm$dd/$hh/pgrba/ge$num.t${hh}z.pgrbaf$fhr 
else
 file=$DFROM/gefs.$yyyymm$dd/$hh/pgrba_bc/ge$num.t${hh}z.pgrba_bcf$fhr 
fi

$COPYGB -xg2 $file xge$num.t${hh}z.pgrbf$fhr

wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":HGT:" | grep "500 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.z500 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":HGT:" | grep "1000 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.z1000
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":UGRD:" | grep "850 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.u850 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":VGRD:" | grep "850 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.v850 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":UGRD:" | grep "250 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.u250 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":VGRD:" | grep "250 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.v250 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":TMP:" | grep "850 mb" | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.t850 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":TMP:" | grep ":2 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.t2m  
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":UGRD:" | grep ":10 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.u10m 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":VGRD:" | grep ":10 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.v10m  

rm xge*f$fhr

done   #for fhr

#$ENSADD $e1 $e2  ge$num.z500 ge$num.z500.index ge$num.z500_ens
#$ENSADD $e1 $e2  ge$num.z1000 ge$num.z1000.index ge$num.z1000_ens
#$ENSADD $e1 $e2  ge$num.u850 ge$num.u850.index ge$num.u850_ens
#$ENSADD $e1 $e2  ge$num.v850 ge$num.v850.index ge$num.v850_ens
#$ENSADD $e1 $e2  ge$num.u200 ge$num.u200.index ge$num.u200_ens
#$ENSADD $e1 $e2  ge$num.v200 ge$num.v200.index ge$num.v200_ens

#cat ge$num.z500_ens >>$ndir/z500.$yyyymm$dd$hh
#cat ge$num.z1000_ens >>$ndir/z1000.$yyyymm$dd$hh
#cat ge$num.u850_ens >>$ndir/u850.$yyyymm$dd$hh
#cat ge$num.v850_ens >>$ndir/v850.$yyyymm$dd$hh
#cat ge$num.u200_ens >>$ndir/u200.$yyyymm$dd$hh
#cat ge$num.v200_ens >>$ndir/v200.$yyyymm$dd$hh

cat ge$num.z500 >>$ndir/z500.$yyyymm$dd$hh
cat ge$num.z1000 >>$ndir/z1000.$yyyymm$dd$hh
cat ge$num.u850 >>$ndir/u850.$yyyymm$dd$hh
cat ge$num.v850 >>$ndir/v850.$yyyymm$dd$hh
cat ge$num.u250 >>$ndir/u250.$yyyymm$dd$hh
cat ge$num.v250 >>$ndir/v250.$yyyymm$dd$hh
cat ge$num.t850 >>$ndir/t850.$yyyymm$dd$hh
cat ge$num.t2m >>$ndir/t2m.$yyyymm$dd$hh
cat ge$num.u10m >>$ndir/u10m.$yyyymm$dd$hh
cat ge$num.v10m >>$ndir/v10m.$yyyymm$dd$hh

done   #for num

rm ge*.z500* ge*.z1000* ge*.t850* ge*.u250 ge*.v250 ge*.u850 ge*.v850 ge*.t2m* ge*.u10m* ge*.v10m*

done   #for hh

done   #for dd

