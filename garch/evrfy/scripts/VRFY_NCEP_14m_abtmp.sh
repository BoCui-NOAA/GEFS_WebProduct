
### example to submit gridtobs job
#!/bin/sh
#@ wall_clock_limit=29:00:00
#@ requirements = Feature == "beta"
#@ job_type = parallel
#@ output = /tmp/yan.luo/fits.o$(jobid)
#@ error = /tmp/yan.luo/fits.e$(jobid)
#@ total_tasks = 30
#@ node = 30
#@ node_usage = shared
#@ network.MPI=switch,not_shared,us
#@ class = dev
#@ account_no = GEN-MTN
#
#@ queue
#

###
###        ------------------------------------------
###        Verify the singler forecast upto 17 days
###        ------------------------------------------
###
### This is a offical jcl to run NCEP ensemble forecast verification 
### on Cray-C90, The scores will stay in $TMPDIR unless you save
### them to your save place
###
###     Yuejian Zhu ( 02/06/95 )
###

set -x
date;pwd

tmpdir=$GTMP/yan.luo/evrfy_14m_abtmp

if [ -s $tmpdir ]; then
  rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi

###
### 2. Set up the climate data entry, grib utility entry.
###

dat=$SHOME/yan.luo/gvrfy/data

########################################################################
#   
#   1.  input1 ------> verification parameters setting
#   2.  input unit assign
#         unit 11 - 30 -------> analysis files
#         unit 31 - 50 -------> forecast files
#         unit 51 - 54 -------> climatology files
#                   51 -------> $HOME/vrfy/data/cac10y.ibm
#                   52 -------> $HOME/vrfy/data/nmc30y.ibm
#                   53 -------> $HOME/vrfy/data/cac8yn.ibm
#                   54 -------> $HOME/vrfy/data/cac8ys.ibm
#         unit 81 - 90 -------> output files
########################################################################

