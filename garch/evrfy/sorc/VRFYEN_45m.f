c     This is main program of ensemble forecast verification on IBM-SP
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
c                     fgroup ---> group the data
c                     spread ---> calculate the spread of the data
c                     talagr ---> calculate the talagrand for anal .vs. fcst
c                     fptala ---> calculate the talagrand for fcst .vs. fcst
c                     grange ---> to get maximum and minimum of dataset
c                     sortmm ---> sorting program
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
c      Consider T00Z, T06Z, T12Z and T18Z components seperately and combinely
c       Modified by Yuejian Zhu 04/12/04
c
c
      program VRFYEN
      parameter (ihmax=408,imem=45,imemp1=imem+1,imp23=imem+23,ispr=12)
      dimension agrid(144,73),fgrid(144,73,imem)
      dimension dgrid(144,73,23),pgrid(144,73,imem)
      dimension cor(3,4,imp23),rms(3,4,imp23),acwt(73)
      dimension fcor(3,4,36),frms(3,4,36),fspr(3,36)
      dimension en(imem),acwta(3)
      dimension itn(imemp1),it(imemp1,ispr),fit(imemp1,ispr,3)
      dimension irel(imem),ir(imem,ispr),fir(imem,ispr,3)
      dimension spr(ispr),sprf(ispr,3)
      dimension kdate(100),igrp(ispr)

      character*5  chem(3),clab(40),flab(24)
      character*80 cfiles(2,3)
      character*80 cpgba,cpgia,cpgbf,cpgif,cpgbp,cpgip                     

      namelist/files/ cfiles
      namelist/namin/ nhours,ilv,icoeff,iclim,kdate

      data igrp /45,40,30,20,20,10,10,10,10,10,10,10/
      data chem /'N Hem','S Hem','Trop.'/
C--------+---------+----------+---------+----------+---------+---------+--
      data clab/'GFS00','CTL00','00Zpa','00Zas','00Zms',
     &          'GFS18',        '18Zpa','18Zas','18Zms',
     &          'GFS12',        '12Zpa','12Zas','12Zms',
     &          'GFS06',        '06Zpa','06Zas','06Zms',
     &          '10L1a','10L1m','10L2a','10L2m','10L3a','10L3m',
     &                          '20mpa','20mas','20mms',
     &                          '20mpa','20mas','20mms',
     &                          '30mpa','30mas','30mms',
     &                  '40mpa','40mas','40mms','45mas',
     &                          '00Zis','18Zis','12Zis','06Zis'/
      data flab/'00T10','18T10','12T10','06T10','10LT1','10LT2','10LT3',
     &          '20mT1','20mT2','30mT1','40mT1','45mT1',
     &          '00R10','18R10','12R10','06R10','10LR1','10LR2','10LR3',
     &          '20mR1','20mR2','30mR1','40mR1','45mR1'/

      open(unit=81,file='scores.ens',err=1020)
c     open(unit=82,file='rmserr.ens',form='unformatted',
c    &     status='unknown',err=1020)
c ----
c job will be controled by read card
c ----
      read  (5,files,end=1020)
      write (6,files)
      read  (5,namin,end=1020)               
      write (6,namin)
      print *, 'icoeff=',icoeff
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
c     do ii = 1, iunit                  ! main loop to run each forecasts
      do ii = 2, iunit                  ! main loop to run each forecasts
       fcor     = 9.9999
       frms     = 999.99
       jcon     = ii   
       fit      = 0.0
       it       = 0
       fir      = 0.0
       ir       = 0
       sprf     = 0.0
       fspr     = 0.0
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
       print *, '-- Forcasts for current 00Z, 06Z, 12Z and 18Z --'
       call getgrb(fgrid,cpgbf,cpgif,ifld,ilev,jdate,mdate,ifhr,11)
c ----
c to calculate talagrand histogram and N+1 distribution
c ----
       acwt = 0.0 
       acwf = 0.0
       do lat = 1, 73                   ! do loop for each latitude     
