#!/bin/sh

set -x
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++ Job for Ensemble Sensitivity Analyses Y. Luo -------- 11-15-2011  ++"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

### define the directory and utility
export nhoursx=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
export COMINJOB=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work_ecmwf/MAIN_CSH
export COMINJOBF=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/fuzzy_clustering/MAIN_CSH
export COMINJOBF2=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/fuzzy_clustering_2vars/MAIN_CSH
export COMINJOB2=/lfs/h2/emc/vpppg/save/yan.luo/CSTAR/work_ecmwf/VIEW_DIRLIST
export COMOUTJOB=$ptmp/yan.luo/cstar
export OUTDIR=$COMOUTJOB/OUTPUT_work_ecmwf

cd $COMINJOB
rm sen_opt.txt

#wget ftp://ftp.emc.ncep.noaa.gov/gc_wmb/yluo/CSTAR/sen_opt.txt
wget http://breezy.somas.stonybrook.edu/CSTAR/Ensemble_Sensitivity/Test/Floater/sen_opt.txt

export iday=`head -7 sen_opt.txt | grep "iday"  |awk '{print $2}'`
export icent=`head -7 sen_opt.txt | grep "icent"  |awk '{print $2}'`
export icent=3
export lat=`head -7 sen_opt.txt | grep "lat"  |awk '{print $2}'`
export lon=`head -7 sen_opt.txt | grep "lon"  |awk '{print $2}'`
export boxsize=`head -7 sen_opt.txt | grep "boxsize"  |awk '{print $2}'`

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

ISUMTIM=33
IWINTIM=32

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

out=$COMOUTJOB/cstar_ecmwf_00z_schedule
job1=$COMINJOB/cactus_ecm_00z.sh            

ECDIR=/lfs/h1/ops/prod/dcom/${YYYY}${MM}${DD}/wgrbbul/ecmwf
vtt=`$nhoursx 192 $CDATE`
vtt1=`echo $vtt | awk '{print substr($0,5,6)}'`
itt1=`echo $CDATE | awk '{print substr($0,5,6)}'`
eclast=${ECDIR}"/DCE"${itt1}"00"${vtt1}"001" 
figlast=$OUTDIR/$CDATE/region2/day1/SEN_2_ECMWF_Z500_0-1day.png

nn=1
while [ $nn -le 10 ]; do
if [ -s $eclast ]; then

if [ $primary == $iscactus ]; then
echo " cactus is the production machine! "
echo " Send web plots through cactus "
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 2048/1 -w ${NEXT_JOB_TIME} -t 3:00:00 -j cactus_ecm_00z.sh -o $out $job1
$COMINJOB/sen_opt.csh $iday $icent $lat $lon $boxsize
$COMINJOB2/show_dirlist_00z.sh
else
echo " dogwood is the production machine! "
echo " Send web plots through dogwood "
CUE=dev_transfer
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 2048/1 -w ${NEXT_JOB_TIME} -t 3:00:00 -j cactus_ecm_00z.sh -o $out $job1
$COMINJOB/sen_opt.csh $iday $icent $lat $lon $boxsize
$COMINJOB2/show_dirlist_00z.sh
fi

############# Submit the cstar job to run ecmwf #####################
if [ $primary == $iscactus ]; then
echo " cactus is the production machine! "
echo " Send web plots through cactus "
job=$COMINJOB/sen_default_ECMWF.csh
jobf1=$COMINJOBF/fuzzy_clustering_3ctr_part1.csh
jobf2=$COMINJOBF/fuzzy_clustering_3ctr_part2.csh
jobf3=$COMINJOBF2/fuzzy_clustering_3ctr_TPTemp.csh
else
echo " dogwood is the production machine! "
echo " Send web plots through dogwood "
job=$COMINJOB/sen_default_ECMWF.csh
jobf1=$COMINJOBF/fuzzy_clustering_3ctr_part1.csh
jobf2=$COMINJOBF/fuzzy_clustering_3ctr_part2.csh
jobf3=$COMINJOBF2/fuzzy_clustering_3ctr_TPTemp.csh
CUE=dev_transfer
fi

if [ ! -s $figlast ]; then
echo "++++++ Submit the job for 00z ++++++"
out=$COMOUTJOB/sen_default_ECMWF_$CDATE
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 2048/1 -w +0000 -t 3:00:00 -j sen_default_ECMWF.csh -o $out $job

echo "++++++ Submit the job for 00z ++++++"
outf1=$COMOUTJOB/fuzzy_clustering_3ctr_part1_$CDATE
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 2048/1 -w +0000 -t 6:00:00 -j fuzzy_clustering_3ctr_part1.csh -o $outf1 $jobf1

outf2=$COMOUTJOB/fuzzy_clustering_3ctr_part2_$CDATE
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 2048/1 -w +0000 -t 6:00:00 -j fuzzy_clustering_3ctr_part2.csh -o $outf2 $jobf2

outf3=$COMOUTJOB/fuzzy_clustering_3ctr_2vars_$CDATE
sub_wcoss2 -a GEFS-DEV -q $CUE -p 1/1/S -r 2048/1 -w +0000 -t 6:00:00 -j fuzzy_clustering_3ctr_TPTemp.csh -o $outf3 $jobf3

fi

nn=11
else
nn=`expr $nn + 1`
sleep 900            
fi
echo $nn
done

RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/CSTAR_ECMWF
CDATE=`$nhoursx -120 $CDATE`
PDY=`echo $CDATE | cut -c1-8`
ssh -l  wd20yl emcrzdm "rm -rf $RZDMDIR/$CDATE"

exit

