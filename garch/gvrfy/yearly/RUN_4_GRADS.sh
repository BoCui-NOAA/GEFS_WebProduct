#!/bin/sh

### This scripts will:
###     1) convert formatted scores to grads format
###     2) using grads to plot time series and die-off curves
###
###     --- By Yuejian Zhu (09/20/00)

### Notes:
###   this script is only for:
###   3,4,5 days leading time series for AC scores of 500 mb ex-tropical height
###   2,3   days leading time series for RMS errors of 200 & 850 mb tropical wind

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
### Plots will be in /gpfstmp/${uname}/grads directory

#set -x
export GTMP=/stmp
export PTMP=/ptmp
export SHOME=/global/save
export SDIR_1=/global/noscrub/wx20yz/vrfy_official
export GLOBAL=/global/shared/stat
export VHOUR=00
export exp_id_1=s
export PFDAYS=10
export SNAME=

GDIR=$GTMP/$LOGNAME/grads   
mkdir -p $GDIR
cp $SHOME/$LOGNAME/grads/linesmpos.gs $GDIR
cd $GDIR;pwd
echo $STYMD $EDYMD $SDIR_1 $PFDAYS

if [ "$SNAME" = "" ]; then SNAME=SCORES;fi
if [ "$PFDAYS" = "" ]; then PFDAYS=5;fi
if [ "$VHOUR" = "" ]; then VHOUR=00;fi
if [ $PFDAYS -ne 5 -a $PFDAYS -ne 6 -a $PFDAYS -ne 7 -a $PFDAYS -ne 8 ]; then
 if [ $PFDAYS -ne 10 -a $PFDAYS -ne 12 -a $PFDAYS -ne 15 ]; then
 echo " The length of die-off diagram ( $PFDAYS ) does not support!!! quit!!!"
 exit 8
 fi
fi
YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM $SHOME/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

ICNT=0
for EXPID in ${exp_id_1} ${exp_id_2} ${exp_id_3} ${exp_id_4} ${exp_id_5} ${exp_id_6}
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};;
  2) EXPID2=$EXPID;SDIR=${SDIR_2};;
  3) EXPID3=$EXPID;SDIR=${SDIR_3};;
  4) EXPID4=$EXPID;SDIR=${SDIR_4};;
  5) EXPID5=$EXPID;SDIR=${SDIR_5};;
  6) EXPID6=$EXPID;SDIR=${SDIR_6};;
esac

 #if [ $VHOUR -eq 00 ]; then SYMDH=$STYMD\00;fi
 #if [ $VHOUR -eq 12 -a "$EXPID" != "e" ]; then SYMDH=$STYMD\12;fi
 #if [ "$EXPID" = "e" ]; then SYMDH=$STYMD\12;fi
 #if [ $VHOUR -eq 06 -o $VHOUR -eq 18 ]; then SYMDH=$STYMD$VHOUR;fi
 #if [ "$EXPID" = "s" -a $STYMD -le 20040908 ]; then VHOUR=;fi
 SYMDH=$STYMD$VHOUR

FDAYS=`$SHOME/wx20yz/bin/LCHECK.sh $SDIR/SCORES${EXPID}.$SYMDH `
echo "Forecast days = $FDAYS"

$SHOME/wx20yz/vrfy_grads/sorc/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $SHOME/wx20yz/vrfy_grads/pub/run_4_grads.ctl > pr$EXPID.ctl    

done

echo $EXPID1 $EXPID2 $EXPID3 $EXPID4 $EXPID5 $EXPID6

export GDIR=$GDIR;$SHOME/wx20yz/vrfy_grads/pub/GSLINES_monthly_yearly.sh $ICNT $PFDAYS

CSTYMD=$CYMDH

set -x

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM $SHOME/wx20yz/bin/mon2mon | cut -c8-10`
CEDYMD=00Z${DD}${CMM}${YY}

set +x

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/EXPID5/$EXPID5/" \
    -e "s/EXPID6/$EXPID6/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    -e "s/PP1/EXP$EXPID1/" \
    -e "s/PP2/EXP$EXPID2/" \
    -e "s/PP3/EXP$EXPID3/" \
    -e "s/PP4/EXP$EXPID4/" \
    -e "s/PP5/EXP$EXPID5/" \
    -e "s/PP6/EXP$EXPID6/" \
    $GDIR/grads_lines.gs >map.gs        

xgrads -cl "$GDIR/map.gs"

cd $GDIR;pwd                   

echo "######################################################"
echo "  Your Grads xxx.gr files in directory of $GDIR"
echo "######################################################"


