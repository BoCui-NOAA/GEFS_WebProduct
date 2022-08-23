
if [ $# -lt 2 ]; then
   echo "Usage:$0 need input"
   echo "1). YYYYMMDDHH (initial time)"
   echo "2). FHR (forecast hours)     "
   exit 8
fi

tmpdir=/ptmp/wx20yz/SMOOTH  
mkdir $tmpdir
cd    $tmpdir

nhoursx=/nwprod/util/exec/ndate

CDATE=$1             
fhr=$2
YMD=`echo $CDATE | cut -c1-8`
CYC=`echo $CDATE | cut -c9-10`

echo " ***************************************"
echo " JOB INPUT INITIAL  TIME IS: $CDATE "
echo " JOB INPUT FORECAST TIME IS: $fhr   "
echo " ***************************************"

for FHR in $fhr 
do

 FDATE=`$nhoursx +$FHR $CDATE`
 HH=`echo $FDATE | cut -c9-10`
 MDH=`echo $FDATE | cut -c5-10`         
 MD=`echo $FDATE | cut -c5-8`         

 ens=n
 copygb -xg2 /global/shared/stat/prs/pgbf00.$FDATE fcst.dat             
 echo "&namin " >input_$ens
 echo "cfcst='fcst.dat'," >>input_$ens
 echo "cfwv1='fwv1.dat'," >>input_$ens
 echo "/" >>input_$ens

 $HOME/gvrfy/sorc/SMOOTH <input_$ens

 mv fcst.dat pgbf00_$ens\0.${FDATE}
 mv fwv1.dat pgbf00_$ens\1.${FDATE}

done

