
set -x

mkdir /gpfstmp/wx20yz/precip
cd /gpfstmp/wx20yz/precip

for yymm in 0501 0502 0503 0504 0505 0506 0507 0508 0509 0510 0511 0512
do

 #ftphpssuser get ENSPRCP /gpfstmp/wx20yz/precip prcp.${yymm}.tar 
 hpsstar get ENSPRCP/prcp.${yymm}.tar 
 tar -cvf prcp.${yymm}.tar precip.20${yymm}*
 ftp_perica put precip /gpfstmp/wx20yz/precip prcp.${yymm}.tar

done