stymd=`echo $CDATE | cut -c1-8`
edymd=`echo $CDATE | cut -c1-8`
if [ $# -lt 2 ]; then
   stymd=$stymd     
   edymd=$edymd   
else
   stymd=$1
   edymd=$2
fi

hours=360

###---
###   1. For region verification, please refer this map to
###      set up la1,la2,lo1,lo2
###      a. icoeff must equal 0 ( grid verification only )
###
###      lon=1                    lon=73                lon=145
###        0E                      180E                   0E
###   90.0N ------------------------------------------------ lat=1 
###         |                                              |
###         |                                              |
###         |                                              |
###         |                                              |
###         |                                              |
###   EQ    +----------------------------------------------+ lat=37
###         |                                              |
###         |                                              |
###         |                                              |
###         |                                              |
###         |                                              |
###   90.0S ------------------------------------------------ lat=73
###
###   --------- icon=1 (Indian)   40E - 120E    40N -    0N -------
###                    icon=1  lon1=17 lon2=49 lat1=21 lat2=37
###   --------- icon=2 (N. Am.)  140W -  50W    20N -   60N -------
###                    icon=2  lon1=89 lon2=125lat1=13 lat2=29
###   --------- icon=3 (Europe)   20W -  40E  77.5N -   30N -------
###                    icon=3  lon1=136lon2=17 lat1=6  lat2=25
###   --------- icon=4 (N. H. )   0E -  360E  77.5N -   20N -------
###                    icon=4  lon1=1  lon2=144lat1=6  lat2=29
###   --------- icon=5 (S. H. )   0E -  360E    20S - 77.5S -------
###                    icon=5  lon1=1  lon2=144lat1=45 lat2=68
###   --------- icon=6 (Trop. )   0E -  360E    20N -   20S -------
###                    icon=6  lon1=1  lon2=144lat1=29 lat2=45
###
###---

###   2. For global hemisphere verification, please refer following set up
###      you should able to choose icoeff=0 or icoeff=1
###
###  la1=6   ---> 77.5S   la2=29  ---> 20.0S
###  la1=45  ---> 20.0N   la2=68  ---> 77.5N
###  This is a example set up for both hemisphere
###  la1=6,la2=29,lo1=1,lo2=144,l1=9,l2=32,nhours=$hours,ilv=$ilv,icon=2,icoeff=0
###  l1 =9   ---> 20.0    l2 =32  ---> 77.5 for both hemisphere 
###
###  ilv=1   ---> t850mb  ilv=2   ---> t2m  
###

while [ $stymd -le $edymd ]; do

for ilv in 850 2m   
do

ilvn=$ilv
if [ "$ilv" = "2m" ]; then
ilvn=2
fi

echo "&files"  >input2
echo "&namin"  >input3

var=" ndate=${stymd}00 , "
echo "$var"
echo "$var" >>input3

err1=0
err2=0

###
# get analysis data
###

YMDH=$stymd\00
YYYY=`echo $stymd | cut -c1-4`
ifile=$GLOBAL/ENS/t$ilv.$YMDH
if [ -s $ifile ]; then
   wgrib $ifile | grep "ens+1:" | grep "anl" | wgrib -i $ifile -grib -o nmc_anl.t$ilv
fi
$windex nmc_anl.t$ilv nmc_anl.t$ilv.index
var="cfiles(1,1)='nmc_anl.t$ilv',"
echo "$var"          
echo "$var" >>input2
var="cfiles(2,1)='nmc_anl.t$ilv.index',"
echo "$var"          
echo "$var" >>input2

###
# get forecasting file
###

kcnt=1
nstep=` expr $hours / 12 `; echo $nstep
nstep=` expr $nstep + 2 ` ; echo $nstep
while [ $kcnt -le $nstep ]; do

   ymdhp24=`$nhours +24 $YMDH `
   var=" kdate(1,$kcnt)=$ymdhp24, "
   echo "$var"
   echo "$var" >>input3

   ymdhp12=`$nhours +12 $YMDH `
   var=" kdate(2,$kcnt)=$ymdhp12, "
   echo "$var"
   echo "$var" >>input3

   ymdhp00=$YMDH       
   var=" kdate(3,$kcnt)=$ymdhp00, "
   echo "$var"
   echo "$var" >>input3

   ymdhm12=`$nhours -12 $YMDH `
   var=" kdate(4,$kcnt)=$ymdhm12, "
   echo "$var"
   echo "$var" >>input3

   jcnt=1

   pgb=t$ilv.$ymdhp00  
   pgi=t$ilv.$ymdhp00.index 
   cat $GLOBAL/ENS_bc/t$ilv.$ymdhp00 $GLOBAL/ENS_bc/t$ilv.$ymdhm12 > $pgb
   $windex $pgb $pgi
   var="cfiles(3,$kcnt)='$pgb',"
   echo "$var"            
   echo "$var" >>input2
   var="cfiles(4,$kcnt)='$pgi',"
   echo "$var"            
   echo "$var" >>input2

   pgb=t$ilv.$ymdhp24
   pgi=t$ilv.$ymdhp24.index 
   cat $GLOBAL/ENS_bc/t$ilv.$ymdhp24 $GLOBAL/ENS_bc/t$ilv.$ymdhp12 >$pgb
   $windex $pgb $pgi
   var="cfiles(5,$kcnt)='$pgb',"
   echo "$var"            
   echo "$var" >>input2
   var="cfiles(6,$kcnt)='$pgi',"
   echo "$var"            
   echo "$var" >>input2
   if [ "$ilv" = "2m" ]; then
   echo " nhours=$hours,ilv=$ilvn,icoeff=1,iclim=2," >>input3
   else
   echo " nhours=$hours,ilv=$ilvn,icoeff=1,iclim=1," >>input3
   fi

   kcnt=`expr $kcnt + 1`
   YMDH=`$nhours -12 $YMDH`
done 

   echo "/" >>input2
   echo "/" >>input3
cat input2 input3 >input0
cat input0  

###
### Very Important, When err1 and err2 are not zero
###

if [ $err1 -ne 0 ]; then
   echo " The err1 = $err1 "
   echo " Go-back to check rcp process "
   echo " The job is running, but it may not correct "
   echo " Warnning!!! Warnning!!!                    "
fi

if [ $err2 -ne 0 ]; then
   echo " The err2 = $err2 "
   echo " Go-back to check getindex process "
   echo " The job is running, but it may not correct "
   echo " Warnning!!! Warnning!!!                    "
fi

pwd

$SHOME/yan.luo/evrfy/exec/VRFY_14m_atmp <input0
#
cp scores.ens scores.t$ilv

done

cat scores.t850 scores.t2m >$NGLOBAL/yan.luo/evrfy/SCOTMPb.$stymd\00

stymd=`$nhours +24 $stymd\00 | cut -c1-8`      

done


####
####  GrADs plotting job.
####
####   Updated daily ( started from Jan. 30th 2003 )

export EDYMD=`echo $CDATE | cut -c1-8`
export STYMD=`$nhours -1080 $CDATE | cut -c1-8`
#/nfsuser/g01/wx20yz/evrfy/opr_grads/RUN_4_GRADS.sh
#/nfsuser/g01/wx20yz/evrfy/opr_grads/RUN_4_GRADS_tg.sh
