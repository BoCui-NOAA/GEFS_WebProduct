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

#inpymdh=2002050100
inpymdh=$1             

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
#export pdir=/gpfstmp/wx20yz/mrf         
export hsmdir=/hsmprod/runhistory/rh${yyyy}/${yyyy}${mm}/${yyyy}${mm}${dd}
export COPYGB=/nwprod/util/exec/copygb

uname -a

echo "hsmdir= $hsmdir"

if [ ! -d $pdir ]; then mkdir -p $pdir; fi

cd $pdir

### for Xiaolei Zou's data assimilation

>fname
echo ./gdas1.t${hh}z.pgrbanl                     >>fname
echo ./gdas1.t${hh}z.pgrbf06                     >>fname
echo ./gdas1.t${hh}z.sfluxgrbf06                 >>fname

>fname

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

### for Weizhong Zeng data assimilation

>fname
echo ./gdas1.t${hh}z.pgrbanl                     >>fname
echo ./gdas1.t${hh}z.sfluxgrbf00                 >>fname
echo ./gdas1.t${hh}z.snogrb                      >>fname
echo ./gdas1.t${hh}z.sstgrb                      >>fname


set +x
echo "Date before tar from HSM is `date`"
set -x

#if [ ! -s /global/prs/pgbf06.$inpymdh ]; then
 timex rsh ncos70as "cat ${hsmdir}/com_fnl_prod_fnl.${ymdh}.tar" | tar -xvf -  `cat fname`

#/nwprod/util/exec/grbindex gdas1.t${hh}z.pgrbanl gdas1.t${hh}z.pgrbianl
#/nwprod/util/exec/grbindex gdas1.t${hh}z.pgrbf06 gdas1.t${hh}z.pgrbif06
#copygb -g2 gdas1.t${hh}z.pgrbanl gdas1.t${hh}z.pgrbianl /global/prs/pgbf00.$inpymdh
#copygb -g2 gdas1.t${hh}z.pgrbf06 gdas1.t${hh}z.pgrbif06 /global/prs/pgbf06.$inpymdh
#ln -s /global/prs/pgbf00.$inpymdh /global/prs/pgbanl.$inpymdh
#cp     $pdir/gdas1.t${hh}z.sfluxgrbf06 /global/prs/flxf06.$inpymdh
#fi

set +x
echo "Date after tar from HSM is `date`"
set -x



