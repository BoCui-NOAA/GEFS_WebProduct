
set -x

### This is final scripts to run climate distribution dataset
###      06/09/2005 -Yuejian Zhu

mkdir /ptmp/wx20yz/CDAS
cd /ptmp/wx20yz/reanl

#for fld in t2m z1000 z700 z500 z250 t850 t500 t250 \
#           u850 v850 u250 v250 rh700 prmsl 
for fld in u10m v10m
do
 
 case $fld in
  z1000) FLD=1000HGT;ifd=7;itp=100;ilv=1000;isthr=0;fc2=1.0;fc3=100.0;;
  z700)  FLD=700HGT;ifd=7;itp=100;ilv=700;isthr=0;fc2=10.0;fc3=1000.0;;
  z500)  FLD=500HGT;ifd=7;itp=100;ilv=500;isthr=0;fc2=100.0;fc3=1000.0;;
  z250)  FLD=250HGT;ifd=7;itp=100;ilv=250;isthr=0;fc2=100.0;fc3=1000.0;;
  t850)  FLD=850TMP;ifd=11;itp=100;ilv=850;isthr=0;fc2=10.0;fc3=100.0;;
  t500)  FLD=500TMP;ifd=11;itp=100;ilv=500;isthr=0;fc2=10.0;fc3=100.0;;
  t250)  FLD=250TMP;ifd=11;itp=100;ilv=250;isthr=0;fc2=10.0;fc3=100.0;;
  u850)  FLD=850UGRD;ifd=33;itp=100;ilv=850;isthr=0;fc2=1.0;fc3=10.0;;
  v850)  FLD=850VGRD;ifd=34;itp=100;ilv=850;isthr=0;fc2=1.0;fc3=10.0;;
  u250)  FLD=250UGRD;ifd=33;itp=100;ilv=250;isthr=0;fc2=1.0;fc3=10.0;;
  v250)  FLD=250VGRD;ifd=34;itp=100;ilv=250;isthr=0;fc2=1.0;fc3=10.0;;
  rh700) FLD=700RH;ifd=52;itp=100;ilv=700;isthr=0;fc2=1.0;fc3=10.0;;
  prmsl) FLD=PRMSL;ifd=2;itp=102;ilv=0;isthr=0;fc2=100.0;fc3=10000.0;;
  t2m)   FLD=2MTMP;ifd=11;itp=105;ilv=2;isthr=18;fc2=10.0;fc3=100.0;;
  u10m)  FLD=10MUGRD;ifd=33;itp=105;ilv=10;isthr=18;fc2=1.0;fc3=10.0;;
  v10m)  FLD=10MVGRD;ifd=34;itp=105;ilv=10;isthr=18;fc2=1.0;fc3=10.0;;
 esac

#hpsstar get reanl/${fld}.tar 
hpsstar get reanl/uv10m.tar 

ICNT=0

echo "&namin " >input
echo "ifd=$ifd,itp=$itp,ilv=$ilv,"         >>input
echo "fc2=$fc2,fc3=$fc3,isthr=$isthr,"     >>input

for iyr in 59 60 61 62 63 64 65 66 67 68 \
           69 70 71 72 73 74 75 76 77 78 \
           79 80 81 82 83 84 85 86 87 88 \
           89 90 91 92 93 94 95 96 97 98 
do

#cat ${fld}.${iyr}* >readin.dat19${iyr}
#cat u10m.${iyr}* v10m.${iyr}* >readin.dat19${iyr}

ICNT=`expr $ICNT + 1`

#if [ "$fld" = "u10m" -o "$fld" = "v10m" -o "$fld" = "t2m" -o "$fld" = "prmsl" ]; then
if [ "$fld" = "t2m" -o "$fld" = "prmsl" ]; then
 copygb -g2 -x readin.dat19${iyr} test
 cp test readin.dat19${iyr}
fi

 echo "cfilea($ICNT)='readin.dat19${iyr}'"  >>input

done

echo "/ " >>input

cat input

$HOME/reanl/climate_fnl.exe <input >/ptmp/wx20yz/CDAS/${FLD}.output

cp fort.61   /ptmp/wx20yz/CDAS/$FLD.JAN
cp fort.62   /ptmp/wx20yz/CDAS/$FLD.FEB
cp fort.63   /ptmp/wx20yz/CDAS/$FLD.MAR
cp fort.64   /ptmp/wx20yz/CDAS/$FLD.APR
cp fort.65   /ptmp/wx20yz/CDAS/$FLD.MAY
cp fort.66   /ptmp/wx20yz/CDAS/$FLD.JUN
cp fort.67   /ptmp/wx20yz/CDAS/$FLD.JUL
cp fort.68   /ptmp/wx20yz/CDAS/$FLD.AUG
cp fort.69   /ptmp/wx20yz/CDAS/$FLD.SEP
cp fort.70   /ptmp/wx20yz/CDAS/$FLD.OCT
cp fort.71   /ptmp/wx20yz/CDAS/$FLD.NOV
cp fort.72   /ptmp/wx20yz/CDAS/$FLD.DEC

cp pgrbmean  /ptmp/wx20yz/CDAS/$FLD.mean
cp pgrbstdv  /ptmp/wx20yz/CDAS/$FLD.stdv
cp pgrbskew  /ptmp/wx20yz/CDAS/$FLD.skew

cp grads_tmp.dat /ptmp/wx20yz/CDAS/${FLD}_grads.dat

rm fort.* pgrb* grads_*
rm *.5* *.6* *.7* *.8* *.9*

done
