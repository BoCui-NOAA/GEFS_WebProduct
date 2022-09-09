

WKD=/global/save/wx20yz/reanl/grads_afmap
cd $WKD

cp $SHOME/$LOGNAME/grads/rgbset.gs .

CDATE=2013012200
FHR=120 
YMD=`echo $CDATE | cut -c1-8`
FDATE=`ndate +$FHR $CDATE `
COMDIR=/com/gens/prod/gefs.$YMD/00
g2ctl=/usrx/local/grads/bin/2.0.a3/g2ctl
gribmap=/usrx/local/grads/bin/2.0.a3/xgribmap
grads=/usrx/local/grads/bin/2.0.a3/xgrads

cp $COMDIR/pgrb2a_an/ge*.t00z.pgrb2a_anf$FHR .
cp $COMDIR/pgrb2a_bc/geavg.t00z.pgrb2a_bcf$FHR .

$g2ctl -verf -ens "01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20" gep%e.t00z.pgrb2a_anf$FHR >test.ctl
$g2ctl -verf geavg.t00z.pgrb2a_bcf$FHR >testm.ctl

$gribmap -i test.ctl
$gribmap -i testm.ctl

sed -e "s/STEP/$STEP/"  \
    -e "s/HOUR/$FHR/"       \
    -e "s/YMDH/$CDATE/"      \
    -e "s/FDATE/$FDATE/"      \
    $SHOME/$LOGNAME/reanl/grads_afmap/TEST_TMIN2m.GS >test.gs       

$grads -cbl "test.gs"

scp amap_na$CDATE\_$FHR.gif wd20yz@emcrzdm.ncep.noaa.gov:/home/people/emc/www/htdocs/gmb/yzhu/test
