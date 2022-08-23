
### This scripts ( for ensemble evaluation only ) will:
###     1) convert formatted scores to grads format
###     2) using grads to plot time series and die-off curves
###
###     --- By Yuejian Zhu (12/29/00)

### Notes:
###     this script is only for:
###     3,4,5 days leading time series for AC scores of 500 mb ex-tropical height
###     2,3   days leading time series for RMS errors of 200 & 850 mb tropical wind
###     if you need longer leading time time series,
###        try RUN_4_GRADS_new.sh

### Requires to set up
###     1) STYMD -- yyyymmdd of verifying score start
###     2) EDYMD -- yyyymmdd of verifying score end
###     3) SDIR  -- your score directory ( default = /global/vrfy )
###     4) exp_id_1 -- experiment 1 ID ( better only one character, e.g a/b/c )
###        exp_id_2 -- experiment 2 ID ( better only one character, e.g a/b/c )
###        exp_id_3 -- experiment 3 ID ( better only one character, e.g a/b/c )
###        exp_id_4 -- experiment 4 ID ( better only one character, e.g a/b/c )
###        experiments should be from minimum 2 to maximum 4
###     5) PFDAYS -- plot leading forecast days ( 5,10,16 only )
###     6) SNAME  -- your saving score name ( default(blank) = SCORES )
### 
### Plots will be in /ptmp/${uname}/grads directory

uname=` who am i | awk '{print $1}' `

### start to set up ###
STYMD=20011101
EDYMD=20011130 
SDIR_1=/global/evfscores               
exp_id_1=s
PFDAYS=5 
FDAYS=5 
SNAME=   
### end of set up ###

#set -x

GDIR=/ptmp/${uname}/grads   
mkdir -p $GDIR;cd $GDIR;pwd

cp $HOME/evrfy/grads/leg_2lines .
cp $HOME/evrfy/grads/leg_3lines .
cp $HOME/evrfy/grads/leg_4lines .
cp $HOME/evrfy/grads/leg_T3lines .

if [ "$SNAME" = "" ]; then export SNAME=SCORES;fi
YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

ICNT=0
for EXPID in ${exp_id_1} 
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};;
esac

$HOME/evrfy/grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/grads/run_4_grads.ctl > pr$EXPID.ctl    

done

echo $EXPID1 

CSTYMD=$CYMDH
ICNT=4

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CEDYMD=00Z$DD$CMM$YY

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/grads/For_Hua-Lu.gs >map.gs

xgrads -cl "$GDIR/map.gs"

echo "######################################################"
echo "  Your Grads xxx.gr files in directory of $GDIR"
echo "######################################################"


cd /ptmp/wx20yz/grads
gxps -c -i nh500h.gr -o nh500h.ps
gxps -c -i sh500h.gr -o sh500h.ps
lpr -P phaser3 nh500h.ps
lpr -P phaser3 sh500h.ps

