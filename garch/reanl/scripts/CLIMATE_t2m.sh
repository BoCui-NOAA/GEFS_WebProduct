
set -x

cd /ptmp/wx20yz/reanl
#rm /ptmp/wx20yz/reanl/*

fld=t2m   
#hpsstar get reanl/${fld}.tar 

ICNT=0

echo "&namin " >input
for iyr in 59 60 61 62 63 64 65 66 67 68 \
           69 70 71 72 73 74 75 76 77 78 \
           79 80 81 82 83 84 85 86 87 88 \
           89 90 91 92 93 94 95 96 97 98 
do

cat ${fld}.${iyr}* >readin.dat19${iyr}

if [ "$fld" = "u10m" -o "$fld" = "v10m" -o "$fld" = "t2m" ]; then
copygb -g2 -x readin.dat19${iyr} test
cp test readin.dat19${iyr}
fi

ICNT=`expr $ICNT + 1`
echo "ifd=11,ilv=2,cfilea($ICNT)='readin.dat19${iyr}'" >>input

done

echo "/ " >>input

cat input

$HOME/reanl/climate_t2m.exe <input

FLD=2MTMP

cp fort.61   /global/CDAS/$FLD.JAN
cp fort.62   /global/CDAS/$FLD.FEB
cp fort.63   /global/CDAS/$FLD.MAR
cp fort.64   /global/CDAS/$FLD.APR
cp fort.65   /global/CDAS/$FLD.MAY
cp fort.66   /global/CDAS/$FLD.JUN
cp fort.67   /global/CDAS/$FLD.JUL
cp fort.68   /global/CDAS/$FLD.AUG
cp fort.69   /global/CDAS/$FLD.SEP
cp fort.70   /global/CDAS/$FLD.OCT
cp fort.71   /global/CDAS/$FLD.NOV
cp fort.72   /global/CDAS/$FLD.DEC


