
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

for EXPID in sq 
do

$SHOME/$LOGNAME/gvrfy/grads/readinq_16d.sh $STYMD $EDYMD $EXPID

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $SHOME/$LOGNAME/gvrfy/grads/exp_q_16d.ctl > $GDIR/pr$EXPID.ctl    

done

EXPID1=sq
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
    $SHOME/$LOGNAME/gvrfy/grads/exp_q_16d.gs > $GDIR/map.gs        

xgrads -cbl "$PTMP/$LOGNAME/qgrads/map.gs"

#sed -e "s/_YYYYMMDD/$EDYMD/" \
#    $SHOME/$LOGNAME/gvrfy/grads/qvrfy.html >$GDIR/qvrfy.html

cd $GDIR

gxgif -r -x 900 -y 700 -i nh_850hPa.gr   -o nh_850hPa.gif
gxgif -r -x 900 -y 700 -i nh_vertical.gr -o nh_vertical.gif
gxgif -r -x 900 -y 700 -i sh_850hPa.gr   -o sh_850hPa.gif
gxgif -r -x 900 -y 700 -i sh_vertical.gr -o sh_vertical.gif
gxgif -r -x 900 -y 700 -i tr_850hPa.gr   -o tr_850hPa.gif
gxgif -r -x 900 -y 700 -i tr_vertical.gr -o tr_vertical.gif

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/qvrfy
ftpemcrzdm emcrzdm put $RZDMDIR $PTMP/$LOGNAME/qgrads nh_850hPa.gif
ftpemcrzdm emcrzdm put $RZDMDIR $PTMP/$LOGNAME/qgrads nh_vertical.gif
ftpemcrzdm emcrzdm put $RZDMDIR $PTMP/$LOGNAME/qgrads sh_850hPa.gif
ftpemcrzdm emcrzdm put $RZDMDIR $PTMP/$LOGNAME/qgrads sh_vertical.gif
ftpemcrzdm emcrzdm put $RZDMDIR $PTMP/$LOGNAME/qgrads tr_850hPa.gif
ftpemcrzdm emcrzdm put $RZDMDIR $PTMP/$LOGNAME/qgrads tr_vertical.gif

ftpemcrzdm emcrzdm put $RZDMDIR $GLOBAL/prsq example.gif
