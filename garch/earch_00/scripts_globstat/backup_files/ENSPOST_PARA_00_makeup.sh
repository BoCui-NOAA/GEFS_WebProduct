
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

workdir=$PTMP/$LOGNAME/earch00_para_makeup
COMDIR=$GLOBAL/ENSPARA      

### production commands and directory

TEST=NO
DFROM=/com/mrf/prod
#DFROM=/com/gens/para
DFROM=/ptmp/wx22lu/ncep_data

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

#for file in z1000 z500 u850 u250 v850 v250 t850 prcp prcp_24hbc prmsl t2m
for file in u10m v10m
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

