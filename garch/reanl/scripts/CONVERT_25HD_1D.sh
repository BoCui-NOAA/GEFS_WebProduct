
set -x

### This is final scripts to run climate distribution dataset
###      06/09/2005 -Yuejian Zhu

cd /nbns/global/wx20yz/CDAS_cyc
#cd /ptmp/wx20yz/reanl       
COPYGB=/nwprod/util/exec/copygb

for fld in prmsl t2m  tmax tmin u10m v10m\
           z1000 z700 z500 z250 t850 t500 t250 \
           u850 v850 u500 v500 u250 v250       
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

 CHR=`echo $FLD | cut -c4-4`
 CHR1=`echo $FLD | cut -c1-3`

 if [ "$CHR" = "U" -o "$CHR" = "V" ]; then
   cat ${CHR1}UGRD_t${IHR}z.mean ${CHR1}VGRD_t${IHR}z.mean >tmpfile
   $COPYGB -g3 -x tmpfile tmpfile_1d
   wgrib tmpfile_1d | grep ${CHR}GRD | wgrib -i tmpfile_1d -grib -o ${FLD}_t${IHR}z.mean_1d
   cat ${CHR1}UGRD_t${IHR}z.stdv ${CHR1}VGRD_t${IHR}z.stdv >tmpfile
   $COPYGB -g3 -x tmpfile tmpfile_1d
   wgrib tmpfile_1d | grep ${CHR}GRD | wgrib -i tmpfile_1d -grib -o ${FLD}_t${IHR}z.stdv_1d
 else

 $COPYGB -g3 -x ${FLD}_t${IHR}z.mean ${FLD}_t${IHR}z.mean_1d
 $COPYGB -g3 -x ${FLD}_t${IHR}z.stdv ${FLD}_t${IHR}z.stdv_1d
 fi

 done

done
