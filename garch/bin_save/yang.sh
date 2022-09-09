
cd /global/help/yang_uv

for dd in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 \
          21 22 23 24 25 26 27 28 29
do
 for fhr in 00 12 24 36 48 60 72 84 96 108 120
 do
   ifile=/global/prs/pgbf$fhr.200307$dd\00
   ofile=/global/help/yang_uv/uv200_f$fhr\_200307$dd\00
   wgrib $ifile | grep "200:TR" | egrep "UGRD|VGRD" | wgrib -i $ifile -grib -o $ofile\_grib
   wgrib $ifile | grep "200:TR" | egrep "UGRD|VGRD" | wgrib -i $ifile -bin -o $ofile\_bin

 done
done
