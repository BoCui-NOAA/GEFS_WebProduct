
## This scripts will run xgrads from

GDIR=$PTMP/$LOGNAME/qgrads

#STYMD=20041215
#EDYMD=20050115
STYMD=$STYMD   
EDYMD=$EDYMD

YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM $SHOME/$LOGNAME/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

for EXPID in kq 
do

$SHOME/$LOGNAME/gvrfy/grads/readinq_16d.sh $STYMD $EDYMD $EXPID

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $SHOME/$LOGNAME/gvrfy/grads/exp_q_16d.ctl > $GDIR/pr$EXPID.ctl    

done

EXPID1=kq
EXPID2=x
CSTYMD=$CYMDH

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM $SHOME/$LOGNAME/bin/mon2mon | cut -c8-10`
CEDYMD=00Z$DD$CMM$YY

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $SHOME/$LOGNAME/gvrfy/grads/exp_q_3d.gs > $GDIR/map.gs        

xgrads -cbl "$GDIR/map.gs"

#sed -e "s/_YYYYMMDD/$EDYMD/" \
#    $SHOME/$LOGNAME/gvrfy/grads/qvrfy.html >$GDIR/qvrfy.html

cd $GDIR

gxgif -r -x 900 -y 700 -i nh_850hPa.gr   -o ukm_nh_850hPa.gif
gxgif -r -x 900 -y 700 -i nh_vertical.gr -o ukm_nh_vertical.gif
gxgif -r -x 900 -y 700 -i sh_850hPa.gr   -o ukm_sh_850hPa.gif
gxgif -r -x 900 -y 700 -i sh_vertical.gr -o ukm_sh_vertical.gif
gxgif -r -x 900 -y 700 -i tr_850hPa.gr   -o ukm_tr_850hPa.gif
gxgif -r -x 900 -y 700 -i tr_vertical.gr -o ukm_tr_vertical.gif

RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/qvrfy
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR ukm_nh_850hPa.gif
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR ukm_nh_vertical.gif
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR ukm_sh_850hPa.gif
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR ukm_sh_vertical.gif
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR ukm_tr_850hPa.gif
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR ukm_tr_vertical.gif

#ftprzdm rzdm put $RZDMDIR $GLOBAL/prsq example.gif
