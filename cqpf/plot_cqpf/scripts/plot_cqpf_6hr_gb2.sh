#set -x
nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
export CDATE=$1
ndays=$2

iday=1
while [ $iday -le $ndays ]; do

export CDATE=$CDATE;/u/yan.luo/save/plot_cqpf/grads/PLOT_CPQPF_0.5d_gb2.sh $CDATE
export CDATE=$CDATE;/u/yan.luo/save/plot_cqpf/grads/PLOT_CQPF_0.5d_gb2.sh $CDATE 

  iday=`expr $iday + 1`
  CDATE=`$nhours +24 $CDATE` 
done
