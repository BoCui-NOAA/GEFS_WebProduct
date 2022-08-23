
if [[ $# != 3 ]];then
  echo "Usage: $0 gribin indexin gribout"
  echo "       inserts ensemble PDS extensions in GRIB file"
  exit 1
fi

ensppfx=/mp/nfsuser/g01/wx20yz/earch/sorc/ensppf
WINDEX=/nwprod/util/exec/grbindex

export ensaddx WINDEX
$WINDEX $1 $2

echo "&namin"       >input
echo "cpgb='$1',cpgi='$2',cpge='$3'"  >>input
echo "/"        >>input

cat input

$ensppfx  <input                          
