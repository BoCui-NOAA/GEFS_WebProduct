#!/bin/sh
if [ $# -lt 3 ]; then
   echo "Usage: $0 need grads input table"
   echo "       example: GRADS_PUB.sh STYMD EDYMD grads_table"
   echo "       please cut and modify following table"
   cat /ensemble/save/Yan.Luo/scripts/grads_table
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

#nhours=/nwprod/util/exec/ndate
STYMD=$1
EDYMD=$2
grads_table=$3

#set -x
GDIR=$GTMP/Yan.Luo/grads_VRFY01   
mkdir -p $GDIR
cp $grads_table $GDIR/grads_table.sh
chmod 755 $GDIR/grads_table.sh
cd $GDIR;pwd
. grads_table.sh
cp $SHOME/Yan.Luo/grads/*.gs .
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
CMM=`grep $MM $SHOME/Yan.Luo/bin/mon2mon | cut -c8-10`
CYMDH=00Z$DD$CMM$YY

ICNT=0
STYMD=$1     
EDYMD=$2
for EXPID in ${exp_id_1} ${exp_id_2} ${exp_id_3} ${exp_id_4} ${exp_id_5} ${exp_id_6}
do

ICNT=`expr $ICNT + 1`

case $ICNT in
  1) EXPID1=$EXPID;SDIR=${SDIR_1};GEXPID1=GFS;;
  2) EXPID2=$EXPID;SDIR=${SDIR_2};GEXPID2=ECM;;
  3) EXPID3=$EXPID;SDIR=${SDIR_3};GEXPID3=UKM;;
  4) EXPID4=$EXPID;SDIR=${SDIR_4};GEXPID4=MSC;;
  5) EXPID5=$EXPID;SDIR=${SDIR_5};GEXPID5=NGP;;
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

FDAYS=`$SHOME/Yan.Luo/bin/LCHECK.sh $SDIR/SCORES${EXPID}.$SYMDH `
echo "Forecast days = $FDAYS"

if [ $FDAYS -eq 99 ]; then
   FDAYS=16
fi

$SHOME/Yan.Luo/gvrfy/grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $SHOME/Yan.Luo/gvrfy/grads/run_4_grads.ctl > pr$EXPID.ctl    

done

echo $EXPID1 $EXPID2 $EXPID3 $EXPID4 $EXPID5 $EXPID6

export GDIR=$GDIR;$SHOME/Yan.Luo/gvrfy/grads/GSLINES.sh $ICNT $PFDAYS

CSTYMD=$CYMDH

set -x

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM $SHOME/Yan.Luo/bin/mon2mon | cut -c8-10`
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

grads -cbl "$GDIR/map1.gs"

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
    $GLOBAL/vrfy_grads/pub/leg_${ICNT}lines >leg_lines

grads -cbl "$GDIR/map2.gs"

cd $GDIR;pwd                   

ictl=0

if [ $ictl -eq 0 ]; then

RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/GFS_VRFY01
for fname in nh500z_1days sh500z_1days \
             nh500z_2days sh500z_2days \
             nh500z_3days sh500z_3days \
             nh500z_4days sh500z_4days \
             nh500z_5days sh500z_5days \
             nh500z_6days sh500z_6days \
             tr850u_1days tr850v_1days \
             tr850u_2days tr850v_2days \
             tr850u_3days tr850v_3days \
             tr850s_1days tr850r_1days \
             tr850s_2days tr850r_2days \
             tr850s_3days tr850r_3days \
             tr200u_1days tr200v_1days \
             tr200u_2days tr200v_2days \
             tr200u_3days tr200v_3days \
             tr200s_1days tr200r_1days \
             tr200s_2days tr200r_2days \
             tr200s_3days tr200r_3days  
do
gxgif -r -x 1100 -y 850 -i $fname\_ac_rms.gr -o $fname\_ac_rms.gif
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR $fname\_ac_rms.gif
done


for fname in nh1000zac  sh1000zac  nh500zac  sh500zac  \
             tr850uac   tr850vac   tr850sac            \
             tr200uac   tr200vac   tr200sac            \
             nh1000zrms sh1000zrms nh500zrms sh500zrms \
             tr850urms  tr850vrms  tr850srms tr850rrms \
             tr200urms  tr200vrms  tr200srms tr200rrms
do
gxgif -r -x 1100 -y 850 -i $fname\_die.gr -o $fname\_die.gif
ftpemcrzdm emcrzdm put $RZDMDIR $GDIR $fname\_die.gif
done

fi

echo "######################################################"
echo "  Your Grads xxx.gr files in directory of $GDIR"
echo "######################################################"