c ----
c calculate the weight for each latitude
c ----
        weight   = sin((lat-1)*2.5*3.1415926/180.0)
        acwt(lat)= weight                                   

        do lon = 1, 144                  ! do loop for each longitude    

         do im = 1, imem                 ! 23 ensemble members
          en(im) = fgrid(lon,lat,im)
         enddo
         an      = agrid(lon,lat)
c ----
c en --> forecast
c an --> analysis
c     ave ---> 41 members average
c     we can't make 45 members average ( no forecasts verified at
c          t00z and t12z for t06z and t18z cycle forecast more than 184 hrs).
c ----
         call talagr(45,45,en,an,itn,xave,xmed,irel,xspr,0)           
         dgrid(lon,lat,1) = xave         ! 45 members
         spr(1)           = xspr
         do kk = 1, 46
          it(kk,1) = itn(kk)
         enddo
         do kk = 1, 45
          ir(kk,1) = irel(kk)
         enddo
         
         call talagr(45,40,en,an,itn,xave,xmed,irel,xspr,0)           
         dgrid(lon,lat,2) = xave         ! 40 members
         dgrid(lon,lat,3) = xmed         ! 40 members
         spr(2)           = xspr
         do kk = 1, 41
          it(kk,2) = itn(kk)
         enddo
         do kk = 1, 40
          ir(kk,2) = irel(kk)
         enddo

         call talagr(45,30,en,an,itn,xave,xmed,irel,xspr,0)           
         dgrid(lon,lat,4) = xave         ! 30 members
         dgrid(lon,lat,5) = xmed         ! 30 members
         spr(3)           = xspr
         do kk = 1, 31
          it(kk,3) = itn(kk)
         enddo
         do kk = 1, 30
          ir(kk,3) = irel(kk)
         enddo
         
         call talagr(45,20,en,an,itn,xave,xmed,irel,xspr,201)           
         dgrid(lon,lat,6) = xave         ! 20 members
         dgrid(lon,lat,7) = xmed         ! 20 members
         spr(4)           = xspr
         do kk = 1, 21
          it(kk,4) = itn(kk)
         enddo
         do kk = 1, 20
          ir(kk,4) = irel(kk)
         enddo
         
         call talagr(45,20,en,an,itn,xave,xmed,irel,xspr,202)           
         dgrid(lon,lat,8) = xave         ! 20 members
         dgrid(lon,lat,9) = xmed         ! 20 members
         spr(5)           = xspr
         do kk = 1, 21
          it(kk,5) = itn(kk)
         enddo
         do kk = 1, 20
          ir(kk,5) = irel(kk)
         enddo

         call talagr(45,10,en,an,itn,xave,xmed,irel,xspr,101)           
         dgrid(lon,lat,10) = xave         ! 10 members T00Z
         dgrid(lon,lat,11) = xmed         ! 10 members T00Z
         spr(6)            = xspr
         do kk = 1, 11
          it(kk,6) = itn(kk)
         enddo
         do kk = 1, 10
          ir(kk,6) = irel(kk)
         enddo
         
         call talagr(45,10,en,an,itn,xave,xmed,irel,xspr,102)           
         dgrid(lon,lat,12) = xave         ! 10 members T18Z
         dgrid(lon,lat,13) = xmed         ! 10 members T18Z
         spr(7)            = xspr
         do kk = 1, 11
          it(kk,7) = itn(kk)
         enddo
         do kk = 1, 10
          ir(kk,7) = irel(kk)
         enddo
         
         call talagr(45,10,en,an,itn,xave,xmed,irel,xspr,103)           
         dgrid(lon,lat,14) = xave         ! 10 members T12Z
         dgrid(lon,lat,15) = xmed         ! 10 members T12Z
         spr(8)            = xspr
         do kk = 1, 11
          it(kk,8) = itn(kk)
         enddo
         do kk = 1, 10
          ir(kk,8) = irel(kk)
         enddo
         
         call talagr(45,10,en,an,itn,xave,xmed,irel,xspr,104)           
         dgrid(lon,lat,16) = xave         ! 10 members T06Z
         dgrid(lon,lat,17) = xmed         ! 10 members T06Z
         spr(9)            = xspr
         do kk = 1, 11
          it(kk,9) = itn(kk)
         enddo
         do kk = 1, 10
          ir(kk,9) = irel(kk)
         enddo
         
         call talagr(45,10,en,an,itn,xave,xmed,irel,xspr,105)           
         dgrid(lon,lat,18) = xave         ! 10 members (5,5,0,0)
         dgrid(lon,lat,19) = xmed         ! 10 members (5,5,0,0)
         spr(10)           = xspr
         do kk = 1, 11
          it(kk,10) = itn(kk)
         enddo
         do kk = 1, 10
          ir(kk,10) = irel(kk)
         enddo
         
         call talagr(45,10,en,an,itn,xave,xmed,irel,xspr,106)           
         dgrid(lon,lat,20) = xave         ! 10 members (4,3,3,0)
         dgrid(lon,lat,21) = xmed         ! 10 members (4,3,3,0)
         spr(11)           = xspr
         do kk = 1, 11
          it(kk,11) = itn(kk)
         enddo
         do kk = 1, 10
          ir(kk,11) = irel(kk)
         enddo
         
         call talagr(45,10,en,an,itn,xave,xmed,irel,xspr,107)           
         dgrid(lon,lat,22) = xave         ! 10 members (3,3,2,2)
         dgrid(lon,lat,23) = xmed         ! 10 members (3,3,2,2)
         spr(12)           = xspr
         do kk = 1, 11
          it(kk,12) = itn(kk)
         enddo
         do kk = 1, 10
          ir(kk,12) = irel(kk)
         enddo
