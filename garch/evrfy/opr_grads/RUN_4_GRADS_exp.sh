
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
#STYMD=$STYMD  
#EDYMD=$EDYMD   
STYMD=20041119
EDYMD=20041130 
SDIR_1=/global/evrfy                   
exp_id_1=s
exp_id_2=c
PFDAYS=5 
FDAYS=5 
SNAME=   
### end of set up ###

#set -x

#GDIR=/ptmp/${uname}/exp_grads   
GDIR=/ptmp/wx20yz/exp_grads   
mkdir -p $GDIR;cd $GDIR;pwd

cp $HOME/evrfy/grads/leg_* .

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
for EXPID in ${exp_id_1} ${exp_id_2} 
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};;
  2) EXPID2=$EXPID;SDIR=${SDIR_2};;
esac

ICNT=1

$HOME/evrfy/opr_grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR $ICNT

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/opr_grads/run_4_grads.ctl > pr$EXPID.ctl    

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/opr_grads/run_4_gradm.ctl > pm$EXPID.ctl    

done

echo $EXPID1 $EXPID2

CSTYMD=$CYMDH
ICNT=4

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CEDYMD=00Z$DD$CMM$YY

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/opr_grads/grads_lines.gs >map.gs

xgrads -cl "$GDIR/map.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/opr_grads/grads_linem.gs >map.gs

#xgrads -cbl "$GDIR/map.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/opr_grads/grads_die_15d.gs >map.gs        

xgrads -cl "$GDIR/map.gs"


sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/opr_grads/grads_T_die_15d.gs >map.gs        

xgrads -cl "$GDIR/map.gs"


cd $GDIR;pwd                   

ictl=1

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/evrfy                

if [ $ictl -eq 0 ]; then

for fname in nh500h_1days  sh500h_1days \
             nh500h_2days  sh500h_2days \
             nh500h_3days  sh500h_3days \
             nh500h_4days  sh500h_4days \
             nh500h_5days  sh500h_5days \
             nh500h_6days  sh500h_6days \
             nh500h_7days  sh500h_7days \
             nh500h_8days  sh500h_8days \
             nh500h_9days  sh500h_9days \
             nh500h_10days sh500h_10days   
do

gxgif -r -x 695 -y 545 -i $fname\_ac.gr -o $fname\_ac.gif
gxgif -r -x 695 -y 545 -i $fname\_rms.gr -o $fname\_rms.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  $fname\_ac.gif  
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  $fname\_rms.gif  

done

gxgif -r -x 695 -y 545 -i nh500h_ac_die.gr  -o nh500h_ac_die.gif
gxgif -r -x 695 -y 545 -i nh500h_rms_die.gr -o nh500h_rms_die.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  nh500h_ac_die.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  nh500h_rms_die.gif

gxgif -r -x 695 -y 545 -i sh500h_ac_die.gr  -o sh500h_ac_die.gif
gxgif -r -x 695 -y 545 -i sh500h_rms_die.gr -o sh500h_rms_die.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  sh500h_ac_die.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  sh500h_rms_die.gif

gxgif -r -x 695 -y 545 -i nh500h_tg-1_die.gr -o nh500h_tg-1_die.gif
gxgif -r -x 695 -y 545 -i nh500h_tg_die.gr   -o nh500h_tg_die.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  nh500h_tg-1_die.gif 
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  nh500h_tg_die.gif 

gxgif -r -x 695 -y 545 -i sh500h_tg-1_die.gr -o sh500h_tg-1_die.gif
gxgif -r -x 695 -y 545 -i sh500h_tg_die.gr   -o sh500h_tg_die.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  sh500h_tg-1_die.gif 
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/opr_grads  sh500h_tg_die.gif 

fi

