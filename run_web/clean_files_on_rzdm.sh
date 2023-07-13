#!/bin/bash

set -x

Date=`date +%y%m%d`
CDATE=20$Date\00
echo "CDATE=$CDATE"
export nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
export YMDM1=`$nhours -24 $CDATE | cut -c1-8`
export YMDM2=`$nhours -48 $CDATE | cut -c1-8`
export YMDM3=`$nhours -72 $CDATE | cut -c1-8`
export YMDM4=`$nhours -96 $CDATE | cut -c1-8`
export YMDM5=`$nhours -120 $CDATE | cut -c1-8`
export YMDM6=`$nhours -144 $CDATE | cut -c1-8`
export YMDM7=`$nhours -168 $CDATE | cut -c1-8`
export YMDM8=`$nhours -192 $CDATE | cut -c1-8`
export YMDM9=`$nhours -216 $CDATE | cut -c1-8`
export YMDM10=`$nhours -240 $CDATE | cut -c1-8`
export YMDM15=`$nhours -360 $CDATE | cut -c1-8`
export YMDM16=`$nhours -384 $CDATE | cut -c1-8`
export YMDM17=`$nhours -408 $CDATE | cut -c1-8`
export YMDM20=`$nhours -480 $CDATE | cut -c1-8`

echo $YMDM20

#for dir in cpqpf_24h cpqpf_6h pqpf_6h cpqpf_cmc amap mmap omap CSTAR_ECMWF   
for dir in cpqpf_24h cpqpf_6h pqpf_6h cpqpf_cmc amap mmap omap
do

ssh bocui@emcrzdm.ncep.noaa.gov "rm -rf /home/people/emc/www/htdocs/gmb/wx20cb/$dir/$YMDM20"
ssh bocui@emcrzdm.ncep.noaa.gov "rm -rf /home/people/emc/www/htdocs/gmb/yluo/$dir/$YMDM20"

done

echo  "deleting files is done!"