c ----
         if ( lat.ge.6.and.lat.le.29 ) then
          jj = 1
          goto 2010
         elseif ( lat.ge.45.and.lat.le.68 ) then
          jj = 2
          goto 2010
         elseif ( lat.gt.29.and.lat.lt.45 ) then
          jj = 3
          goto 2010
         else
          goto 2020
         endif
 2010 continue
         do i = 1, ispr 
          do kk = 1, igrp(i)+1
           fit(kk,i,jj) = fit(kk,i,jj) + it(kk,i)*weight/144.0
          enddo
         enddo
         do i = 1, ispr
          do kk = 1, igrp(i)
           fir(kk,i,jj) = fir(kk,i,jj) + ir(kk,i)*weight/144.0
          enddo
         enddo
         do kk = 1,ispr 
          sprf(kk,jj)  = sprf(kk,jj)  + spr(kk)*weight/144.0
         enddo
 2020 continue
        enddo                              ! end do loop for lon=1,144
       enddo                               ! end do loop for lat=1,73 
c ----
c normalize the N+1 distribution scores
c ----
       acwta = 0.0
       do kk = 1, 24
        acwta(1) = acwta(1) + acwt(kk+ 5)
        acwta(2) = acwta(2) + acwt(kk+44)
       enddo
       do kk = 1, 15
        acwta(3) = acwta(3) + acwt(kk+29)
       enddo
       do i = 1, ispr
        do kk = 1, igrp(i)+1
         do jj = 1,3
          fit(kk,i,jj)=fit(kk,i,jj)*100.0/acwta(jj)
         enddo
        enddo
       enddo
       do i = 1, ispr
        do kk = 1, igrp(i)
         do jj = 1,3
          fir(kk,i,jj)=fir(kk,i,jj)*100.0/acwta(jj)/2.0
         enddo
        enddo
       enddo
       do kk = 1, ispr 
        do jj = 1, 3
         sprf(kk,jj)=sqrt(sprf(kk,jj)/float(igrp(kk)-1)/acwta(jj))
        enddo
       enddo
c       print *, '------ Forcasts for  24 hours after 00Z, 12Z ------ '
c       call getgrb(pgrid,cpgbp,cpgip,ifld,ilev,jdat1,mdat1,ifhr24,10)
c       call fptala(fgrid,pgrid,23,23,fitavg)
c       call fptala(fgrid,pgrid,10,101,fit101)   ! T00Z 10 members
c       call fptala(fgrid,pgrid,10,102,fit102)   ! T12Z 10 members
c ----
c to calculate amomaly corrlation and rms error
c ----
        do im=1,imem
         call states(agrid,fgrid(1,1,im),ifld,ilev,jdate,cor(1,1,im),
     *               rms(1,1,im),icoeff,iclim)
        enddo
        do im=1,23
         call states(agrid,dgrid(1,1,im),ifld,ilev,jdate,
     *               cor(1,1,imem+im),rms(1,1,imem+im),icoeff,iclim)
        enddo
