
if [ $# -lt 3 ]; then
 echo "Usage: $0 need STYMD, EXP_ID, SDIR"
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
EXPID=$2
icnt=0
SDIR=$3
EXdir=$SDIR
PDIR=/ptmp/wx20yz/test

cd $PDIR;pwd

ndatex=/nwprod/util/exec/ndate
EDYMD=`$ndatex +384 $STYMD\00 | cut -c1-8 `
OUTDAY=$STYMD\00
VHOUR=00
SNAME=SCORES

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

 STYMD=`$ndatex 24 $STYMD\00 | cut -c1-8`

done

echo "ofile='SCORES$EXPID.$OUTDAY',"                    >>input
echo "/" >>input

cat input

/nfsuser/g01/wx20yz/gvrfy/grads/readin_convert <input

cat SCORES$EXPID.$OUTDAY

#cp SCORES$EXPID.$OUTDAY /nbns/global/wx20yz/vrfy_conv
cp SCORES$EXPID.$OUTDAY /nbns/global/wx20yz/vrfy_conv50
