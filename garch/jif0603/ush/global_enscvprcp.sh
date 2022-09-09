#set -x
######################### CALLED BY EXENSCQPF ##########################
echo "------------------------------------------------"
echo "Ensemble CQPF -> global_enscvprcp.sh            "
echo "------------------------------------------------"
echo "History: Feb 2004 - First implementation of this new script."
echo "AUTHOR: Yuejian Zhu (wx20yz)"

### gribin -- input grib file
### indexin -- input grib index file
### gribout -- output grib file
GBINDX=/apps/ops/prod/libs/intel/19.1.3.304/grib_util/1.2.2/bin/grbindex
$GBINDX $1 $2

echo "&namin"       >input
echo "cpgb='$1',cpgi='$2',cpge='$3',ini=0,ipr=24,isp=24,itu=12"  >>input
echo "/"        >>input

cat input

export pgm=global_enscvprcp
#. prep_step

#startmsg

/lfs/h2/emc/vpppg/save/yan.luo/jif0603/exec/global_enscvprcp  <input 
#export err=$?;err_chk

rm input
