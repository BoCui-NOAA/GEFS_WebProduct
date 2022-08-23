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

TMPDIR=$PTMP/$LOGNAME/ENS_uv10m$hh

mkdir $TMPDIR
cd $TMPDIR

ENSADD=$SHOME/$LOGNAME/earch/scripts/ensadd.sh
#DFROM=/com/gens/prod                
export DFROM=$SCOM/gens/prod
ndir=$GLOBAL/cmc_ens

#set -x

for dd in $dd                                     
do

for hh in $hh   
do

>$TMPDIR/u10m.$yyyymm$dd$hh
>$TMPDIR/v10m.$yyyymm$dd$hh

for num in c00 p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 p11 p12 p13 p14 p15 p16 p17 p18 p19 p20
do

>ge$num.u10m
>ge$num.v10m

for fhr in 00 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 360 372 384 
do

file=$DFROM/cmce.$yyyymm$dd/$hh/pgrba/cmc_ge$num.t${hh}z.pgrbaf$fhr 
$COPYGB -xg2 $file xge$num.t${hh}z.pgrbf$fhr

wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":UGRD:" | grep ":10 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.u10m 
wgrib xge$num.t${hh}z.pgrbf$fhr | grep ":VGRD:" | grep ":10 m " | wgrib -i xge$num.t${hh}z.pgrbf$fhr -grib -append -o ge$num.v10m  

rm xge*f$fhr

done   #for fhr

cat ge$num.u10m >>$TMPDIR/u10m.$yyyymm$dd$hh
cat ge$num.v10m >>$TMPDIR/v10m.$yyyymm$dd$hh

done   #for num

rm  ge*.u10m* ge*.v10m*

done   #for hh

done   #for dd

cp $TMPDIR/u10m.$yyyymm$dd$hh $ndir/u10m.$yyyymm$dd$hh
cp $TMPDIR/v10m.$yyyymm$dd$hh $ndir/v10m.$yyyymm$dd$hh


