#!/bin/sh
if [ $# -ne 2 ] ; then
  echo "$0 sanl pgb"
  echo "  converts sigmal files to pgb file"
  exit 8
fi

sanl=$1
pgb=$2
set -x

# grib process number
IGEN=180

PGBPARM=/ptmp/wx20yz/pgb.parm
cat >$PGBPARM <<EOF
 &NAMPGB IO=144,JO=73,KO=16,NCPUS=1,ICEN2=1,IGEN=$IGEN,
 KO=17,PO=1000.,925.,850.,700.,600.,500.,
                   400.,300.,250.,200.,150.,100.,
                        70., 50., 30., 20., 10., 
 /
EOF

# ulimit -s 38000

ln -sf $sanl   fort.11
ln -sf $pgb    fort.51
#/u/wx51we/home/r1/pgb/pgb.x <$PGBPARM
#/u/wx51we/home/r1/pgb/dbl_pgb.x.asp <$PGBPARM
/u/wx51we/home/r1/pgb/dbl_pgb.x <$PGBPARM
echo "err=$?"
[ $? -ne 0 ] && exit 8
echo "converted $sanl -> $pgb"
exit 0

