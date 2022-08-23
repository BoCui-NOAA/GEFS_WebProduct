c     This is a program to calculate  ensemble outliers on IBM-SP
c     ----------- NCEP Ensemble Forecasts Version -------------------
c                Global verification for icoeff=0 or icoeff=1
c                 includes: Northern Hemisphere
c                           Southern Hemisphere
c                           Tropical            
c
c     main program    VRFYEN
c
c      subroutine     states ---> main routine to calculate anomal corr.
c                     rmsawt ---> to get mean error and RMS error
c                     latwmn ---> to get latitude mean values
c                     sumwav ---> to sum the wave groups
c                     acgrid ---> to calculate anomally correlation at grid
c                     grd2wv ---> transform from grid to wave
c                     getcac ---> read cac climate database
c                     get23y ---> read reanalysis data ( GRIB format )        
c                     getanl ---> read analysis file ( GRIB format )      
c                     getgrb ---> read ensemble forecasts ( GRIB format )
c                     putgrb ---> write the grib format file               
c                     fgroup ---> group the data
c                     spread ---> calculate the spread of the data
c                     talagr ---> calculate the talagrand for anal .vs. fcst
c                     fptala ---> calculate the talagrand for fcst .vs. fcst
c                     grange ---> to get maximum and minimum of dataset
c                     sortmm ---> sorting program
c                     outlie ---> to calculate the outlier and distac=nce
c                     sort   ---> simple sorting program
c                     
c
c     parameters                                                    
c                     ihmax  ---> maximum hours to verify (normally 360 hours ) 
c                     imem   ---> forecasting members ( NCEP are 23 members )
c
c
c      Fortran 77 on Cray ====== coded by Yuejian Zhu 07/15/95
c       Modified by Yuejian Zhu 06/30/00
c
c      Consider T00Z and T12Z components seperately
c       Modified by Yuejian Zhu 09/01/00
c
c      Adding all 40 members outline and distance calculation
c       Modified by Yuejian Zhu 09/08/00
c
c
      program VRFYEN
      parameter (ihmax=408,imem=23,imemp1=imem+1,imemp7=imem+7)

      dimension agrid(144,73),ogrid(144,73),fgrid(144,73,imem)
      dimension pgrid(144,73,imem)
      dimension kdate(100)

      character*80 cfiles(2,3)
      character*80 cpgba,cpgia,cpgbf,cpgif,cpgbp,cpgip                     

      namelist/files/ cfiles
      namelist/namin/ nhours,ilv,kdate

C--------+---------+----------+---------+----------+---------+---------+--

      open(unit=81,file='scores.ens',err=1020)
      open(unit=82,file='rmserr.ens',form='unformatted',
     &     status='unknown',err=1020)
      call baopen (61,'outlier.dat',iret)
c ----
c job will be controled by read card
c ----
      read  (5,files,end=1020)
      write (6,files)
      read  (5,namin,end=1020)               
      write (6,namin)
 1010 continue
c ---------------------------------------------------------------------+------
c ilv is real pressure level now       
c convert nhours to units ( 1 unit=12 hours here )
c two more step:
c               1. -12Z for previous 24 hours forecast
c               2.  00Z for initial time verificationt
c ---------------------------------------------------------------------+------
      ilev=ilv
      if (nhours.gt.ihmax) nhours = ihmax
      iunit = nhours/12 + 2
c ----
      do ii = 2, iunit                  ! main loop to run each forecasts
       jcon     = ii   
       ifhr     = (ii-2)*12
       ifhr24   = ifhr - 24 
       ndate    = kdate(ii+4)
       jdate    = kdate(3)
       mdate    = kdate(4)
       jdat1    = kdate(1)
       mdat1    = kdate(2)
       cpgba    = cfiles(1,1)
       cpgia    = cfiles(2,1)
       cpgbf    = cfiles(1,2)
       cpgif    = cfiles(2,2)
       cpgbp    = cfiles(1,3)
       cpgip    = cfiles(2,3)
       ifld     = 7
c ----
c get analysis and forecasting data
c ----
       print *, '------  Analysis for current 00Z, 12Z ------'
       call getanl(agrid,cpgba,cpgia,ifld,ilev,ndate,0)
       print *, '------  Forcasts for current 00Z, 12Z ------'
       call getgrb(fgrid,cpgbf,cpgif,ifld,ilev,jdate,mdate,ifhr,11)
       print *, '------ Forcasts for  24 hours after 00Z, 12Z ------ '
       call getgrb(pgrid,cpgbp,cpgip,ifld,ilev,jdat1,mdat1,ifhr24,10)
c ----
c to calculate the outlines and distances
c ----
c       ii.ge.4 --> start lead time is 24 hours
       if (ilev.eq.500) then
        if (ii.ge.4.or.ii.lt.16) then
         call outlie(agrid,fgrid,pgrid,23,ogrid)
c        do lon = 1, 144
c        write (*,'(i3,10(f7.1))') lon,(ogrid(lon,lat),lat=18,27)
c        enddo
         call putgrb(ogrid,ilev,9,jdate,ifhr)
         call putgrb(agrid,ilev,7,ndate,0)
        endif
       endif
      enddo                              ! end loop for main do loop ii   
c -----------------------------
      call baclose(61,iret)
      stop
 1020 print *, " there is a program to read file #5 "
      stop
      end
