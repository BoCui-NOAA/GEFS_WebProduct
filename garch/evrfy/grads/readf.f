       program r_aero_atl
CCC
CCC    example to read the extract avn analysis and forecast data
CCC               by GrADs utility.
CCC    --------- Yuejian Zhu (09/05/2001)
CCC
CCC    Covering Atlantic Ocean and Gulf of Mexico
CCC    1) resolution = 1 degree * 1 degree
CCC    2) area       = 15N-45N, 260E(100W) - 340E(20W)
CCC    3) fields     = z, u, v
CCC    4) levels     = 1000, 925, 850, 700 and 500 hPa
CCC    5) forecast   = 00, 12, 24, 36, 48, 60, and 72 hours
CCC
CCC     First data z(15N,260E)
CCC      next data z(15N,261E)
CCC                ..........
CCC

       parameter (nlon=81,nlat=31,nlev=5,ntim=7)
       real*4    aa(31)
       real*4    z(nlon,nlat,nlev,ntim)
       real*4    u(nlon,nlat,nlev,ntim)
       real*4    v(nlon,nlat,nlev,ntim)

       open(unit=10,file='500h_egrate_3.5-7d_sct.dat',
     *      form='unformatted',status='old',err=1001)

       read(10,end=100) aa
 100  continue
      print *, aa
       stop
 1001  print *,'there is a problem to open unit 10'
       stop
       end

