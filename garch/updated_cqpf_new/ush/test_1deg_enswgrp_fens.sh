######################### CALLED BY EXENSCQPF ##########################
echo "------------------------------------------------"
echo "Ensemble 1deg CQPF -> global_1deg_enswgrp.sh              "
echo "------------------------------------------------"
echo "History: Feb 2004 - First implementation of this new script."
echo "AUTHOR: Yuejian Zhu (wx20yz)"

echo "         ######################################### "
echo "         ####  RUN PRECIPTATION VERIFICATION  #### "
echo "         ####  RUN PRECIPTATION VERIFICATION  #### "
echo "         ####  RUN PRECIPTATION VERIFICATION  #### "
echo "         ######################################### "

set -x
#export hourlist="00  06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 \
#                102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
#                204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
#                306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export hourlist=" 06  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96"

export memberlist="000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020"


#ls /com/gens/prod/gefs.${YMD}/${cyc}/pgrba | wc >aa
#mail -s gefs.data Yan.Luo@noaa.gov<aa

#####################
## fetch today's forecast   
#####################

for nfhrs in $hourlist; do
  for nens in $memberlist; do
    file=ENSEMBLE.MET.fcst_et${nens}.0${nfhrs}.$YMD${cyc}
    infile=$COMIN/$YMD/wgrbbul/fnmocens_gb2/$file
    outfile1=$DATA/fnmoc_prcp.t${cyc}z.pgrba2f${nfhrs}
    outfile2=$DATA/fnmoc_prcp.t${cyc}z.pgrbaf${nfhrs}

  if [ -f $infile ]; then
    >>$outfile1
      $WGRIB2 -match ":APCP:" $infile -append -grib $outfile1
  else
    echo " ***** Missing today's precipitation forecast *****"
    echo " ***** Program must be stoped here !!!!!!!!!! *****"
    export err=8;$DATA/err_chk
   fi
  done
     $CNVGRIB -g21 $outfile1 $outfile2
#     $GBINDX $outfile2 $outfile2.index
done

export hourlist="102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
                204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export memberlist="000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020"

for nfhrs in $hourlist; do
  for nens in $memberlist; do
    file=ENSEMBLE.MET.fcst_et${nens}.${nfhrs}.$YMD${cyc}
    infile=$COMIN/$YMD/wgrbbul/fnmocens_gb2/$file
    outfile1=$DATA/fnmoc_prcp.t${cyc}z.pgrba2f${nfhrs}
    outfile2=$DATA/fnmoc_prcp.t${cyc}z.pgrbaf${nfhrs}

  if [ -f $infile ]; then
    >>$outfile1
      $WGRIB2 -match ":APCP:" $infile -append -grib $outfile1
  else
    echo " ***** Missing today's precipitation forecast *****"
    echo " ***** Program must be stoped here !!!!!!!!!! *****"
    export err=8;$DATA/err_chk
   fi
  done
     $CNVGRIB -g21 $outfile1 $outfile2
#     $GBINDX $outfile2 $outfile2.index
done

