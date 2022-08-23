c     This is main program of ensemble forecast verification on IBM-SP
c     ----------- ECMWF Ensemble Forecasts Version -------------------
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
c      Consider T12Z components and first 10 members only
c       Modified by Yuejian Zhu 10/18/00
c
      program VRFYEN
      parameter (ihmax=408,imem=11,imemp1=imem+1,imemp4=imem+4)

      dimension agrid(144,73),fgrid(144,73,imem)
      dimension dgrid(144,73,7),pgrid(144,73,imem)
      dimension cor(3,4,imemp4),rms(3,4,imemp4),acwt(73)
      dimension fcor(3,4,13),frms(3,4,13),irel(imem),rel(imem,3)
      dimension ir10(10),r10(10,3)
      dimension xrms(144,73),rel5(5,3),acwta(3)
      dimension en(imem),it(imemp1,4),fit(imemp1,3,4),fitavg(imemp1,3)
      dimension fit10(11,3)
      dimension jk(imem),it1(imemp1),it2(11),ikk(2)
      dimension spr(4),sprf(4,3),f14avg(15,3)
      dimension kdate(100),igrp(2)

      character*5  chem(3),clab(7),flab(7)
      character*80 cfiles(2,30)
      character*80 cpgba,cpgia,cpgbf,cpgif,cpgbp,cpgip                     

      namelist/files/ cfiles
      namelist/namin/ nhours,ilv,icoeff,iclim,kdate

      data ikk  /12,11/
      data igrp /11,10/
      data chem /'N Hem','S Hem','Trop.'/
C--------+---------+----------+---------+----------+---------+---------+--
      data clab/' CTL ','12Zpa','11tsa','10tms','11tms','10Med','11Med'/
      data flab/'T11  ','T11+1','T10  ','T10+1','R11  ','R10  ','Sg2  '/

      open(unit=81,file='scores.ens',err=1020)
      open(unit=82,file='rmserr.ens',form='unformatted',
     &     status='unknown',err=1020)
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
      if (nhours.gt.ihmax) nhours = 240
      iunit = nhours/24 + 1
c ----
      do ii = 1, iunit                  ! main loop to run each forecasts
       fcor     = 9.9999
       frms     = 9999.99
       jcon     = ii   
       fit      = 0.0
       rel      = 0.0
       r10      = 0.0
       sprf     = 0.0
       ifhr     = (ii-1)*24
       ifhr24   = ifhr - 24 
       ndate    = kdate(ii+2)
       jdate    = kdate(2)
       jdat1    = kdate(1)
       cpgba    = cfiles(1,ii+2)
       cpgia    = cfiles(2,ii+2)
       cpgbf    = cfiles(1,1)
       cpgif    = cfiles(2,1)
       cpgbp    = cfiles(1,2)
       cpgip    = cfiles(2,2)
       ifld     = 7
c ----
c get analysis and forecasting data
c ----
       print *, '------  Analysis for current 12Z ------'
       call getanl(agrid,cpgba,cpgia,ifld,ilev,ndate,0)
       print *, '------  Forcasts for current 12Z only ------'
       call getgrb(fgrid,cpgbf,cpgif,ifld,ilev,jdate,ifhr,15)
c ----
c to calculate talagrand histogram and N+1 distribution
c ----
       xrms = 0.0
       acwt = 0.0 
       acwf = 0.0
       do lat = 1, 73                   ! do loop for each latitude     
c ----
c calculate the weight for each latitude
c ----
        weight   = sin( (lat-1) * 2.5 * 3.1415926 / 180.0 )
        acwt(lat)= weight                                   

        do lon = 1, 144                  ! do loop for each longitude    

         do im = 1, imem                 ! 11 ensemble members
          en(im) = fgrid(lon,lat,im)
         enddo
         an      = agrid(lon,lat)
c ----
c en --> forecast
c an --> analysis
c     ave ---> 11 members average
c     xmed --> the medium of 11 members
c ----
         call talagr(11,10,en,an,it2,ave,xmed10,pijk,ir10,jcon)           
         call talagr(11,11,en,an,it1,ave,xmed11,prms,irel,jcon)
c ----
c to calculate the rms for initial perturbation
c ----
         if (ii.le.1) then
          xrms(lon,lat) = xrms(lon,lat) + prms 
         endif
