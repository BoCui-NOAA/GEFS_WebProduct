#######################################
# Child script: ensprcpcv.sh
# ABSTRACT:  This script produces a gribindex of
#            files
#            Theses files are then feed into the
#            executable ensprcpcv.$xc
#
#######################################
set +xS
echo " "
echo "Entering sub script  ensprcpcv.sh"
echo "File 1=$1"
echo " "
echo "     ==== START TO PRCPCV PROCESS ====="
echo " "


####
#     $1   -----> input grib precipitation file name
#
#     output:
#                 precip.new
#
####

if [ $# -lt 1 ]; then
   echo " Usage: $0 need file name "
   exit 8
fi


cd $DATA


export prcpcvx


$EXGRBIX/grbindex $1 prcpcv.index

pgm=`basename prcpcv.$xc .$xc`
export pgm; prep_step


FILENV=$DATA/wrgiprcpcv.asgn$$;export FILENV
assign -a $CDIR/$1                 -s unblocked fort.11
assign -a prcpcv.index             -s unblocked fort.21
assign -a precip.new               -s unblocked fort.51

$EXECens/prcpcv.$xc 2>/dev/null                
err=$?;export err; err_chk


cp precip.new $COM/$1


echo " "
echo "Leaving sub script  ensprcpcv.sh"
echo " "

