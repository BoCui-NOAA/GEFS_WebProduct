*dset $PTMP/$LOGNAME/cpc/FILENAME                                 
dset FILENAME                                 
dtype grib
options template yrev
*index $PTMP/$LOGNAME/cpc/FILENAME.map                
index FILENAME.map                
undef -9.99E+33
title PRW-GDAS                                                                  
xdef   144 linear    0.000   2.500
ydef    73 linear  -90.000   2.500
zdef    1  levels    0
tdef    36 linear  HHDDMMYY 3hr
vars     4
pp1        0 19,1,0  percentage of 0.5 inch (12.7mm)
pp2        0 20,1,0  percentage of 1.0 inch (25.4mm)
pp3        0 21,1,0  percentage of 2.0 inch (50.8mm)
pp4        0 22,1,0  percentage of 4.0 inch (101.6mm)
endvars
