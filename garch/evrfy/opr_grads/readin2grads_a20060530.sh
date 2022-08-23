
if [ $# -le 5 ]; then
 echo "Usage: $0 need STYMD, EDYMD, EXP_ID, IFDAYS(max=16), SDIR and PDIR"
 exit 8
fi

### STYMD=YYYYMMDD 
### EDYMD=YYYYMMDD
### EXP_ID=a/b/c/d ....
### IFDAYS is the longest lead forecasts ( maximum = 16 )
### SDIR is the directory of your scores
### PDIR id the directory of your plot

export SNAME

STYMD=$1
EDYMD=$2
EXPID=$3
icnt=0
ifdays=$4
SDIR=$5
PDIR=$6
ICTL=$7

EXdir=$SDIR

cd $PDIR;pwd

ifdays=`expr $ifdays + 1`

ndatex=/nwprod/util/exec/ndate

echo "&namin " >input

while [ $STYMD -le $EDYMD ]; do
 (( icnt += 1 ))
 if [ -s $EXdir/SCORES$EXPID.$STYMD\00 ]; then
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.${STYMD}00'"
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.${STYMD}00'," >>input
  echo "ifile($icnt)=1"
  echo "ifile($icnt)=1,"                            >>input
 else
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.${STYMD}00'"
  echo "cfile($icnt)='$EXdir/$SNAME$EXPID.${STYMD}00'," >>input
  echo "ifile($icnt)=0"
  echo "ifile($icnt)=0,"                            >>input
 fi

 STYMD=`$ndatex 24 $STYMD\00 | cut -c1-8`

done

echo "ofile='grads_$EXPID.dat',"                    >>input
echo "ofilm='gradm_$EXPID.dat',"                    >>input
echo "idays=$icnt"                                  >>input
echo "ifdays=$ifdays"                               >>input
echo "/" >>input

cat input
rm grads_$EXPID.dat
rm gradm_$EXPID.dat

if [ $ICTL -eq 1 ]; then
 #$HOME/evrfy/exec/23m_10+10_grads_daily_test <input
 $HOME/evrfy/exec/14m_a20060530_grads <input
elif [ $ICTL -eq 2 ]; then
 $HOME/evrfy/exec/10m_cmc_grads <input
fi
