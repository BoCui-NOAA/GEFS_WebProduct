
## This scripts will run xgrads from

GDIR=/ptmp/wx20yz/qgrads

STYMD=20051106
EDYMD=20051125
STYMD=20050701
EDYMD=20060115
#STYMD=$STYMD   
#EDYMD=$EDYMD

EXDIR=/nbns/global/wx20yz/vrfy_convq

YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

for EXPID in sq hq 
do

$HOME/gvrfy/grads/readinq_16d.sh $STYMD $EDYMD $EXPID $EXDIR

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    /nfsuser/g01/wx20yz/gvrfy/grads/exp_q_16d.ctl > $GDIR/pr$EXPID.ctl    

done

EXPID1=sq
EXPID2=hq
CSTYMD=$CYMDH

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CEDYMD=00Z$DD$CMM$YY

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    /nfsuser/g01/wx20yz/gvrfy/grads/exp_qpara_16d.gs > $GDIR/map.gs        

xgrads -cl "/ptmp/wx20yz/qgrads/map.gs"

#sed -e "s/_YYYYMMDD/$EDYMD/" \
#    /nfsuser/g01/wx20yz/gvrfy/grads/qvrfy.html >$GDIR/qvrfy.html

cd /ptmp/wx20yz/qgrads

gxgif -r -x 900 -y 700 -i nh_850hPa.gr   -o nh_850hPa.gif
gxgif -r -x 900 -y 700 -i nh_vertical.gr -o nh_vertical.gif
gxgif -r -x 900 -y 700 -i sh_850hPa.gr   -o sh_850hPa.gif
gxgif -r -x 900 -y 700 -i sh_vertical.gr -o sh_vertical.gif
gxgif -r -x 900 -y 700 -i tr_850hPa.gr   -o tr_850hPa.gif
gxgif -r -x 900 -y 700 -i tr_vertical.gr -o tr_vertical.gif

#RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/exp/PRV_200511
RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/exp/PRH_GFS
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/qgrads nh_850hPa.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/qgrads nh_vertical.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/qgrads sh_850hPa.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/qgrads sh_vertical.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/qgrads tr_850hPa.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/qgrads tr_vertical.gif

#ftprzdm rzdm put $RZDMDIR /global/prsq example.gif