c ----
c output scores cor(3,4,22),rms(3,4,22) 
c        1. GFS ( T254 ) 00Z scores
c        2. CTL ( T126 ) 00Z scores
c     3-12. 5 pairs      00Z scores
c       13. GFS ( T254 ) 18Z scores
c    14-23. 5 pairs      18Z scores
c       24. GFS ( T254 ) 12Z scores
c    25-34. 5 pairs      12Z scores
c       35. GFS ( T254 ) 06Z scores
c    36-45. 5 pairs      06Z scores
c       46. Mean   (45m)     scores
c       47. Mean   (40m)     scores
c       48. Medium (40m)     scores
c       49. Mean   (30m)     scores
c       50. Medium (30m)     scores
c       51. Mean   (20m)     scores
c       52. Medium (20m)     scores
c       53. Mean   (20m)     scores
c       54. Medium (20m)     scores
c       55. T00Z 10m mean    scores
c       56. T00Z 10m medium  scores
c       57. T18Z 10m mean    scores
c       58. T18Z 10m medium  scores
c       59. T12Z 10m mean    scores
c       60. T12Z 10m medium  scores
c       61. T06Z 10m mean    scores
c       62. T06Z 10m medium  scores
c       63. 10m mean(5,5,0,0)scores
c       64. 10m med.(5,5,0,0)scores
c       65. 10m mean(4,3,3,0)scores
c       66. 10m med.(4,3,3,0)scores
c       67. 10m mean(3,3,2,2)scores
c       68. 10m med.(3,3,2,2)scores
c convert to fcor and frms 
c        1. GFS ( T254 ) 00Z scores
c        2. CTL ( T126 ) 00Z scores
c        3. 5 pairs      00Z scores average
c        4. 5 pairs mean 00Z scores
c        5. 5 pairs med. 00Z scores
c        6. GFS ( T254 ) 18Z scores
c        7. 5 pairs      18Z scores average
c        8. 5 pairs mean 18Z scores
c        9. 5 pairs med. 18Z scores
c       10. GFS ( T254 ) 12Z scores
c       11. 5 pairs      12Z scores average
c       12. 5 pairs mean 12Z scores
c       13. 5 pairs med. 12Z scores
c       14. GFS ( T254 ) 06Z scores
c       15. 5 pairs      06Z scores average
c       16. 5 pairs mean 06Z scores
c       17. 5 pairs med. 06Z scores
c       18. 10m mean(5,5,0,0)scores
c       19. 10m mean(5,5,0,0)scores
c       20. 10m mean(5,5,0,0)scores
c       21. 10m mean(5,5,0,0)scores
c       22. 10m mean(5,5,0,0)scores
c       23. 10m mean(5,5,0,0)scores
c       24. 20 mem.          scores average
c       25. 20 mem. mean     scores
c       26. 20 mem. med.     scores
c       27. 20 mem.          scores average
c       28. 20 mem. mean     scores
c       29. 20 mem. med.     scores
c       30. 30 mem.          scores average
c       31. 30 mem. mean     scores
c       32. 30 mem. med.     scores
c       33. 40 mem.          scores average
c       34. 40 mem. mean     scores
c       35. 40 mem. med.     scores
c       36. 45 mem. mean     scores
c       37. T00Z  10 members individual Scores
c       38. T18Z  10 members individual Scores
c       39. T12Z  10 members individual Scores
c       40. T06Z  10 members individual Scores
c ----
        if (ii.eq.1) then
         fcor=9.9999
         frms=999.99
        else
         fcor=0.0
         frms=0.0
        endif
