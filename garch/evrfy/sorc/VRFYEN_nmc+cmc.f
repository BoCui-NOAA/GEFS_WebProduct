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
c                     imem   ---> forecasting members ( NCEP are 17 members )
c
c
c      Fortran 77 on Cray ====== coded by Yuejian Zhu 07/15/95
c
c
      program VRFYEN
      parameter       (ihmax=408,imem=17,imemp5=imem+5)
      dimension       agrid(144,73),fgrid(144,73,imem)
      dimension       dgrid(144,73,5),pgrid(144,73,imem)
      dimension       cor(3,4,imemp5),rms(3,4,imemp5),acwt(73)
      dimension       fcor(3,4,11),frms(3,4,11),irel(imem),rel(imem,3)
      dimension       xrms(144,73),rel5(5,3),acwta(3)
      dimension       en(17),it(18,4),fit(18,3,4),fitavg(18,3)
      dimension       jk(17),it1(18),it2(9),it3(11),it4(15),ikk(5)
      dimension       spr(4),sprf(4,3),f16avg(17,3),f10avg(11,3)
      dimension       kdate(100),igrp(4)
      double precision          randm(16),seed
      dimension       indx(16)
      character*5     chem(3),clab(11),flab(9)
      character*80    cfiles(2,3)
      character*80    cpgba,cpgia,cpgbf,cpgif,cpgbp,cpgip                     
      namelist/files/ cfiles
      namelist/namin/ nhours,ilv,icoeff,iclim,kdate
      data ikk  /18,9,11,15,18/
      data igrp /17,8,10,14/
      data chem /'N Hem','S Hem','Trop.'/
      data clab /' CTL ',' 4pA ',' 4pB ',' 5pr ',' 16pa',
     &           '17tsa',' 8ems','10ems','16ems','17tms','Meds '/
      data flab /'T17  ','T+1  ','T10  ','T+1  ','T16  ','T+1  ',
     &           'R17  ','Rs5  ','Sg4  '/
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
c ----
c to generate a random order by using random seed generater
c ----
c     seed=kdate(1)
c     print *, seed
c     call durand(seed,16,randm)
c     call isortx(randm,1,16,indx)
c     write(*,'(16i4)') (indx(i),i=1,16)
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
       frms     = 9999.99
       jcon     = ii   
       fit      = 0.0
       rel      = 0.0
       sprf     = 0.0
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
       call getgrb(fgrid,cpgbf,cpgif,ifld,ilev,jdate,ifhr,11)
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
         en(1) = fgrid(lon,lat,1)
         do im = 2, 17
c         en(im) = fgrid(lon,lat,indx(im-1)+1)
          en(im) = fgrid(lon,lat,im)
         enddo
         an      = agrid(lon,lat)
c ----
c en --> forecast
c an --> analysis
c     ave ---> 17 members average
c     xmed --> the medium of 17 members
c ----
         call talagr(17,8,en,an,it2,ajk,xjk,pjk,jk,0)           
         call talagr(17,10,en,an,it3,ajk,xjk,pjk,jk,0)           
         call talagr(17,16,en,an,it4,ajk,xjk,pjk,jk,0)           
         call talagr(17,17,en,an,it1,ave,xmed,prms,irel,jcon)
c ----
c to calculate the rms for initial perturbation
c       ii=1 for -12 hours, ii=2 for 00 hours
c ----
         if (ii.le.2) then
          xrms(lon,lat) = xrms(lon,lat) + prms 
         endif
c ----
         do kk=1,18
          it(kk,1) = it1(kk)
         enddo
         do kk=1,9
          it(kk,2) = it2(kk)
         enddo
         do kk=1,11
          it(kk,3) = it3(kk)
         enddo
         do kk=1,15
          it(kk,4) = it4(kk)
         enddo
c        dgrid(lon,lat,1) = ave
         dgrid(lon,lat,2) = xmed
