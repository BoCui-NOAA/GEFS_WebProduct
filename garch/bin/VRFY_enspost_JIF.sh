
newdir=/ptmp/wx20rw/d/com/mrf/prod/ens.20040311
olddir=/com/mrf/prod/ens.20040311

for cyc in 00 06 12 18
do
 for fld in z1000 z925 z850 z700 z500 z250 z200 \
            t1000 t925 t850 t700 t500 t250 t200 \
            u1000 u925 u850 u700 u500 u250 u200 \
            v1000 v925 v850 v700 v500 v250 v200 \
            rh1000 rh925 rh850 rh700 rh500      \
            t2m   u10m v10m rh2m prmsl prcp     \
            tcdc  pwat psfc zsfc cape tmax tmin \
            rain  frzr snow icep
 do
 
 file=enspost.t${cyc}z.$fld
 fsize=`ls -l $newdir/$file | awk '{print $5}'`
 frecords=`wgrib $newdir/$file | wc -l `
 echo "IMP $file has size of $fsize and records of $frecords "
 if [ -s $olddir/$file ]; then
 fsize=`ls -l $olddir/$file | awk '{print $5}'`
 frecords=`wgrib $olddir/$file | wc -l `
 echo "OPR $file has size of $fsize and records of $frecords "
 else
 echo "OPR $file is not available                            "
 fi
 
 echo " "
 file=enspost.t${cyc}z.${fld}hr
 fsize=`ls -l $newdir/$file | awk '{print $5}'`
 frecords=`wgrib $newdir/$file | wc -l `
 echo "IMP $file has size of $fsize and records of $frecords "
 if [ -s $olddir/$file ]; then
 fsize=`ls -l $olddir/$file | awk '{print $5}'`
 frecords=`wgrib $olddir/$file | wc -l `
 echo "OPR $file has size of $fsize and records of $frecords "
 else
 echo "OPR $file is not availabe                             "
 fi
 echo " "
 
 done
done
           
