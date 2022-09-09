
tmpdir=/ptmp/wx20yz/cpqpf_ecm
mkdir /ptmp/wx20yz/cpqpf_ecm
cd /ptmp/wx20yz/cpqpf_ecm

export CDATE=$CDATE    

scripts=/nfsuser/g01/wx20yz/jif0406/grads
nhoursx=/nwprod/util/exec/ndate

$scripts/getdat_ecm.sh

YY=`echo $CDATE | cut -c1-4`
MM=`echo $CDATE | cut -c5-6`
DD=`echo $CDATE | cut -c7-8`
HH=`echo $CDATE | cut -c9-10`
CMM=`grep "$MM" /nfsuser/g01/wx20yz/bin/mon2mon | cut -c8-10`

#if [ $DD -le 9 ]; then
#   DD=0$DD
#fi

HHDDMMYY=00Z$DD$CMM$YY

FILENAME=prcp_gfs_nmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"   \
    $scripts/qpf.CTL         >nmc_ctl
gribmap -i nmc_ctl

FILENAME=prcp_gfs_cmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"   \
    $scripts/qpf.CTL         >cmc_ctl
gribmap -i cmc_ctl

FILENAME=prcp_gfs_ecm
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"   \
    $scripts/qpf.CTL         >ecm_ctl
gribmap -i ecm_ctl

fname1=nmc_ctl
fname2=nmc_ctl
fname3=ecm_ctl
sed -e "s/YYMMDDHH/$CDATE/"  \
    -e "s/FILENAME1/$fname1/" \
    -e "s/FILENAME2/$fname2/" \
    -e "s/FILENAME3/$fname3/" \
    $scripts/qpf.GS  >pgrads_qpf.gs

xgrads -cp "run pgrads_qpf.gs"
#xgrads -cbp "run pgrads_qpf.gs"

for AMOUNT in 1.00 6.35 12.7 25.4
do

FILENAME=pqpf_$AMOUNT\_nmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"     \
    $scripts/pqpf.CTL   >nmc_$AMOUNT\_ctl
gribmap -i nmc_$AMOUNT\_ctl

FILENAME=pqpf_$AMOUNT\_cmc
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"     \
    $scripts/pqpf.CTL   >cmc_$AMOUNT\_ctl
gribmap -i cmc_$AMOUNT\_ctl

FILENAME=pqpf_$AMOUNT\_ecm
sed -e "s/FILENAME/$FILENAME/"   \
    -e "s/HHDDMMYY/$HHDDMMYY/"     \
    $scripts/pqpf.CTL   >ecm_$AMOUNT\_ctl
gribmap -i ecm_$AMOUNT\_ctl

fname1=nmc_$AMOUNT\_ctl
fname2=cmc_$AMOUNT\_ctl
fname3=ecm_$AMOUNT\_ctl

case $AMOUNT in
1.00) amt1=1.0;amt2=0.04;;
6.35) amt1=6.35;amt2=0.25;;
12.7) amt1=12.7;amt2=0.50;;
25.4) amt1=25.4;amt2=1.00;;
esac

sed -e "s/YYMMDDHH/$CDATE/"  \
    -e "s/FILENAME1/$fname1/" \
    -e "s/FILENAME2/$fname2/" \
    -e "s/FILENAME3/$fname3/" \
    -e "s/PNAME1/$pname1/"   \
    -e "s/AMT1/$amt1/"        \
    -e "s/AMT2/$amt2/"        \
    $scripts/pqpf_example.GS  >pgrads_pqpf.gs

xgrads -cp "run pgrads_pqpf.gs"
#xgrads -cbp "run pgrads_pqpf.gs"

done

#RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/cpqpf
#ftprzdmmkdir rzdm $RZDMDIR $YY$MM$DD
#for AMOUNT in gfs 1.0 6.35 12.7 25.4
#do
# for ID in a b c d
# do
# gxgif -r -x 600 -y 800 -i gmeta_$AMOUNT\_$CDATE$ID -o $ID$AMOUNT\_$CDATE.gif
# ftprzdm rzdm put $RZDMDIR/$YY$MM$DD $tmpdir $ID$AMOUNT\_$CDATE.gif
# done
#done
#
#sed -e "s/YYYYMMDD/$YY$MM$DD/"    \
#    $scripts/CPQPF_H.HTML   >CPQPF.html
#
#for hhour in 00 24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 \
#             384 408 432
#do
# SYMD=`$nhoursx -$hhour $CDATE | cut -c1-8`
# SYMDH=`$nhoursx -$hhour $CDATE`
#
# sed -e "s/YYYYMMDDHH/$SYMDH/"  \
#     -e "s/YYYYMMDD/$SYMD/"     \
#     $scripts/CPQPF_M.HTML   >>CPQPF.html
#done
#
#cat $scripts/CPQPF_E.HTML   >>CPQPF.html
#
#RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/html
#ftprzdm rzdm put $RZDMDIR $tmpdir CPQPF.html

