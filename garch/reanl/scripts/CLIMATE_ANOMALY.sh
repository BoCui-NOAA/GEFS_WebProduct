
tmpdir=/ptmp/wx20yz/canomaly
mkdir $tmpdir
cd    $tmpdir

nhoursx=/nwprod/util/exec/ndate

CDATE=2005110800
CDATE=2005112400
CDATE=2005120300
YMD=`echo $CDATE | cut -c1-8`
CYC=`echo $CDATE | cut -c9-10`

#for FHR in 24 48 72 96 120 
for FHR in 24 
do

 >pgrbmean
 >pgrbstdv

 FDATE=`$nhoursx +$FHR $CDATE`
 HH=`echo $FDATE | cut -c9-10`
 MDH=`echo $FDATE | cut -c5-10`         
 MDHm6=`$nhoursx -06 $FDATE | cut -c5-10`

 for FLD in 1000HGT 700HGT 500HGT 250HGT 850TMP 500TMP 250TMP \
            850UGRD 850VGRD 500UGRD 500VGRD 250UGRD 250VGRD \
            PRMSL 2MTMP TMAX TMIN 10MUGRD 10MVGRD
 do
  file1=/ptmp/wx20yz/CDAS/${FLD}_t${HH}z.mean
  file2=/ptmp/wx20yz/CDAS/${FLD}_t${HH}z.stdv
  if [ "$FLD" = "2MTMP" -o "$FLD" = "TMAX" -o "$FLD" = "TMIN" -o "$FLD" = "10MUGRD" -o "$FLD" = "10MVGRD" ]; then
   wgrib $file1 | grep $MDHm6 | wgrib -i $file1 -grib -append -o pgrbmean
   wgrib $file2 | grep $MDHm6 | wgrib -i $file2 -grib -append -o pgrbstdv
  else
   wgrib $file1 | grep $MDH | wgrib -i $file1 -grib -append -o pgrbmean
   wgrib $file2 | grep $MDH | wgrib -i $file2 -grib -append -o pgrbstdv
  fi
 done

 time copygb -g3 -x pgrbmean pgrbmean1d
 time copygb -g3 -x pgrbstdv pgrbstdv1d

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
 echo "&namin " >input
 echo "cfcst='fcst_$ens.dat'," >>input
 echo "cmean='mean_$ens.dat'," >>input
 echo "cstdv='stdv_$ens.dat'," >>input
 echo "cbias='bias_$ens.dat'," >>input
 echo "canom='anom_$ens.dat'," >>input
 echo "/" >>input

 $HOME/reanl/exec/climate_anomaly.exe <input

 mv anom_$ens.dat ens${ens}.t${CYC}z.pgrb_anf${FHR}
 } &  

 done

 wait

 #rm fcst_*.dat mean_*.dat stdv_*.dat

done

