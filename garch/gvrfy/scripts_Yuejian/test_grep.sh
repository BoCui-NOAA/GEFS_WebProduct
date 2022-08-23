
mkdir /ptmp/wx20yz/comp
cd /ptmp/wx20yz/comp

mkdir prs
mkdir prc

mm=08

#tar -xvf /global/ENSZ500/z500.01$mm.tar

for dd in 01 02 03 04 05 06 07 08 09 10 \
          11 12 13 14 15 16 17 18 19 20 \
          21 22 23 24 25 26 27 28 29 30 31 
do

fname=/global/ENS/z500.2001$mm${dd}00
ofile=pgbf00.2001$mm${dd}00
wgrib $fname | grep "ens+0" | grep "anl" | wgrib -i $fname -grib -o prs/$ofile
wgrib $fname | grep "ens-0" | grep "anl" | wgrib -i $fname -grib -o prc/$ofile

for fh in 24 48 72 96 120 144 168 192 216 240 264 288 312 336 360 384
do

ofile=pgbf${fh}.2001${mm}${dd}00
wgrib $fname | grep "ens+0" | grep ":${fh}hr" | wgrib -i $fname -grib -o prs/$ofile
wgrib $fname | grep "ens-0" | grep ":${fh}hr" | wgrib -i $fname -grib -o prc/$ofile

done
done