c ----
         do kk=1,12
          it(kk,1) = it1(kk)
         enddo
         do kk=1,11
          it(kk,2) = it2(kk)
         enddo

c ----
c average and medium
c ----

         dgrid(lon,lat,2) = xmed11       ! 11 members
         dgrid(lon,lat,4) = xmed10       ! 10 members 

c ----
c spread
c ----
         call spread(11,en,ave,spr2,2)   ! 10 members
         dgrid(lon,lat,3) = ave          ! 10 members
         call spread(11,en,ave,spr1,1)   ! 11 members
         dgrid(lon,lat,1) = ave          ! 11 members
         spr(1) = spr1
         spr(2) = spr2
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
         do i = 1, 2
          do kk = 1, ikk(i)
           fit(kk,jj,i) = fit(kk,jj,i) + it(kk,i)*weight/144.0
          enddo
         enddo

         do kk = 1, 11
          rel(kk,jj)   = rel(kk,jj)  + irel(kk)*weight/144.0
         enddo

         do kk = 1, 10
          r10(kk,jj)   = r10(kk,jj)  + ir10(kk)*weight/144.0
         enddo

         do kk = 1, 2
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
       do i = 1, 2
        do kk = 1, ikk(i)
         do jj = 1,3
          fit(kk,jj,i)=fit(kk,jj,i)*100.0/acwta(jj)
         enddo
        enddo
       enddo
       do kk = 1, imem
        do jj = 1, 3
         rel(kk,jj) = rel(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 10   
        do jj = 1, 3
         r10(kk,jj) = r10(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 2
        do jj = 1, 3
         sprf(kk,jj) = sqrt(sprf(kk,jj)/float(igrp(kk)-1)/acwta(jj))
        enddo
       enddo
       print *, '------ Forcasts for  24 hours after 12Z ------ '
       call getgrb(pgrid,cpgbp,cpgip,ifld,ilev,jdat1,ifhr24,10)
       call fptala(fgrid,pgrid,11,11,fitavg)
       call fptala(fgrid,pgrid,10,10,fit10)   ! T12Z 10 members
c ----
c to calculate amomaly corrlation and rms error
c ----
       do im=1,imem
        call states(agrid,fgrid(1,1,im),ifld,ilev,jdate,cor(1,1,im),
     *               rms(1,1,im),icoeff,iclim)
       enddo
       do im=1,4
        call states(agrid,dgrid(1,1,im),ifld,ilev,jdate,
     *              cor(1,1,imem+im),rms(1,1,imem+im),icoeff,iclim)
       enddo
c ----
c output scores cor(3,4,22),rms(3,4,22) 
c        1. ECMWF Ctr    12Z scores
c     2-11. 5 pairs      12Z scores
c       12. Mean   11m       scores
c       13. Medium 11m       scores
c       14. Mean   10m       scores
c       15. Medium 10m       scores          
c convert to fcor and frms 
c        1. ECMWF Ctr    12Z scores
c        2. 10 members scores mean 
c        3. 11 members scores mean ( diff. from mean scores )
c        4. 10 members mean scores
c        5. 11 members mean scores ( totally )
c        6. 10 members Medium scores
c        7. 11 members Medium Scores
c ----
        fcor=0.0
        frms=0.0
c
c         For tropical region:
c             anhw = sum(acwt(29--37))
c             ashw = 1.0 - anhw
c ----
        anhw = ((acwta(3)-1.0)/2.0 + 1.0)/acwta(3)
        print *, 'anhw=',anhw
        ashw = 1.0 - anhw
        do jj = 1, 4
         do kk = 1,3
          fcor(kk,jj,1) = cor(kk,jj,1)
          frms(kk,jj,1) = rms(kk,jj,1)
          fcor(kk,jj,4) = cor(kk,jj,14)
          frms(kk,jj,4) = rms(kk,jj,14)
          fcor(kk,jj,5) = cor(kk,jj,12)
          frms(kk,jj,5) = rms(kk,jj,12)
          fcor(kk,jj,6) = cor(kk,jj,15)
          frms(kk,jj,6) = rms(kk,jj,15)
          fcor(kk,jj,7) = cor(kk,jj,13)
          frms(kk,jj,7) = rms(kk,jj,13)
         enddo
        enddo
c ---- 2. 5 pairs      12Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 2, 11
           fcor(kk,jj,2) = fcor(kk,jj,2) + cor(kk,jj,mm)/10.0
           frms(kk,jj,2) = frms(kk,jj,2) + rms(kk,jj,mm)/10.0
          enddo
         enddo
        enddo
c ---- 3. 11 members ( totally ) scores mean
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 1, 11
           fcor(kk,jj,3) = fcor(kk,jj,3) + cor(kk,jj,mm)/float(imem)
           frms(kk,jj,3) = frms(kk,jj,3) + rms(kk,jj,mm)/float(imem)
          enddo
         enddo
        enddo

c ----
c write out scores 
c ----
c--------+---------+---------+---------+---------+---------+---------+--
c ---- N Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,200) ilev,kdate(ii+2),jdate
       print *, ' Anomaly Correlation For N Hemisphere at Valid Time ',
     &          kdate(ii+2)
       do jj = 1, 7    
        write(*,201)  clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
       enddo
       write(81,221) clab(2), (cor(1,4,jj),jj=2,11)
       write(81,222) clab(2), (rms(1,1,jj),jj=2,11)
c--------+---------+---------+---------+---------+---------+---------+--
c ---- S Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,202) ilev,kdate(ii+2),jdate
       print *, ' Anomaly Correlation For S Hemisphere at Valid Time ',
     &          kdate(ii+2)
       do jj = 1, 7    
        write(*,201)  clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
       enddo
       write(81,221) clab(2), (cor(2,4,jj),jj=2,11)
       write(81,222) clab(2), (rms(2,1,jj),jj=2,11)
