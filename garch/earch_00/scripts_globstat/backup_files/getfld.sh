
#set -x
if [ $# -lt 2 ]; then
   echo "  The input arguments less then 2 "
   exit 8
fi

echo "         ########################################## "
echo "         ****      For GRIB file only           *** "
echo "         **** input=$1     *** "
echo "         ****     from mixed GRIB files         *** "
echo "         ****        Please  wait !!!!!!!       *** "
echo "         ########################################## "

####
#     $1   -----> input grib1 file name with less than (360*181) resolution
#     $2   -----> output grib1 file name with the same resolution as input
####

export getfldx WINDEX 
echo "gtefldx = $getfldx WINDEX = $WINDEX"
pwd
set -x

$WINDEX  $1 $2.index
 
FILENV=.assigngetfld$$;export FILENV

assign -a $1                 -s unblocked     fort.11
assign -a $2.index           -s unblocked     fort.21
assign -a $2.z1000           -s unblocked     fort.51
assign -a $2.z700            -s unblocked     fort.52
assign -a $2.z500            -s unblocked     fort.53
assign -a $2.z250            -s unblocked     fort.54
assign -a $2.u10m            -s unblocked     fort.55
assign -a $2.u850            -s unblocked     fort.56
assign -a $2.u500            -s unblocked     fort.57
assign -a $2.u250            -s unblocked     fort.58
assign -a $2.v10m            -s unblocked     fort.59
assign -a $2.v850            -s unblocked     fort.60
assign -a $2.v500            -s unblocked     fort.61
assign -a $2.v250            -s unblocked     fort.62
assign -a $2.t2m             -s unblocked     fort.63
assign -a $2.t850            -s unblocked     fort.64
assign -a $2.rh700           -s unblocked     fort.65
assign -a $2.precip          -s unblocked     fort.66
assign -a $2.prmsl           -s unblocked     fort.67
assign -a $2.tmax            -s unblocked     fort.68
assign -a $2.tmin            -s unblocked     fort.69

$getfldx 

ls -l *precip
#$getfldx 2>/dev/null