c ----
c         For tropical region:
c             anhw = sum(acwt(29--37))
c             ashw = 1.0 - anhw
c ----
        anhw = ((acwta(3)-1.0)/2.0+1.0)/acwta(3)
        ashw = 1.0 - anhw
        do jj = 1, 4
         do kk = 1,3
          fcor(kk,jj,1) = cor(kk,jj,1)       !GFS00
          frms(kk,jj,1) = rms(kk,jj,1)       !GFS00
          fcor(kk,jj,2) = cor(kk,jj,2)       !CTL00
          frms(kk,jj,2) = rms(kk,jj,2)       !CTL00
          fcor(kk,jj,4) = cor(kk,jj,55)      !10m00
          frms(kk,jj,4) = rms(kk,jj,55)      !10m00
          fspr(kk,   4) = sprf(6,kk)         !10m00
          fcor(kk,jj,5) = cor(kk,jj,56)      !10m00
          frms(kk,jj,5) = rms(kk,jj,56)      !10m00

          fcor(kk,jj,6) = cor(kk,jj,13)      !GFS18
          frms(kk,jj,6) = rms(kk,jj,13)      !GFS18
          fcor(kk,jj,8) = cor(kk,jj,57)      !10m18
          frms(kk,jj,8) = rms(kk,jj,57)      !10m18
          fspr(kk,   8) = sprf(7,kk)         !10m18
          fcor(kk,jj,9) = cor(kk,jj,58)      !10m18
          frms(kk,jj,9) = rms(kk,jj,58)      !10m18

          fcor(kk,jj,10)= cor(kk,jj,24)      !GFS12
          frms(kk,jj,10)= rms(kk,jj,24)      !GFS12
          fcor(kk,jj,12)= cor(kk,jj,59)      !10m12
          frms(kk,jj,12)= rms(kk,jj,59)      !10m12
          fspr(kk,   12)= sprf(8,kk)         !10m12
          fcor(kk,jj,13)= cor(kk,jj,60)      !10m12
          frms(kk,jj,13)= rms(kk,jj,60)      !10m12

          fcor(kk,jj,14)= cor(kk,jj,35)      !GFS06
          frms(kk,jj,14)= rms(kk,jj,35)      !GFS06
          fcor(kk,jj,16)= cor(kk,jj,61)      !10m06
          frms(kk,jj,16)= rms(kk,jj,61)      !10m06
          fspr(kk,   16)= sprf(9,kk)         !10m06
          fcor(kk,jj,17)= cor(kk,jj,62)      !10m06
          frms(kk,jj,17)= rms(kk,jj,62)      !10m06

          fcor(kk,jj,18)= cor(kk,jj,63)      !10m01
          frms(kk,jj,18)= rms(kk,jj,63)      !10m01
          fspr(kk,   18)= sprf(10,kk)        !10m01
          fcor(kk,jj,19)= cor(kk,jj,64)      !10m01
          frms(kk,jj,19)= rms(kk,jj,64)      !10m01

          fcor(kk,jj,20)= cor(kk,jj,65)      !10m02
          frms(kk,jj,20)= rms(kk,jj,65)      !10m02
          fspr(kk,   20)= sprf(11,kk)        !10m02
          fcor(kk,jj,21)= cor(kk,jj,66)      !10m02
          frms(kk,jj,21)= rms(kk,jj,66)      !10m02

          fcor(kk,jj,22)= cor(kk,jj,67)      !10m03
          frms(kk,jj,22)= rms(kk,jj,67)      !10m03
          fspr(kk,   22)= sprf(12,kk)        !10m03
          fcor(kk,jj,23)= cor(kk,jj,68)      !10m03
          frms(kk,jj,23)= rms(kk,jj,68)      !10m03

          fcor(kk,jj,25)= cor(kk,jj,51)      !20m01
          frms(kk,jj,25)= rms(kk,jj,51)      !20m01
          fspr(kk,   25)= sprf(4,kk)         !20m01
          fcor(kk,jj,26)= cor(kk,jj,52)      !20m01
          frms(kk,jj,26)= rms(kk,jj,52)      !20m01

          fcor(kk,jj,28)= cor(kk,jj,53)      !20m02
          frms(kk,jj,28)= rms(kk,jj,53)      !20m02
          fspr(kk,   28)= sprf(5,kk)         !20m02
          fcor(kk,jj,29)= cor(kk,jj,54)      !20m02
          frms(kk,jj,29)= rms(kk,jj,54)      !20m02

          fcor(kk,jj,31)= cor(kk,jj,49)      !30m01
          frms(kk,jj,31)= rms(kk,jj,49)      !30m01
          fspr(kk,   31)= sprf(3,kk)         !30m01
          fcor(kk,jj,32)= cor(kk,jj,50)      !30m01
          frms(kk,jj,32)= rms(kk,jj,50)      !30m01

          fcor(kk,jj,34)= cor(kk,jj,47)      !40m01
          frms(kk,jj,34)= rms(kk,jj,47)      !40m01
          fspr(kk,   34)= sprf(2,kk)         !40m01
          fcor(kk,jj,35)= cor(kk,jj,48)      !40m01
          frms(kk,jj,35)= rms(kk,jj,48)      !40m01

          fcor(kk,jj,36)= cor(kk,jj,46)      !45m01
          frms(kk,jj,36)= rms(kk,jj,46)      !45m01
