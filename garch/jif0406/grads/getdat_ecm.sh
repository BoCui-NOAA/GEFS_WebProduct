
YMD=`echo $CDATE | cut -c1-8`
datdir1=$home/jif0406/data    
gbindex=/nwprod/util/exec/grbindex
prcpcvx=/nfsuser/g01/wx20yz/xbin/prcpcv.sh

file1=$datdir1/ensstat.t00z.pqpf_24h
wgrib $file1 | grep "APCP>1.000000" | wgrib -i $file1 -grib -o pqpf_1.00_nmc
wgrib $file1 | grep "APCP>6.350000" | wgrib -i $file1 -grib -o pqpf_6.35_nmc
wgrib $file1 | grep "APCP>12.70000" | wgrib -i $file1 -grib -o pqpf_12.7_nmc
wgrib $file1 | grep "APCP>25.39999" | wgrib -i $file1 -grib -o pqpf_25.4_nmc
file1=$datdir1/ensstatc.t00z.pqpf_24h
wgrib -ncep_ens $file1 | grep "APCP>1.000000" | wgrib -i $file1 -grib -o pqpf_1.00_cmc
wgrib -ncep_ens $file1 | grep "APCP>6.350000" | wgrib -i $file1 -grib -o pqpf_6.35_cmc
wgrib -ncep_ens $file1 | grep "APCP>12.70000" | wgrib -i $file1 -grib -o pqpf_12.7_cmc
wgrib -ncep_ens $file1 | grep "APCP>25.39999" | wgrib -i $file1 -grib -o pqpf_25.4_cmc
file2=$datdir1/ensstate.t12z.pqpf_24h 
wgrib -ncep_ens $file2 | grep "APCP>1.000000" | wgrib -i $file2 -grib -o pqpf_1.00_ecm
wgrib -ncep_ens $file2 | grep "APCP>6.350000" | wgrib -i $file2 -grib -o pqpf_6.35_ecm
wgrib -ncep_ens $file2 | grep "APCP>12.70000" | wgrib -i $file2 -grib -o pqpf_12.7_ecm
wgrib -ncep_ens $file2 | grep "APCP>25.39999" | wgrib -i $file2 -grib -o pqpf_25.4_ecm

file1=$datdir1/enspost.t00z.prcp
$gbindex $file1 precipi.nmc 
$prcpcvx $file1 precipi.nmc precip.nmc
wgrib precip.nmc | grep "ens+0" | wgrib -i precip.nmc -grib -o prcp_gfs_nmc

file1=$datdir1/enspostc.t00z.prcp
wgrib -ncep_ens $file1 | grep "ens+0" | wgrib -i $file1 -grib -o prcp_gfs_cmc

file1=$datdir1/ensposte.t12z.prcp
wgrib -ncep_ens $file1 | grep "ens-0" | wgrib -i $file1 -grib -o prcp_gfs_ecm


