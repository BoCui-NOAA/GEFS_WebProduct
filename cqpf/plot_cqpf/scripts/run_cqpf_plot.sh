set +x

nhours=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
Date=`date +%y%m%d`
export CDATE=20$Date\00
echo "CDATE=$CDATE"
export CDATEm24=`$nhours -24 $CDATE`
export CDATEm48=`$nhours -48 $CDATE`
export CDATEm72=`$nhours -72 $CDATE`
export CDATEm96=`$nhours -96 $CDATE`
export CDATEm120=`$nhours -120 $CDATE`
export CDATEm144=`$nhours -144 $CDATE`
export CDATEm240=`$nhours -240 $CDATE`

#---------------------------------------
eval primary=`cat  /lfs/h1/ops/prod/config/prodmachinefile | grep primary`
eval backup=`cat  /lfs/h1/ops/prod/config/prodmachinefile | grep backup`

echo $primary "and " $backup

isdogwood=primary:dogwood

if [  $primary != $isdogwood ]; then
   echo  " Check plotting jobs on dogwood!"
else
echo " cactus is the production machine! "
echo " Send web plots through cactus "

echo "++++++ Submite the cqpf plotting job ++++++"

cd /u/yan.luo/save/plot_cqpf/scripts
./run_ccpa.sh $CDATEm240 $CDATE
./plot_cqpf_6hr_gb2.sh $CDATEm96 5
./plot_cqpf_24hr_gb2.sh $CDATEm96 5

fi

exit
