
if [ $# -lt 2 ]; then
   echo "Usage:$0 need input"
   echo "1). YYYYMMDDHH (initial time)"
   echo "2). FHR (forecast hours)     "
   exit 8
fi

tmpdir=/ptmp/wx20yz/canomaly
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

 for ens in n1 p1 n2 p2 n3 p3 n4 p4 n5 p5
 do

 cp /com/mrf/prod/ens.$YMD/ens${ens}.t${CYC}z.pgrbf${FHR} fcst_$ens.dat
 cp $fdir/cmean_1d.1959$MD mean_$ens.dat
 cp $fdir/cstdv_1d.1959$MD stdv_$ens.dat
 ### get analysis difference between CDAS and GDAS
 #cp cbias_1d.$YMD$CYC     bias_$ens.dat

 {
 echo "&namin " >input_$ens
 echo "cfcst='fcst_$ens.dat'," >>input_$ens
 echo "cmean='mean_$ens.dat'," >>input_$ens
 echo "cstdv='stdv_$ens.dat'," >>input_$ens
 echo "cbias='bias_$ens.dat'," >>input_$ens
 echo "canom='anom_$ens.dat'," >>input_$ens
 echo "/" >>input_$ens

 $HOME/reanl/exec/climate_anomaly.exe <input_$ens >output_$ens

 mv anom_$ens.dat ens${ens}.t${CYC}z.pgrb_anf${FHR}
 } &  

 done

 wait

 rm fcst_*.dat mean_*.dat stdv_*.dat

 cat output_$ens

 ls -l ens*.t${CYC}z.pgrb_anf${FHR}

done

