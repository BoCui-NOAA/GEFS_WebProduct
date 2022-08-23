
###
###   This job will calculate the probability of CMC ensemble          
###    -------- New at 03/19/2002
###

#set -x
date;pwd

tmpdir=$GTMP/yan.luo/vfprob_cmc10m_f

if [ -s $tmpdir ]; then
  rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi

sorc=$SHOME/yan.luo/eprob/scripts
bindir=$SHOME/yan.luo/bin

################################################################
ymdh=$CDATE           
fhours=384 
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
  nhours=$fhours,ilv=4,kp5=7,kp6=100,kp7=500,icon=2,icoeff=1,
 /    
paramEOF
echo " &files " > input2
echo " &kdata " > input3
################################################################
#### Forecast file
################################################################

ymdhm12=`$nhours -12 $ymdh`
cat $GLOBAL/cmc_ens/z500.$ymdh >z500.$ymdh
pgb=z500.$ymdh
pgi=z500i.$ymdh
$windex  $pgb $pgi
var=" cfilef(1)='$pgb',cfilef(2)='$pgi', "
echo "$var"
echo "$var" >> input2
 
var=" kdate(1)=$ymdh "
echo "$var"
echo "$var" >> input3
var=" kdate(2)=$ymdhm12 "
echo "$var"
echo "$var" >> input3

#################################################################
#### Analysis files
#################################################################
ymdhp12=`$nhours +12 $ymdh`
pgb=$GLOBAL/ens/z500_cmc_fnl.$YYYY
pgi=z500_cmc_fnl.$YYYY\i
$windex $pgb $pgi
var=" cfilea(1,1)='$pgb',cfilea(2,1)='$pgi', "
echo "$var"
echo "$var" >> input2
nstep=` expr $fhours / 12 ` ; echo $nstep
kcnt=1
while [ $kcnt -le $nstep ] ; do
################################################################
#### Verifying dates  
###############################################################
jcnt=` expr $kcnt + 2 `
var=" kdate($jcnt)=$ymdhp12 "
echo "$var"
echo "$var" >> input3
kcnt=` expr $kcnt + 1 `
ymdhp12=`$nhours 12 $ymdhp12 `
done

echo " /" >>input2
echo " /" >>input3
cat input2 input1 input3 > param

export sorc YYMM ymdh tmpdir

#/nfsuser/g01/wx20yz/eprob/exec/VFPROB_cmc10m_f20060530 <param
$SHOME/yan.luo/eprob/exec/VFPROB_10m_f20060530 <param

cp prob.ens $SHOME/yan.luo/global/vfprob/PROB10m.$ymdh

rm input1 input2 input3 param
####################################################################
ymdh=`$nhours 24 $ymdh `
ndayb=`expr $ndayb + 1 `
done