c         fspr(kk,   36)= sprf(1,kk)         !45m01
         enddo
        enddo
c ---- 3. 5 pairs      00Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 3, 12
           fcor(kk,jj,3) = fcor(kk,jj,3) + cor(kk,jj,mm)/10.0
           frms(kk,jj,3) = frms(kk,jj,3) + rms(kk,jj,mm)/10.0
          enddo
         enddo
        enddo
c ---- 4. 5 pairs      18Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 14, 23   
           fcor(kk,jj,7) = fcor(kk,jj,7) + cor(kk,jj,mm)/10.0
           frms(kk,jj,7) = frms(kk,jj,7) + rms(kk,jj,mm)/10.0
          enddo
         enddo
        enddo
c ---- 5. 5 pairs      12Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 25, 34   
           fcor(kk,jj,11) = fcor(kk,jj,11) + cor(kk,jj,mm)/10.0
           frms(kk,jj,11) = frms(kk,jj,11) + rms(kk,jj,mm)/10.0
          enddo
         enddo
        enddo
c ---- 6. 5 pairs      06Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 36, 45   
           fcor(kk,jj,15) = fcor(kk,jj,15) + cor(kk,jj,mm)/10.0
           frms(kk,jj,15) = frms(kk,jj,15) + rms(kk,jj,mm)/10.0
          enddo
         enddo
        enddo
c ---- 7. 10 + 10 members  scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 3, 12   
           fcor(kk,jj,24) = fcor(kk,jj,24) + cor(kk,jj,mm)/20.0
           frms(kk,jj,24) = frms(kk,jj,24) + rms(kk,jj,mm)/20.0
          enddo
          do mm = 14, 23  
           fcor(kk,jj,24) = fcor(kk,jj,24) + cor(kk,jj,mm)/20.0
           frms(kk,jj,24) = frms(kk,jj,24) + rms(kk,jj,mm)/20.0
          enddo
         enddo
        enddo
c ---- 8. 10 + 10 members  scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 3, 12   
           fcor(kk,jj,27) = fcor(kk,jj,27) + cor(kk,jj,mm)/20.0
           frms(kk,jj,27) = frms(kk,jj,27) + rms(kk,jj,mm)/20.0
          enddo
          do mm = 25, 34  
           fcor(kk,jj,27) = fcor(kk,jj,27) + cor(kk,jj,mm)/20.0
           frms(kk,jj,27) = frms(kk,jj,27) + rms(kk,jj,mm)/20.0
          enddo
         enddo
        enddo
c ---- 9.  30     members  scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 3, 12   
           fcor(kk,jj,30) = fcor(kk,jj,30) + cor(kk,jj,mm)/30.0
           frms(kk,jj,30) = frms(kk,jj,30) + rms(kk,jj,mm)/30.0
          enddo
          do mm = 14, 23  
           fcor(kk,jj,30) = fcor(kk,jj,30) + cor(kk,jj,mm)/30.0
           frms(kk,jj,30) = frms(kk,jj,30) + rms(kk,jj,mm)/30.0
          enddo
          do mm = 25, 34  
           fcor(kk,jj,30) = fcor(kk,jj,30) + cor(kk,jj,mm)/30.0
           frms(kk,jj,30) = frms(kk,jj,30) + rms(kk,jj,mm)/30.0
          enddo
         enddo
        enddo
