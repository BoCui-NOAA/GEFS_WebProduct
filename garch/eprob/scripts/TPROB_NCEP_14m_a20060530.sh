
###
###   This job will calculate the probability of NCEP ensemble          
###    -------- New at 07/21/97
###   Against one analysis -- New at 01/02/2003
###

set -x
date;pwd

tmpdir=$GTMP/$LOGNAME/teprob_14m_a

if [ -s $tmpdir ]; then
  rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi

sorc=$SHOME/$LOGNAME/eprob/scripts
bindir=$SHOME/$LOGNAME/bin

################################################################
ymdh=$CDATE           
fhours=384 
nstepm1=`expr $fhours / 12 `; echo $nstepm1
nstep=`expr $nstepm1 + 1 `
ndayb=1
ndayl=1
YY=`echo $ymdh | cut -c3-4`
MM=`echo $ymdh | cut -c5-6`
MMp1=`expr $MM + 1 `               
MMm1=`expr $MM - 1 `               
YYYY=`echo $ymdh | cut -c1-4`
if [ $MMp1 -eq 13 ]; then MMp1=1 ; fi
if [ $MMp1 -le 9 ]; then MMp1=0$MMp1 ; fi
if [ $MMm1 -eq 00 ]; then 
   MMm1=12 
   YY=`expr $YY - 1 `
fi
if [ $MMm1 -le 9 ]; then MMm1=0$MMm1 ; fi
CMM=`grep "$MM" $bindir/mon2mon | cut -c8-10`
CMMp1=`grep "$MMp1" $bindir/mon2mon | cut -c8-10`
CMMm1=`grep "$MMm1" $bindir/mon2mon | cut -c8-10`
YYMM=$YY$MMm1

while [ $ndayb -le $ndayl ]; do
################################################################
cat <<paramEOF > input1
 &namin
  nhours=$fhours,ilv=4,kp5=11,kp6=100,kp7=850,icon=2,icoeff=1,
 /    
paramEOF
echo " &files " > input2
echo " &kdata " > input3
#################################################################
#### Analysis files
#################################################################
ymdhm12=`$nhours -12 $ymdh`
pgb=$GLOBAL/ENS/t850.$ymdh            
pgi=t850i_anl.$ymdh   
$windex $pgb $pgi
var=" cfilea(1,1)='$pgb',cfilea(2,1)='$pgi', "
echo "$var"
echo "$var" >> input2

################################################################
#### Verifying dates  
###############################################################

var=" kdate(1)=$ymdh "
echo "$var"
echo "$var" >> input3

>t850_fst.$ymdh
YMDH=$ymdh

kcnt=1
 
while [ $kcnt -le $nstep ] ; do

jcnt=` expr $kcnt + 1 `
var=" kdate($jcnt)=$ymdhm12 "
echo "$var"
echo "$var" >> input3

################################################################
#### Forecast file
################################################################

YMDH=`$nhours -12 $YMDH`
infile=$GLOBAL/ENS/t850.$YMDH
ifrs=`expr $kcnt \* 12 `
$wgrib $infile | grep ":${ifrs}hr fcst" | wgrib -i $infile -grib -append -o t850_fst.$ymdh

kcnt=`expr $kcnt + 1`
ymdhm12=`$nhours -12 $ymdhm12 `

done

pgb=t850_fst.$ymdh
pgi=t850i_fst.$ymdh
$windex  $pgb $pgi
var=" cfilef(1)='$pgb',cfilef(2)='$pgi', "
echo "$var"
echo "$var" >> input2

echo " /" >>input2
echo " /" >>input3
cat input2 input1 input3 > param

$SHOME/$LOGNAME/eprob/exec/TVFPROB_14m_a20060530  <param
mv prob.ens $GLOBAL/eprob/TPROB14.$ymdh

####################################################################
ymdh=`$nhours 24 $ymdh `
ndayb=`expr $ndayb + 1 `
done
