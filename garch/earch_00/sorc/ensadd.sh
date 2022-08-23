
if [[ $# != 5 ]];then
  echo "Usage: $0 ienst iensi gribin indexin gribout"
  echo "       inserts ensemble PDS extensions in GRIB file"
  exit 1
fi

ensaddx=//mp/nfsuser/g01/wx20yz/earch/sorc/ensadd
WINDEX=/nwprod/util/exec/grbindex

export ensaddx WINDEX
$WINDEX $3 $4

echo "&namin"       >input
echo "ienst=$1,iensi=$2,cpgb='$3',cpgi='$4',cpge='$5'"  >>input
echo "/   "        >>input

cat input

$ensaddx  <input                          