c ----
c     gave --> first 8 members of 00Z pertubation run
c ----
         igcon=1
         call fgroup(17,en,gave,1)
         dgrid(lon,lat,3) = gave
c ----
c     gave --> first 10 members of 00Z pertubation run
c ----
         call fgroup(17,en,gave,2)
         dgrid(lon,lat,4) = gave
c ----
c     gave --> total 16 members of pertubation run
c ----
         call fgroup(17,en,gave,3)
         dgrid(lon,lat,5) = gave
c ----
c spread
c ----
         call spread(17,en,ave,spr4,4)
         call spread(17,en,ave,spr3,3)
         call spread(17,en,ave,spr2,2)
         call spread(17,en,ave,spr1,1)
         dgrid(lon,lat,1) = ave
         spr(1)=spr1
         spr(2)=spr2
         spr(3)=spr3
         spr(4)=spr4
c ----
         if ( lat.ge.6.and.lat.le.29 ) then
          jj = 1
          goto 2010
         elseif ( lat.ge.45.and.lat.le.68 ) then
          jj = 2
          goto 2010
c ---- Note: changed 08/09/2000
c        elseif ( lat.ge.29.and.lat.le.45 ) then
         elseif ( lat.gt.29.and.lat.lt.45 ) then
          jj = 3
          goto 2010
         else
          goto 2020
         endif
 2010 continue
         do i = 1, 4
          do kk = 1, ikk(i)
           fit(kk,jj,i) = fit(kk,jj,i) + it(kk,i)*weight/144.0
          enddo
         enddo
         do kk = 1, 17
           rel(kk,jj)   = rel(kk,jj)   + irel(kk)*weight/144.0
         enddo
         do kk = 1, 4
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
c ---- Notes: changed 08/09/2000
c      do kk = 1, 17
c       acwta(3) = acwta(3) + acwt(kk+28)
c      enddo
       do kk = 1, 15
        acwta(3) = acwta(3) + acwt(kk+29)
       enddo
       do i = 1, 4
        do kk = 1, ikk(i)
         do jj = 1,3
          fit(kk,jj,i)=fit(kk,jj,i)*100.0/acwta(jj)
         enddo
        enddo
       enddo
       do kk = 1, 17
        do jj = 1, 3
         rel(kk,jj) = rel(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 4
        do jj = 1, 3
CCC modified by Yuejian Zhu at 08/04/99
c        sprf(kk,jj) = sqrt(sprf(kk,jj)/float(igrp(kk))/acwta(jj))
         sprf(kk,jj) = sqrt(sprf(kk,jj)/float(igrp(kk)-1)/acwta(jj))
        enddo
       enddo
        print *, '------ Forcasts for  24 hours after 00Z, 12Z ------ '
        call getgrb(pgrid,cpgbp,cpgip,ifld,ilev,jdat1,ifhr24,10)
        call fptala(fgrid,pgrid,17,fitavg)
        call fptala(fgrid,pgrid,16,f16avg)
        call fptala(fgrid,pgrid,10,f10avg)
c ----
c to calculate amomaly corrlation and rms error
c ----
        do im=1,17
         call states(agrid,fgrid(1,1,im),ifld,ilev,jdate,cor(1,1,im),
     *               rms(1,1,im),icoeff,iclim)
        enddo
        do im=1,5
         call states(agrid,dgrid(1,1,im),ifld,ilev,jdate,cor(1,1,17+im),
     *               rms(1,1,17+im),icoeff,iclim)
        enddo
c ----
c output scores cor(3,4,22),rms(3,4,22) 
c        1. CTL ( T126 ) 00Z scores
c     2-17. 8 pairs      00Z scores
c       18. Mean or average scores.
c       19. Medium scores
c       20. First  8 members scores
c       21. First 10 members scores
c       22. 16 members ( pertubation only )
c convert to fcor and frms 
c        1. MRF ( T126 ) 00Z scores
c        2. 4 pairs a    00Z scores
c        3. 4 pairs b    00Z scores
c        4. 5 pairs      00Z scores
c        5. 8 pairs      00Z scores
c        6. 17 members scores mean ( diff. from mean scores )
c        --------------------------
c        7. First  8 members mean scores
c        8. First 10 members mean scores
c        9. 16 members mean scores ( pertubation only )
c       10. 17 members mean scores ( totally )
c       11. Medium scores
c ----
        if (ii.eq.1) then
         fcor=9.9999
         frms=9999.99
        else
         fcor=0.0
         frms=0.0
        endif
c ----
c ---- 1. MRF ( T126 ) 00Z scores
c ---- 7. First  8 members mean scores
c ---- 8. First 10 members mean scores
c ---- 9. 16 members mean scores ( pertubation only )
c ----10. 17 members mean scores ( totally )
c ----11. Medium scores
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
          fcor(kk,jj,7) = cor(kk,jj,20)
          frms(kk,jj,7) = rms(kk,jj,20)
          fcor(kk,jj,8) = cor(kk,jj,21)
          frms(kk,jj,8) = rms(kk,jj,21)
          fcor(kk,jj,9) = cor(kk,jj,22)
          frms(kk,jj,9) = rms(kk,jj,22)
          fcor(kk,jj,10)= cor(kk,jj,18)
          frms(kk,jj,10)= rms(kk,jj,18)
          fcor(kk,jj,11)= cor(kk,jj,19)
          frms(kk,jj,11)= rms(kk,jj,19)
         enddo
        enddo
c ---- 2. 4 pairs a  T00Z scores 
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 2, 9  
           fcor(kk,jj,2) = fcor(kk,jj,2) + cor(kk,jj,mm)/8.0
           frms(kk,jj,2) = frms(kk,jj,2) + rms(kk,jj,mm)/8.0
          enddo
         enddo
        enddo
c ---- 3. 4 pairs b  T00Z scores 
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 10, 17
           fcor(kk,jj,3) = fcor(kk,jj,3) + cor(kk,jj,mm)/8.0
           frms(kk,jj,3) = frms(kk,jj,3) + rms(kk,jj,mm)/8.0
          enddo
         enddo
        enddo
c ---- 4. 5 pairs     T00Z scores
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 2, 11
           fcor(kk,jj,4) = fcor(kk,jj,4) + cor(kk,jj,mm)/10.0
           frms(kk,jj,4) = frms(kk,jj,4) + rms(kk,jj,mm)/10.0
          enddo
         enddo
        enddo
c ---- 5. 8 pairs     T00Z scores
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 2, 17
           fcor(kk,jj,5) = fcor(kk,jj,5) + cor(kk,jj,mm)/16.0
           frms(kk,jj,5) = frms(kk,jj,5) + rms(kk,jj,mm)/16.0
          enddo
         enddo
        enddo
c ----6. 17 members ( totally )
        do jj = 1, 4
         do kk = 1, 3  
          do mm = 1, 17
           fcor(kk,jj,6) = fcor(kk,jj,6) + cor(kk,jj,mm)/17.0
           frms(kk,jj,6) = frms(kk,jj,6) + rms(kk,jj,mm)/17.0
          enddo
         enddo
        enddo
        rel5 = 0.0
        do jj = 1, 3
         rel5(1,jj) = rel(1,jj)
         rel5(2,jj) = rel(2,jj)
         rel5(4,jj) = rel(13,jj)
         do kk = 1, 10
          rel5(3,jj) = rel5(3,jj) + rel(kk+2,jj)/10.0
         enddo
         do kk = 1, 4
          rel5(5,jj) = rel5(5,jj) + rel(kk+13,jj)/4.0
         enddo
        enddo
c ----
c write out scores 
c ----
c ---- N Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,200) ilev,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For N Hemisphere at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 11    
        write(*,201)  clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
       enddo
       write(81,221) clab(6), (cor(1,4,jj),jj=1,10)
       write(81,221) clab(6), (cor(1,4,jj),jj=11,17)
       write(81,222) clab(6), (rms(1,1,jj),jj=1,10)
       write(81,222) clab(6), (rms(1,1,jj),jj=11,17)
