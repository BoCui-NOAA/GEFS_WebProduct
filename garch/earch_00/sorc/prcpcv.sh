
if [[ $# != 3 ]];then
  echo "Usage: $0 gribin indexin gribout"
  echo "       convert precipitation to every 12 hrs accumulation"
  exit 1
fi

prcpcvx=//mp/nfsuser/g01/wx20yz/earch/exec/prcpcv.x
WINDEX=/nwprod/util/exec/grbindex

export prcpcvx WINDEX
$WINDEX $1 $2

echo "&namin"       >input
echo "cpgb='$1',cpgi='$2',cpge='$3'"  >>input
echo "/"        >>input

cat input

$prcpcvx  <input                          
