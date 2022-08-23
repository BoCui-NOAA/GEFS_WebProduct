
if [ $# -le 5 ]; then
 echo "Usage: $0 need STYMD, EDYMD, EXP_ID, IFDAYS(max=16), SDIR, PDIR"
 exit 8
fi

### STYMD=YYYYMMDD 
### EDYMD=YYYYMMDD
### EXP_ID=a/b/c/d ....
### IFDAYS is the longest lead forecasts ( maximum = 16 )
### SDIR is the directory of your scores
### PDIR id the directory of your plot

export SNAME VHOUR

STYMD=$1
EDYMD=$2
EXPID=$3
icnt=0
ifdays=$4
SDIR=$5
PDIR=$6
EXdir=$SDIR

if [ $# -eq 7 ]; then
GEXPID=$7
else
GEXPID=$EXPID
fi

cd $PDIR;pwd

ifdays=`expr $ifdays + 1`

echo "&namin " >input

while [ $STYMD -le $EDYMD ]; do
 (( icnt += 1 ))
 SYMDH=$STYMD$VHOUR 
 if [ -s $EXdir/SCORES$EXPID.$SYMDH ]; then
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.$SYMDH'"
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.$SYMDH'," >>input
  echo "ifile($icnt)=1"
  echo "ifile($icnt)=1,"                            >>input
 else
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.$SYMDH'"
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.$SYMDH'," >>input
  echo "ifile($icnt)=0"
  echo "ifile($icnt)=0,"                            >>input
 fi

 STYMD=`$nhours 24 $STYMD\00 | cut -c1-8`

done

echo "ofile='grads_$GEXPID.dat',"                    >>input
echo "idays=$icnt" >>input
echo "ifdays=$ifdays" >>input
echo "/" >>input

cat input
rm grads_$GEXPID.dat

$GLOBAL/vrfy_grads/sorc/readin2grads <input
