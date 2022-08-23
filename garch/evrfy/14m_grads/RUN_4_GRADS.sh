
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

set -x
### start to set up ###
#export STYMD=20060224
export STYMD=20060301
export EDYMD=$edymd   
SDIR_1=/global/evrfy
SDIR_2=/global/evrfy
SDIR_3=                                    
SDIR_4=                                
exp_id_1=s
exp_id_2=x
exp_id_3= 
exp_id_4= 
PFDAYS=5
FDAYS=5
SNAME=   
### end of set up ###

#set -x

GDIR=/ptmp/wx20yz/grads_14m   
mkdir -p $GDIR;cd $GDIR;pwd

cp $HOME/evrfy/14m_grads/leg_* .

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
for EXPID in ${exp_id_1} ${exp_id_2} ${exp_id_3} ${exp_id_4}
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};;
  2) EXPID2=$EXPID;SDIR=${SDIR_2};;
  3) EXPID3=$EXPID;SDIR=${SDIR_3};;
  4) EXPID4=$EXPID;SDIR=${SDIR_4};;
esac

$HOME/evrfy/14m_grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR 1 1

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/14m_grads/run_4_grads.ctl > pr$EXPID.ctl

done

echo $EXPID1 $EXPID2 $EXPID3 $EXPID4

CSTYMD=$CYMDH
ICNT=4

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
    $HOME/evrfy/14m_grads/grads_2lines_1000mb.gs >map.gs

xgrads -cbl "$GDIR/map.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/14m_grads/grads_die_15d_2lines_1000mb.gs >map.gs

xgrads -cbl "$GDIR/map.gs"


sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/14m_grads/grads_Tdie_15d_2lines_1000mb.gs >map.gs

xgrads -cbl "$GDIR/map.gs"


ICNT=0
for EXPID in ${exp_id_1} ${exp_id_2} ${exp_id_3} ${exp_id_4}
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};;
  2) EXPID2=$EXPID;SDIR=${SDIR_2};;
  3) EXPID3=$EXPID;SDIR=${SDIR_3};;
  4) EXPID4=$EXPID;SDIR=${SDIR_4};;
esac

$HOME/evrfy/14m_grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR 1 2

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/14m_grads/run_4_grads.ctl > pr$EXPID.ctl    

done

echo $EXPID1 $EXPID2 $EXPID3 $EXPID4

CSTYMD=$CYMDH
ICNT=4

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
    $HOME/evrfy/14m_grads/grads_2lines_500mb.gs >map.gs

xgrads -cbl "$GDIR/map.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/14m_grads/grads_die_15d_2lines_500mb.gs >map.gs        

xgrads -cbl "$GDIR/map.gs"


sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/14m_grads/grads_Tdie_15d_2lines_500mb.gs >map.gs        

xgrads -cbl "$GDIR/map.gs"


cd $GDIR;pwd                   

ictl=0

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/evrfy_prx 

if [ $ictl -eq 0 ]; then

for fname in nh1000h_1days  sh1000h_1days tr1000h_1days \
             nh1000h_2days  sh1000h_2days tr1000h_2days \
             nh1000h_3days  sh1000h_3days tr1000h_3days \
             nh1000h_4days  sh1000h_4days tr1000h_4days \
             nh1000h_5days  sh1000h_5days tr1000h_5days \
             nh1000h_6days  sh1000h_6days tr1000h_6days \
             nh1000h_7days  sh1000h_7days tr1000h_7days \
             nh1000h_8days  sh1000h_8days tr1000h_8days \
             nh500h_1days  sh500h_1days tr500h_1days \
             nh500h_2days  sh500h_2days tr500h_2days \
             nh500h_3days  sh500h_3days tr500h_3days \
             nh500h_4days  sh500h_4days tr500h_4days \
             nh500h_5days  sh500h_5days tr500h_5days \
             nh500h_6days  sh500h_6days tr500h_6days \
             nh500h_7days  sh500h_7days tr500h_7days \
             nh500h_8days  sh500h_8days tr500h_8days  
do

gxgif -r -x 1100 -y 850 -i $fname\_ac.gr -o $fname\_ac.gif
ftprzdm rzdm put $RZDMDIR $GDIR $fname\_ac.gif

gxgif -r -x 1100 -y 850 -i $fname\_rms.gr -o $fname\_rms.gif
ftprzdm rzdm put $RZDMDIR $GDIR $fname\_rms.gif

done

for fname in nh1000h_ac sh1000h_ac tr1000h_ac \
             nh500h_ac sh500h_ac tr500h_ac \
             nh1000h_rms sh1000h_rms tr1000h_rms \
             nh500h_rms sh500h_rms tr500h_rms \
             nh1000h_tg sh1000h_tg tr1000h_tg \
             nh500h_tg sh500h_tg tr500h_tg \
             nh1000h_tg-1 sh1000h_tg-1 tr1000h_tg-1 \
             nh500h_tg-1 sh500h_tg-1 tr500h_tg-1  
do

gxgif -r -x 1100 -y 850 -i $fname\_die.gr  -o $fname\_die.gif
ftprzdm rzdm put $RZDMDIR $GDIR $fname\_die.gif

done

fi

