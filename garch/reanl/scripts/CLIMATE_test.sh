
set -x

cd /ptmp/wx20yz/reanl

fld=z1000
fld=z700
fld=z250
fld=t850
fld=t500
fld=t250
fld=u850
fld=u500
fld=u250
fld=rh700
fld=u10m  
fld=t2m   
fld=z500
#hpsstar get reanl/${fld}.tar 

ICNT=0

echo "&namin " >input
for iyr in 59 60 61 62 63 64 65 66 67 68 \
           69 70 71 72 73 74 75 76 77 78 \
           79 80 81 82 83 84 85 86 87 88 \
           89 90 91 92 93 94 95 96 97 98 
do

cat ${fld}.${iyr}* >readin.dat19${iyr}

ICNT=`expr $ICNT + 1`
echo "cfilea($ICNT)='readin.dat19${iyr}'" >>input

done

echo "/ " >>input

cat input

$HOME/reanl/climate_test.exe <input

FLD=500HGT
FLD=1000HGT
FLD=700HGT
FLD=250HGT
FLD=850TMP
FLD=500TMP
FLD=250TMP
FLD=850UGRD
FLD=500UGRD
FLD=250UGRD
FLD=700RH
FLD=10MUGRD
FLD=2MTMP
FLD=500HGT

#cp fort.61   /global/CDAS/$FLD.JAN
#cp fort.62   /global/CDAS/$FLD.FEB
#cp fort.63   /global/CDAS/$FLD.MAR
#cp fort.64   /global/CDAS/$FLD.APR
#cp fort.65   /global/CDAS/$FLD.MAY
#cp fort.66   /global/CDAS/$FLD.JUN
#cp fort.67   /global/CDAS/$FLD.JUL
#cp fort.68   /global/CDAS/$FLD.AUG
#cp fort.69   /global/CDAS/$FLD.SEP
#cp fort.70   /global/CDAS/$FLD.OCT
#cp fort.71   /global/CDAS/$FLD.NOV
#cp fort.72   /global/CDAS/$FLD.DEC