c ---- 10. 40 members  scores mean
       if (ii.gt.1) then
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 3, 12   
           fcor(kk,jj,33) = fcor(kk,jj,33) + cor(kk,jj,mm)/40.0
           frms(kk,jj,33) = frms(kk,jj,33) + rms(kk,jj,mm)/40.0
          enddo
          do mm = 14, 23  
           fcor(kk,jj,33) = fcor(kk,jj,33) + cor(kk,jj,mm)/40.0
           frms(kk,jj,33) = frms(kk,jj,33) + rms(kk,jj,mm)/40.0
          enddo
          do mm = 25, 34  
           fcor(kk,jj,33) = fcor(kk,jj,33) + cor(kk,jj,mm)/40.0
           frms(kk,jj,33) = frms(kk,jj,33) + rms(kk,jj,mm)/40.0
          enddo
          do mm = 36, 45  
           fcor(kk,jj,33) = fcor(kk,jj,33) + cor(kk,jj,mm)/40.0
           frms(kk,jj,33) = frms(kk,jj,33) + rms(kk,jj,mm)/40.0
          enddo
         enddo
        enddo
       endif

c ----
c write out scores 
c ----
c--------+---------+---------+---------+---------+---------+---------+--
c ---- N Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,200) ilev,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For N Hemisphere at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 36    
        write(*,201)  clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
     &               ,fspr(1,jj)
       enddo
       write(81,221) clab(37), (cor(1,4,jj),jj=3,12)
       write(81,221) clab(38), (cor(1,4,jj),jj=14,23)
       write(81,221) clab(39), (cor(1,4,jj),jj=25,34)
       write(81,221) clab(40), (cor(1,4,jj),jj=36,45)
       write(81,222) clab(37), (rms(1,1,jj),jj=3,12)
       write(81,222) clab(38), (rms(1,1,jj),jj=14,23)
       write(81,222) clab(39), (rms(1,1,jj),jj=25,34)
       write(81,222) clab(40), (rms(1,1,jj),jj=36,45)
c--------+---------+---------+---------+---------+---------+---------+--
c ---- S Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,202) ilev,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For S Hemisphere at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 36    
        write(*,201)  clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
     &               ,fspr(2,jj)
       enddo
       write(81,221) clab(37), (cor(2,4,jj),jj=3,12)
       write(81,221) clab(38), (cor(2,4,jj),jj=14,23)
       write(81,221) clab(39), (cor(2,4,jj),jj=25,34)
       write(81,221) clab(40), (cor(2,4,jj),jj=36,45)
       write(81,222) clab(37), (rms(2,1,jj),jj=3,12)
       write(81,222) clab(38), (rms(2,1,jj),jj=14,23)
       write(81,222) clab(39), (rms(2,1,jj),jj=25,34)
       write(81,222) clab(40), (rms(2,1,jj),jj=36,45)
c--------+---------+---------+---------+---------+---------+---------+--
c ---- Tropical
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,217) ilev,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For Tropical at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 36   
        write(*,201)  clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
     &               ,fspr(3,jj)
       enddo
       write(81,221) clab(37), (cor(3,4,jj),jj=3,12)
       write(81,221) clab(38), (cor(3,4,jj),jj=14,23)
       write(81,221) clab(39), (cor(3,4,jj),jj=25,34)
       write(81,221) clab(40), (cor(3,4,jj),jj=36,45)
       write(81,222) clab(37), (rms(3,1,jj),jj=3,12)
       write(81,222) clab(38), (rms(3,1,jj),jj=14,23)
       write(81,222) clab(39), (rms(3,1,jj),jj=25,34)
       write(81,222) clab(40), (rms(3,1,jj),jj=36,45)
