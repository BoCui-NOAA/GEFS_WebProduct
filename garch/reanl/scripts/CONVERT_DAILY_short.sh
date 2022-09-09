
tmpdir=/ptmp/wx20yz/convert
mkdir $tmpdir
cd    $tmpdir

nhoursx=/nwprod/util/exec/ndate
MM=02

for DD in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 \
          16 17 18 19 20 21 22 23 24 25 26 27 28 29
do

 YMD=1959$MM$DD

 fmean=/nbns/global/wx20yz/CDAS/cmean.$YMD
 fstdv=/nbns/global/wx20yz/CDAS/cstdv.$YMD
 Fmean=/nbns/global/wx20yz/CDAS_cyc/cmean.$YMD
 Fstdv=/nbns/global/wx20yz/CDAS_cyc/cstdv.$YMD
 
 cat $Fmean\00 $Fmean\06 $Fmean\12 $Fmean\18 >$fmean
 cat $Fstdv\00 $Fstdv\06 $Fstdv\12 $Fstdv\18 >$fstdv

done
