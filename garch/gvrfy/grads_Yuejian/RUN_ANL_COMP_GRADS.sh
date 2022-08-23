
## This scripts will run xgrads from

GDIR=/ptmp/wx20yz/cgrads
SDIR=/global/vrfy_cons
FDAYS=16

mkdir $GDIR;cd $GDIR
STYMD=20050201
EDYMD=20050330
export STYMD=$STYMD   
export EDYMD=$EDYMD
export SNAME=SCORES

YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

for EXPID in s24 e24 m24 n24
do
 
case $EXPID in
 s24) VHOUR=00;;
 e24) VHOUR=12;;
 m24) VHOUR=00;;
 n24) VHOUR=00;;
esac

export VHOUR=$VHOUR

$HOME/gvrfy/grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/gvrfy/grads/run_4_grads.ctl > $GDIR/pr$EXPID.ctl

done

EXPID1=s24
EXPID2=e24
EXPID3=m24
EXPID4=n24
GEXPID1=NCEP
GEXPID2=ECM
GEXPID3=CMC
GEXPID4=NOGAP
ICNT=4
PFDAYS=8
echo $EXPID1 $EXPID2 $EXPID3 $EXPID4 
export GDIR=$GDIR;$HOME/gvrfy/grads/GSLINES.sh $ICNT $PFDAYS
CSTYMD=$CYMDH

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CEDYMD=00Z$DD$CMM$YY

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    /nfsuser/g01/wx20yz/gvrfy/grads/anl_comp.gs > $GDIR/map.gs        

xgrads -cl "$GDIR/map.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    /nfsuser/g01/wx20yz/gvrfy/grads/grads_die_cons.gs >map2.gs

sed -e "s/ICNT/$ICNT/" \
    -e "s/PR1/$GEXPID1/" \
    -e "s/PR2/$GEXPID2/" \
    -e "s/PR3/$GEXPID3/" \
    -e "s/PR4/$GEXPID4/" \
    /global/vrfy_grads/pub/leg_${ICNT}lines >leg_lines

xgrads -cl "$GDIR/map2.gs"


ictl=1

if [ $ictl -eq 0 ]; then

cd /ptmp/wx20yz/cgrads

gxgif -r -x 900 -y 700 -i znh_500hPa.gr   -o znh_500hPa.gif
gxgif -r -x 900 -y 700 -i zsh_500hPa.gr   -o zsh_500hPa.gif
gxgif -r -x 900 -y 700 -i rtr_200hPa.gr   -o rtr_200hPa.gif
gxgif -r -x 900 -y 700 -i rtr_850hPa.gr   -o rtr_850hPa.gif

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/qvrfy
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/cgrads znh_500hPa.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/cgrads zsh_500hPa.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/cgrads rtr_200hPa.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/cgrads rtr_850hPa.gif

fi     
