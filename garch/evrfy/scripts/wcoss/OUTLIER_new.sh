

### example to submit gridtobs job
#!/bin/sh
#@ wall_clock_limit=25:40:00
#@ requirements = Feature == "beta"
#@ job_type = parallel
#@ output = /tmp/Yan.Luo/fits.o$(jobid)
#@ error = /tmp/Yan.Luo/fits.e$(jobid)
#@ total_tasks = 30
#@ node = 30
#@ node_usage = shared
#@ network.MPI=switch,not_shared,us
#@ class = dev
#
#@ queue
#

###
###        ------------------------------------------
###        Verify the single forecast upto 17 days
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

uname=` who am i | awk '{print $1}' `
tmpdir=/$stmp/Yan.Luo/vfens 

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

dat=$home/gvrfy/data
windex=/nwprod/util/exec/grbindex
nhours=/nwprod/util/exec/ndate

########################################################################
#   
#   1.  input1 ------> verification parameters setting
#   2.  input unit assign
#         unit 11 - 30 -------> analysis files
#         unit 31 - 50 -------> forecast files
#         unit 51 - 54 -------> climatology files
#                   51 -------> $home/vrfy/data/cac10y.ibm
#                   52 -------> $home/vrfy/data/nmc30y.ibm
#                   53 -------> $home/vrfy/data/cac8yn.ibm
#                   54 -------> $home/vrfy/data/cac8ys.ibm
#         unit 81 - 90 -------> output files
########################################################################

if [ $# -lt 2 ]; then
   stymd=20030402
   edymd=20030407
else
   stymd=$1
   edymd=$2
fi

hours=264

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
###  ilv=1   ---> 1000mb  ilv=2   ---> 500mb
###

while [ $stymd -le $edymd ]; do

#for ilv in 1000 500
for ilv in 500
do

echo "&files"  >input2
echo "&namin"  >input3

ymdp24=`$nhours +24 $stymd\00 `
var=" kdate(1)=$ymdp24, "
echo "$var"
echo "$var" >>input3

ymdp12=`$nhours +12 $stymd\00 `
var=" kdate(2)=$ymdp12, "
echo "$var"
echo "$var" >>input3

stymdh=$stymd\00
var=" kdate(3)=$stymdh, "
echo "$var"
echo "$var" >>input3

ymdm12=`$nhours -12 $stymd\00 `
var=" kdate(4)=$ymdm12, "
echo "$var"
echo "$var" >>input3

err1=0
err2=0

###
# get analysis data
###

kcnt=1
YYYY=`echo $edymd | cut -c1-4`
pymdh=$ymdm12                   
nstep=` expr $hours / 12 `; echo $nstep
nstep=` expr $nstep + 2 ` ; echo $nstep
while [ $kcnt -le $nstep ]; do
   hcnt=` echo $pymdh | cut -c9-10`
   if [ $hcnt -eq 00 ]; then
      ymdh=$pymdh
   else
      ymdh=`$nhours 12 $pymdh `
   fi
   jcnt=` expr $kcnt + 4 `
   var=" kdate($jcnt)=$pymdh, "
   echo "$var"
   echo "$var" >>input3
   pymdh=`$nhours 12 $pymdh `
   kcnt=` expr $kcnt + 1 `
done

   if [ -s $GLOBAL/ens/z$ilv\_ncep_fnl.$YYYY ]; then
      cp $GLOBAL/ens/z$ilv\_ncep_fnl.$YYYY nmc_anl.$ilv
   fi
   $windex nmc_anl.$ilv nmc_anl.$ilv.index
   var="cfiles(1,1)='nmc_anl.$ilv',"
   echo "$var"          
   echo "$var" >>input2
   var="cfiles(2,1)='nmc_anl.$ilv.index',"
   echo "$var"          
   echo "$var" >>input2

###
# get forecasting file
###
   jcnt=1

   pgb=z$ilv.$stymd\00
   pgi=z$ilv.$stymd\00.index 
   cat $GLOBAL/ENS/z$ilv.$stymd\00 $GLOBAL/ENS/z$ilv.$ymdm12 > $pgb
   $windex $pgb $pgi
   var="cfiles(1,2)='$pgb',"
   echo "$var"            
   echo "$var" >>input2
   var="cfiles(2,2)='$pgi',"
   echo "$var"            
   echo "$var" >>input2

   pgb=z$ilv.$ymdp24
   pgi=z$ilv.$ymdp24.index 
   cat $GLOBAL/ENS/z$ilv.$ymdp24 $GLOBAL/ENS/z$ilv.$stymd\12 >$pgb
   $windex $pgb $pgi
   var="cfiles(1,3)='$pgb',"
   echo "$var"            
   echo "$var" >>input2
   var="cfiles(2,3)='$pgi',"
   echo "$var"            
   echo "$var" >>input2
   echo " nhours=$hours,ilv=$ilv," >>input3

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

if [ $stymd -le 20000511 ]; then
$home/evrfy/exec/vrfy_outlier_28m <input0
else
#/nfsuser/g01/wx20yz/evrfy/exec/vrfy_outlier <input0
### using new scripts since 08/05/2002
### adding 40 ensemble mean to the map
#$home/evrfy/exec/vrfy_outlier_new <input0
$home/evrfy/exec/vrfy_outlier_20060601 <input0
fi

cp outlier.dat outlier.z$ilv 

done

cp outlier.z500 $NGLOBAL/Yan.Luo/evfscores/OUTLIEs.$stymd\00

$home/evrfy/scripts/OMAP_new.sh $stymd
#/nfsuser/g01/wx20yz/evrfy/scripts/OMAP.sh $stymd
#/nfsuser/g01/wx20yz/evrfy/scripts/OMAP_bk.sh $stymd
       
stymd=`$nhours +24 $stymd\00 | cut -c1-8`      

rm outlier.dat outlier.z500

done
rm /$stmp/Yan.Luo/vfens/*

