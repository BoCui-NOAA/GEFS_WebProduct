#!/bin/sh
if [ $# -lt 3 ]; then
   echo "Usage: $0 need grads input table"
   echo "       example: GRADS_PUB.sh STYMD EDYMD grads_table"
   echo "       please cut and modify following table"
   cat /nfsuser/g01/wx20yz/scripts/grads_table
   exit
fi

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

nhours=/nwprod/util/exec/ndate
#uname=` who am i | awk '{print $1}' `
uname=wx20yz
STYMD=$1
EDYMD=$2
grads_table=$3

#set -x
GDIR=/gpfstmp/${uname}/grads_VRFY01   
mkdir -p $GDIR
cp $grads_table $GDIR/grads_table.sh
chmod 755 $GDIR/grads_table.sh
cd $GDIR;pwd
. grads_table.sh
echo $STYMD $EDYMD

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
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

ICNT=0
STYMD=$1     
EDYMD=$2
for EXPID in ${exp_id_1} ${exp_id_2} ${exp_id_3} ${exp_id_4} ${exp_id_5} ${exp_id_6}
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};GEXPID1=GFS;;
  2) EXPID2=$EXPID;SDIR=${SDIR_2};GEXPID2=PRV;;
  3) EXPID3=$EXPID;SDIR=${SDIR_3};GEXPID3=PRU;;
  4) EXPID4=$EXPID;SDIR=${SDIR_4};GEXPID4=PRY2;;
  5) EXPID5=$EXPID;SDIR=${SDIR_5};GEXPID5=PRY3;;
  6) EXPID6=$EXPID;SDIR=${SDIR_6};GEXPID6=XXX;;
esac

 if [ "$EXPID" = "e" ]; then 
    SYMDH=`$nhours -12 $STYMD\00 `
    STYMD=`$nhours -12 $STYMD\00 | cut -c1-8 `
    EDYMD=`$nhours -12 $EDYMD\00 | cut -c1-8 `
    SYMDH=$STYMD\12
    VHOUR=12
 else
    STYMD=$1     
    EDYMD=$2
    SYMDH=$STYMD\00
    VHOUR=00
 fi

FDAYS=`/nfsuser/g01/wx20yz/bin/LCHECK.sh $SDIR/SCORES${EXPID}.$SYMDH `
echo "Forecast days = $FDAYS"

$HOME/gvrfy/grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/gvrfy/grads/run_4_grads_ST.ctl > pr$EXPID.ctl    

done

echo $EXPID1 $EXPID2 $EXPID3 $EXPID4 $EXPID5 $EXPID6

export GDIR=$GDIR;$HOME/gvrfy/grads/GSLINES_ST.sh $ICNT $PFDAYS

CSTYMD=$CYMDH

set -x

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`
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
    -e "s/PP1/$GEXPID1/" \
    -e "s/PP2/$GEXPID2/" \
    -e "s/PP3/$GEXPID3/" \
    -e "s/PP4/$GEXPID4/" \
    -e "s/PP5/$GEXPID5/" \
    -e "s/PP6/$GEXPID6/" \
    $GDIR/grads_lines.gs >map1.gs        

xgrads -cl "$GDIR/map1.gs"
#xgrads -cbl "$GDIR/map1.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/EXPID3/$EXPID3/" \
    -e "s/EXPID4/$EXPID4/" \
    -e "s/EXPID5/$EXPID5/" \
    -e "s/EXPID6/$EXPID6/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $GDIR/grads_die.gs >map2.gs        

sed -e "s/ICNT/$ICNT/" \
    -e "s/PR1/$GEXPID1/" \
    -e "s/PR2/$GEXPID2/" \
    -e "s/PR3/$GEXPID3/" \
    -e "s/PR4/$GEXPID4/" \
    -e "s/PR5/$GEXPID5/" \
    -e "s/PR6/$GEXPID6/" \
    /global/vrfy_grads/pub/leg_${ICNT}lines >leg_lines

xgrads -cl "$GDIR/map2.gs"
#xgrads -cbl "$GDIR/map2.gs"

cd $GDIR;pwd                   

ictl=0

if [ $ictl -eq 0 ]; then

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/exp/PRV_200511
for fname in nh50z_1days sh50z_1days \
             nh50z_2days sh50z_2days \
             nh50z_3days sh50z_3days \
             nh50z_4days sh50z_4days \
             nh50z_5days sh50z_5days \
             nh50z_6days sh50z_6days \
             tr100u_1days tr100v_1days \
             tr100u_2days tr100v_2days \
             tr100u_3days tr100v_3days \
             tr100s_1days tr100r_1days \
             tr100s_2days tr100r_2days \
             tr100s_3days tr100r_3days \
             tr50u_1days tr50v_1days \
             tr50u_2days tr50v_2days \
             tr50u_3days tr50v_3days \
             tr50s_1days tr50r_1days \
             tr50s_2days tr50r_2days \
             tr50s_3days tr50r_3days  
do
gxgif -r -x 1100 -y 850 -i $fname\_ac_rms.gr -o $fname\_ac_rms.gif
ftprzdm rzdm put $RZDMDIR $GDIR $fname\_ac_rms.gif
done


for fname in nh100zac   sh100zac   nh50zac   sh50zac  \
             tr100uac   tr100vac   tr100sac            \
             tr50uac    tr50vac    tr50sac            \
             nh100zrms  sh100zrms  nh50zrms  sh50zrms \
             tr100urms  tr100vrms  tr100srms tr100rrms \
             tr50urms   tr50vrms   tr50srms  tr50rrms
do
gxgif -r -x 1100 -y 850 -i $fname\_die.gr -o $fname\_die.gif
ftprzdm rzdm put $RZDMDIR $GDIR $fname\_die.gif
done

fi

echo "######################################################"
echo "  Your Grads xxx.gr files in directory of $GDIR"
echo "######################################################"


