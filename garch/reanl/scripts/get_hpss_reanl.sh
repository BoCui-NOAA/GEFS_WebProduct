
set -x

### This is final scripts to run climate distribution dataset
###      06/09/2005 -Yuejian Zhu

mkdir /ptmp/wx20yz/reanl
cd /ptmp/wx20yz/reanl

IHR=00

for fld in prmsl t2m  tmax tmin u10m v10m \
           z1000 z700 z500 z250 t850 t500 t250 \
           u850 v850 u500 v500 u250 v250       
do

hpsstar get reanl/${fld}.tar 

tar -cvf X${fld}.tar ${fld}*

rm ${fld}*

done