c ---- S Hemisphere
       write(81,202) ilev,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For S Hemisphere at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 11    
        write(*,201)  clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
       enddo
       write(81,221) clab(6), (cor(2,4,jj),jj=1,10)
       write(81,221) clab(6), (cor(2,4,jj),jj=11,17)
       write(81,222) clab(6), (rms(2,1,jj),jj=1,10)
       write(81,222) clab(6), (rms(2,1,jj),jj=11,17)
c ---- Tropical
       write(81,217) ilev,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For Tropical at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 11   
        write(*,201)  clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
       enddo
       write(81,221) clab(6), (cor(3,4,jj),jj=1,10)
       write(81,221) clab(6), (cor(3,4,jj),jj=11,17)
       write(81,222) clab(6), (rms(3,1,jj),jj=1,10)
       write(81,222) clab(6), (rms(3,1,jj),jj=11,17)
c ----
       write(81,211) ilev,kdate(ii+4)
       print *, ' N+1 Contains Distrib. from Analysis at Valid Time ',
     &          kdate(ii+4)
c ----                
       if (ii.eq.1) then
        fit    = 0.0
        fitavg = 0.0
        f16avg = 0.0
        f10avg = 0.0
        rel    = 0.0
        rel5   = 0.0
        sprf   = 0.0
       endif

       do i = 1, 3
        do j = 1, 4
         if (sprf(j,i).gt.99.99) then
          sprf(j,i) = 99.99
         endif
        enddo
       enddo

       do i = 1, 3
        write(*,215)   chem(i)
        write(*,212)   flab(1),(fit(j,i,1),j=1,9)
        write(*,212)   flab(1),(fit(j,i,1),j=10,18)
        write(*,212)   flab(2),(fitavg(j,i),j=1,9)
        write(*,212)   flab(2),(fitavg(j,i),j=10,18)
        write(*,212)   flab(3),(fit(j,i,3),j=1,11)
        write(*,212)   flab(4),(f10avg(j,i),j=1,11)
        write(*,212)   flab(5),(fit(j,i,4),j=1,9)
        write(*,212)   flab(5),(fit(j,i,4),j=10,15)
        write(*,212)   flab(6),(f16avg(j,i),j=1,9)
        write(*,212)   flab(6),(f16avg(j,i),j=10,17)
        write(*,212)   flab(7),(rel(j,i),j=1,9)
        write(*,212)   flab(7),(rel(j,i),j=10,17)
        write(*,212)   flab(8),(rel5(j,i),j=1,5)
        write(*,212)   flab(9),(sprf(j,i),j=1,4)
        write(81,215)   chem(i)
        write(81,212)   flab(1),(fit(j,i,1),j=1,9)
        write(81,212)   flab(1),(fit(j,i,1),j=10,18)
        write(81,212)   flab(2),(fitavg(j,i),j=1,9)
        write(81,212)   flab(2),(fitavg(j,i),j=10,18)
        write(81,212)   flab(3),(fit(j,i,3),j=1,11)
        write(81,212)   flab(4),(f10avg(j,i),j=1,11)
        write(81,212)   flab(5),(fit(j,i,4),j=1,9)
        write(81,212)   flab(5),(fit(j,i,4),j=10,17)
        write(81,212)   flab(6),(f16avg(j,i),j=1,9)
        write(81,212)   flab(6),(f16avg(j,i),j=10,17)
        write(81,212)   flab(7),(rel(j,i),j=1,9)
        write(81,212)   flab(7),(rel(j,i),j=10,17)
        write(81,212)   flab(8),(rel5(j,i),j=1,5)
        write(81,212)   flab(9),(sprf(j,i),j=1,4)
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
