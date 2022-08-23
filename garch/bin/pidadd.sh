
if [[ $# != 4 ]];then
  echo "Usage: $0 idcen idpro gribin gribout"
  echo "       modify center ID and process ID"
  echo "       idcen -- pds(1) "
  echo "       idpro -- pds(2) "
  exit 1
fi

### idcen -- pds(1)
### idpro -- pds(2)
### gribin -- input grib file
### gribout -- output grib file with grib extension

set -x 
pidadd=/global/save/wx20yz/bin/pidadd

export pidadd 

echo "&namin"       >input$1$2
echo "idcen=$1,idpro=$2,cpgb='$3',cpge='$4'"  >>input$1$2
echo "/   "        >>input$1$2

cat input$1$2

$pidadd  <input$1$2                          
