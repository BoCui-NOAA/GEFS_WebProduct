
###                ****** PROB_NCEP_opr.sh *******
###
###   This script will run the ralative measure of predictability (RMOP)
###   ---------------------- 11/14/2000
###

set -x
date;pwd

export tmpdir=$GTMP/yan.luo/vfprob

if [ -s $tmpdir ]; then
  rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi

export script=$SHOME/yan.luo/eprob/scripts
export bindir=$SHOME/yan.luo/bin
export datdir=$SHOME/yan.luo/eprob/data

cp $datdir/dis_avg20.dat .
################################################################
ymdh=$CDATE           
ymd=`echo $CDATE | cut -c1-8`
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

cp $datdir/prob_nh_${MM}.dat $script/prob_nh.dat

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
cat $GLOBAL/ENS/z500.$ymdh >z500.$ymdh
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
nstep=` expr $fhours / 12 ` ; echo $nstep
kcnt=1
while [ $kcnt -le $nstep ] ; do
#################################################################
#### Verifying dates  
#################################################################
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

#/nfsuser/g01/wx20yz/eprob/exec/prob_opr_new <param
#$SHOME/yan.luo/save/eprob/exec/prob_opr_20060530 <param
$SHOME/yan.luo//eprob/exec/prob_opr_20m <param

echo "  Updated to $CDATE" >header

lines=`cat dis_avg_new.dat | wc -l`
if [ $lines -ne 0 ]; then
 cat header dis_avg_new.dat >$datdir/dis_avg20_tmp.dat
 length=`cat $datdir/dis_avg20_tmp.dat | wc -l`
 if [ $length -eq 142 ]; then
  cp $datdir/dis_avg20_tmp.dat $datdir/dis_avg20.dat
 fi
fi

rm input1 input2 input3 param 
#cp probex.ens $GLOBAL/eprob/prob.$CDATE
mv probex.ens prob.$CDATE
ls -l *grads

$script/MMAP.sh $ymd
$script/MMAP_pac.sh $ymd
$script/MMAP_nh.sh $ymd

####################################################################
ymdh=`$nhours 24 $ymdh `
cp $datdir/dis_avg20.dat $datdir/dis_avg20.$ymdh
ndayb=`expr $ndayb + 1 `
done

#rm /$stmp/yan.luo/vfprob/*