c ----
       write(81,211) ilev,kdate(ii+4)
       print *, ' N+1 Contains Distrib. from Analysis at Valid Time ',
     &          kdate(ii+4)
c ----                
       if (ii.eq.1) then
        fit    = 0.0
        fir    = 0.0
       endif
       do i = 1, 3
        write(81,215) chem(i)
        write(81,212) flab(1),(fit(j,6,i),j=1,11)
        write(81,212) flab(2),(fit(j,7,i),j=1,11)
        write(81,212) flab(3),(fit(j,8,i),j=1,11)
        write(81,212) flab(4),(fit(j,9,i),j=1,11)
        write(81,212) flab(5),(fit(j,10,i),j=1,11)
        write(81,212) flab(6),(fit(j,11,i),j=1,11)
        write(81,212) flab(7),(fit(j,12,i),j=1,11)
        write(81,212) flab(8),(fit(j,4,i),j=1,12)
        write(81,212) flab(8),(fit(j,4,i),j=13,21)
        write(81,212) flab(9),(fit(j,5,i),j=1,12)
        write(81,212) flab(9),(fit(j,5,i),j=13,21)
        write(81,212) flab(10),(fit(j,3,i),j=1,12)
        write(81,212) flab(10),(fit(j,3,i),j=13,24)
        write(81,212) flab(10),(fit(j,3,i),j=25,31)
        write(81,212) flab(11),(fit(j,2,i),j=1,12)
        write(81,212) flab(11),(fit(j,2,i),j=13,24)
        write(81,212) flab(11),(fit(j,2,i),j=25,36)
        write(81,212) flab(11),(fit(j,2,i),j=37,41)
        write(81,212) flab(13),(fir(j,6,i),j=1,10)
        write(81,212) flab(14),(fir(j,7,i),j=1,10)
        write(81,212) flab(15),(fir(j,8,i),j=1,10)
        write(81,212) flab(16),(fir(j,9,i),j=1,10)
        write(81,212) flab(17),(fir(j,10,i),j=1,10)
        write(81,212) flab(18),(fir(j,11,i),j=1,10)
        write(81,212) flab(19),(fir(j,12,i),j=1,10)
        write(81,212) flab(20),(fir(j,4,i),j=1,12)
        write(81,212) flab(20),(fir(j,4,i),j=13,20)
        write(81,212) flab(21),(fir(j,5,i),j=1,12)
        write(81,212) flab(21),(fir(j,5,i),j=13,20)
        write(81,212) flab(22),(fir(j,3,i),j=1,12)
        write(81,212) flab(22),(fir(j,3,i),j=13,24)
        write(81,212) flab(22),(fir(j,3,i),j=25,30)
        write(81,212) flab(23),(fir(j,2,i),j=1,12)
        write(81,212) flab(23),(fir(j,2,i),j=13,24)
        write(81,212) flab(23),(fir(j,2,i),j=25,36)
        write(81,212) flab(23),(fir(j,2,i),j=37,40)
       enddo
 
      enddo                              ! end loop for main do loop ii   
c
 200  format(' Anomaly Corr. For N Hem. ',
     .       i4,' mb at Valid Time ',i10,' (ini. ',i10,')')
 202  format(' Anomaly Corr. For S Hem. ',
     .       i4,' mb at Valid Time ',i10,' (ini. ',i10,')')
 201  format(a5,1x,4(f7.4),4(f7.2),f7.2)
 211  format('Group Talagrand, Spread etc. from Analysis ',
     .       'for ',i4,' mb at Valid Time ',i10)
 212  format(a5,12(f6.2)) 
 215  format('    ---- for ',a5,' ----' )
 213  format('   ------- Northern Hemisphere -------   ')
 214  format('   ------- Southern Hemisphere -------   ')
 216  format('   ------- Tropical area       -------   ')
 217  format(' Anomaly Corr. For Tropic.',
     .       i4,' mb at Valid Time ',i10,' (ini. ',i10,')')
 221  format(a5,1x,10(f7.4))
 222  format(a5,1x,10(f7.2))
c ---- finished output
 1020 continue
c -----------------------------
      stop
      end
