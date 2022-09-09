
### example 1
#!/bin/sh
#@ wall_clock_limit=10:15:00
#@ requirements = Feature == "beta"
#@ job_type = parallel
#@ output = /tmp/wx20yz/garch.o$(jobid)
#@ error = /tmp/wx20yz/garch.e$(jobid)
#@ total_tasks = 1
#@ node = 1
#@ node_usage = shared
#@ network.MPI=switch,not_shared,us
#@ class = dev
#
#@ queue
#

#set -x

tmpdir=/ptmp/wx20yz/convert
mkdir $tmpdir
cd    $tmpdir

nhoursx=/nwprod/util/exec/ndate

for MM in 08 10 12                 
do

for DD in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 \
          16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
do

 for HH in 00 06 12 18
 do

 CDATE=1959$MM$DD$HH
 MDH=`echo $CDATE | cut -c5-10`         
 MDHm6=`$nhoursx -06 $CDATE | cut -c5-10`

 fmean=/nbns/global/wx20yz/CDAS_cyc/cmean_1d.$CDATE
 fstdv=/nbns/global/wx20yz/CDAS_cyc/cstdv_1d.$CDATE
 >$fmean
 >$fstdv

 for FLD in 1000HGT 700HGT 500HGT 250HGT 850TMP 500TMP 250TMP \
            850UGRD 850VGRD 500UGRD 500VGRD 250UGRD 250VGRD \
            PRMSL 2MTMP TMAX TMIN 10MUGRD 10MVGRD
 do
  file1=/nbns/global/wx20yz/CDAS_cyc/${FLD}_t${HH}z.mean_1d
  file2=/nbns/global/wx20yz/CDAS_cyc/${FLD}_t${HH}z.stdv_1d
  if [ "$FLD" = "2MTMP" -o "$FLD" = "TMAX" -o "$FLD" = "TMIN" -o "$FLD" = "10MUGRD" -o "$FLD" = "10MVGRD" ]; then
   wgrib $file1 | grep $MDHm6 | wgrib -i $file1 -grib -append -o $fmean
   wgrib $file2 | grep $MDHm6 | wgrib -i $file2 -grib -append -o $fstdv
  else
   wgrib $file1 | grep $MDH | wgrib -i $file1 -grib -append -o $fmean
   wgrib $file2 | grep $MDH | wgrib -i $file2 -grib -append -o $fstdv
  fi
 done

 done

done

done

