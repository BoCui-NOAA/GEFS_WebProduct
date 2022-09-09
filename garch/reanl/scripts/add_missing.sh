
cd /ptmp/wx20yz/reanl

#for FLD in z1000 z700 z500 z250 u850 u500 u250 v850 v500 v250 t850 \
#           t500 t250 rh700 prmsl u10m v10m t2m prcp tmax tmin

for FLD in t500
do

  for dd in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 \
            21 22 23 24 25 26 27 28 29 30                                
  do
  
   for hh in 00 06 12 18
   do

    LL=`wgrib $FLD.9109a | grep 9109$dd$hh | wc -l`
    #wgrib $FLD.9109 | grep 9109$dd$hh | grep "500 mb" | sed -n "1,1p" | wgrib -i $FLD.9109 -grib -o /ptmp/wx20yz/reanl_new/$FLD.9109$dd$hh

    if [ $LL -gt 0 ]; then
    wgrib $FLD.9109a | grep 9109$dd$hh | grep "500 mb" | sed -n "1,1p" | wgrib -i $FLD.9109a -grib -o /ptmp/wx20yz/reanl_new/$FLD.9109$dd$hh
    fi
   
   done

  done

  #hpsstar put reanl/$FLD.tar $FLD.*

done
