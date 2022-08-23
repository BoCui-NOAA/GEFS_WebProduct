#!/bin/sh

set -x
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++ Job for Ensemble Sensitivity Analyses Y. Luo -------- 11-15-2011  ++"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

### define the directory and utility
export nhoursx=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
export COMIN=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work/MAIN_CSH
export COMINJOB=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work/MAIN_CSH
export COMOUTJOB=$ptmp/yan.luo/cstar
export OUTDIR=$COMOUTJOB/OUTPUT_work

if [ ! -s $OUTDIR ]; then
mkdir -p $OUTDIR
fi

### get real time from IBM-SP computer system
Date=`date +%y%m%d`
CDATE=20$Date\12
echo "CDATE=$CDATE"

### Define the time for each cycle and different days
YYYY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`

################################################
# the 00z data are avaiable at 03:10am EDT  
# the 12z data are avaiable at 15:10pm EDT 
################################################

# NEXT JOB TIME is 17:00am EDT for summer time
# NEXT JOB TIME is 16:00am EST for winter time

ISUMTIM=31
IWINTIM=30

ADDHR=$IWINTIM
#ADDHR=$ISUMTIM
NEXT_JOB_TIME=`$nhoursx +$ADDHR $CDATE`
CUE=dev_transfer

eval primary=`cat  /lfs/h1/ops/prod/config/prodmachinefile | grep primary`
eval backup=`cat  /lfs/h1/ops/prod/config/prodmachinefile | grep backup`
echo $primary "and " $backup
iscactus=primary:cactus

##################################
### Submit the schedual job itself   
##################################

out=$COMOUTJOB/cstar_12z_schedule_def
job1=$COMINJOB/cactus_def_12z.sh            

CMCDIR_prod=/lfs/h1/ops/prod/com/naefs/v6.1/cmce.${YYYY}${MM}${DD}/${HH}/pgrb2ap5
NCEPDIR_prod=/lfs/h1/ops/prod/com/gefs/v12.2/gefs.${YYYY}${MM}${DD}/${HH}/atmos/pgrb2ap5
CMCDIR=/lfs/h1/ops/prod/com/naefs/v6.1/cmce.${YYYY}${MM}${DD}/${HH}/pgrb2ap5
NCEPDIR=/lfs/h1/ops/prod/com/gefs/v12.2/gefs.${YYYY}${MM}${DD}/${HH}/atmos/pgrb2ap5
OUTPUT=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work/OUTPUT
#mkdir -p $CMCDIR 
#mkdir -p $NCEPDIR 
ncplast=${NCEPDIR}/gep20.t${HH}z.pgrb2a.0p50.f192
cmclast=${CMCDIR}/cmc_gep20.t${HH}z.pgrb2a.0p50.f192
figlast=$OUTPUT/$CDATE/region2/day1/SEN_2_NCEP_Z500_0-1day.png

nn=1
while [ $nn -le 10 ]; do
if [ -s $ncplast ]; then

############# Submit the cstar job to run ncep #####################
if [ $primary == $iscactus ]; then
echo " cactus is the production machine! "
echo " Send web plots through cactus "
CUE=dev_transfer
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 1024/1 -w ${NEXT_JOB_TIME} -t 6:00:00 -j cactus_def_12z.sh -o $out $job1
job=$COMIN/sen_default_NCEP.csh
else
echo " dogwood is the production machine! "
echo " Send web plots through dogwood "
CUE=dev_transfer
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 1024/1 -w ${NEXT_JOB_TIME} -t 6:00:00 -j cactus_def_12z.sh -o $out $job1
job=$COMIN/sen_default_NCEP.csh
CUE=dev_transfer
fi
out=$COMOUTJOB/cstar_ncep_$CDATE
echo "++++++ Submit the job for 12z ++++++"
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 1024/1 -w +0000 -t 6:00:00 -j CSTAR_NCEP -o $out $job

nn=11
else
nn=`expr $nn + 1`
sleep 900            
fi
echo $nn
done

nn=1
while [ $nn -le 20 ]; do
if [ -s $cmclast -a -s $figlast ]; then

############# Submit the cstar job to run ncep+cmc #####################
if [ $primary == $iscactus ]; then
echo " cactus is the production machine! "
echo " Send web plots through cactus "
job=$COMIN/sen_default_CMC+NCEP.csh
else
echo " dogwood is the production machine! "
echo " Send web plots through dogwood "
job=$COMIN/sen_default_CMC+NCEP.csh
CUE=dev_transfer
fi
out=$COMOUTJOB/cstar_ncep+cmc_$CDATE
echo "++++++ Submit the job for 12z ++++++"
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 2048/1 -w +0000 -t 6:00:00 -j CSTAR_NCEP_CMC -o $out $job

nn=21
else
nn=`expr $nn + 1`
sleep 900            
fi
echo $nn
done

RZDMDIR=/home/people/emc/ftp/gc_wmb/yluo/CSTAR
CDATE=`$nhoursx -240 $CDATE`
PDY=`echo $CDATE | cut -c1-8`
ssh -l  wd20yl emcrzdm "rm -rf $RZDMDIR/$CDATE"

exit

