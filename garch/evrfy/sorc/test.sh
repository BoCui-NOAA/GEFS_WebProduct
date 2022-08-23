
if [ $# -le 2 ]; then
   echo "Usage: $0 need STYMD, EDYMD and EXP_ID"
   exit 8
fi

mkdir /ptmp/wx20yz/test  
cd /ptmp/wx20yz/test  

STYMD=$1
EDYMD=$2

EXPID=$3
EXdir=/ptmp/wx20is/scorest62   
icnt=0

ndatex=/nwprod/util/exec/ndate

echo "&namin " >input

while [ $STYMD -le $EDYMD ]; do
 (( icnt += 1 ))
 STYMDH=$STYMD\00
 if [ -s $EXdir/SCORES$EXPID.$STYMDH ]; then
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMDH'"
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMDH'," >>input
  echo "ifile($icnt)=1"
  echo "ifile($icnt)=1,"                            >>input
 else
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMDH'"
  echo "cfile($icnt)='$EXdir/SCORES$EXPID.$STYMDH'," >>input
  echo "ifile($icnt)=0"
  echo "ifile($icnt)=0,"                            >>input
 fi

 STYMD=`$ndatex 24 $STYMD\00 | cut -c1-8`

done

echo "ofile='AVG$EXPID.dat',"                    >>input
echo "idays=$icnt" >>input
echo "/" >>input

cat input
rm AVG$EXPID.dat

/nfsuser/g01/wx20yz/evrfy/exec/exp_avg_15d <input

cat AVG$EXPID.dat 
cp  AVG$EXPID.dat  /global/help/wx20is

