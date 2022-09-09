
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

CDATE=$1             
YMD=`echo $CDATE | cut -c1-8`
CYC=`echo $CDATE | cut -c9-10`

fhr=$2

echo " ***************************************"
echo " JOB INPUT INITIAL  TIME IS: $CDATE "
echo " JOB INPUT FORECAST TIME IS: $fhr   "
echo " ***************************************"

for FHR in $fhr 
do

 >pgrbmean1d
 >pgrbstdv1d

 FDATE=`$nhoursx +$FHR $CDATE`
 HH=`echo $FDATE | cut -c9-10`
 MDH=`echo $FDATE | cut -c5-10`         
 MDHm6=`$nhoursx -06 $FDATE | cut -c5-10`

 for FLD in 1000HGT 700HGT 500HGT 250HGT 850TMP 500TMP 250TMP \
            850UGRD 850VGRD 500UGRD 500VGRD 250UGRD 250VGRD \
            PRMSL 2MTMP TMAX TMIN 10MUGRD 10MVGRD
 do
  file1=/nbns/global/wx20yz/CDAS/${FLD}_t${HH}z.mean_1d
  file2=/nbns/global/wx20yz/CDAS/${FLD}_t${HH}z.stdv_1d
  if [ "$FLD" = "2MTMP" -o "$FLD" = "TMAX" -o "$FLD" = "TMIN" -o "$FLD" = "10MUGRD" -o "$FLD" = "10MVGRD" ]; then
   wgrib $file1 | grep $MDHm6 | wgrib -i $file1 -grib -append -o pgrbmean1d
   wgrib $file2 | grep $MDHm6 | wgrib -i $file2 -grib -append -o pgrbstdv1d
  else
   wgrib $file1 | grep $MDH | wgrib -i $file1 -grib -append -o pgrbmean1d
   wgrib $file2 | grep $MDH | wgrib -i $file2 -grib -append -o pgrbstdv1d
  fi
 done

 for ens in n1 p1 n2 p2 n3 p3 n4 p4 n5 p5
 do

 #ln -s /com/mrf/prod/ens.$YMD/ens${ens}.t${CYC}z.pgrbf${FHR} fcst_$ens.dat
 #ln -s pgrbmean1d mean_$ens.dat
 #ln -s pgrbstdv1d stdv_$ens.dat
# rcp wx20yz@blue:/com/mrf/prod/ens.$YMD/ens${ens}.t${CYC}z.pgrbf${FHR} fcst_$ens.dat
 cp /com/mrf/prod/ens.$YMD/ens${ens}.t${CYC}z.pgrbf${FHR} fcst_$ens.dat
 cp pgrbmean1d mean_$ens.dat
 cp pgrbstdv1d stdv_$ens.dat

 {
 echo "&namin " >input_$ens
 echo "cfcst='fcst_$ens.dat'," >>input_$ens
 echo "cmean='mean_$ens.dat'," >>input_$ens
 echo "cstdv='stdv_$ens.dat'," >>input_$ens
 echo "cbias='bias_$ens.dat'," >>input_$ens
 echo "canom='anom_$ens.dat'," >>input_$ens
 echo "/" >>input_$ens

 $HOME/reanl/exec/climate_anomaly.exe <input_$ens

 mv anom_$ens.dat ens${ens}.t${CYC}z.pgrb_anf${FHR}
 } &  

 done

 wait

 rm fcst_*.dat mean_*.dat stdv_*.dat

 ls -l ens*.t${CYC}z.pgrb_anf${FHR}

done

