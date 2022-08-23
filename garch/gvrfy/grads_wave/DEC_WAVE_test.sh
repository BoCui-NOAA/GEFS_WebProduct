
if [ $# -lt 2 ]; then
   echo "Usage:$0 need input"
   echo "1). YYYYMMDDHH (initial time)"
   echo "2). FHR (forecast hours)     "
   exit 8
fi

tmpdir=/ptmp/wx20yz/DEC_WAVE
mkdir $tmpdir
cd    $tmpdir

nhoursx=/nwprod/util/exec/ndate

fdir=/nbns/global/wx20yz/CDAS
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
 copygb -xg2 /global/prs/pgbf00.$FDATE fcst.dat             
 echo "&namin " >input_$ens
 echo "cfcst='fcst.dat'," >>input_$ens
 echo "cfwv1='fwv1.dat'," >>input_$ens
 echo "cfwv2='fwv2.dat'," >>input_$ens
 echo "cfwv3='fwv3.dat'," >>input_$ens
 echo "/" >>input_$ens

 $HOME/gvrfy/sorc/DEC_WAVE <input_$ens

 mv fcst.dat pgbf00_$ens\0.${FDATE}
 mv fwv1.dat pgbf00_$ens\1.${FDATE}
 mv fwv2.dat pgbf00_$ens\2.${FDATE}
 mv fwv3.dat pgbf00_$ens\3.${FDATE}


 #for ens in s u
 for ens in s 
 do

 cp /global/prs/pgbf${FHR}.$CDATE fcst.dat

 echo "&namin " >input_$ens
 echo "cfcst='fcst.dat'," >>input_$ens
 echo "cfwv1='fwv1.dat'," >>input_$ens
 echo "cfwv2='fwv2.dat'," >>input_$ens
 echo "cfwv3='fwv3.dat'," >>input_$ens
 echo "/" >>input_$ens

 $HOME/gvrfy/sorc/DEC_WAVE <input_$ens

 mv fcst.dat pgbf${FHR}_$ens\0.${CDATE}                           
 mv fwv1.dat pgbf${FHR}_$ens\1.${CDATE}                           
 mv fwv2.dat pgbf${FHR}_$ens\2.${CDATE}                           
 mv fwv3.dat pgbf${FHR}_$ens\3.${CDATE}                           

 done

done

