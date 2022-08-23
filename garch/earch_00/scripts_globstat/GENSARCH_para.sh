#!/bin/sh
#@ wall_clock_limit=00:15:00
#@ requirements = Feature == "beta"
#@ job_type = parallel
#@ output = /tmp/globstat/garch.o$(jobid)
#@ error = /tmp/globstat/garch.e$(jobid)
#@ total_tasks = 30
#@ node = 30
#@ node_usage = shared
#@ network.MPI=switch,not_shared,us
#@ class = dev
#@ queue
#

set -x

### CDATE=YYYYMMDDHH Y2K comparable
### export from outside of script

if [ "$CDATE" = "" ]; then
   echo "CDATE = $CDATE "
   echo "JOB EXIT NOW !!!!!!"
   exit
fi

export CDATE=$CDATE

echo " +++++++++++++++++++++++++++++++++++++++++++++++++"
echo " +++++ GLOBAL ENSEMBLE ARCHIVE on MIST   +++++++++"
echo " +++++++++++++++++++++++++++++++++++++++++++++++++"

###
### Define the time for each cycle and different days
###

export CDATEp06=`$nhours +06 $CDATE`
export CDATEm06=`$nhours -06 $CDATE`
export CDATEm12=`$nhours -12 $CDATE`
export CDATEm18=`$nhours -18 $CDATE`
export CDATEm24=`$nhours -24 $CDATE`
export CDATEm30=`$nhours -30 $CDATE`
export CDATEm36=`$nhours -36 $CDATE`
export CDATEm42=`$nhours -42 $CDATE`
export CDATEm48=`$nhours -48 $CDATE`
export CDATEm54=`$nhours -54 $CDATE`
export CDATEm60=`$nhours -60 $CDATE`
export CDATEm72=`$nhours -72 $CDATE`
export CDATEm84=`$nhours -84 $CDATE`
export CDATEm96=`$nhours -96 $CDATE`
export CDATEm108=`$nhours -108 $CDATE`
export CDATEm120=`$nhours -120 $CDATE`
export CDATEp00=$CDATE
export CDATEp12=`$nhours +12 $CDATE`
export CDATEp24=`$nhours +24 $CDATE`
export YMDM1=`$nhours -24 $CDATE | cut -c1-8`
export YMDM2=`$nhours -48 $CDATE | cut -c1-8`
export YMDM3=`$nhours -72 $CDATE | cut -c1-8`
export YMDM4=`$nhours -96 $CDATE | cut -c1-8`
export YMDM5=`$nhours -120 $CDATE | cut -c1-8`
export CYMD=`echo $CDATE | cut -c1-8`
export CYMDM1=`echo $CDATEm24 | cut -c1-8`
export YYYYMM=`$nhours -96 $CDATE | cut -c1-6`
export MMDD=`echo $CDATE | cut -c5-8`
export DD=`echo $CDATE | cut -c7-8`
export HH=`echo $CDATE | cut -c9-10`

################### Global ensemble data archive ####################

echo "++++++ Submite the NCEP ENSPOST_06 job ++++++"
export CDATE=$CDATEm18
out=$PTMP/$LOGNAME/ens06_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_PARA_06.sh
sub -e CDATE -a GEN-MTN -w "+00" -j ens06_para -o $out $job

echo "++++++ Submite the NCEP ENSPOST_12 job ++++++"
export CDATE=$CDATEm12
out=$PTMP/$LOGNAME/ens12_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_PARA_12.sh
sub -e CDATE -a GEN-MTN -w "+00" -j ens12_para -o $out $job

echo "++++++ Submite the NCEP ENSPOST_18 job ++++++"
export CDATE=$CDATEm06
out=$PTMP/$LOGNAME/ens18_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_PARA_18.sh
sub -e CDATE -a GEN-MTN -w "+00" -j ens18_para -o $out $job

echo "++++++ Submite the NCEP ENSPOST_00 job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/ens00_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_PARA_00.sh
sub -e CDATE -a GEN-MTN -w "+0030" -j ens00_para -o $out $job

echo "++++++ Submite the NCEP BC ENSPOST_06 job ++++++"
export CDATE=$CDATEm18
out=$PTMP/$LOGNAME/ens06bc_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC_para.sh
sub -e CDATE -a GEN-MTN -w "+0010" -j ens06bc_para -o $out $job

echo "++++++ Submite the NCEP BC ENSPOST_12 job ++++++"
export CDATE=$CDATEm12
out=$PTMP/$LOGNAME/ens12bc_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC_para.sh
sub -e CDATE -a GEN-MTN -w "+0010" -j ens12bc_para -o $out $job

echo "++++++ Submite the NCEP BC ENSPOST_18 job ++++++"
export CDATE=$CDATEm06
out=$PTMP/$LOGNAME/ens18bc_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC_para.sh
sub -e CDATE -a GEN-MTN -w "+0010" -j ens18bc_para -o $out $job

echo "++++++ Submite the NCEP BC ENSPOST_00 job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/ens00bc_para.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC_para.sh
sub -e CDATE -a GEN-MTN -w "+0030" -j ens00bc_para -o $out $job

