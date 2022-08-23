#!/bin/sh

set -x
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++ Job for Ensemble Sensitivity Analyses Y. Luo -------- 11-15-2011  ++"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

### define the directory and utility
export nhoursx=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
export COMIN=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work_update/MAIN_CSH 
export COMINJOB=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work_update/MAIN_CSH
export COMOUTJOB=$ptmp/yan.luo/cstar
export OUTDIR=$COMOUTJOB/OUTPUT_work_update

cd $COMINJOB
rm sen_opt.txt
rm sen_fwd.txt

#wget ftp://ftp.emc.ncep.noaa.gov/gc_wmb/yluo/CSTAR/sen_opt.txt
wget http://breezy.somas.stonybrook.edu/CSTAR/Ensemble_Sensitivity/Test/Floater/sen_opt.txt

export iday=`head -7 sen_opt.txt | grep "iday"  |awk '{print $2}'`
export icent=`head -7 sen_opt.txt | grep "icent"  |awk '{print $2}'`
export lat=`head -7 sen_opt.txt | grep "lat"  |awk '{print $2}'`
export lon=`head -7 sen_opt.txt | grep "lon"  |awk '{print $2}'`
export boxsize=`head -7 sen_opt.txt | grep "boxsize"  |awk '{print $2}'`

#wget ftp://ftp.emc.ncep.noaa.gov/gc_wmb/yluo/CSTAR/sen_fwd.txt
wget http://breezy.somas.stonybrook.edu/CSTAR/Ensemble_Sensitivity/Test/Floater/sen_fwd.txt

export iday_fwd=`head -7 sen_fwd.txt | grep "iday"  |awk '{print $2}'`
export icent_fwd=`head -7 sen_fwd.txt | grep "icent"  |awk '{print $2}'`
export lat_fwd=`head -7 sen_fwd.txt | grep "lat"  |awk '{print $2}'`
export lon_fwd=`head -7 sen_fwd.txt | grep "lon"  |awk '{print $2}'`
export boxsize_fwd=`head -7 sen_fwd.txt | grep "boxsize"  |awk '{print $2}'`

if [ ! -s $OUTDIR ]; then
mkdir -p $OUTDIR
fi

### get real time from IBM-SP computer system
Date=`date +%y%m%d`
CDATE=20$Date\00
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

# NEXT JOB TIME is 5:00am EDT for summer time
# NEXT JOB TIME is 4:00am EST for winter time

ISUMTIM=32
IWINTIM=31

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

out=$COMOUTJOB/senopt_00z_schedule_opt
job1=$COMINJOB/cactus_opt_00z.sh            

NCEPDIR=/lfs/h1/ops/prod/com/gefs/v12.2/gefs.${YYYY}${MM}${DD}/${HH}/atmos/pgrb2ap5
OUTPUT=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work/OUTPUT
#mkdir -p $NCEPDIR 
ncplast=${NCEPDIR}/gep20.t${HH}z.pgrb2a.0p50.f192
figlast=$OUTPUT/$CDATE/region2/day1/SEN_3_NCEP_Z500_0-1day.png

nn=1
while [ $nn -le 10 ]; do
if [ -s $ncplast ]; then

if [ $primary == $iscactus ]; then
echo " cactus is the production machine! "
echo " Send web plots through cactus "
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 1024/1 -w ${NEXT_JOB_TIME} -t 3:00:00 -j cactus_opt_00z.sh -o $out $job1
csh $COMIN/sen_opt.csh $iday $icent $lat $lon $boxsize
csh $COMIN/sen_back_proj.csh 12 0 1 38.5 289.5 8.5
csh $COMIN/sen_fwd_proj.csh 12 $iday_fwd $icent_fwd $lat_fwd $lon_fwd $boxsize_fwd
else
echo " dogwood is the production machine! "
echo " Send web plots through dogwood "
CUE=dev_transfer
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 1024/1 -w ${NEXT_JOB_TIME} -t 3:00:00 -j cactus_opt_00z.sh -o $out $job1
csh $COMIN/sen_opt.csh $iday $icent $lat $lon $boxsize
csh $COMIN/sen_back_proj.csh 12 0 1 38.5 289.5 8.5
csh $COMIN/sen_fwd_proj.csh 12 $iday_fwd $icent_fwd $lat_fwd $lon_fwd $boxsize_fwd
fi

nn=11
else
nn=`expr $nn + 1`
sleep 900            
fi
echo $nn
done

