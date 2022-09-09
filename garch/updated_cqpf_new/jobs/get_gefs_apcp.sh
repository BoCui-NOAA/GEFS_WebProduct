#set -x 
#scpdir=/u/$LOGNAME/save/updated_cqpf_new/jobs
scpdir=$SHOME/$LOGNAME/updated_cqpf_new/jobs

nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
Date=`date +%y%m%d`
export CDATE=20$Date\00
echo "CDATE=$CDATE"

export CDATE=`$nhours -48 $CDATE`
echo "CDATE=$CDATE"

cd $scpdir
run_convert_post
export CDATE=`$nhours +24 $CDATE`
echo "CDATE=$CDATE"
ARCH_GEFS_PRCP.sms.prod_20200915
ARCH_CMCE_PRCP.sms.prod
ARCH_FENS_PRCP.sms.prod

exit
