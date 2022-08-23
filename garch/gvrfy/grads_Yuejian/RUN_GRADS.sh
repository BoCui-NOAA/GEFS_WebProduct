
## This scripts will run xgrads from

GDIR=/nfstmp/wx20yz/grads

STYMD=19991028
EDYMD=19991104

YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
echo $CMM
CYMDH=00Z$DD$CMM$YY

for EXPID in s x
do

readin.sh $STYMD $EDYMD $EXPID

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    exp.ctl > $GDIR/pr$EXPID.ctl    

done

EXPID1=s
EXPID2=x
CSTYMD=$CYMDH

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
echo $CMM
CEDYMD=00Z$DD$CMM$YY

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    exp.gs > $GDIR/map.gs        


xgrads -cl "/nfstmp/wx20yz/grads/map.gs"

