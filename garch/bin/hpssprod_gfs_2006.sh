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

#inpymdh=2005112300
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
export hpssdir=/1year/hpssprod/runhistory/rh${yyyy}/${yyyy}${mm}/${yyyy}${mm}${dd}
export COPYGB=/nwprod/util/exec/copygb

uname -a

echo "hpssdir= $hpssdir"

if [ ! -d $pdir ]; then mkdir -p $pdir; fi

cd $pdir

>fname
echo ./gfs.t${hh}z.pgrbf00                     >>fname
echo ./gfs.t${hh}z.pgrbf24                     >>fname
echo ./gfs.t${hh}z.pgrbf48                     >>fname
echo ./gfs.t${hh}z.pgrbf72                     >>fname
echo ./gfs.t${hh}z.pgrbf96                     >>fname
echo ./gfs.t${hh}z.pgrbf120                    >>fname
echo ./gfs.t${hh}z.pgrbf144                    >>fname
echo ./gfs.t${hh}z.pgrbf168                    >>fname
echo ./gfs.t${hh}z.pgrbf192                    >>fname
echo ./gfs.t${hh}z.pgrbf216                    >>fname
echo ./gfs.t${hh}z.pgrbf240                    >>fname
echo ./gfs.t${hh}z.pgrbf264                    >>fname
echo ./gfs.t${hh}z.pgrbf288                    >>fname
echo ./gfs.t${hh}z.pgrbf312                    >>fname
echo ./gfs.t${hh}z.pgrbf336                    >>fname
echo ./gfs.t${hh}z.pgrbf360                    >>fname
echo ./gfs.t${hh}z.pgrbf384                    >>fname

set +x
echo "Date before tar from HPSS is `date`"
set -x

hpsstar get $hpssdir/com_gfs_prod_gfs.${ymdh}.pgrb.tar `cat fname`

for hr in 00 24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 384
do

copygb -g2 -x gfs.t${hh}z.pgrbf$hr /ptmp/wx20yz/prs/pgbf$hr.${ymdh}

done

set +x
echo "Date after tar from HSM is `date`"
set -x



