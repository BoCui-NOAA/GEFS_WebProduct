
if [[ $# != 5 ]];then
  echo "Usage: $0 ienst iensi gribin indexin gribout"
  echo "       inserts ensemble PDS extensions in GRIB file"
  exit 1
fi

ensaddx=$SHOME/$LOGNAME/earch/exec/ensadd.x

export ensaddx windex
$windex $3 $4

echo "&namin"       >input$1$2
echo "ienst=$1,iensi=$2,cpgb='$3',cpgi='$4',cpge='$5'"  >>input$1$2
echo "/   "        >>input$1$2

cat input$1$2

$ensaddx  <input$1$2                          
