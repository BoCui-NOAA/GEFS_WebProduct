

export CDATE=$CDATE
YEAR=`echo $CDATE | cut -c1-4`
MON=`echo $CDATE | cut -c5-6`
DAY=`echo $CDATE | cut -c7-8`
CYC=`echo $CDATE | cut -c9-10`

hpsstar get /1year/hpssprod/runhistory/rh$YEAR/$YEAR$MON/$YEAR$MON$DAY/com_gens_prod_cmce.$YEAR$MON$DAY\_$CYC.pgrba_bc.tar
