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

inpymdh=2003030100
#inpymdh=$1             

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

export pdir=/ptmp/wx20yz/fnl/${yymmdd}     
#export hpssdir=/hpssprod/runhistory/rh${yyyy}/${yyyy}${mm}/${yyyy}${mm}${dd}
export hpssdir=/hpssuser/g02/wx15gv/s70/hsmprod/runhistory/rh${yyyy}/${yyyy}${mm}/${yyyy}${mm}${dd}
export COPYGB=/nwprod/util/exec/copygb

uname -a

echo "hpssdir= $hpssdir"

if [ ! -d $pdir ]; then mkdir -p $pdir; fi

cd $pdir

### for Xiaolei Zou's data assimilation

>fname
echo ./gdas1.t${hh}z.pgrbanl                     >>fname
echo ./gdas1.t${hh}z.pgrbf06                     >>fname
echo ./gdas1.t${hh}z.sfluxgrbf06                 >>fname

echo ./gdas1.t${hh}z.prepbufr                    >>fname
echo ./gdas1.t${hh}z.m1bn14.tm00.ieee_d          >>fname
echo ./gdas1.t${hh}z.h1bn14.tm00.ieee_d          >>fname
echo ./gdas1.t${hh}z.h1bn15.tm00.ieee_d          >>fname
echo ./gdas1.t${hh}z.h1bn16.tm00.ieee_d          >>fname
echo ./gdas1.t${hh}z.sbvn16.tm00.ieee_d          >>fname
echo ./gdas1.t${hh}z.a1bn15.tm00.ieee_d          >>fname 
echo ./gdas1.t${hh}z.a1bn16.tm00.ieee_d          >>fname
echo ./gdas1.t${hh}z.b1bn15.tm00.ieee_d          >>fname
echo ./gdas1.t${hh}z.b1bn16.tm00.ieee_d          >>fname

echo ./gdas1.t${hh}z.sfcanl                      >>fname   
echo ./gdas1.t${hh}z.abias                       >>fname
echo ./gdas1.t${hh}z.sgm3prep                    >>fname
echo ./gdas1.t${hh}z.sgesprep                    >>fname
echo ./gdas1.t${hh}z.sgp3prep                    >>fname

set +x
echo "Date before tar from HPSS is `date`"
set -x

hpsstar get $hpssdir/com_fnl_prod_fnl.${ymdh}.tar `cat fname`

set +x
echo "Date after tar from HSM is `date`"
set -x



