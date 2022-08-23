
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

#set -x

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

workdir=$PTMP/$LOGNAME/earch18_para
COMDIR=$GLOBAL/ENSPARA    

# production directory

DFROM=/com/gens/para

if [ ! -s $workdir ]; then
   mkdir -p $workdir
fi
cd $workdir;pwd;rm $workdir/*

TEST=NO
export CDATE COMDIR DFROM YMD YMDH 
export nhours windex 

YMD=`echo $CDATE | cut -c1-8`
HH=`echo $CDATE | cut -c9-10`
YMDH=$CDATE
YMDM1=`$nhours -24 $YMDH | cut -c1-8`
YMDHM5=`$nhours -120 $YMDH`
YMDHM15=`$nhours -360 $YMDH`
YMDHM45=`$nhours -1080 $YMDH`
YMDM45=`$nhours -1080 $YMDH | cut -c1-8`
YMDHM65=`$nhours -1560 $YMDH`

if [ $HH -ne 18 ]; then
   echo " This is not cycle 18Z job, exit "
   exit 8
fi

rm $GLOBAL/ENS/*.${YMDM65}18

for file in z1000 z500 u850 u250 v850 v250 t850 t2m prcp prmsl
do
 if [ "$file" = "prcp" ]; then
    fileo=precip
 else
    fileo=$file
 fi
 cp $DFROM/gefs.$YMD/${HH}/ensstat/enspost.t${HH}z.${file}  $COMDIR/${fileo}.${YMD}${HH}
done

for file in pqpf pqrf pqsf pqif pqff                         
do
 cp $DFROM/gefs.$YMD/${HH}/ensstat/ensstat.t${HH}z.${file}  $COMDIR/${file}.${YMD}${HH}
done

