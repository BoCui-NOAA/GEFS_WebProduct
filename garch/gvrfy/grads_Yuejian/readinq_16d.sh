
if [ $# -le 3 ]; then
   echo "Usage: $0 need STYMD, EDYMD, EXP_ID and EXDIR"
   exit 8
fi

mkdir /ptmp/wx20yz/qgrads
cd /ptmp/wx20yz/qgrads

STYMD=$1
EDYMD=$2

EXPID=$3
#EXdir=/global/vrfyq
EXdir=$4               
icnt=0

ndatex=/nfsuser/g01/wx20yz/bin/ndate
#ndatex=/nwprod/util/exec/ndate

echo "&namin " >input

while [ $STYMD -le $EDYMD ]; do
 (( icnt += 1 ))
 if [ -s $EXdir/SCORES$EXPID.$STYMD\00 ]; then
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.${STYMD}00'"
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.${STYMD}00'," >>input
  echo "ifile($icnt)=1"
  echo "ifile($icnt)=1,"                            >>input
 else
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.${STYMD}00'"
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.${STYMD}00'," >>input
  echo "ifile($icnt)=0"
  echo "ifile($icnt)=0,"                            >>input
 fi

 STYMD=`$ndatex 24 $STYMD\00 | cut -c1-8`

done

echo "ofile='grads_$EXPID.dat',"                    >>input
echo "idays=$icnt" >>input
echo "/" >>input

cat input
rm grads_$EXPID.dat

/nfsuser/g01/wx20yz/gvrfy/grads/readinq_16d <input
