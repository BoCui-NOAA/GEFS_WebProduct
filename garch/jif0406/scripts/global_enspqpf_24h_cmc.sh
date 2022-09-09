#!/bin/sh
#######################################
# Child script: enspqpf_24h_cmc.sh
# ABSTRACT:  This script produces CMC's ensemble based
#            Probabilistic quantitative precipitation forecast (PQPF)
#######################################
set +x
echo " "
echo "Entering sub script enspqpf_24h_cmc.sh"
echo " "
set -x

if [[ $# != 2 ]]
then
   echo "Usage: $0 gribin gribout"
   exit 1
fi

export PQPF24H_CMC=/lfs/h2/emc/vpppg/save/yan.luo/jif0406/exec/global_enspqpf_24h_cmc

eval $PQPF24H_CMC <<EOF 
 &namin
 cpgb='$1',cpge='$2' /
EOF

set +x
echo "         ======= END OF ENSPPF PROCESS  ========== "
echo " "
echo "Leaving sub script enspqpf_24h_cmc.sh"
echo " "
set -x
