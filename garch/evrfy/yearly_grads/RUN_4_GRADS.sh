
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
STYMD=$STYMD  
EDYMD=$EDYMD   
SDIR_1=/ensemble/noscrub/Yan.Luo/evfscores               
exp_id_1=s
PFDAYS=5 
IFDAYS=$fdays 
SNAME=   
### end of set up ###

set -x

GDIR=/$ptmp/${uname}/grads   
mkdir -p $GDIR;cd $GDIR;pwd

cp $home/evrfy/grads/leg_* .

if [ "$SNAME" = "" ]; then export SNAME=SCORES;fi
TYEAR=`echo $STYMD | cut -c3-4`
NYEAR=`echo $EDYMD | cut -c3-4`
YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM $home/bin/mon2mon | cut -c8-10`
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
for EXPID in ${exp_id_1} ${exp_id_2} 
#for EXPID in ${exp_id_1}
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};;
  2) EXPID2=$EXPID;SDIR=${SDIR_2};;
esac

$home/evrfy/grads/readin2grads.sh $STYMD $EDYMD $EXPID $IFDAYS $SDIR $GDIR $ICNT

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $home/evrfy/grads/run_4_grads.ctl > pr$EXPID.ctl    

done

echo $EXPID1 $EXPID2

CSTYMD=$CYMDH
ICNT=4

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM $home/bin/mon2mon | cut -c8-10`
CEDYMD=00Z$DD$CMM$YY

ifdays=`expr $fdays + 1`
sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    -e "s/IFDAYS/$ifdays/" \
    $home/evrfy/yearly_grads/grads_line.gs >map.gs

grads -cbl "$GDIR/map.gs"

