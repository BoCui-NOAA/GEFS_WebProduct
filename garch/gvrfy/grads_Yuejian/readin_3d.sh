
if [ $# -le 2 ]; then
   echo "Usage: $0 need STYMD, EDYMD and EXP_ID"
   exit 8
fi

mkdir /ptmp/wx20yz/grads
cd /ptmp/wx20yz/grads

STYMD=$1
EDYMD=$2

EXPID=$3
EXdir=/global/prh
icnt=0

ndatex=/nfsuser/g01/wx20yz/bin/ndate
#ndatex=/nwprod/util/exec/ndate

echo "&namin " >input

while [ $STYMD -le $EDYMD ]; do
 (( icnt += 1 ))
 if [ -s $EXdir/SCORES$EXPID.$STYMD ]; then
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMD'"
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMD'," >>input
  echo "ifile($icnt)=1"
  echo "ifile($icnt)=1,"                            >>input
 else
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMD'"
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMD'," >>input
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

/nfsuser/g01/wx20yz/gvrfy/grads/readin_3d <input
