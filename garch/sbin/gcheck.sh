
if [ $# -lt 1 ]; then
   echo "Usage: $0 need YYYYMMDD"
   exit 8
fi

YMD=$1

echo "###############################################################"
echo "#####            global archive check for $1        #####"
echo "###############################################################"
echo ""

echo "###############################################################"
echo "#####            start at /global/prs   GDAS              #####"

icnt=0
for hour in 00 06 12 18
do
 for fname in pgbf00 pgbf06 flxf06
 do
    lfile=/global/prs/$fname.$YMD$hour
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
done
echo "#####            Total $icnt files for GDAS  ( Good at 20 )  #####"
echo "###############################################################"

echo ""
echo "###############################################################"
echo "#####            start at /global/prs   MRFS              #####"

icnt=0
for fhrs in 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 \
         204 216 228 240 252 264 276 288 300 312 324 336 348 360
do
 for fname in pgbf$fhrs flxf$fhrs 
 do
    lfile=/global/prs/$fname.$YMD\00
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
done
echo "#####            Total $icnt files for MRFS  ( Good at 90 )  #####"
echo "###############################################################"

echo ""
echo "###############################################################"
echo "#####            start at /global/prz   GDAZ              #####"

icnt=0
for hour in 00 06 12 18
do
 for fname in pgbf00 flxf06 
 do
    lfile=/global/prz/$fname.$YMD$hour
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
done
echo "#####            Total $icnt files for GDAZ  ( Good at 16 )  #####"
echo "###############################################################"

echo ""
echo "###############################################################"
echo "#####            start at /global/prz   MRFZ              #####"

icnt=0
for fhrs in 24 48 72 96 120 144 168 192 216 240 264 288 312 336 360
do
 for fname in pgbf$fhrs
 do
    lfile=/global/prz/$fname.$YMD\00
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
done
for fhrs in 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 \
         204 216 228 240 252 264 276 288 300 312 324 336 348 360
do
 for fname in flxf$fhrs 
 do
    lfile=/global/prz/$fname.$YMD\00
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
done
echo "#####            Total $icnt files for MRFS  ( Good at 75 )  #####"
echo "###############################################################"

echo ""
echo "###############################################################"
echo "#####            start at /global/pra   AVNS              #####"

icnt=0
YMD_NY2K=`echo $YMD | cut -c3-8`
for fhrs in 00 06 12 18 24 30 36
do
 for fname in PGBf$fhrs.$YMD\00 PGBf$fhrs.$YMD\12
 do
    lfile=/global/pra/$fname
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
done
for fhrs in 00 12 24 36 48 60 72 84 96 108 120
do
 for fname in pgbf$fhrs
 do
    lfile=/global/pra/$fname.$YMD\12
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
done
echo "#####            Total $icnt files for AVNS  ( Good at 25 )  #####"
echo "###############################################################"

echo ""
echo "###############################################################"
echo "#####            start at /global/ecm   ECMWF             #####"

icnt=0
    lfile=/global/ecm/ecmgrb.$YMD\12
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
echo "#####            Total $icnt files for ECMWF ( Good at 1  )   #####"
echo "###############################################################"

echo ""
echo "###############################################################"
echo "#####            start at /global/prk   UKMET             #####"

icnt=0
 for fname in ukmet.$YMD\00 ukmet.$YMD\12
 do
    lfile=/global/prk/$fname
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
echo "#####            Total $icnt files for UKMET ( Good at 2  )   #####"
echo "###############################################################"

echo ""
echo "###############################################################"
echo "#####            start at /global/fno   FNOC              #####"

icnt=0
 for fname in fnoc.$YMD\00 fnoc.$YMD\12
 do
    lfile=/global/fno/$fname
    if [ ! -s $lfile ]; then
       echo " Missing $lfile "
    else
       icnt=`expr $icnt + 1`
    fi
 done
echo "#####            Total $icnt files for FNOC  ( Good at 2  )   #####"
echo "###############################################################"

