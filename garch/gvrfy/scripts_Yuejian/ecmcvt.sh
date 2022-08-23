

if [ $# -lt 2 ]; then
   echo "Usage: $0 need input file [ /global/ecm/ecmgrb.2000010112 ] "
   echo "     : $0 need output file [ ecmgrb.2000010112 ] "
   exit 8
fi

GBF=$1     
GBFINX=grb.index
PGBO=$2     

if [ -s $GBFINX ]; then
   rm $GBFINX
fi
if [ -s $PGBO   ]; then
   rm $PGBO
fi

/nwprod/util/exec/grbindex $GBF $GBFINX              

echo "&namin"       >input
echo "cpgb='$GBF',cpgi='$GBFINX',pgbo='$PGBO' "  >>input
echo "/"        >>input

#cat input

/nfsuser/g01/wx20yz/gvrfy/exec/ecmcvt <input

