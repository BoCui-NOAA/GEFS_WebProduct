
if [[ $# != 6 ]];then
  echo "Usage: $0 ienst iensi iensp gribin indexin gribout"
  echo "       inserts ensemble PDS extensions in GRIB file"
  echo "       ienst -- ens(2) "
  echo "       iensi -- ens(3) "
  echo "       iensp -- ens(4) "
  exit 1
fi

### ienst -- kens(2)
### iensi -- kens(3)
### gribin -- input grib file
### indexin -- input grib index file
### gribout -- output grib file with grib extension

set -x 
ensaddx=/nfsuser/g01/wx20yz/bin/ensadd_new.x
WINDEX=/nwprod/util/exec/grbindex

export ensaddx WINDEX
$WINDEX $4 $5

echo "&namin"       >input$1$2
echo "ienst=$1,iensi=$2,iensp=$3,cpgb='$4',cpgi='$5',cpge='$6'"  >>input$1$2
echo "/   "        >>input$1$2

cat input$1$2

$ensaddx  <input$1$2                          
