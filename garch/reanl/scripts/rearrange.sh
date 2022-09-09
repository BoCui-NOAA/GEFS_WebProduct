
cd /ptmp/wx20yz/reanl

for FLD in z1000 z700 z500 z250 u850 u500 u250 v850 v500 v250 t850 \
           t500 t250 rh700 prmsl t2m prcp tmax tmin
#          t500 t250 rh700 prmsl u10m v10m t2m prcp tmax tmin
do

  for yy in 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 \
            79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98
  do
  
   year=19$yy

   file=`echo $FLD.$yy\01 $FLD.$yy\02 $FLD.$yy\03 $FLD.$yy\04 $FLD.$yy\05 $FLD.$yy\06 $FLD.$yy\07 $FLD.$yy\08 $FLD.$yy\09 $FLD.$yy\10 $FLD.$yy\11 $FLD.$yy\12 `

   hpsstar get reanl/climate.$year $file        

  done

  ls -l $FLD.*01
  ls -l $FLD.*01 | wc -l
  ls -l $FLD.* | wc -l

  if [ "$FLD" = "t2m" -o "$FLD" = "prcp" -o "$FLD" = "tmax" -o "$FLD" = "tmin" ]; then
  for mm in 01 02 03 04 05 06 07 08 09 10 11 12
  do
  copygb -g2 -x $FLD.$yy$mm $FLD.$yy$mm\_a
  mv $FLD.$yy$mm\_a $FLD.$yy$mm
  done
  hpsstar put reanl/$FLD.tar $FLD.*
  else
  hpsstar put reanl/$FLD.tar $FLD.*
  fi

  rm $FLD.*

done
