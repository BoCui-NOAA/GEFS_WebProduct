
if [ $# -lt 1 ]; then
    echo " Usage: $0 need yymmddhh "
    echo " For example: PLOT.sh 2000120100 "
    exit 8
fi

   echo
   echo " ######################################################## "
   echo " ###   Start to plot the verification scores          ### "
   echo " ###   Please wait! wait! wait!!!!!!!                 ### "
   echo " ######################################################## "
   echo 

###
### 

CDATE=$1
ptmp=/ptmp/wx20yz/DEC_WAVE
mkdir $ptmp;cd $ptmp

YEAR=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE   | cut -c5-6`
DD=`echo $CDATE   | cut -c7-8`
HH=`echo $CDATE   | cut -c9-10`
CMM=`grep $MM $HOME/bin/mon2mon | cut -c8-10`
MDATE=${HH}Z${DD}${CMM}$YEAR

### need to set up following three lines
EXPID1=s
EXPID2=u
RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/exp/PRU_200511
RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/doc/FITWAV_2D 
RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/doc/FITWAV_1D 

#for fhr in 00 24 48 72 96 120
for fhr in 120
do

for WAVE in 0 1 2 3
do

FDATE=`ndate +$fhr $CDATE`
sed -e "s/_FHR/00/"           \
    -e "s/_WAVE/$WAVE/"         \
    -e "s/_EXPID/s/"          \
    -e "s/_YMDH/$FDATE/"        \
    -e "s/_MDATE/$MDATE/"        \
   $HOME/gvrfy/grads_wave/PLOT.CTL >pgbf00_s${WAVE}.${CDATE}.ctl

gribmap -i pgbf00_s${WAVE}.${CDATE}.ctl                  

FDATE=`ndate +$fhr $CDATE`
sed -e "s/_FHR/00/"           \
    -e "s/_WAVE/$WAVE/"         \
    -e "s/_EXPID/n/"          \
    -e "s/_YMDH/$FDATE/"        \
    -e "s/_MDATE/$MDATE/"        \
   $HOME/gvrfy/grads_wave/PLOT.CTL >pgbf00_n${WAVE}.${CDATE}.ctl

gribmap -i pgbf00_n${WAVE}.${CDATE}.ctl                  

done

for ID in $EXPID1 $EXPID2 
do


for WAVE in 0 1 2 3
do

sed -e "s/_FHR/$fhr/"           \
    -e "s/_WAVE/$WAVE/"         \
    -e "s/_EXPID/$ID/"          \
    -e "s/_YMDH/$CDATE/"        \
    -e "s/_MDATE/$MDATE/"        \
   $HOME/gvrfy/grads_wave/PLOT.CTL >pgbf${fhr}_${ID}${WAVE}.${CDATE}.ctl

gribmap -i pgbf${fhr}_${ID}${WAVE}.${CDATE}.ctl
done

done

done


sed -e "s/_FHR/$fhr/"           \
    -e "s/_YMDH/$CDATE/"        \
    $HOME/gvrfy/grads_wave/PLOT_test1.GS >plot.gs

grads -cl "run plot.gs"
#grads -clb "run plot1.gs"

gxgif -r -x 1000 -y 770 -i f$fhr.$CDATE\_1dd.gr -o f$fhr.$CDATE\_1dd.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/DEC_WAVE f$fhr.$CDATE\_1dd.gif 

ictl=1

if [ $ictl -eq 0 ]; then
for ID in $EXPID1 $EXPID2 
do

sed -e "s/_SEASON/$season/"  \
    -e "s/_OBJ/wgne/"        \
    -e "s/_SYEAR/$SYEAR/"    \
    -e "s/_SCMM/$SCMM/"      \
    -e "s/_SDD/$SDD/"        \
    -e "s/_ID/$ID/"          \
   $HOME/wgne/grads/f36.CTL >f36$ID.ctl

sed -e "s/_SEASON/$season/"  \
    -e "s/_OBJ/wgne/"        \
    -e "s/_SYEAR/$SYEAR/"    \
    -e "s/_SCMM/$SCMM/"      \
    -e "s/_SDD/$SDD/"        \
    -e "s/_ID/$ID/"          \
   $HOME/wgne/grads/f60.CTL >f60$ID.ctl

sed -e "s/_SEASON/$season/"  \
    -e "s/_OBJ/wgne/"        \
    -e "s/_SYEAR/$SYEAR/"    \
    -e "s/_SCMM/$SCMM/"      \
    -e "s/_SDD/$SDD/"        \
    -e "s/_ID/$ID/"        \
   $HOME/wgne/grads/f84.CTL >f84$ID.ctl
done

sed -e "s/_SYEAR/$SYEAR/"  \
    -e "s/_EYEAR/$EYEAR/"  \
    -e "s/_SCMM/$SCMM/"  \
    -e "s/_ECMM/$ECMM/"  \
    -e "s/_SDD/$SDD/"  \
    -e "s/_EDD/$EDD/"  \
    -e "s/FNAME/$FNAME/"  \
    -e "s/_EXPID1/$EXPID1/"  \
    -e "s/_EXPID2/$EXPID2/"  \
    $HOME/wgne/grads/tplot_etsbis_2l_new.GS >plot2.gs

*grads -clbp "run plot2.gs"
grads -cp "run plot2.gs"

for hour in 002 020 050 100 150 250
do
gxgif -r -x 850 -y 1100 -i etsbis.p$hour\_12-36_$EXPID2.gr -o etsbis.p$hour\_12-36.$season.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/wgne etsbis.p$hour\_12-36.$season.gif
gxgif -r -x 850 -y 1100 -i etsbis.p$hour\_36-60_$EXPID2.gr -o etsbis.p$hour\_36-60.$season.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/wgne etsbis.p$hour\_36-60.$season.gif
gxgif -r -x 850 -y 1100 -i etsbis.p$hour\_60-84_$EXPID2.gr -o etsbis.p$hour\_60-84.$season.gif
ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/wgne etsbis.p$hour\_60-84.$season.gif
done

#cp $HOME/wgne/grads/qpf_pry.html .
#RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/html 
#ftprzdm rzdm put $RZDMDIR /ptmp/wx20yz/wgne qpf_pry.html

fi
