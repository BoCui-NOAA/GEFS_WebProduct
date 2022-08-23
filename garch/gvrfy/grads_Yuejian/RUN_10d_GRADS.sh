
## This scripts will run xgrads from

GDIR=/gpfstmp/wx20yz/grads_VRFY01

mkdir $GDIR

STYMD=20041001
EDYMD=20041031

YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

for EXPID in s e
do

readin_15d.sh $STYMD $EDYMD $EXPID

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    /nfsuser/g01/wx20yz/gvrfy/grads/exp_15d.ctl > $GDIR/pr$EXPID.ctl    

done

EXPID1=s
EXPID2=x
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
    /nfsuser/g01/wx20yz/gvrfy/grads/exp_15d.gs > $GDIR/map.gs        


xgrads -cl "/nfstmp/wx20yz/grads/map.gs"

