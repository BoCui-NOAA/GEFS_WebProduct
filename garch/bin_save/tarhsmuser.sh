#!/usr/bin/ksh
#@ job_type = serial
#@ output = /nfsuser/g01/wx20yz/taravnhsm.out
#@ error  = /nfsuser/g01/wx20yz/taravnhsm.out
#@ wall_clock_limit = 00:60:00
#@ preferences = Feature == "dev"
#@ notification = never
#@ class = 1
#@ job_name = tar_hsm
#@ queue

#set -x
# #@ startdate = 10/19/00 06:00

PS4=' + taravnhsm.sh line $LINENO: '

#inpymdh=2002020100
inpymdh=$CDATE          

export PDY=` echo $inpymdh | cut -c1-8`
export cyc=` echo $inpymdh | cut -c9-10`
export yy=`     echo $PDY | cut -c3-4`
export mm=`     echo $PDY | cut -c5-6`
export dd=`     echo $PDY | cut -c7-8`
export hh=${cyc}
export yyyy=`   echo $PDY | cut -c1-4`
export yymmdd=` echo $PDY | cut -c3-8`
export yymmddhh=${yymmdd}${cyc}
export ymdh=${PDY}${hh}

export pdir=/global/ENSX2D
export hsmdir=/hsmuser/g01/wx20rw/ensxj2d/ensx.enspost/${yyyy}/${yyyy}${mm}

uname -a

echo "hsmdir= $hsmdir"

if [ ! -d $pdir ]; then mkdir -p $pdir; fi

cd $pdir

set +x
echo "Date before tar from HSM is `date`"
set -x

  timex rsh ncos70as "cat ${hsmdir}/tar.ensx.enspost.20${yymmdd}" | tar -xvf - ./ens.20${yymmdd}/enspost.t00z.z1000 ./ens.20${yymmdd}/enspost.t00z.z500 ./ens.20${yymmdd}/enspost.t12z.z1000 ./ens.20${yymmdd}/enspost.t12z.z500

set +x
echo "Date before tar from HSM is `date`"
set -x

cd $pdir
mv ens.20${yymmdd}/enspost.t00z.z1000  z1000.20${yymmdd}00
mv ens.20${yymmdd}/enspost.t00z.z500   z500.20${yymmdd}00
mv ens.20${yymmdd}/enspost.t12z.z1000  z1000.20${yymmdd}12
mv ens.20${yymmdd}/enspost.t12z.z500   z500.20${yymmdd}12

#rm ens.20${yymmdd}/*
rmdir ens.20${yymmdd}

