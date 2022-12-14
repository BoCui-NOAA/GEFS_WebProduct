#set -x

SHOME=/lfs/h2/emc/vpppg/save/$LOGNAME/cqpf
COMIN=/lfs/h1/ops/prod/com/ccpa/v4.2
export tmpdir=/lfs/h2/emc/ptmp/$LOGNAME/cqpf_tmp

export nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate

if [ -s $tmpdir ]; then
  rm $tmpdir/*
  rm -rf  $tmpdir/opr 
  rm -rf  $tmpdir/cal
  rm -rf  $tmpdir/dsc
  rm -rf  $tmpdir/obs
  cd $tmpdir
else
  mkdir -p $tmpdir
cd $tmpdir 
fi

mkdir -p $tmpdir/opr    
mkdir -p $tmpdir/cal 
mkdir -p $tmpdir/dsc
mkdir -p $tmpdir/obs            
cp $SHOME/grads/rgbset.gs .
cp $SHOME/grads/cbar.gs   .
cp $SHOME/grads/cbarn.gs   .

#CDATE=2011092900    
CDATE=$1
#export CDATE=$CDATE
#CDATE=`$nhours -192 $CDATE `

#scripts=/u/$LOGNAME/save/plot_cqpf/grads
scripts=$SHOME/plot_cqpf/grads


YY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`
CMM=`grep "$MM" $SHOME/bin/mon2mon | cut -c8-10`

for RUNID in gfs ctl;do

$scripts/get_cqpf_0.5d_gb2.sh $CDATE $RUNID

done

for RUNID in ctl;do

$scripts/get_qpf_ndgd_gb2.sh $CDATE $RUNID

done

for RUNID in gfs ctl;do

hourlist="    06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
              102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192\
              198 204 210 216 222 228 234 240"

cd  $tmpdir/obs
for nfhrs in $hourlist; do 
   fymdh=`$nhours +$nfhrs $CDATE`
   fymd=`echo $fymdh | cut -c1-8`
   fcyc=`echo $fymdh | cut -c9-10`
 if [ $nfhrs -eq 00 -o $nfhrs -eq 06 -o $nfhrs -eq 12 ]; then
  case $nfhrs in
  00) grptime=00_00;nshrs=00;;
  06) grptime=00_06;nshrs=00;;
  12) grptime=06_12;nshrs=06;; 
  esac
  else
    nshrs=`expr $nfhrs - 6`
    grptime=$nshrs"_"$nfhrs
  fi
    symdh=`$nhours +$nshrs $CDATE`
    file=ccpa.t${fcyc}z.06h.0p5.conus
    infile=$COMIN/ccpa.$fymd/${fcyc}/$file
    outfile=$tmpdir/obs/obs_${CDATE}_${grptime}
    cp $infile $outfile
    $SHOME/xbin/grib2ctl -verf obs_${CDATE}_${grptime}   > obs_$nfhrs.ctl
    $SHOME/xbin/gribmap -i  obs_$nfhrs.ctl
done


cd  $tmpdir

for nfhrs in $hourlist; do

   fymdh=`$nhours +$nfhrs $CDATE`
   fymd=`echo $fymdh | cut -c1-8`
   fcyc=`echo $fymdh | cut -c9-10`
 if [ $nfhrs -eq 00 -o $nfhrs -eq 06 -o $nfhrs -eq 12 ]; then
  case $nfhrs in
  00) grptime=00_00;nshrs=00;;
  06) grptime=00_06;nshrs=00;;
  12) grptime=06_12;nshrs=06;;
  esac
  else
    nshrs=`expr $nfhrs - 6`
    grptime=$nshrs"_"$nfhrs
  fi
    symdh=`$nhours +$nshrs $CDATE`

sed -e "s/IDATE/$CDATE/"  \
    -e "s/TIME1/$nshrs/" \
    -e "s/TIME2/$nfhrs/" \
    -e "s/VDATE1/$symdh/" \
    -e "s/VDATE2/$fymdh/" \
    $scripts/qpf_${RUNID}_gb2.GS  >pgrads_qpf.gs

#grads -d Cairo -h GD -cbl "run pgrads_qpf.gs"
grads -cbl "run pgrads_qpf.gs"

done
done

for amap in gfs ctl
do
cp  ${amap}_${CDATE}_F00-06.png ${amap}_${CDATE}_F0-6.png
cp  ${amap}_${CDATE}_F06-12.png ${amap}_${CDATE}_F6-12.png
done

export RZDMDIR=/home/people/emc/www/htdocs/gmb/wx20cb/cpqpf_6h
$SHOME/xbin/ftpemcrzdmmkdir emcrzdm $RZDMDIR $YY$MM$DD

scp *.png   bocui@emcrzdm:$RZDMDIR/$YY$MM$DD

