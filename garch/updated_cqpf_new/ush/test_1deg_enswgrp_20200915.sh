#!/bin/sh
######################### CALLED BY EXENSCQPF ##########################
echo "------------------------------------------------"
echo "Ensemble CQPF -> gefs_enswgrp.sh              "
echo "------------------------------------------------"
echo "History: Dec 2011 - First implementation of this new script."
echo "History: Dec 2013 - Change I/O from GRIB1 to GRIB2"
echo "AUTHOR: Yan Luo (wx22lu)"

echo "         ######################################### "
echo "         ####  RUN PRECIPTATION VERIFICATION  #### "
echo "         ####  RUN PRECIPTATION VERIFICATION  #### "
echo "         ####  RUN PRECIPTATION VERIFICATION  #### "
echo "         ######################################### "

#set -x
export hourlist="006 012 018 024 030 036 042 048 054 060 066 072 078 084 090 096 \
                 102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192 198 \
                 204 210 216 222 228 234 240 246 252 258 264 270 276 282 288 294 300 \
                 306 312 318 324 330 336 342 348 354 360 366 372 378 384"

export memberlist="gfs c00 p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 p11 p12 p13 p14 p15 p16 p17 p18 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 avg spr"

if [ $cyc -eq 18 ]; then
export YMD=$YMDM1
fi

#####################
## fetch today's forecast   
#####################

for nfhrs in $hourlist; do
  for nens in $memberlist; do
    file=ge${nens}.t${cyc}z.pgrb2a.0p50.f${nfhrs}
    infile=$COMIN/gefs.$YMD/${cyc}/atmos/pgrb2ap5/$file
    outfile1=$DATA/geprcp.t${cyc}z.pgrb2a.0p50.f${nfhrs}
    outfile2=$DATA/geprcp.t${cyc}z.pgrba.0p50.f${nfhrs}
    outfile3=$DATA/prcp.t${cyc}z.pgrbaf${nfhrs}

    shrs=`expr $nfhrs - 6`
    ehrs=`expr $nfhrs - 0`

   if [ -f $infile ]; then
#    rm $outfile
    >>$outfile1
#    $WGRIB2 -match ":APCP:" $infile -append -grib $outfile
    $WGRIB2 -match ":APCP:" -match ${shrs}-${ehrs} -for_n 1:1  $infile  -append -grib $outfile1
   else
    echo " ***** Missing today's precipitation forecast *****"
    echo " ***** Program must be stoped here !!!!!!!!!! *****"
    export err=8;$DATA/err_chk
    fi     
  done    # for nens in $memberlist

     $CNVGRIB -g21 $outfile1 $outfile2
     $COPYGB -g3 -i3 -x $outfile2 $outfile3

done      # for  nfhrs in $hourlist
