c
c  Main program    ANOMALY
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2005-10-10
c
c This is main program to generate climate anomaly forecasts.             
c
c   subroutine                                                    
c              IADDATE---> to add forecast hours to initial data    
c              GETGB  ---> to get GRIB format data                  
c              GRANGE ---> to calculate max. and min value of array
c
c   parameters:
c      ix    -- x-dimensional
c      iy    -- y-dimensional
c      ixy   -- ix*iy
c      iv    -- 19 variables
c
c   Fortran 77 on IBMSP 
c
C--------+---------+---------+---------+---------+----------+---------+--
      program ANOMALY
      parameter (ix=360,iy=181,ixy=ix*iy,iv=19)            
      dimension fcst(ixy),cavg(ixy),stdv(ixy),bias(ixy)
      dimension ipds(200),igds(200)
      dimension jpds(200),jgds(200)
      dimension kpds(200),kgds(200)
      dimension ifld(iv),ityp(iv),ilev(iv)
c     double precision dfcst,fmon(2),opara(2)
      dimension fmon(2),opara(2)
      logical*1 lb(ixy)
      character*80 cfcst,cmean,cstdv,cbias,canom
      namelist /namin/ cfcst,cmean,cstdv,cbias,canom
      data ifld/   7,   7,   7,   7,  11,  11,  11,  33,  34,  33,  34,
     &            33,  34,   2,  11,  15,  16,  33,  34/
      data ityp/ 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 102, 105, 105, 105, 105, 105/
      data ilev/1000, 700, 500, 250, 850, 500, 250, 850, 850, 500, 500,
     &           250, 250,   0,   2,   2,   2,  10,  10/

c
c     to calculate anomaly forecast
c
        fmon(1) = 0.0      
        fmon(2) = 1.0     
        call pelnor(fmon,opara)
        opara(1) = 0.0
        opara(2) = 1.0
        dfcst   = 1.0       
        anom=cdfnor(dfcst,opara)*100.0
        print *, ' fm1=',opara(1),' fm2=',opara(2),
     *           ' fc=',dfcst,' an=',anom
        fmon(1) = 0.0      
        fmon(2) = 1.0     
        call pelnor(fmon,opara)
        opara(1) = 0.0
        opara(2) = 1.0
        dfcst   = -1.0       
        anom=cdfnor(dfcst,opara)*100.0
        print *, ' fm1=',opara(1),' fm2=',opara(2),
     *           ' fc=',dfcst,' an=',anom
        fmon(1) = 10.0
        fmon(2) = 5.0
        call pelnor(fmon,opara)
        opara(1) = 10.0
        opara(2) = 5.0
        dfcst   = 15.0
        anom=cdfnor(dfcst,opara)*100.0
        print *, ' fm1=',opara(1),' fm2=',opara(2),
     *           ' fc=',dfcst,' an=',anom

      stop
      end

