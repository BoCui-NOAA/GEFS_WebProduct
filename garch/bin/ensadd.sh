
if [[ $# != 5 ]];then
  echo "Usage: $0 ienst iensi gribin indexin gribout"
  echo "       inserts ensemble PDS extensions in GRIB file"
  exit 1
fi

### ienst -- kens(2)
### iensi -- kens(3)
### gribin -- input grib file
### indexin -- input grib index file
### gribout -- output grib file with grib extension

set -x 
ensaddx=/ensemble/save/emc.enspara/earch/exec/ensadd.x
WINDEX=/nwprod/util/exec/grbindex

export ensaddx WINDEX
$WINDEX $3 $4

echo "&namin"       >input$1$2
echo "ienst=$1,iensi=$2,cpgb='$3',cpgi='$4',cpge='$5'"  >>input$1$2
echo "/   "        >>input$1$2

cat input$1$2

$ensaddx  <input$1$2                          
