set -x 
if [ $# -lt 1 ]; then
   echo "Usage:$0 need input"
   echo "1). YYYYMMDDHH (initial time)"
#  echo "2). FHR (forecast hours)     "
   exit 8
fi

PTMP=/lfs/h2/emc/ptmp
SHOME=/lfs/h2/emc/vpppg/save
NGLOBAL=/lfs/h2/emc/vpppg/noscrub
tmpdir=$PTMP/$LOGNAME/canomaly
mkdir $tmpdir
cd    $tmpdir

cp $SHOME/$LOGNAME/grads/rgbset.gs .

nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
CNVGRIB=/apps/ops/prod/libs/intel/19.1.3.304/grib_util/1.2.2/bin/cnvgrib
COPYGB=/apps/ops/prod/libs/intel/19.1.3.304/grib_util/1.2.2/bin/copygb
fdir=$NGLOBAL/$LOGNAME/CDAS
CDATE=$1             
fhr=$2
YMD=`echo $CDATE | cut -c1-8`
CYC=`echo $CDATE | cut -c9-10`
CYCM6=`$nhours -6 $CDATE | cut -c9-10`
YY=`echo $CDATE | cut -c3-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
CMM=`grep $MM $SHOME/$LOGNAME/bin/mon2mon | cut -c4-6`
CYMDH=${CYC}z$DD$CMM$YY

YMDM2=`$nhours -48 $CDATE | cut -c1-8`
YMDM3=`$nhours -72 $CDATE | cut -c1-8`

echo " ***************************************"
echo " JOB INPUT INITIAL  TIME IS: $CDATE "
echo " JOB INPUT FORECAST TIME IS: $fhr   "
echo " ***************************************"

#for FHR in $fhr 
for FHR in 024 048 072 096 120 144 168 192 216 240 264 288 312 336 360
do

 FDATE=`$nhours +$FHR $CDATE`
 HH=`echo $FDATE | cut -c9-10`
 MDH=`echo $FDATE | cut -c5-10`         
 MD=`echo $FDATE | cut -c5-8`         
 STEP=`expr $FHR / 24 + 1`

 cp /lfs/h1/ops/prod/com/naefs/v6.1/gefs.$YMD/${CYC}/pgrb2a_bc/geavg.t${CYC}z.pgrb2a_bcf${FHR} .
 $CNVGRIB -g21  geavg.t${CYC}z.pgrb2a_bcf${FHR}  favg.dat
 cp /lfs/h1/ops/prod/com/naefs/v6.1/gefs.$YMD/${CYC}/pgrb2a_bc/gespr.t${CYC}z.pgrb2a_bcf${FHR} .
 $CNVGRIB -g21  gespr.t${CYC}z.pgrb2a_bcf${FHR}  fspr.dat
 cp $fdir/cmean_1d.1959$MD cavg.dat
 cp $fdir/cstdv_1d.1959$MD cstd.dat
 ### get analysis difference between CDAS and GDAS
 ### this file is on white only
 afile=/lfs/h1/ops/prod/com/naefs/v6.1/gefs.$YMDM2/${CYC}/pgrb2ap5/glbanl.t${CYC}z.pgrb2a.0p50_mdf000
 #afile=/com/gens/prod/gefs.$YMDM3/${CYCM6}/pgrba/glbanl.t${CYCM6}z.pgrba_mdf00
 #afile=/nbns/global/wx20cb/cdas_ncep/gefs.$YMDM3/${CYC}/pgrba/glbanl.t${CYC}z.pgrba_mdf00
# scp mist:$afile   bias.dat
 $CNVGRIB -g21 $afile glbanl.t${CYC}z.pgrbap5_mdf00
 $COPYGB -xg3 glbanl.t${CYC}z.pgrbap5_mdf00   bias.dat

 ls -l *.dat

 echo "&namin " >input
 echo "cfavg='favg.dat'," >>input
 echo "cfspr='fspr.dat'," >>input
 echo "ccavg='cavg.dat'," >>input
 echo "ccstd='cstd.dat'," >>input
 echo "cbias='bias.dat'," >>input
 echo "caavg='aavg.dat'," >>input
 echo "cap10='ap10.dat'," >>input
 echo "cap90='ap90.dat'," >>input
 echo "cfp10='fp10.dat'," >>input
 echo "cfp90='fp90.dat'," >>input
 echo "ibias=0," >>input
 echo "nmemb=14," >>input
 echo "/" >>input

 $SHOME/$LOGNAME/reanl/sorc_webmap/climate_anomaly_map.exe <input 

sed -e "s/_DATANAME/favg.dat/"  \
    -e "s/_CYMDH/$CYMDH/"       \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >favg.ctl

sed -e "s/_DATANAME/fp10.dat/"  \
    -e "s/_CYMDH/$CYMDH/"       \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >fp10.ctl

sed -e "s/_DATANAME/fp90.dat/"  \
    -e "s/_CYMDH/$CYMDH/"       \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >fp90.ctl

sed -e "s/_DATANAME/aavg.dat/"  \
    -e "s/_CYMDH/$CYMDH/"       \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >aavg.ctl

sed -e "s/_DATANAME/ap10.dat/"  \
    -e "s/_CYMDH/$CYMDH/"       \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >ap10.ctl

sed -e "s/_DATANAME/ap90.dat/"  \
    -e "s/_CYMDH/$CYMDH/"       \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >ap90.ctl

$SHOME/$LOGNAME/xbin/gribmap -i favg.ctl
$SHOME/$LOGNAME/xbin/gribmap -i fp10.ctl
$SHOME/$LOGNAME/xbin/gribmap -i fp90.ctl
$SHOME/$LOGNAME/xbin/gribmap -i aavg.ctl
$SHOME/$LOGNAME/xbin/gribmap -i ap10.ctl
$SHOME/$LOGNAME/xbin/gribmap -i ap90.ctl

sed -e "s/STEP/$STEP/"  \
    -e "s/HOUR/$FHR/"       \
    -e "s/YMDH/$CDATE/"      \
    -e "s/FDATE/$FDATE/"      \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_NA.GS >amap_na.gs 

grads -cbl "amap_na.gs"

sed -e "s/STEP/$STEP/"  \
    -e "s/HOUR/$FHR/"       \
    -e "s/YMDH/$CDATE/"      \
    -e "s/FDATE/$FDATE/"      \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_GB.GS >amap_gb.gs 

grads -cbpl "amap_gb.gs"

rm *.dat

RZDMDIR=/home/people/emc/www/htdocs/gmb/wx20cb/amap
$SHOME/$LOGNAME/xbin/ftpemcrzdmmkdir emcrzdm $RZDMDIR $CDATE
$SHOME/$LOGNAME/xbin/ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$PTMP/$LOGNAME/canomaly amap_na${CDATE}_$FHR.png
$SHOME/$LOGNAME/xbin/ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$PTMP/$LOGNAME/canomaly amap_gb${CDATE}_$FHR.png

done

KYMD01=`$nhours -00  $CDATE`
KYMD02=`$nhours -24  $CDATE`
KYMD03=`$nhours -48  $CDATE`
KYMD04=`$nhours -72  $CDATE`
KYMD05=`$nhours -96  $CDATE`
KYMD06=`$nhours -120 $CDATE`
KYMD07=`$nhours -144 $CDATE`
KYMD08=`$nhours -168 $CDATE`
KYMD09=`$nhours -192 $CDATE`
KYMD10=`$nhours -216 $CDATE`
KYMD11=`$nhours -240 $CDATE`
KYMD12=`$nhours -264 $CDATE`
KYMD13=`$nhours -288 $CDATE`
KYMD14=`$nhours -312 $CDATE`
KYMD15=`$nhours -336 $CDATE`
KYMD16=`$nhours -360 $CDATE`
KYMD31=`$nhours -720 $CDATE`

sed -e "s/YYYYMMDD01/$KYMD01/g" \
    -e "s/YYYYMMDD02/$KYMD02/g" \
    -e "s/YYYYMMDD03/$KYMD03/g" \
    -e "s/YYYYMMDD04/$KYMD04/g" \
    -e "s/YYYYMMDD05/$KYMD05/g" \
    -e "s/YYYYMMDD06/$KYMD06/g" \
    -e "s/YYYYMMDD07/$KYMD07/g" \
    -e "s/YYYYMMDD08/$KYMD08/g" \
    -e "s/YYYYMMDD09/$KYMD09/g" \
    -e "s/YYYYMMDD10/$KYMD10/g" \
    -e "s/YYYYMMDD11/$KYMD11/g" \
    -e "s/YYYYMMDD12/$KYMD12/g" \
    -e "s/YYYYMMDD13/$KYMD13/g" \
    -e "s/YYYYMMDD14/$KYMD14/g" \
    -e "s/YYYYMMDD15/$KYMD15/g" \
    -e "s/YYYYMMDD16/$KYMD16/g" \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_NA.HTML >amap_na.html

sed -e "s/YYYYMMDD01/$KYMD01/g" \
    -e "s/YYYYMMDD02/$KYMD02/g" \
    -e "s/YYYYMMDD03/$KYMD03/g" \
    -e "s/YYYYMMDD04/$KYMD04/g" \
    -e "s/YYYYMMDD05/$KYMD05/g" \
    -e "s/YYYYMMDD06/$KYMD06/g" \
    -e "s/YYYYMMDD07/$KYMD07/g" \
    -e "s/YYYYMMDD08/$KYMD08/g" \
    -e "s/YYYYMMDD09/$KYMD09/g" \
    -e "s/YYYYMMDD10/$KYMD10/g" \
    -e "s/YYYYMMDD11/$KYMD11/g" \
    -e "s/YYYYMMDD12/$KYMD12/g" \
    -e "s/YYYYMMDD13/$KYMD13/g" \
    -e "s/YYYYMMDD14/$KYMD14/g" \
    -e "s/YYYYMMDD15/$KYMD15/g" \
    -e "s/YYYYMMDD16/$KYMD16/g" \
    $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_GB.HTML >amap_gb.html

$SHOME/$LOGNAME/xbin/ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/$LOGNAME/canomaly amap_na.html
$SHOME/$LOGNAME/xbin/ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/$LOGNAME/canomaly amap_gb.html
$SHOME/$LOGNAME/xbin/ftpemcrzdmrmdir emcrzdm $RZDMDIR $KYMD31
