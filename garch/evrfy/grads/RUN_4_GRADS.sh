
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
STYMD=20060301
EDYMD=20060530 
SDIR_1=/global/shared/stat/evfscores               
exp_id_1=s
PFDAYS=5 
FDAYS=5 
SNAME=   
### end of set up ###

#set -x

GDIR=/ptmp/${uname}/grads   
mkdir -p $GDIR;cd $GDIR;pwd

cp $HOME/evrfy/grads/leg_* .
cp $HOME/grads/linesmpos.gs .

if [ "$SNAME" = "" ]; then export SNAME=SCORES;fi
TYEAR=`echo $STYMD | cut -c3-4`
NYEAR=`echo $EDYMD | cut -c3-4`
YY=`echo $STYMD | cut -c1-4`
MM=`echo $STYMD | cut -c5-6`
DD=`echo $STYMD | cut -c7-8`
CMM=`grep $MM $HOME/bin/mon2mon | cut -c8-10`
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

$HOME/evrfy/grads/readin2grads.sh $STYMD $EDYMD $EXPID $FDAYS $SDIR $GDIR $ICNT

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/grads/run_4_grads.ctl > pr$EXPID.ctl    

sed -e "s/EXPID/$EXPID/" \
    -e "s/CYMDH/$CYMDH/" \
    $HOME/evrfy/grads/run_4_gradm.ctl > pm$EXPID.ctl    

done

echo $EXPID1 $EXPID2

CSTYMD=$CYMDH
ICNT=4

YY=`echo $EDYMD | cut -c1-4`
MM=`echo $EDYMD | cut -c5-6`
DD=`echo $EDYMD | cut -c7-8`
CMM=`grep $MM $HOME/bin/mon2mon | cut -c8-10`
CEDYMD=00Z$DD$CMM$YY

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/grads/grads_lines.gs >map.gs

xgrads -cl "$GDIR/map.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/grads/grads_linem.gs >map.gs

xgrads -cl "$GDIR/map.gs"

sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/grads/grads_die_15d.gs >map.gs        

xgrads -cl "$GDIR/map.gs"


sed -e "s/EXPID1/$EXPID1/" \
    -e "s/EXPID2/$EXPID2/" \
    -e "s/CSTYMD/$CSTYMD/" \
    -e "s/CEDYMD/$CEDYMD/" \
    $HOME/evrfy/grads/grads_T_die_15d.gs >map.gs        
#   $HOME/evrfy/grads/grads_T_die_15da.gs >map.gs        

xgrads -cl "$GDIR/map.gs"


cd $GDIR;pwd                   

ictl=0

SGIDIR=/export-1/sgi100/data/WebServer/htdocs/ens/evrfy          
RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/evrfy                

if [ $ictl -eq 0 ]; then

if [ $JCNT -gt 40 ]; then
 gname=$SEASON$YEAR
else
 gname=$YY$MM
fi

for fname in nh500h_3days  sh500h_3days \
             nh500h_4days  sh500h_4days \
             nh500h_5days  sh500h_5days \
             nh500h_6days  sh500h_6days \
             nh500h_7days  sh500h_7days \
             nh500h_8days  sh500h_8days \
             nh500h_9days  sh500h_9days \
             nh500h_10days sh500h_10days   

do


gxgif -r -x 900 -y 700 -i $fname\_ac.gr -o $fname\_ac_$gname.gif
gxps  -c               -i $fname\_ac.gr -o $fname\_ac_$gname.ps  
gxgif -r -x 900 -y 700 -i $fname\_rms.gr -o $fname\_rms_$gname.gif
gxps  -c               -i $fname\_rms.gr -o $fname\_rms_$gname.ps  

#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  $fname\_ac_$gname.gif  
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  $fname\_rms_$gname.gif  
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  $fname\_ac_$gname.gif  
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  $fname\_rms_$gname.gif  

done

gxgif -r -x 900 -y 700 -i nh500h_ac_die.gr  -o nh500h_ac_die_$gname.gif
gxgif -r -x 900 -y 700 -i nh500h_rms_die.gr -o nh500h_rms_die_$gname.gif
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  nh500h_ac_die_$gname.gif
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  nh500h_rms_die_$gname.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  nh500h_ac_die_$gname.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  nh500h_rms_die_$gname.gif

gxgif -r -x 900 -y 700 -i sh500h_ac_die.gr  -o sh500h_ac_die_$gname.gif
gxgif -r -x 900 -y 700 -i sh500h_rms_die.gr -o sh500h_rms_die_$gname.gif
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  sh500h_ac_die_$gname.gif
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  sh500h_rms_die_$gname.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  sh500h_ac_die_$gname.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  sh500h_rms_die_$gname.gif

gxgif -r -x 900 -y 700 -i nh500h_tg-1_die.gr -o nh500h_tg-1_die_$gname.gif
gxgif -r -x 900 -y 700 -i nh500h_tg_die.gr   -o nh500h_tg_die_$gname.gif
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  nh500h_tg-1_die_$gname.gif 
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  nh500h_tg_die_$gname.gif 
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  nh500h_tg-1_die_$gname.gif 
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  nh500h_tg_die_$gname.gif 

