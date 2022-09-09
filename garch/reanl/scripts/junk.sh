
WINDEX=/nwprod/util/exec/grbindex
nhoursx=/nwprod/util/exec/ndate
WGRIB=/nwprod/util/exec/wgrib
COPYGB=/nwprod/util/exec/copygb

mkdir /ptmp/wx20yz/china
cd /ptmp/wx20yz/china


ymdh=2005110100
for fh in 12 24 36 48 72
do

  ifile=/com/mrf/prod/ens.20051101/ensn1.t00z.pgrbf$fh    
  ofile=ensn1_pgrbf$fh\_$ymdh             
  >/ptmp/wx20yz/china/$ofile

for file in z850 z500 z200 u850 u500 u200 v850 v500 v200 t850 t500 t200 
do

 case $file in
      z850)   CSEL=":HGT:850 mb";echo $CSEL;;
      z500)   CSEL=":HGT:500 mb"; echo $CSEL;;
      z200)   CSEL=":HGT:200 mb"; echo $CSEL;;
      u850)   CSEL=":UGRD:850 mb";echo $CSEL;;
      u500)   CSEL=":UGRD:500 mb";echo $CSEL;;
      u200)   CSEL=":UGRD:200 mb";echo $CSEL;;
      v850)   CSEL=":VGRD:850 mb";echo $CSEL;;
      v500)   CSEL=":VGRD:500 mb";echo $CSEL;;
      v200)   CSEL=":VGRD:200 mb";echo $CSEL;;
      t850)   CSEL=":TMP:850 mb"; echo $CSEL;;
      t500)   CSEL=":TMP:500 mb"; echo $CSEL;;
      t200)   CSEL=":TMP:200 mb"; echo $CSEL;;
 esac

  wgrib -v $ifile | grep "$CSEL" | wgrib -i $ifile -grib -append -o /ptmp/wx20yz/china/$ofile

done

done


