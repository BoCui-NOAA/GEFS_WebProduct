
for ymdh in 2004070100 2004070200 2004070300
do

ind=/global/ENS
otd=/ptmp/wx20yz/help

>tmpfile
for fname in z1000 z500 u850 v850 u250 v250 prmsl precip
do

cat $ind/$fname.$ymdh >>tmpfile

done

for sign in ens+0 ens-0 ens+1 ens-1 ens+2 ens-2 ens+3 ens-3 ens+4 ens-4 ens+5 ens-5
do

wgrib tmpfile | grep "$sign" | wgrib -i tmpfile -grib -o $otd/ensemble.$sign.$ymdh

done

done