gxgif -r -x 900 -y 700 -i sh500h_tg-1_die.gr -o sh500h_tg-1_die_$gname.gif
gxgif -r -x 900 -y 700 -i sh500h_tg_die.gr   -o sh500h_tg_die_$gname.gif
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  sh500h_tg-1_die_$gname.gif 
#ftpsgi sgi100 put $SGIDIR /ptmp/wx20yz/grads  sh500h_tg_die_$gname.gif 
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  sh500h_tg-1_die_$gname.gif 
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  sh500h_tg_die_$gname.gif 

fi

###
### to creat a scripts/html for PAC/RMS table
###
cat $HOME/evrfy/grads/Z500_PAC_RMS_ini.html   >Z500_PAC_RMS.html

YEAR=2006
for MM in 15 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0405
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_PAC_RMS_mid.html   >>Z500_PAC_RMS.html

done

YEAR=2005
for MM in 15 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0405
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_PAC_RMS_mid.html   >>Z500_PAC_RMS.html

done

YEAR=2004
#for MM in 15 14 13 16 02 01
for MM in 15 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0304
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_PAC_RMS_mid.html   >>Z500_PAC_RMS.html

done

YEAR=2003
#for MM in 12 15 11 10 09 14 08 07 06 13 05 04 03 16 02 01
for MM in 15 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0203
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_PAC_RMS_mid.html   >>Z500_PAC_RMS.html

done

YEAR=2002
#for MM in 12 15 11 10 09 14 08 07 06 13 05 04 03 16 02 01
for MM in 15 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0102             
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_PAC_RMS_mid.html   >>Z500_PAC_RMS.html

done

YEAR=2001
#for MM in 12 15 11 10 09 14 08 07 06 13 05 04 03 16 02 01
for MM in 15 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0001            
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_PAC_RMS_mid.html   >>Z500_PAC_RMS.html

done

YEAR=2000
#for MM in 12 15 11 10 09 14 08 07 06 13 05
for MM in 15 14 13
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_PAC_RMS_mid.html   >>Z500_PAC_RMS.html

done

cat $HOME/evrfy/grads/Z500_PAC_RMS_end.html   >>Z500_PAC_RMS.html

#ftp -vi lnx70 <<EOF
#cd /export-1/sgi100/data/WebServer/htdocs/ens/yzhu
#put Z500_PAC_RMS.html
#EOF

sed -e "s/ens/gmb\/yzhu/" \
     Z500_PAC_RMS.html >Z500_PAC_RMS.rzdm_html
mv Z500_PAC_RMS.rzdm_html Z500_PAC_RMS.html

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/html/opr
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  Z500_PAC_RMS.html           

###
### to creat a scripts/html for talagrand table
###
cat $HOME/evrfy/grads/Z500_TG_ini.html   >Z500_TG.html

YEAR=2005
for MM in 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0405
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_TG_mid.html   >>Z500_TG.html

done

YEAR=2004
for MM in 15 14 13 16 
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0304
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_TG_mid.html   >>Z500_TG.html

done

YEAR=2003
#for MM in 12 15 11 10 09 14 08 07 06 13 05 04 03 16 02 01
for MM in 15 14 13 16    
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0203
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_TG_mid.html   >>Z500_TG.html

done

YEAR=2002
#for MM in 12 15 11 10 09 14 08 07 06 13 05 04 03 16 02 01
for MM in 15 14 13 16
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0102          
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_TG_mid.html   >>Z500_TG.html

done

YEAR=2001
#for MM in 12 15 11 10 09 14 08 07 06 13 05 04 03 16 02 01 
for MM in 15 14 13 16 
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
  if [ $MM -eq 16 ]; then
  SMYEAR=$CMON\0001         
  fi
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_TG_mid.html   >>Z500_TG.html

done

YEAR=2000
#for MM in 12 15 11 10 09 14 08 07 06 13 05 
for MM in 15 14 13 
do
 CMON=`cat $HOME/evrfy/grads/mon2mon | grep "$MM" | cut -c4-6`
 SMYEAR=$YEAR$MM
 YYYY=$YEAR
 SEAMON=$CMON

 if [ $MM -gt 12 ]; then
  if [ "$CMON" = "aut" ]; then
   CMON=fal
  fi
  SMYEAR=$CMON$YEAR
 fi

 sed -e "s/SEAMON/$SEAMON/" \
     -e "s/YYYY/$YYYY/"     \
     -e "s/SMYEAR/$SMYEAR/" \
     $HOME/evrfy/grads/Z500_TG_mid.html   >>Z500_TG.html

done

cat $HOME/evrfy/grads/Z500_TG_end.html   >>Z500_TG.html

#ftp -vi lnx70 <<EOF
#cd /export-1/sgi100/data/WebServer/htdocs/ens/yzhu
#put Z500_TG.html
#EOF

sed -e "s/ens/gmb\/yzhu/" \
     Z500_TG.html >Z500_TG.rzdm_html
mv Z500_TG.rzdm_html Z500_TG.html

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/html/opr
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/grads  Z500_TG.html           

echo "######################################################"
echo "  Your Grads xxx.gr files in directory of $GDIR"
echo "######################################################"

### to run Talagrand diagram ( using different control )

export STYMD=$STYMD
export EDYMD=$EDYMD
$HOME/evrfy/grads/RUN_4_GRADS_tg.sh
