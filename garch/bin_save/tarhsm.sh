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

set -x
# #@ startdate = 10/19/00 06:00

PS4=' + taravnhsm.sh line $LINENO: '

inpymdh=2002022200

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

export pdir=/gpfstmp/wx20yz/enshr
export hsmdir=/hsmprod/runhistory/rh${yyyy}/${yyyy}${mm}/${yyyy}${mm}${dd}

uname -a

echo "hsmdir= $hsmdir"

if [ ! -d $pdir ]; then mkdir -p $pdir; fi

cd $pdir

set +x
echo "Date before tar from HSM is `date`"
set -x

  timex rsh ncos70as "cat ${hsmdir}/com_mrf_prod_ens.${ymdh}.pgrib.tar" | tar -xvf - ./ensc0.t00z.pgrbf42 ./ensn1.t00z.pgrbf42 ./ensn2.t00z.pgrbf42 ./ensn3.t00z.pgrbf42 ./ensn4.t00z.pgrbf42 ./ensn5.t00z.pgrbf42 ./ensp1.t00z.pgrbf42 ./ensp2.t00z.pgrbf42 ./ensp3.t00z.pgrbf42 ./ensp4.t00z.pgrbf42 ./ensp5.t00z.pgrbf42 

set +x
echo "Date before tar from HSM is `date`"
set -x

cd $pdir
touch ./*
