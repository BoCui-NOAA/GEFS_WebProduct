
set -x

############################################################
#HISTORY:
#03/28/2011: Initial script created by Yan Luo
############################################################
#----------------------------------------------------------

SHOME=/lfs/h2/emc/vpppg/save
COMIN=/lfs/h1/ops/prod/com/ccpa/v4.2
tempdir=/$ptmp/$LOGNAME/plot_ccpa
export nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
#CDATE=2021082400
CDATE=`$nhours -216 $CDATE`
#CDATE=`$nhours -24 $CDATE`

grib2ctl=$SHOME/$LOGNAME/ccpa/xbin/grib2ctl

ndays=8

iday=1

while [ $iday -le $ndays ]; do

mkdir -p $tempdir
cd $tempdir; rm * 

cp $SHOME/$LOGNAME/ccpa/grads/rgbset.gs .
cp $SHOME/$LOGNAME/ccpa/grads/cbar.gs   .
cp $SHOME/$LOGNAME/ccpa/grads/cbarn.gs   .


scripts=$SHOME/$LOGNAME/ccpa/plot_ccpa/grads


YY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`
CMM=`grep "$MM" $SHOME/$LOGNAME/bin/mon2mon | cut -c8-10`
curdate=`echo $CDATE | cut -c1-8`
datnext=`$nhours +24 $CDATE | cut -c1-8`
PDY=`$nhours +24 $CDATE | cut -c1-8`
PDYp1=`$nhours +48 $CDATE | cut -c1-8`
#    $scripts/REALTIME_copyST4.sh $YY $MM $DD

cd $tempdir

#cp -p $COMIN/ccpa.$curdate/18/ccpa_conus_hrap_t18z_06h $tempdir/ccpa_$curdate\18_06h
#cp -p $COMIN/ccpa.$datnext/00/ccpa_conus_hrap_t00z_06h $tempdir/ccpa_$datnext\00_06h
#cp -p $COMIN/ccpa.$datnext/06/ccpa_conus_hrap_t06z_06h $tempdir/ccpa_$datnext\06_06h
#cp -p $COMIN/ccpa.$datnext/12/ccpa_conus_hrap_t12z_06h $tempdir/ccpa_$datnext\12_06h

cp -p $COMIN/ccpa.$curdate/18/ccpa.t18z.06h.hrap.conus $tempdir/ccpa_$curdate\18_06h
cp -p $COMIN/ccpa.$datnext/00/ccpa.t00z.06h.hrap.conus $tempdir/ccpa_$datnext\00_06h
cp -p $COMIN/ccpa.$datnext/06/ccpa.t06z.06h.hrap.conus $tempdir/ccpa_$datnext\06_06h
cp -p $COMIN/ccpa.$datnext/12/ccpa.t12z.06h.hrap.conus $tempdir/ccpa_$datnext\12_06h

for hh in  06 12 18 24
do
  case $hh in 
   06) tt=18;ymd=$curdate;; 
   12) tt=00;ymd=$datnext;;
   18) tt=06;ymd=$datnext;;
   24) tt=12;ymd=$datnext
  esac
    $grib2ctl -verf ccpa_${ymd}${tt}_06h   > ccpa_${ymd}${tt}_06h.ctl
    gribmap -i ccpa_${ymd}${tt}_06h.ctl 

sed -e "s/YYMMDD/$ymd/"  \
    -e "s/HH/$tt/"       \
    $scripts/ccpa_6hr.GS  >ccpa_6hr.gs
grads -cbl "run ccpa_6hr.gs"

export RZDMDIR=/home/people/emc/www/htdocs/gmb/wx20cb/ccpa
ssh -l bocui emcrzdm "mkdir -p $RZDMDIR/$datnext"

done

sed -e "s/HHZDDCMMYY/18Z$DD$CMM$YY/"  \
    $scripts/CCPA.CTL  >ccpa.ctl
sed -e "s/YYMMDD/$datnext/"  \
    -e "s/HH/12/"       \
    $scripts/ccpa_24hr.GS  >ccpa_24hr.gs

    gribmap -i ccpa.ctl

grads -cbl "run ccpa_24hr.gs"

  iday=`expr $iday + 1`
  CDATE=`$nhours +24 $CDATE`

scp *.png bocui@emcrzdm:$RZDMDIR/$datnext

done

cd $tempdir

  CDATE=`$nhours -24 $CDATE`
sed -e "s/YYYYMMD2/$SYMD2/"    \
    $scripts/CCPA_H.HTML   >CCPA.html

for hhour in 00 24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 \
             384 408 432
do
 
 curdate=`$nhours -$hhour $CDATE `
 SYMD1=`$nhours -$hhour $CDATE | cut -c1-8`
 nextdate=`$nhours +24 $curdate `
 SYMD2=`$nhours +24 $curdate | cut -c1-8`

 sed -e "s/YYYYMMD1/$SYMD1/"  \
     -e "s/YYYYMMD2/$SYMD2/"     \
     -e "s/_YYYYMMD2/_${SYMD2}/"     \
     $scripts/CCPA_M.HTML   >>CCPA.html
done

cat $scripts/CCPA_E.HTML   >>CCPA.html

cp -p CCPA.html CCPA_prod.html
export RZDMDIR=/home/people/emc/www/htdocs/gmb/wx20cb
scp CCPA.html bocui@emcrzdm:$RZDMDIR
scp CCPA_prod.html bocui@emcrzdm:$RZDMDIR
ssh -l bocui emcrzdm "export date=$PDYp1;$RZDMDIR/ccpa/make_link_24h.sh"
ssh -l bocui emcrzdm "export date=$PDY;$RZDMDIR/ccpa/make_link_06h.sh"

exit
