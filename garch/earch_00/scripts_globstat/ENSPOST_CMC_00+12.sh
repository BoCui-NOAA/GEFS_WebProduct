
#@ requirements = Feature == "beta"
#@ job_type = parallel
#@ output = /tmp/wx20yz/garch.o$(jobid)
#@ error = /tmp/wx20yz/garch.e$(jobid)
#@ total_tasks = 30
#@ node = 30
#@ node_usage = shared
#@ network.MPI=switch,not_shared,us
#@ class = dev
#@ account_no = GEN-MTN
#
#@ queue
#

#set -x

echo " +++++++++++++++++++++++++++++++++++++++++++++++++"
echo " ++++++++ IBM MIST     !!!!!!!!! +++++++++++++++++"
echo " ++++++++ IBM MIST     !!!!!!!!! +++++++++++++++++"
echo " ++++++++ IBM MIST     !!!!!!!!! +++++++++++++++++"
echo " ++++++++ IBM MIST     !!!!!!!!! +++++++++++++++++"
echo " ++++++++ IBM MIST     !!!!!!!!! +++++++++++++++++"
echo " +++++++++++++++++++++++++++++++++++++++++++++++++"

export DFROM=$SCOM/gens/prod
export DFROM=/com/gens/prod
export CDATE=$CDATE
export CDATEbc=$CDATE
export YMDHP1=`$nhours +24 $CDATE `
export YMDHM12=`$nhours -12 $CDATE `

echo "YMDHM12=$YMDHM12"
### cmc operational and ensemble forecast data archive ###
$SHOME/$LOGNAME/earch/scripts/cmc_ensemble.sh $YMDHM12
export CDATE=$YMDHM12;$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12_W10M.sh
export CDATE=$YMDHM12;$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12_W250.sh

$SHOME/$LOGNAME/earch/scripts/cmc_ensemble.sh $CDATEbc
export CDATE=$CDATEbc;$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12_W10M.sh
export CDATE=$CDATEbc;$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12_W250.sh

