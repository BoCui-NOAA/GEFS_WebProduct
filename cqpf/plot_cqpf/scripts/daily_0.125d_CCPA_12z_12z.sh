#set -x

############################################################
#HISTORY:
#09/01/2011: Initial script created by yan.luo
############################################################
#----------------------------------------------------------

SHOME=/u/yan.luo/save
COMIN=/lfs/h2/emc/vpppg/noscrub/yan.luo/COM_TAR/0.125d
COMOUT=/lfs/h2/emc/vpppg/noscrub/yan.luo/daily_0.125d_ccpav4
exec_dir=/lfs/h1/ops/para/packages/ccpa.v4.2.0/exec
tempdir=/lfs/h2/emc/ptmp/yan.luo/daily_ccpa_12z_ccpav4

module load prod_util/2.0.5
module load grib_util/1.2.2

CDATE=$1

if [ -s $tempdir ]; then
cd $tempdir; rm * 
else
mkdir -p $tempdir
cd $tempdir
fi

YY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`
CMM=`grep "$MM" $SHOME/bin/mon2mon | cut -c8-10`
curdate=`echo $CDATE | cut -c1-8`
datnext=`$NDATE +24 $CDATE | cut -c1-8`

cd $tempdir

cp -pr $COMIN/ccpa.$curdate/18/ccpa.t18z.06h.0p125.conus  $tempdir/rfc_06h_1.grb
cp -pr $COMIN/ccpa.$datnext/00/ccpa.t00z.06h.0p125.conus  $tempdir/rfc_06h_2.grb
cp -pr $COMIN/ccpa.$datnext/06/ccpa.t06z.06h.0p125.conus  $tempdir/rfc_06h_3.grb
cp -pr $COMIN/ccpa.$datnext/12/ccpa.t12z.06h.0p125.conus  $tempdir/rfc_06h_4.grb

$exec_dir/ccpa_accum_6h_files  $YY $MM $DD 12         

mv $tempdir/rfc_24h.grb $COMOUT/ccpa_conus_0.125d_${datnext}12
