
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
### export from script 

if [ "$CDATE" = " " ]; then
   echo "CDATE = $CDATE "
   echo "JOB EXIT NOW !!!!!!"
   exit
fi

### local variables and commands

workdir=$PTMP/$LOGNAME/earch00
COMDIR=$GLOBAL/ENS          

### production commands and directory

TEST=NO
#DFROM=/com/mrf/prod
export DFROM=$SCOM/gens/prod
export DFROM=/com/gens/prod

if [ ! -s $workdir ]; then
   mkdir -p $workdir
fi
cd $workdir;pwd;rm $workdir/*

export CDATE COMDIR DFROM YMD YMDH YMDHM12 
export nhours windex 

YMDH=$CDATE
YMD=`echo $CDATE | cut -c1-8 `
YYYY=`echo $CDATE | cut -c1-4 `
MMDD=`echo $CDATE | cut -c5-8 `
CDATEp00=$CDATE
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

rm $GLOBAL/ENS/*.${YMDM65}00

#for file in z1000 z500 t850 prcp prcp_24hbc prmsl t2m u10m v10m u850 v850 u200 v200
for file in z1000 z500 t850 prcp prcp_24hbc prmsl t2m u10m v10m u850 v850
do
 if [ "$file" = "prcp" ]; then
    fileo=precip
 elif [ "$file" = "prcp_24hbc" ]; then
    fileo=precip_24hbc
 else
    fileo=$file
 fi
 cp $DFROM/gefs.$YMD/${HH}/ensstat/enspost.t${HH}z.${file} $COMDIR/${fileo}.${YMD}${HH}
done

export CDATE=$CDATE;$SHOME/$LOGNAME/earch/scripts/ENSPOST_00+12_W250.sh

#for file in pqpf pqrf pqsf pqif prff pqpf_24h pqpf_24hbc prcp_24hbc
for file in pqpf pqrf pqsf pqif pqrf pqpf_24h pqpf_24hbc
do
 if [ "$file" = "prcp_24hbc" ]; then
    fileo=precip_24hbc
 else
    fileo=$file
 fi
 cp $DFROM/gefs.$YMD/${HH}/ensstat/ensstat.t${HH}z.${file}  $COMDIR/${fileo}.${YMD}${HH}
done

#export CDATE=$CDATE;$SHOME/$LOGNAME/earch/scripts/ENSPOST_00+12_W10M.sh

### ADD_ANL (analysis) for NCEP only, (start 11/14/2006 -Yuejian Zhu)

export CDATE=$CDATEp00 YEAR=$YYYY;$SHOME/$LOGNAME/arch/ADD_ANL_nmc.sh

if [ $MMDD -gt 1130 -a $MMDD -le 1231 ]; then
YEAR=`expr $YYYY + 1`
export CDATE=$CDATEp00 YEAR=$YYYY;$SHOME/$LOGNAME/arch/ADD_ANL_nmc.sh
fi

if [ $MMDD -gt 0101 -a $MMDD -le 0131 ]; then
YEAR=`expr $YYYY - 1`
export CDATE=$CDATEp00 YEAR=$YYYY;$SHOME/$LOGNAME/arch/ADD_ANL_nmc.sh
fi

icnt=1

if [ $icnt -eq 0 ]; then
### forecast maps
### plotting daily pqpf maps ( traditional ) and CPC's maps

out=$PTMP/$LOGNAME/www.output
#job=/nfsuser/g01/wx20yz/wpqpf/scripts/www_23m.qsub
job=$SHOME/$LOGNAME/wpqpf/scripts/www_20060530.qsub
sub -e CDATE -w "+00" -j webjob -o $out $job

### forecast maps
### All following four jobs run 6-h plotting for pqpf, pqrf, pqsf and pqif
### Note: NCEP "Calibrated QPF/CQPF, PQPF/CPQPF" is called at t00z cycle
### see $SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub, ../jif_cqpf/grads/PLOT.sh

CDATE_BK=$CDATE
ICYC=`echo $CDATE | cut -c9-10`
out=$PTMP/$LOGNAME/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
sub -e CDATE -w "+00" -j web$ICYC\job -o $out $job

CDATE=`$nhours -18 $CDATE_BK `
ICYC=`echo $CDATE | cut -c9-10`
out=$PTMP/$LOGNAME/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
sub -e CDATE -w "+00" -j web$ICYC\job -o $out $job

CDATE=`$nhoursx -12 $CDATE_BK `
ICYC=`echo $CDATE | cut -c9-10`
out=$PTMP/$LOGNAME/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
sub -e CDATE -w "+00" -j web$ICYC\job -o $out $job

CDATE=`$nhoursx -06 $CDATE_BK `
ICYC=`echo $CDATE | cut -c9-10`
out=$PTMP/$LOGNAME/www.$CDATE.output
job=$SHOME/$LOGNAME/wpqpf/scripts/www_200312.qsub
sub -e CDATE -w "+00" -j web$ICYC\job -o $out $job

#### Convert data to enspost for after bias correction

echo "++++++ Submite job ++++++"
export CDATE=$YMDH
out=$PTMP/$LOGNAME/enspost_bias_00.out
job=$SHOME/$LOGNAME/evrfy/scripts/enspost_bias_20060530.sh
sub -e CDATE -w "+0010" -j bc00 -o $out $job

echo "++++++ Submite job ++++++"
export CDATE=$YMDHM12
out=$PTMP/$LOGNAME/enspost_bias_12.out
job=$SHOME/$LOGNAME/evrfy/scripts/enspost_bias_20060530.sh
sub -e CDATE -w "+0000" -j bc12 -o $out $job

#### Convert data to enspostc for after bias correction

echo "++++++ Submite job ++++++"
export CDATE=$YMDH
out=$PTMP/$LOGNAME/enspostc_bias_00.out
job=$SHOME/$LOGNAME/evrfy/scripts/enspostc_bias_20060530.sh
sub -e CDATE -w "+0010" -j cbc00 -o $out $job

echo "++++++ Submite job ++++++"
export CDATE=$YMDHM12
out=$PTMP/$LOGNAME/enspostc_bias_12.out
job=$SHOME/$LOGNAME/evrfy/scripts/enspostc_bias_20060530.sh
sub -e CDATE -w "+0000" -j cbc12 -o $out $job

CDATE=$CDATE_BK

export CDATE=$CDATE;$SHOME/$LOGNAME/arch/ADD_ANL.sh

export CDATE=$CDATE;$SHOME/$LOGNAME/jif0406/grads/PLOT.sh

$SHOME/$LOGNAME/web_glb_js/base/get_days.sh
$SHOME/$LOGNAME/web_glb_js/base/ftp_html.sh

$SHOME/$LOGNAME/reanl/grads_webmap/CLIMATE_ANOMALY_map.sh $CDATE

#sleep 600

$SHOME/$LOGNAME/reanl/grads_webmap/CLIMATE_ANOMALY_map_cmc.sh $CDATE

fi

