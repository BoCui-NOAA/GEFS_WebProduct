
if [ $# -lt 2 ]; then
 echo "Usage: $0 need YYYYMMDDHH FHR"
 exit 8
else
 ISYR=2004
 ISMTH=09
 ISDAY=11
 ISHR=12
 FHR=00
fi

#!/bin/ksh
#set -xeua
set -x

mkdir $PTMP/$LOGNAME/tprh2q_prk
cd    $PTMP/$LOGNAME/tprh2q_prk

YMDH=$1
FHR=$2
ISYR=`echo $YMDH | cut -c1-4`
ISMTH=`echo $YMDH | cut -c5-6`
ISDAY=`echo $YMDH | cut -c7-8`
ISHR=`echo $YMDH | cut -c9-10`

ISTYMDH=$ISYR$ISMTH$ISDAY$ISHR

#ifile=/global/prk/ukmet.$ISTYMDH 
#ofile=pgbf$FHR.$ISTYMDH            
#wgrib $ifile | grep RH | grep "$FHR hr" | wgrib -i $ifile -grib -o $ofile

cp $GLOBAL/prk/ukmet.$ISTYMDH pgbf$FHR.$ISTYMDH

cat <<paramEOF >input
&namin
 ishr=$ISHR,isday=$ISDAY,ismth=$ISMTH,isyr=$ISYR,iehr=$ISHR,ieday=$ISDAY,iemth=$ISMTH,ieyr=$ISYR,ifhr=$FHR
/
paramEOF

export qfile=qhf$FHR.$ISTYMDH
$SHOME/$LOGNAME/gvrfy/sorc/tprh2q_prk.x <input
if [ $FHR -eq 00 ]; then
cp $qfile $GLOBAL/prkq/pgbanl.$ISTYMDH
else
cp $qfile $GLOBAL/prkq/pgbf$FHR.$ISTYMDH
fi
