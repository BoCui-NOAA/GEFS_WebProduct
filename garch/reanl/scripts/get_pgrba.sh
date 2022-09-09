

cd /ptmp/wx20yz/CDAS

for MM in 01 02 03 04 05 06 07 08 09 10 11 12
do

 >pgba_mean.1959${MM}15
 >pgba_stdv.1959${MM}15

 for fld in z1000 z700 z500 z250 t850 t500 t250 \
            u850  v850 u500 v500 u250 v250      \
            prmsl t2m  tmax tmin u10m v10m

 do

  for IHR in 00 06 12 18
  do

   case $fld in
    z1000) FLD=1000HGT;ifd=7;itp=100;ilv=1000;ifhr=0;fc2=1.0;fc3=100.0;;
    z700)  FLD=700HGT;ifd=7;itp=100;ilv=700;ifhr=0;fc2=10.0;fc3=1000.0;;
    z500)  FLD=500HGT;ifd=7;itp=100;ilv=500;ifhr=0;fc2=100.0;fc3=1000.0;;
    z250)  FLD=250HGT;ifd=7;itp=100;ilv=250;ifhr=0;fc2=100.0;fc3=1000.0;;
    t850)  FLD=850TMP;ifd=11;itp=100;ilv=850;ifhr=0;fc2=10.0;fc3=100.0;;
    t500)  FLD=500TMP;ifd=11;itp=100;ilv=500;ifhr=0;fc2=10.0;fc3=100.0;;
    t250)  FLD=250TMP;ifd=11;itp=100;ilv=250;ifhr=0;fc2=10.0;fc3=100.0;;
    u850)  FLD=850UGRD;ifd=33;itp=100;ilv=850;ifhr=0;fc2=1.0;fc3=10.0;;
    v850)  FLD=850VGRD;ifd=34;itp=100;ilv=850;ifhr=0;fc2=1.0;fc3=10.0;;
    u500)  FLD=500UGRD;ifd=33;itp=100;ilv=500;ifhr=0;fc2=1.0;fc3=10.0;;
    v500)  FLD=500VGRD;ifd=34;itp=100;ilv=500;ifhr=0;fc2=1.0;fc3=10.0;;
    u250)  FLD=250UGRD;ifd=33;itp=100;ilv=250;ifhr=0;fc2=1.0;fc3=10.0;;
    v250)  FLD=250VGRD;ifd=34;itp=100;ilv=250;ifhr=0;fc2=1.0;fc3=10.0;;
    prmsl) FLD=PRMSL;ifd=2;itp=102;ilv=0;ifhr=0;fc2=100.0;fc3=10000.0;;
    t2m)   FLD=2MTMP;ifd=11;itp=105;ilv=2;ifhr=6;fc2=10.0;fc3=100.0;;
    tmax)  FLD=TMAX;ifd=15;itp=105;ilv=2;ifhr=6;fc2=10.0;fc3=100.0;;
    tmin)  FLD=TMIN;ifd=16;itp=105;ilv=2;ifhr=6;fc2=10.0;fc3=100.0;;
    u10m)  FLD=10MUGRD;ifd=33;itp=105;ilv=10;ifhr=6;fc2=1.0;fc3=10.0;;
    v10m)  FLD=10MVGRD;ifd=34;itp=105;ilv=10;ifhr=6;fc2=1.0;fc3=10.0;;
   esac

   HH=$IHR
   DD=15
   if [ "$fld" = "t2m" -o "$fld" = "tmax" -o "$fld" = "tmin" -o "$fld" = "u10m" -o "$fld" = "v10m" ]; then
    HH=`expr $IHR - 6`
    if [ $HH -lt 0 ]; then
     HH=18
     DD=14
    fi
   fi

   file=${FLD}_t${IHR}z.mean
   wgrib $file | grep "59${MM}${DD}${HH}" | wgrib -i $file -grib -append -o pgba_mean.1959${MM}15
   file=${FLD}_t${IHR}z.stdv
   wgrib $file | grep "59${MM}${DD}${HH}" | wgrib -i $file -grib -append -o pgba_stdv.1959${MM}15

  done
 done
done
