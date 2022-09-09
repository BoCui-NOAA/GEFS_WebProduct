
set -x

### This is final scripts to run climate distribution dataset
###      06/09/2005 -Yuejian Zhu

mkdir /ptmp/wx20yz/CDAS_t19
mkdir /ptmp/wx20yz/reanl_t19
cd /ptmp/wx20yz/reanl_t19

IHR=00

for fld in u10m  
do

 for IHR in 00 
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

hpsstar get reanl/${fld}.tar 
 cp /ptmp/wx20yz/reanl_new/${fld}.9109 .
 cp /ptmp/wx20yz/reanl_new/${fld}.9404 .
 cp /ptmp/wx20yz/reanl_new/${fld}.7805 .
 cp /ptmp/wx20yz/reanl_new/${fld}.9702 .
 cp /ptmp/wx20yz/reanl_new/${fld}.9703 .


ICNT=0

echo "&namin " >input
echo "ifd=$ifd,itp=$itp,ilv=$ilv,"         >>input
echo "ihr=$IHR,ifhr=$ifhr,fc2=$fc2,fc3=$fc3,"     >>input

for iyr in 59 60 61 62 63 64 65 66 67 68 \
           69 70 71 72 73 74 75 76 77 78 \
           79 80 81 82 83 84 85 86 87 88 \
           89 90 91 92 93 94 95 96 97 98 
do

 cat ${fld}.${iyr}* >readin.dat19${iyr}
 ICNT=`expr $ICNT + 1`
 echo "cfilea($ICNT)='readin.dat19${iyr}'"  >>input

done

echo "/ " >>input

cat input

$HOME/reanl/exec/climate_t19running_mean <input >/ptmp/wx20yz/CDAS_19/${FLD}_t${IHR}z.output

cp pgrbmean  /ptmp/wx20yz/CDAS_t19/${FLD}_t${IHR}z.mean
cp pgrbstdv  /ptmp/wx20yz/CDAS_t19/${FLD}_t${IHR}z.stdv
#cp pgrbskew  /ptmp/wx20yz/CDAS_t19/$FLD.skew

#cp grads_tmp.dat /ptmp/wx20yz/CDAS_4/${FLD}_grads.dat

rm fort.* pgrb* grads_*
rm *.5* *.6* *.7* *.8* *.9*

 done

done
