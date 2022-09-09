set -x
tmpdir=$PTMP/$LOGNAME/cpqpf_cmc
mkdir $tmpdir                   
cd $tmpdir                 
rm $tmpdir/*
cp $SHOME/$LOGNAME/grads/rgbset.gs .
cp $SHOME/$LOGNAME/grads/cbar.gs   .

export CDATE=$CDATE    

scripts=$SHOME/$LOGNAME/jif0406/grads

$scripts/getdat.sh

YY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`
CMM=`grep "$MM" $SHOME/$LOGNAME/bin/mon2mon | cut -c8-10`

#if [ $DD -le 9 ]; then
#   DD=0$DD
#fi

HHDDMMYY=00Z$DD$CMM$YY

FILENAME=prcp_gfs_nmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"   \
    $scripts/qpf_20060301.CTL  >nmc_ctl
$SHOME/$LOGNAME/xbin/gribmap -i nmc_ctl

FILENAME=prcp_gfs_cmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"   \
    $scripts/qpf_20060301.CTL  >cmc_ctl
$SHOME/$LOGNAME/xbin/gribmap -i cmc_ctl

fname1=nmc_ctl
fname2=cmc_ctl
sed -e "s/YYMMDDHH/$CDATE/"  \
    -e "s/FILENAME1/$fname1/" \
    -e "s/FILENAME2/$fname2/" \
    $scripts/qpf_20060301.GS  >pgrads_qpf.gs

#xgrads -cp "run pgrads_qpf.gs"
grads -cbp "run pgrads_qpf.gs"

fname1=nmc_ctl
fname2=cmc_ctl
sed -e "s/YYMMDDHH/$CDATE/"  \
    -e "s/FILENAME1/$fname1/" \
    -e "s/FILENAME2/$fname2/" \
    $scripts/qpf_global.GS  >pgrads_qpf_global.gs

#xgrads -cp "run pgrads_qpf_global.gs"
grads -cbp "run pgrads_qpf_global.gs"

for AMOUNT in 1.00 6.35 12.7 25.4
do

FILENAME=pqpf_$AMOUNT\_nmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"     \
    $scripts/pqpf.CTL   >nmc_$AMOUNT\_ctl
$SHOME/$LOGNAME/xbin/gribmap -i nmc_$AMOUNT\_ctl

FILENAME=pqpf_$AMOUNT\_cmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"     \
    $scripts/pqpf.CTL   >cmc_$AMOUNT\_ctl
$SHOME/$LOGNAME/xbin/gribmap -i cmc_$AMOUNT\_ctl

fname1=nmc_$AMOUNT\_ctl
fname2=cmc_$AMOUNT\_ctl

case $AMOUNT in
1.00) amt1=1.0;amt2=0.04;;
6.35) amt1=6.35;amt2=0.25;;
12.7) amt1=12.7;amt2=0.50;;
25.4) amt1=25.4;amt2=1.00;;
esac

sed -e "s/YYMMDDHH/$CDATE/"  \
    -e "s/FILENAME1/$fname1/" \
    -e "s/FILENAME2/$fname2/" \
    -e "s/AMT1/$amt1/"        \
    -e "s/AMT2/$amt2/"        \
    $scripts/pqpf.GS  >pgrads_pqpf.gs

#xgrads -cp "run pgrads_pqpf.gs"
grads -cbp "run pgrads_pqpf.gs"

done

RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/cpqpf_cmc
ftpemcrzdmmkdir emcrzdm $RZDMDIR $YY$MM$DD
for AMOUNT in gfs 1.0 6.35 12.7 25.4
do
 for ID in a b c d
 do
# gxgif -r -x 600 -y 800 -i gmeta_$AMOUNT\_$CDATE$ID -o $ID$AMOUNT\_$CDATE.gif
 ftpemcrzdm emcrzdm put $RZDMDIR/$YY$MM$DD $tmpdir $ID$AMOUNT\_$CDATE.png
 done
done

sed -e "s/YYYYMMDD/$YY$MM$DD/"    \
    $scripts/CPQPF_H_com.HTML   >CPQPF_cmc.html

for hhour in 00 24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 \
             384 408 432
do
 SYMD=`$nhours -$hhour $CDATE | cut -c1-8`
 SYMDH=`$nhours -$hhour $CDATE`

 sed -e "s/YYYYMMDDHH/$SYMDH/"  \
     -e "s/YYYYMMDD/$SYMD/"     \
     $scripts/CPQPF_M.HTML   >>CPQPF_cmc.html
done

cat $scripts/CPQPF_E.HTML   >>CPQPF_cmc.html

RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/html
ftpemcrzdm emcrzdm put $RZDMDIR $tmpdir CPQPF_cmc.html
