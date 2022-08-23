SHELL=/bin/sh
#set -x

  module purge
  module load envvar/1.0
  module load PrgEnv-intel/8.1.0
  module load craype/2.7.8
  module load intel/19.1.3.304
  module load bacio/2.4.1
  module load w3nco/2.4.1
  module load sp/2.3.3
  module load ip/3.3.3

  export FCMP=ftn

export LIBS="${BACIO_LIB4} \
              ${W3NCO_LIBd} \
              ${IP_LIBd} \
              ${SP_LIBd}"

make -f makefile_outlier_20060601
make -f makefile_outlier_28m 
make -f makefile_ecm_10
make -f makefile_VRFY_14m_f20060530
##make -f makefile_VRFY_cmc16m_f20060530
make -f makefile_VRFY_14m_atmp
make -f makefile_vrfyex_ecm_20030101
make -f makefile_VRFY_20m_a20070530
make -f makefile_VRFY_14m_a20060530
make -f makefile_VRFY_20m_f20070530
##make -f makefile_VRFY_cmc16m_a20060530
make -f makefile_VRFY_20m_a20060530
