
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

#uname=` who am i | awk '{print $1}' `

### start to set up ###
#STYMD=20021201
#EDYMD=20030121 

export STYMD=$STYMD
export EDYMD=$EDYMD
SDIR_1=/global/evrfy                   
exp_id_1=s
PFDAYS=5 
FDAYS=5 
SNAME=   
### end of set up ###

#set -x

#GDIR=/ptmp/${uname}/opr_grads   
GDIR=/ptmp/wx20yz/opr_grads   
mkdir -p $GDIR;cd $GDIR;pwd

cp $HOME/evrfy/grads/leg_3lines .
cp $HOME/evrfy/grads/leg_4lines .
cp $HOME/evrfy/grads/leg_T3lines .

if [ "$SNAME" = "" ]; then export SNAME=SCORES;fi
TYEAR=`echo $STYMD | cut -c3-4`
NYEAR=`echo $EDYMD | cut -c3-4`
YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

JCNT=`expr $EDYMD - $STYMD`
if [ $MM -eq 12 ]; then
 SEASON=win
 YEAR=$TYEAR$NYEAR
fi
if [ $MM -eq 03 ]; then
 SEASON=spr
 YEAR=$YY
fi
if [ $MM -eq 06 ]; then
 SEASON=sum
 YEAR=$YY
fi
if [ $MM -eq 09 ]; then
 SEASON=fal
 YEAR=$YY
fi

ICNT=0
for EXPID in ${exp_id_1} 
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};;
esac

$HOME/evrfy/opr_grads/readin2grads_tg.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/opr_grads/run_4_grads_tg.ctl > pr$EXPID.ctl    

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
    $HOME/evrfy/opr_grads/grads_T.gs > map.gs        

*xgrads -cpl "$GDIR/map.gs"
xgrads -cbl "$GDIR/map.gs"

cd $GDIR;pwd

ictl=0

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/evrfy

if [ $ictl -eq 0 ]; then

for dd in 1 2 3 4 5 6 7
do

gxgif -r -x 695 -y 545 -i nh500h_$dd\days_tg.gr -o nh500h_$dd\days_tg.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  nh500h_$dd\days_tg.gif

gxgif -r -x 695 -y 545 -i sh500h_$dd\days_tg.gr -o sh500h_$dd\days_tg.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  sh500h_$dd\days_tg.gif

done

fi


echo "######################################################"
echo "  Your Grads xxx.gr files in directory of $GDIR"
echo "######################################################"

