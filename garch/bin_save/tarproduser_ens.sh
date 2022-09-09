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

#PS4=' + taravnhsm.sh line $LINENO: '

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

#export pdir=/global/bim/prmsl_data
export pdir=/ptmp/wx20yz/ens          
export hsmdir=/hsmprod/runhistory/rh$yyyy/$yyyy$mm/$yyyy$mm$dd

uname -a

echo "hsmdir= $hsmdir"

if [ ! -d $pdir ]; then mkdir -p $pdir; fi

cd $pdir

>fname
for fff in prcp prmsl rh700 t250 t2m t500 t850 tmax tmin u10m u250 u500 u850 v10m v250 v500 v850 z1000 z250 z500 z700 z850
do

echo ./enspost.t${hh}z.${fff}hr                    >>fname
echo ./enspost.t${hh}z.${fff}hri                   >>fname

done

set +x
echo "Date before tar from HSM is `date`"
set -x

# timex rsh ncos70as "cat ${hsmdir}/com_mrf_prod_ens.200109${dd}00.enspost.tar" | tar -xvf - ./enspost.t00z.prmsl
# timex rsh ncos70as "cat ${hsmdir}/com_mrf_prod_ens.200109${dd}12.enspost.tar" | tar -xvf - ./enspost.t12z.prmsl
  timex rsh ncos70as "cat ${hsmdir}/com_mrf_prod_ens.200304${dd}12.enspost.tar" | tar -xvf - `cat fname`           

set +x
echo "Date before tar from HSM is `date`"


