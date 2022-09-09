
cd /ptmp/wx20yz/reanl_new

for FLD in z1000 z700 z500 z250 u850 u500 u250 v850 v500 v250 t850 \
           t500 t250 rh700 prmsl u10m v10m t2m prcp tmax tmin
do

  cat $FLD.9404* >/ptmp/wx20yz/reanl_fnl/$FLD.9404

done
