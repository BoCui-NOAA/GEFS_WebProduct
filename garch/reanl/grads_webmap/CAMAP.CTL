dset ^_DATANAME
index ^_DATANAME.idx
undef 9.999E+20
title _DATANAME
*  produced by grib2ctl v0.9.12.5p38beta2
*dtype grib 3
dtype grib 255
*options yrev
ydef 181 linear -90.000000 1
xdef 360 linear 0.000000 1.000000
tdef 100 linear _CYMDH 24hrs
zdef 7 levels
1000 925 850 700 500 250 200 
vars 11
HGTprs 7 7,100,0 ** Geopotential height [gpm]
PRESsfc  0 1,1,0  ** surface Pressure [Pa]
PRMSLmsl  0 2,102,0  ** Pressure reduced to MSL [Pa]
TMAX2m  0 15,105,2 ** 2 m above ground Max. temp. [K]
TMIN2m  0 16,105,2 ** 2 m above ground Min. temp. [K]
TMPprs 7 11,100,0 ** Temp. [K]
TMP2m  0 11,105,2 ** 2 m above ground Temp. [K]
UGRDprs 7 33,100,0 ** u wind [m/s]
UGRD10m  0 33,105,10 ** 10 m above ground u wind [m/s]
VGRDprs 7 34,100,0 ** v wind [m/s]
VGRD10m  0 34,105,10 ** 10 m above ground v wind [m/s]
ENDVARS
