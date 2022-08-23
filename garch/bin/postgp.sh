
if [ $# -lt 6 ]; then
   echo "$0: Usage: 1. SIGINP"
   echo "           2. FLXINP"
   echo "           3. FLXIOUT"
   echo "           4. PGBOUT"
   echo "           5. PGIOUT"
   echo "           6. IO=no. of longitudes"
   echo "           7. JO=no. of latitudes"
   exit 8
fi
EXESCRIPT=/nwprod/ush/global_postgp.sh

$EXESCRIPT $1 $2 $3 $4 $5 $6 $7

