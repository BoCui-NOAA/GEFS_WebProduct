
set -x
YYYY=1996
YY=`echo $YYYY | cut -c3-4`

mkdir /ptmp/wx20yz/cray3

cd /ptmp/wx20yz/cray3

STYMD=$YY\0101
EDYMD=$YY\1231

while [ $STYMD -le $EDYMD ]; do

filename=tar$STYMD\00

ftp -vi 192.58.232.23 <<EOF
bin
cd /dmf_archive/cray3/dm/wd20yz/ENSB
get $filename
EOF

ftphsmuser put nmcens /ptmp/wx20yz/cray3 $filename

filename=tar$STYMD\12

ftp -vi 192.58.232.23 <<EOF
bin
cd /dmf_archive/cray3/dm/wd20yz/ENSB
get $filename
EOF

ftphsmuser put nmcens /ptmp/wx20yz/cray3 $filename

STYMD=`ndate +24 19$STYMD\00 | cut -c3-8`

done

