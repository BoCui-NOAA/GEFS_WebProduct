
if [ $# -le 1 ]; then
   echo "Usage: $0 need [stymd] and [edymd]"
   exit 8
fi

WINDEX=/nwprod/util/exec/grbindex
nhoursx=/nwprod/util/exec/ndate
WGRIB=/nwprod/util/exec/wgrib
COPYGB=/nwprod/util/exec/copygb

set -x

cd /ptmp/wx20yz/reanl

stymd=$1
edymd=$2

yymm=`echo $stymd | cut -c1-4`

while [ $stymd -le $edymd ]; do

for file in z1000 z700 z500 z250 u850 u500 u250 v850 v500 \
            v250  t850 t500 t250 rh700 prmsl 
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
 esac

 pgbfile=pgb.f00${stymd}
( $WGRIB -verf -s ${pgbfile}00 | grep "$CSEL" |
 $WGRIB ${pgbfile}00 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}06 | grep "$CSEL" |
 $WGRIB ${pgbfile}06 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}12 | grep "$CSEL" |
 $WGRIB ${pgbfile}12 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}18 | grep "$CSEL" |
 $WGRIB ${pgbfile}18 -s -grib -i -append -o $file.$yymm )

done

for file in u10m v10m t2m prcp tmax tmin
do

set -x
 case $file in
      u10m)   CSEL="UGRD"; echo $CSEL;;
      v10m)   CSEL="VGRD"; echo $CSEL;;
      t2m)    CSEL="TMP";  echo $CSEL;;
      prcp)   CSEL="PRATE"; echo $CSEL;;
      tmax)   CSEL="TMAX"; echo $CSEL;;
      tmin)   CSEL="TMIN"; echo $CSEL;;
 esac

 pgbfile=grb2d${stymd}
if [ "$file" = "t2m" ]; then
( $WGRIB -verf -s ${pgbfile}00 | grep "$CSEL" | grep "2 m above gnd" |
 $WGRIB ${pgbfile}00 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}06 | grep "$CSEL" | grep "2 m above gnd" |
 $WGRIB ${pgbfile}06 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}12 | grep "$CSEL" | grep "2 m above gnd" |
 $WGRIB ${pgbfile}12 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}18 | grep "$CSEL" | grep "2 m above gnd" |
 $WGRIB ${pgbfile}18 -s -grib -i -append -o $file.$yymm )
else
( $WGRIB -verf -s ${pgbfile}00 | grep "$CSEL" |  
 $WGRIB ${pgbfile}00 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}06 | grep "$CSEL" |  
 $WGRIB ${pgbfile}06 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}12 | grep "$CSEL" |  
 $WGRIB ${pgbfile}12 -s -grib -i -append -o $file.$yymm )
( $WGRIB -verf -s ${pgbfile}18 | grep "$CSEL" |  
 $WGRIB ${pgbfile}18 -s -grib -i -append -o $file.$yymm )
fi

done

stymd=`$nhoursx +24 19${stymd}00 | cut -c3-8`

done
