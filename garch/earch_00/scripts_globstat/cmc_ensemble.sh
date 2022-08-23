if [ $# -ne 1 ] ; then 
echo "Usage: $0 need input CDATE "
exit 1 
fi
set -eu

set -x 
CDATE=$1
YMD=`echo $CDATE | cut -c1-8`
CYC=`echo $CDATE | cut -c9-10`
export DFROM=$SCOM/gens/prod
fdir=$DFROM/cmce.$YMD/${CYC}/ensstat
export YMDM2=`$nhours -48 $CDATE | cut -c1-8 `

for fld in z500 z1000 t850 t2m prmsl 
do
if [ -s $fdir/enspostc.t${CYC}z.${fld}hr ]; then
$COPYGB -g2 -x $fdir/enspostc.t${CYC}z.${fld}hr $GLOBAL/cmc_ens/$fld.${CDATE}
else
echo " data:$fdir/enspostc.t${CYC}z.${fld}hr is not there"
###rcp wx20yz@white:$fdir/enspostc.t${CYC}z.${fld}hr enspostc.t${CYC}z.${fld}hr
###$COPYGB -g2 -x enspostc.t${CYC}z.${fld}hr $GLOBAL/cmc_ens/$fld.${CDATE}
fi

done

fld=prcp
FLD=precip
if [ -s $fdir/enspostc.t${CYC}z.${fld}hr ]; then
$COPYGB -g2 -i3,1 -x $fdir/enspostc.t${CYC}z.${fld}hr $GLOBAL/cmc_ens/${FLD}.${CDATE}
else
echo " data:$fdir/enspostc.t${CYC}z.${fld}hr is not there"
###rcp wx20yz@white:$fdir/enspostc.t${CYC}z.${fld}hr enspostc.t${CYC}z.${fld}hr
###$COPYGB -g2 -i3,1 -x enspostc.t${CYC}z.${fld}hr $GLOBAL/cmc_ens/${FLD}.${CDATE}
fi

### adding the analysis difference between CMC and NCEP

fdir=$DFROM/cmce.$YMDM2/${CYC}/pgrba

$COPYGB -g2 -x $fdir/cmc_glbanl.t${CYC}z.pgrba_mdf00 $GLOBAL/cmc_ens/gblmd.${YMDM2}${CYC}

