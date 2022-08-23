
if [ $# -le 0 ]; then
   echo "Usage;$0 need file name"
   exit 8
fi

FNAME=$1

TLINE=`cat $FNAME | sed -n "3,19 p" | grep ".hrs" | wc -l`

LCNT=16
if [ $TLINE -eq 17 ]; then
  echo $LCNT
else
  for FHOUR in 360 336 312 288 264 240 216 192 168 144 120 96 72 48 24
  do
    LYES=`cat $FNAME | sed -n "3,19 p" | grep "$FHOUR.hrs" | wc -l`
    LCNT=`expr $LCNT - 1`
    if [ $LYES -ge 1 ]; then
     echo $LCNT
     exit 0
    fi
  done
fi


