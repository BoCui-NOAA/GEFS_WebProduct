
### example 1
#!/bin/sh
#@ job_type = parallel
#@ output = /tmp/wx22lu/earch.o$(jobid)
#@ error = /tmp/wx22lu/earch.e$(jobid)
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

### CDATE=YYYYMMDDHH Y2K comparable 
### export from script 

if [ "$CDATE" = " " ]; then
   echo "CDATE = $CDATE "
   echo "JOB EXIT NOW !!!!!!"
   exit
fi

### local variables and commands

workdir=$GTMP/$LOGNAME/earch00
COMDIR=$GLOBAL/ENS          

### production commands and directory

CUE=dev_transfer
TEST=NO
DFROM=/com/mrf/prod
DFROM=/com/gens/prod

if [ ! -s $workdir ]; then
   mkdir -p $workdir
fi
cd $workdir;pwd;rm $workdir/*

export CDATE COMDIR DFROM YMD YMDH YMDHM12 
export nhours windex 

YMDH=$CDATE
YMD=`echo $CDATE | cut -c1-8 `
HH=`echo $CDATE | cut -c9-10`
YMDM1=`$nhours -24 $YMDH | cut -c1-8`
YMDHM12=`$nhours -12 $YMDH `
YMDHM5=`$nhours -120 $YMDH `
YMDHM15=`$nhours -360 $YMDH `
YMDHM45=`$nhours -1080 $YMDH `
YMDM45=`$nhours -1080 $YMDH | cut -c1-8`
YMDHM65=`$nhours -1560 $YMDH `

if [ $HH -ne 00 ]; then
   echo " This is not cycle 00Z job, exit "
   exit 8
fi

### forecast maps
### plotting daily pqpf maps ( traditional ) and CPC's maps

export CDATE=$CDATE
out=$GTMP/$LOGNAME/output/www.output; rm $out
#job=/nfsuser/g01/wx22lu/wpqpf/scripts/www_23m.qsub
job=$SHOME/$LOGNAME/wpqpf/scripts/www_20060530.qsub
#sub -a GEN-MTN -e CDATE -w "+0030" -j webjob -o $out $job
$SSUB -a NAEFS-DEV -q $CUE -p 1/1/S -r 512/1 -w +0030 -t 3:00:00 -j webjob -o $out $job

### forecast maps
### All following four jobs run 6-h plotting for pqpf, pqrf, pqsf and pqif
### Note: NCEP "Calibrated QPF/CQPF, PQPF/CPQPF" is called at t00z cycle
### see $SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub, ../jif_cqpf/grads/PLOT.sh

export CDATE_BK=$CDATE
ICYC=`echo $CDATE | cut -c9-10`
out=$GTMP/$LOGNAME/output/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
#sub -a GEN-MTN -e CDATE -w "+0000" -j web$ICYC\job -o $out $job
$SSUB -a NAEFS-DEV -q $CUE -p 1/1/S -r 512/1 -w +0000 -t 3:00:00 -j web$ICYC\job -o $out $job

export CDATE=`$nhours -18 $CDATE_BK `
ICYC=`echo $CDATE | cut -c9-10`
out=$GTMP/$LOGNAME/output/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
#sub -a GEN-MTN -e CDATE -w "+00" -j web$ICYC\job -o $out $job
$SSUB -a NAEFS-DEV -q $CUE -p 1/1/S -r 512/1 -w +0005 -t 3:00:00 -j web$ICYC\job -o $out $job

export CDATE=`$nhours -12 $CDATE_BK `
ICYC=`echo $CDATE | cut -c9-10`
out=$GTMP/$LOGNAME/output/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
#sub -a GEN-MTN -e CDATE -w "+00" -j web$ICYC\job -o $out $job
$SSUB -a NAEFS-DEV -q $CUE -p 1/1/S -r 512/1 -w +0010 -t 3:00:00 -j web$ICYC\job -o $out $job

export CDATE=`$nhours -06 $CDATE_BK `
ICYC=`echo $CDATE | cut -c9-10`
out=$GTMP/$LOGNAME/output/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
#sub -a GEN-MTN -e CDATE -w "+00" -j web$ICYC\job -o $out $job
$SSUB -a NAEFS-DEV -q $CUE -p 1/1/S -r 512/1 -w +0015 -t 3:00:00 -j web$ICYC\job -o $out $job

#### Convert data to enspost for after bias correction

#echo "++++++ Submite job ++++++"
#export CDATE=$YMDH
#out=$GTMP/$LOGNAME/enspost_bias_00.out
#job=$SHOME/$LOGNAME/evrfy/scripts/enspost_bias_20060530.sh
#sub -a GEN-MTN -e CDATE -w "+0010" -j bc00 -o $out $job

#echo "++++++ Submite job ++++++"
#export CDATE=$YMDHM12
#out=$GTMP/$LOGNAME/enspost_bias_12.out
#job=$SHOME/$LOGNAME/evrfy/scripts/enspost_bias_20060530.sh
#sub -a GEN-MTN -e CDATE -w "+0000" -j bc12 -o $out $job

#### Convert data to enspostc for after bias correction

#echo "++++++ Submite job ++++++"
#export CDATE=$YMDH
#out=$GTMP/$LOGNAME/enspostc_bias_00.out
#job=$SHOME/$LOGNAME/evrfy/scripts/enspostc_bias_20060530.sh
#sub -a GEN-MTN -e CDATE -w "+0010" -j cbc00 -o $out $job

#echo "++++++ Submite job ++++++"
#export CDATE=$YMDHM12
#out=$GTMP/$LOGNAME/enspostc_bias_12.out
#job=$SHOME/$LOGNAME/evrfy/scripts/enspostc_bias_20060530.sh
#sub -a GEN-MTN -e CDATE -w "+0000" -j cbc12 -o $out $job

CDATE=$CDATE_BK

#export CDATE=$CDATE;$SHOME/$LOGNAME/arch/ADD_ANL.sh

export CDATE=$CDATE;$SHOME/$LOGNAME/jif0406/grads/PLOT.sh

$SHOME/$LOGNAME/web_glb_js/base/get_days.sh
$SHOME/$LOGNAME/web_glb_js/base/ftp_html.sh

$SHOME/$LOGNAME/reanl/grads_webmap/CLIMATE_ANOMALY_map.sh $CDATE

#$SHOME/$LOGNAME/reanl/grads_webmap/CLIMATE_ANOMALY_map_cmc.sh $YMDM1\00
#sleep 3600
#$SHOME/$LOGNAME/reanl/grads_webmap/CLIMATE_ANOMALY_map_cmc.sh $CDATE

