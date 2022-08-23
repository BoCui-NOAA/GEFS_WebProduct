
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
STYMD=$1        
EDYMD=$2        

TDAYS=`expr $EDYMD - $STYMD `
SDIR_1=/global/evfscores               
exp_id_1=s
PFDAYS=5 
FDAYS=5 
SNAME=   
### end of set up ###

#set -x

GDIR=/ptmp/${uname}/grads   
mkdir -p $GDIR;cd $GDIR;pwd

cp $HOME/evrfy/grads/leg_3lines_avn .
cp $HOME/evrfy/grads/leg_4lines_avn .
cp $HOME/evrfy/grads/leg_T3lines .
cp $HOME/evrfy/grads/leg_l1      .
cp $HOME/evrfy/grads/leg_l2      .

if [ "$SNAME" = "" ]; then export SNAME=SCORES;fi
YY=`echo $STYMD | cut -c1-4`
TYEAR=`echo $STYMD | cut -c3-4`
NYEAR=`echo $EDYMD | cut -c3-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

DIFF=`expr $EDYMD - $STYMD`

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

#$HOME/evrfy/grads/readin2grads_avn.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR
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
    -e "s/TDAYS/$TDAYS/" \
    $HOME/evrfy/grads/grads_sct_7-3.5da.gs > map.gs        
#   $HOME/evrfy/grads/grads_sct_7-3.5d.gs > map.gs        
#   $HOME/evrfy/grads/grads_sct_3-8d.gs > map.gs        
#   $HOME/evrfy/grads/grads_sct_15d_avn.gs > map.gs        

xgrads -cbl "$GDIR/map.gs"


cd $GDIR;pwd                   

ictl=0

SGIDIR=/export-1/sgi100/data/WebServer/htdocs/ens/avn_vrfy          

if [ $ictl -eq 0 ]; then

for fname in 500h_egrate_3.5-7d_sct 
do

 if [ $DIFF -gt 40 ]; then
  gxgif -r -x 695 -y 545 -i $fname.gr -o $fname$SEASON$YEAR.gif
  gxps -c                -i $fname.gr -o $fname$SEASON$YEAR.ps     
  #lpr -P phaser3 $fname$SEASON$YEAR.ps
 else
  gxgif -r -x 695 -y 545 -i $fname.gr -o $fname$MM$YY.gif
  gxps -c                -i $fname.gr -o $fname$MM$YY.ps     
  #lpr -P phaser3 $fname$MM$YEAR.ps
 fi

#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  $fname\_ac_$SEASON$YEAR.gif  
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  $fname\_rms_$SEASON$YEAR.gif  

done

fi

echo "######################################################"
echo "  Your Grads xxx.gr files in directory of $GDIR"
echo "######################################################"

