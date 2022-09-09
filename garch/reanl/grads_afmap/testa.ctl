dset /com/gens/prod/gefs.20120531/00/pgrb2a_an/gep%e.t00z.pgrb2a_anf24
index gep01.t00z.pgrb2a_anf24.idx
undef 9.999E+20
title /com/gens/prod/gefs.20120531/00/pgrb2a_an/gep01.t00z.pgrb2a_anf24
*  produced by g2ctl v0.0.4i
* griddef=1:0:(360 x 181):grid_template=0:winds(N/S): lat-lon grid:(360 x 181) units 1e-06 input WE:NS output WE:SN res 48 lat 90.000000 to -90.000000 by 1.000000 lon 0.000000 to 359.000000 by 1.000000 #points=65160:winds(N/S)

dtype grib2
options template
ydef 181 linear -90.000000 1
xdef 360 linear 0.000000 1.000000
tdef 1 linear 00Z01jun2012 1mo
* PROFILE hPa
zdef 4 levels 100000 70000 50000 25000
options pascals
vars 16
HGTprs    4,100  0,3,5 ** (1000 700 500 250) Geopotential Height [gpm]
PRMSLmsl   0,101,0   0,3,1 ** mean sea level Pressure Reduced to MSL [Pa]
TMAX2m   0,103,2   0,0,4,2 ** 2 m above ground Maximum Temperature [K]
TMIN2m   0,103,2   0,0,5,3 ** 2 m above ground Minimum Temperature [K]
TMP850mb   0,100,85000   0,0,0 ** 850 mb Temperature [K]
TMP500mb   0,100,50000   0,0,0 ** 500 mb Temperature [K]
TMP250mb   0,100,25000   0,0,0 ** 250 mb Temperature [K]
TMP2m   0,103,2   0,0,0 ** 2 m above ground Temperature [K]
UGRD850mb   0,100,85000   0,2,2 ** 850 mb U-Component of Wind [m/s]
UGRD500mb   0,100,50000   0,2,2 ** 500 mb U-Component of Wind [m/s]
UGRD250mb   0,100,25000   0,2,2 ** 250 mb U-Component of Wind [m/s]
UGRD10m   0,103,10   0,2,2 ** 10 m above ground U-Component of Wind [m/s]
VGRD850mb   0,100,85000   0,2,3 ** 850 mb V-Component of Wind [m/s]
VGRD500mb   0,100,50000   0,2,3 ** 500 mb V-Component of Wind [m/s]
VGRD250mb   0,100,25000   0,2,3 ** 250 mb V-Component of Wind [m/s]
VGRD10m   0,103,10   0,2,3 ** 10 m above ground V-Component of Wind [m/s]
ENDVARS
EDEF 5
01 1 00Z01jun2012 3,1
02 1 00Z01jun2012 3,2
03 1 00Z01jun2012 3,3
04 1 00Z01jun2012 3,4
05 1 00Z01jun2012 3,5
ENDEDEF
