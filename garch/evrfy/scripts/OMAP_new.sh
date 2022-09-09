#set -x
if [ $# -lt 1 ]; then
  echo "Usage:$0 need [YYYYMMDD] input"
  exit 8
fi

ptmp=/lfs/h2/emc/ptmp
home=/lfs/h2/emc/vpppg/save/$LOGNAME
NGLOBAL=/lfs/h2/emc/vpppg/noscrub

mkdir $ptmp/$LOGNAME/omap
cd $ptmp/$LOGNAME/omap

ndatex=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
CDATE=$1\00

cp $NGLOBAL/$LOGNAME/evfscores/OUTLIEs.$CDATE .
cp $home/grads/rgbset.gs .
cp $home/grads/cbar.gs .

grib2ctl.sh OUTLIEs.$CDATE >outlier.ctl

gribmap -i outlier.ctl

IYMDHM8=`$ndatex -168 $CDATE`
IYMDH=`$ndatex +24   $CDATE`
VYMDH1=`$ndatex +48  $CDATE`
VYMDH2=`$ndatex +72  $CDATE`
VYMDH3=`$ndatex +96  $CDATE`
VYMDH4=`$ndatex +120 $CDATE`
VYMDH5=`$ndatex +144 $CDATE`
VYMDH6=`$ndatex +168 $CDATE`
VYMDH7=`$ndatex +192 $CDATE`
VYMDH8=`$ndatex +216 $CDATE`

sed -e "s/IYMDH/$IYMDH/" \
    -e "s/VYMDH1/$VYMDH1/" \
    -e "s/VYMDH2/$VYMDH2/" \
    -e "s/VYMDH3/$VYMDH3/" \
    -e "s/VYMDH4/$VYMDH4/" \
    -e "s/VYMDH5/$VYMDH5/" \
    -e "s/VYMDH6/$VYMDH6/" \
    -e "s/VYMDH7/$VYMDH7/" \
    -e "s/VYMDH8/$VYMDH8/" \
    $home/evrfy/grads/outlier_new.gs >outlier.gs

pwd

grads -cbl "outlier.gs"

RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/omap  

ftpemcrzdmmkdir emcrzdm  $RZDMDIR $IYMDH

for fhr in 24 48 72 96 120 144 168 192
do
 export CDATE=$IYMDH
 #gxgif -r -x 1000 -y 773 -i omap_${CDATE}_$fhr.gr -o omap_${CDATE}_$fhr.gif
 ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$ptmp/$LOGNAME/omap omap_${CDATE}_$fhr.png
done

sed -e "s/IYMDH/$IYMDH/" \
    -e "s/VYMDH1/$VYMDH1/" \
    -e "s/VYMDH2/$VYMDH2/" \
    -e "s/VYMDH3/$VYMDH3/" \
    -e "s/VYMDH4/$VYMDH4/" \
    -e "s/VYMDH5/$VYMDH5/" \
    -e "s/VYMDH6/$VYMDH6/" \
    -e "s/VYMDH7/$VYMDH7/" \
    -e "s/VYMDH8/$VYMDH8/" \
    $home/evrfy/grads/outlier_4p_new.gs >outlier.gs

pwd

grads -cbl "outlier.gs"

export CDATE=$IYMDH
#gxgif -r -x 1100 -y 850 -i omap_${CDATE}_map1.gr -o omap_${CDATE}_map1.gif
ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$ptmp/$LOGNAME/omap omap_${CDATE}_map1.png
export CDATE=$IYMDH
#gxgif -r -x 1100 -y 850 -i omap_${CDATE}_map2.gr -o omap_${CDATE}_map2.gif
ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$ptmp/$LOGNAME/omap omap_${CDATE}_map2.png


### create html scripts and ftp to sgi100

$home/evrfy/scripts/moderr_html.sh $IYMDHM8

sed -e "s/ens\/moderr\/figs/gmb\/yluo\/omap/" \
       moderr.html >moderr.rzdm_html
mv moderr.rzdm_html moderr.html
change_url.sh moderr.html
RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/html/opr
ftpemcrzdm emcrzdm put $RZDMDIR /$ptmp/$LOGNAME/omap moderr.html

