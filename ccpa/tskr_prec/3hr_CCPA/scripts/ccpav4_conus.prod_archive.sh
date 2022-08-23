###### 02/24/2010 #######################################################
# This script statistically adjust STAGE IV precipitation analysis (6-hourly)
# to generate Climatologically Calibrated Precipitation Analysis (CCPA)
#########################################################################

#!/bin/sh

set +x
echo " "
echo " ENTERING SUB SCRIPT $0 "
echo " "
set -x

#################################
# set input parameters
# curdate and datnext : date of precip analysis, the precip accumulation 
#           periods covers 12Z today (curdate) and 12Z next day (datnext) 
# cyc    : initial cycle = 12Z
# interp: -i parameter for copygb (method of interpolation)
# grid: grid definition of input data, defined in ../ush/copygb_pcp.sh
# COMIN ---- (Partial) name of directory of INPUT, source of STAGE IV raw data
# COMOUT ---- (Partial) name of directory of OUTPUT files
####################################

cd $work_dir

curdate=$1
datnext=$2

#----------------------------------------------------------
# Print info
#
echo Welcome to the CCPA script
echo ------------------------------------
echo ----- Current Settings -----
echo
echo   Directories:
echo home_dir   = $home_dir
echo COMOUT   = $COMOUT
echo
echo 
echo   Executables:
echo 
echo grads  = $grads_exe
echo copygb_exe = $copygb_exe
echo wgrib  = $wgrib_exe
echo 
echo   Constants:
echo 
echo interp = $interp
echo grid   = $grid
echo 
echo  ---- Program Execution -----

#  SENDTAR=YES
#  if [ $SENDTAR == YES ]; then
#for hh in 06 12 18 24
#do 
# case $hh in 
#  06) tt=18;ymd=$curdate;; 
#  12) tt=00;ymd=$datnext;;
#  18) tt=06;ymd=$datnext;;
#  24) tt=12;ymd=$datnext
# esac
# OUTDIR=$COMOUT\.$ymd
# cd $OUTDIR
# cd ../
# tar -cvf ccpa_conus_$ymd\_$tt\Z.tar gefs.$ymd/$tt/ccpa
# mv ccpa_conus_$ymd\_$tt\Z.tar $home_dir\/COM_TAR/
#done
#  fi

# mkdir $DATA\/tar
# cd $DATA\/tar
#for grid in hrap ndgd 0.125d 0.5d 1.0d 
#do
# for hh in 06 12 18 24
# do 
#  case $hh in 
#   06) tt=18;ymd=$curdate;; 
#   12) tt=00;ymd=$datnext;;
#   18) tt=06;ymd=$datnext;;
#   24) tt=12;ymd=$datnext
#  esac
#  OUTDIR=$COMOUT\.$ymd
#  cp -pr $OUTDIR/$tt\/ccpa/ccpa_conus_$grid\_t$tt\z_06h $ymd\_ccpa_conus_$grid\_t$tt\z_06h
# done
# tar -cvf $curdate\_ccpa_conus_$grid\.tar *$grid* 
# mv $curdate\_ccpa_conus_$grid\.tar $home_dir\/COM_TAR2/
#done
#  cd $DATA

  cd $COMOUT\.$curdate\/../
  OUTDIR=ccpa.$curdate
  OUTDIS=ccpa.$datnext
 for grid in hrap ndgd ndgd2.5 0.125d 0.5d 1.0d 
 do

   case $grid in 
     hrap)   reso=hrap;;
     ndgd)   reso=ndgd5p0;;
     ndgd2.5)reso=ndgd2p5;;
     0.125d) reso=0p125;;
     0.5d)   reso=0p5;;
     1.0d)   reso=1p0
   esac

 mkdir -p $COMTAR\/$grid
  tar -cvf $DATA/ccpa_conus_$grid\_$curdate\.tar                 \
           $OUTDIR/18/ccpa.t*z.06h.$reso\.conus* $OUTDIR/18/ccpa.t*z.03h.$reso\.conus* $OUTDIR/18/ccpa.t*z.01h.$reso\.conus*  $OUTDIS/00/ccpa.t00z.06h.$reso\.conus* $OUTDIS/00/ccpa.t*z.03h.$reso\.conus* $OUTDIS/00/ccpa.t*z.01h.$reso\.conus* $OUTDIS/06/ccpa.t06z.06h.$reso\.conus*  $OUTDIS/06/ccpa.t*z.03h.$reso\.conus* $OUTDIS/06/ccpa.t*z.01h.$reso\.conus* $OUTDIS/12/ccpa.t12z.06h.$reso\.conus* $OUTDIS/12/ccpa.t*z.03h.$reso\.conus* $OUTDIS/12/ccpa.t*z.01h.$reso\.conus* 
  mv $DATA/ccpa_conus_$grid\_$curdate\.tar $COMTAR\/$grid 
 done
 for grid in hrap ndgd ndgd2.5 0.125d 0.5d 1.0d 
 do
  cd $COMTAR\/
  cd $grid
  tar -xvf ccpa_conus_$grid\_$curdate\.tar
  rm -rf ccpa_conus_$grid\_$curdate\.tar
  cd ../
 done
   cd $DATA

set +x
echo " "
echo "LEAVING SUB SCRIPT $0 "
echo " "
set -x
