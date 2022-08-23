
if [ $# -lt 2 ]; then
 echo "Usage: $0 need input file and output file"
 exit 8      
fi

date;pwd

###
### 1. Set up the temperally directory
###

tmpdir=$PTMP/$LOGNAME/postjma 

if [ -s $tmpdir ]; then
  rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi

###
### 2. Set up the climate data entry, grib utility entry.
###

dat=$SHOME/$LOGNAME/gvrfy/data
EXECS=$SHOME/$LOGNAME/gvrfy/exec/postjma    
windex=/nwprod/util/exec/grbindex           
nhours=/nwprod/util/exec/ndate

GDSN=00002000ff0000900025015f900000008000000005747c09c409c40000000000
GDSS=00002000ff000090002500000000000080815f9005747c09c409c40000000000

#file=$GLOBAL/jma/pgbanl.2008040100
file=$1                                 
pgbo=$2                                 
wgrib -GDS $file | grep $GDSN | wgrib -i $file -grib -o pgbn
wgrib -GDS $file | grep $GDSS | wgrib -i $file -grib -o pgbs

cat <<paramEOF >input
 &namin
 cpgbn='pgbn',                              
 cpgbs='pgbs',                              
 cpgbo='$pgbo',                              
 /
paramEOF

FILENV=.assignv$$ 
export FILENV

cat input

$EXECS                                    <input  2>/dev/null
