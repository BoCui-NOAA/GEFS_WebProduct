
WINDEX=/nwprod/util/exec/grbindex
nhoursx=/nwprod/util/exec/ndate
WGRIB=/nwprod/util/exec/wgrib
COPYGB=/nwprod/util/exec/copygb

cd /ptmp/wx20yz/reanl_test
for file in z1000 z700 z500 z250 u850 u500 u250 v850 v500 \
            v250  t850 t500 t250 rh700 prmsl u10m v10m t2m prcp tmax tmin 
do

set -x
 case $file in
      z1000)  CSEL=":HGT:1000 mb";echo $CSEL;;
      z700)   CSEL=":HGT:700 mb"; echo $CSEL;;
      z500)   CSEL=":HGT:500 mb"; echo $CSEL;;
      z250)   CSEL=":HGT:250 mb"; echo $CSEL;;
      u850)   CSEL=":UGRD:850 mb";echo $CSEL;;
      u500)   CSEL=":UGRD:500 mb";echo $CSEL;;
      u250)   CSEL=":UGRD:250 mb";echo $CSEL;;
      v850)   CSEL=":VGRD:850 mb";echo $CSEL;;
      v500)   CSEL=":VGRD:500 mb";echo $CSEL;;
      v250)   CSEL=":VGRD:250 mb";echo $CSEL;;
      t850)   CSEL=":TMP:850 mb"; echo $CSEL;;
      t500)   CSEL=":TMP:500 mb"; echo $CSEL;;
      t250)   CSEL=":TMP:250 mb"; echo $CSEL;;
      rh700)  CSEL=":RH:700 mb";  echo $CSEL;;
      prmsl)  CSEL=":PRMSL:MSL";  echo $CSEL;;
      u10m)   CSEL="UGRD:10 m"; echo $CSEL;;
      v10m)   CSEL="VGRD:10 m"; echo $CSEL;;
      t2m)    CSEL="TMP:2 m";  echo $CSEL;;
      prcp)   CSEL="PRATE"; echo $CSEL;;
      tmax)   CSEL="TMAX"; echo $CSEL;;
      tmin)   CSEL="TMIN"; echo $CSEL;;
 esac

  >/ptmp/wx20yz/reanl_new/$file.9703
  ifile_1=/ptmp/wx20yz/reanl_test/$file.9703
  ifile_2=$HOME/19970305.grb
              

  for dd in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 \
            21 22 23 24 25 26 27 28 29 30 31
  do

   for hh in 00 06 12 18
   do

   LL=`wgrib -v $ifile_1 | grep 9703$dd$hh | grep "$CSEL" | wc -l`

   if [ $LL -gt 0 ]; then
    wgrib -v $ifile_1 | grep 9703$dd$hh | grep "$CSEL" | sed -n "1,1p" | wgrib -i $ifile_1 -grib -append -o /ptmp/wx20yz/reanl_new/$file.9703
   else
    wgrib -v $ifile_2 | grep 9703$dd$hh | grep "$CSEL" | sed -n "1,1p" | wgrib -i $ifile_2 -grib -append -o /ptmp/wx20yz/reanl_new/$file.9703
   fi

  done

 done

done