c--------+---------+---------+---------+---------+---------+---------+--
c ---- Tropical
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,217) ilev,kdate(ii+2),jdate
       print *, ' Anomaly Correlation For Tropical at Valid Time ',
     &          kdate(ii+2)
       do jj = 1, 7   
        write(*,201)  clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
       enddo
       write(81,221) clab(2), (cor(3,4,jj),jj=2,11)
       write(81,222) clab(2), (rms(3,1,jj),jj=2,11)
c ----
       write(81,211) ilev,kdate(ii+2)
       print *, ' N+1 Contains Distrib. from Analysis at Valid Time ',
     &          kdate(ii+2)
c ----                
       if (ii.eq.1) then
        fitavg = 0.0
        fit10  = 0.0
       endif
       do i = 1, 3
        write(*,215)   chem(i)
        write(*,212)   flab(1),(fit(j,i,1),j=1,12)
        write(*,212)   flab(2),(fitavg(j,i),j=1,12)
        write(*,212)   flab(3),(fit(j,i,2),j=1,11)
        write(*,212)   flab(4),(fit10(j,i),j=1,11)
        write(*,212)   flab(5),(rel(j,i),j=1,11)
        write(*,212)   flab(6),(r10(j,i),j=1,10)
        write(*,212)   flab(7),(sprf(j,i),j=1,2)
        write(81,215)   chem(i)
        write(81,212)   flab(1),(fit(j,i,1),j=1,12)
        write(81,212)   flab(2),(fitavg(j,i),j=1,12)
        write(81,212)   flab(3),(fit(j,i,2),j=1,11)
        write(81,212)   flab(4),(fit10(j,i),j=1,11)
        write(81,212)   flab(5),(rel(j,i),j=1,11)
        write(81,212)   flab(6),(r10(j,i),j=1,10)
        write(81,212)   flab(7),(sprf(j,i),j=1,2)
       enddo
c
      enddo                              ! end loop for main do loop ii   
c
 200  format(' Anomaly Corr. For N Hem. ',
     .       i4,' mb at Valid Time ',i10,' (ini. ',i10,')')
 202  format(' Anomaly Corr. For S Hem. ',
     .       i4,' mb at Valid Time ',i10,' (ini. ',i10,')')
 201  format(a5,4(f8.4),4(f9.2))
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
 222  format(a5,10(f7.2))
c ---- finished output
c     write out initial perturbation to unit 82
      do lon=1,144
       do lat=1,73
        xrms(lon,lat) = sqrt(xrms(lon,lat)/14.0)
       enddo
      enddo
      write (82) xrms
 1020 continue
c -----------------------------
      stop
      end
