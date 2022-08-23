
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

### CDATE=YYYYMMDDHH Y2K comparable
### export from outside of script

if [ "$CDATE" = "" ]; then
   echo "CDATE = $CDATE "
   echo "JOB EXIT NOW !!!!!!"
   exit
fi

###
### assign vaiables and commands
###

# local directory

workdir=$PTMP/$LOGNAME/eecmarch12
COMDIR=$GLOBAL/ecm_ens    

# production directory

COPYGB=/nwprod/util/exec/copygb
#DFROM=/com/mrf/prod
export DFROM=$SCOM/mrf/prod
export DFROM=/com/mrf/prod

if [ ! -s $workdir ]; then
   mkdir -p $workdir
fi
cd $workdir;pwd;rm $workdir/*

TEST=NO
export CDATE COMDIR DFROM YMD YMDH 
export nhours windex 

YMD=`echo $CDATE | cut -c1-8 `
HH=`echo $CDATE | cut -c9-10 `
YMDH=$CDATE
YMDM1=`$nhours -24 $YMDH | cut -c1-8`
YMDHM5=`$nhours -120 $YMDH`
YMDHM15=`$nhours -360 $YMDH`
YMDHM45=`$nhours -1080 $YMDH`
YMDM45=`$nhours -1080 $YMDH | cut -c1-8`
YMDHM65=`$nhours -1560 $YMDH`

if [ $HH -ne 12 ]; then
   echo " This is not cycle 12Z job, exit "
   exit 8
fi

#rm $GLOBAL/ecm_ens/*.${YMDM65}12

cp $DFROM/wsr.${YMDM1}/enspost.t12z.z500  $GLOBAL/ecm_ens/z500.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.z1000 $GLOBAL/ecm_ens/z1000.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.u850  $GLOBAL/ecm_ens/u850.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.v850  $GLOBAL/ecm_ens/v850.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.u200  $GLOBAL/ecm_ens/u200.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.v200  $GLOBAL/ecm_ens/v200.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.t850  $GLOBAL/ecm_ens/t850.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.t2m   $GLOBAL/ecm_ens/t2m.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.u10m  $GLOBAL/ecm_ens/u10m.${YMDM1}12
cp $DFROM/wsr.${YMDM1}/enspost.t12z.v10m  $GLOBAL/ecm_ens/v10m.${YMDM1}12

