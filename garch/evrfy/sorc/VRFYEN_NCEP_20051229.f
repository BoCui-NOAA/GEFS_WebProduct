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
c      To modify for verifying one analysis only
c       Modified by Yuejian Zhu 01/14/03  
c
c
      program VRFYEN
      parameter (ihmax=408,imem=23,imemp1=imem+1,imemp7=imem+7)

      dimension agrid(144,73),ogrid(144,73),fgrid(144,73,imem)
      dimension dgrid(144,73,7),pgrid(144,73,imem)
      dimension cor(3,4,imemp7),rms(3,4,imemp7),acwt(73)
      dimension fcor(3,4,13),frms(3,4,13),irel(imem),rel(imem,3)
      dimension ir101(10),r101(10,3),ir102(10),r102(10,3),ir20(20)
      dimension xrms(144,73),rel5(5,3),acwta(3)
      dimension en(imem),it(imemp1,4),fit(imemp1,3,4),fitavg(imemp1,3)
      dimension fit101(11,3),fit102(11,3)
      dimension jk(imem),it1(imemp1),it2(11),it3(11),it4(21),ikk(4)
      dimension spr(4),sprf(4,3),f14avg(15,3)
      dimension kdate(4,100),igrp(4)

      character*5  chem(3),clab(13),flab(12)
      character*80 cfiles(6,100)
      character*80 cpgba,cpgia,cpgbf,cpgif,cpgbp,cpgip                     

      namelist/files/ cfiles
      namelist/namin/ nhours,ilv,icoeff,iclim,ndate,kdate

      data ikk  /24,11,11,21/
      data igrp /23,10,10,20/
      data chem /'N Hem','S Hem','Trop.'/
C--------+---------+----------+---------+----------+---------+---------+--
      data clab/' MRF ',' CTL ','00Zpa',' AVN ','12Zpa','23tsa','00Zap',
     &           '12Zap','20ems','23tms','23Med','00Med','12Med'/
      data flab/'T23  ','T+1  ','T1000','T10+1','T1012','T10+1','T20  ',
     &           'R23  ','Rs5  ','R1000','R1012','Sg4  '/

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
      iunit = nhours/12 + 1
c ----
c     do ii = 2, iunit                  ! main loop to run each forecasts
      do ii = 1, iunit                  ! main loop to run each forecasts
       fcor     = 9.9999
       frms     = 9999.99
       jcon     = ii   
       fit      = 0.0
       rel      = 0.0
       r101     = 0.0
       r102     = 0.0
       sprf     = 0.0
       ifhr     = (ii-1)*12
       ifhr24   = ifhr - 24 
       ndate    = ndate      
       jdate    = kdate(3,ii)
       mdate    = kdate(4,ii)
       jdat1    = kdate(1,ii)
       mdat1    = kdate(2,ii)
       cpgba    = cfiles(1,1)
       cpgia    = cfiles(2,1)
       cpgbf    = cfiles(3,ii)
       cpgif    = cfiles(4,ii)
       cpgbp    = cfiles(5,ii)
       cpgip    = cfiles(6,ii)
       ifld     = 7
c ----
c get analysis and forecasting data
c ----
       print *, '------  Analysis for current 00Z, 12Z ------'
       call getanl(agrid,cpgba,cpgia,ifld,ilev,ndate,0)
       print *, '------  Forcasts for current 00Z, 12Z ------'
       call getgrb(fgrid,cpgbf,cpgif,ifld,ilev,jdate,mdate,ifhr,11)
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

         do im = 1, imem                 ! 23 ensemble members
          en(im) = fgrid(lon,lat,im)
         enddo
         an      = agrid(lon,lat)
c ----
c en --> forecast
c an --> analysis
c     ave ---> 23 members average
c     xmed --> the medium of 23 members
c ----
         call talagr(23,10,en,an,it2,ajk,xmed00,pjk,ir101,101)           
         call talagr(23,10,en,an,it3,ajk,xmed12,pjk,ir102,102)           
         call talagr(23,20,en,an,it4,ajk,xjk,pjk,ir20,0)           
         call talagr(23,23,en,an,it1,ave,xmed,prms,irel,jcon)
c ----
c to calculate the rms for initial perturbation
c       ii=1 for -12 hours, ii=2 for 00 hours
c ----
         if (ii.le.2) then
          xrms(lon,lat) = xrms(lon,lat) + prms 
         endif
c ----
         do kk=1,24
          it(kk,1) = it1(kk)
         enddo
         do kk=1,11
          it(kk,2) = it2(kk)
         enddo
         do kk=1,11
          it(kk,3) = it3(kk)
         enddo
         do kk=1,21
          it(kk,4) = it4(kk)
         enddo

c ----
c average and medium
c ----

         dgrid(lon,lat,2) = xmed         ! 23 members
         dgrid(lon,lat,6) = xmed00       ! 1st 10 members (00Z)
         dgrid(lon,lat,7) = xmed12       ! 2nd 10 members (12Z)

         call fgroup(23,en,gave,2)       ! 1st 10 members
         dgrid(lon,lat,3) = gave
         call fgroup(23,en,gave,5)       ! 2nd 10 members
         dgrid(lon,lat,4) = gave
         call fgroup(23,en,gave,6)       ! 10 +10 members
         dgrid(lon,lat,5) = gave

c ----
c spread
c ----
         call spread(23,en,ave,spr4,7)   ! 10 +10 members
         call spread(23,en,ave,spr3,6)   ! 2nd 10 members
         call spread(23,en,ave,spr2,3)   ! 1st 10 members
         call spread(23,en,ave,spr1,5)   ! 23 members

         dgrid(lon,lat,1) = ave          ! 23 members
         spr(1) = spr1
         spr(2) = spr2
         spr(3) = spr3
         spr(4) = spr4
c ----
CCC
CCC Notes: We found a problem since beginning:
CCC        for tropical: jj = 3
CCC        lat=29 and lat=45 are never add in
CCC        but it count as final average
CCC        --- we will make changes --- 08/09/2000
CCC
         if ( lat.ge.6.and.lat.le.29 ) then
          jj = 1
          goto 2010
         elseif ( lat.ge.45.and.lat.le.68 ) then
          jj = 2
          goto 2010
C        elseif ( lat.ge.29.and.lat.le.45 ) then
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

         do kk = 1, 23
          rel(kk,jj)   = rel(kk,jj)   + irel(kk)*weight/144.0
         enddo

         do kk = 1, 10
          r101(kk,jj)   = r101(kk,jj)   + ir101(kk)*weight/144.0
          r102(kk,jj)   = r102(kk,jj)   + ir102(kk)*weight/144.0
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
C      do kk = 1, 17
C       acwta(3) = acwta(3) + acwt(kk+28)
C      enddo
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
       do kk = 1, imem
        do jj = 1, 3
         rel(kk,jj) = rel(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 10
        do jj = 1, 3
         r101(kk,jj) = r101(kk,jj)*100.0/acwta(jj)/2.0
         r102(kk,jj) = r102(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 4
        do jj = 1, 3
CCC modified by Yuejian Zhu at 08/04/99
c        sprf(kk,jj) = sqrt(sprf(kk,jj)/float(igrp(kk))/acwta(jj))
         sprf(kk,jj) = sqrt(sprf(kk,jj)/float(igrp(kk)-1)/acwta(jj))
        enddo
       enddo
        print *, '------ Forecasts for  24 hours after 00Z, 12Z ------ '
        call getgrb(pgrid,cpgbp,cpgip,ifld,ilev,jdat1,mdat1,ifhr24,10)
c       call fptala(fgrid,pgrid,14,14,f14avg)
        call fptala(fgrid,pgrid,10,101,fit101)   ! T00Z 10 members
        call fptala(fgrid,pgrid,23,23,fitavg)
        call fptala(fgrid,pgrid,10,102,fit102)   ! T12Z 10 members
c ----
c to calculate the outliers and distances
c ----
Cc       ii.ge.4 --> start lead time is 24 hours
C        if (ilev.eq.500) then
C        if (ii.ge.4.or.ii.lt.16) then
C         call outlie(agrid,fgrid,pgrid,23,ogrid)
Cc        do lon = 1, 144
C         do lon = 40,49 
C         write (*,'(i3,10(f7.1))') lon,(ogrid(lon,lat),lat=18,27)
C         enddo
C         call putgrb(ogrid,ilev,9,jdate,ifhr)
C         call putgrb(agrid,ilev,7,ndate,0)
C        endif
C        endif
c ----
c to calculate amomaly corrlation and rms error
c ----
        do im=1,imem
         call states(agrid,fgrid(1,1,im),ifld,ilev,jdate,cor(1,1,im),
     *               rms(1,1,im),icoeff,iclim)
        enddo
        do im=1,7
         call states(agrid,dgrid(1,1,im),ifld,ilev,jdate,
     *               cor(1,1,imem+im),rms(1,1,imem+im),icoeff,iclim)
        enddo
c ----
c output scores cor(3,4,22),rms(3,4,22) 
c        1. MRF ( T126 ) 00Z scores
c        2. MRFZ ( T62 ) 00Z scores
c     3-12. 5 pairs      00Z scores
c       13. AVN ( T126 ) 12Z scores
c    14-23. 5 pairs      12Z scores
c       24. Mean or average  scores
c       25. Medium (23m)     scores
c       26. First 10 members scores
c       27. Second10 members scores
c       28. 10 + 10  members scores          
c       29. Medium first  10 scores          
c       30. Medium second 10 scores          
c convert to fcor and frms 
c        1. MRF ( T126 ) 00Z scores
c        2. MRFZ ( T62 ) 00Z scores
c        3. 5 pairs      00Z scores
c        4. AVN ( T126 ) 12Z scores
c        5. 5 pairs      12Z scores
c        6. 23 members scores mean ( diff. from mean scores )
c        --------------------------
c        7. First 10 members mean scores
c        8. Second10 members mean scores
c        9. 10 + 10  members mean scores ( pertubation only )
c       10. 23 members mean scores ( totally )
c       11. 23 members Medium scores
c       12. First 10 members Medium Scores
c       13. Second10 members Medium Scores
c ----
c       if (ii.eq.1) then
c        fcor=9.9999
c        frms=9999.99
c       else
c        fcor=0.0
c        frms=0.0
c       endif
c ----
c ---- 1. MRF ( T126 ) 00Z scores
c ---- 2. MRFZ ( T62 ) 00Z scores
c ---- 4. AVN ( T126 ) 12Z scores
c ---- 7. First 10 members mean scores
c ---- 8. Second10 members mean scores
c ---- 9. 10 + 10  members mean scores ( pertubation only )
c ----10. 23 members mean scores ( totally )
c ----11. 23 members Medium scores
c ----12. 10 members Medium scores (T00Z)
c ----13. 10 members Medium scores (T12Z)
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
          fcor(kk,jj,2) = cor(kk,jj,2)
          frms(kk,jj,2) = rms(kk,jj,2)
          fcor(kk,jj,4) = cor(kk,jj,13)
          frms(kk,jj,4) = rms(kk,jj,13)
          fcor(kk,jj,7) = cor(kk,jj,26)
          frms(kk,jj,7) = rms(kk,jj,26)
          fcor(kk,jj,8) = cor(kk,jj,27)
          frms(kk,jj,8) = rms(kk,jj,27)
          fcor(kk,jj,9) = cor(kk,jj,28)
          frms(kk,jj,9) = rms(kk,jj,28)
          fcor(kk,jj,10)= cor(kk,jj,24)
          frms(kk,jj,10)= rms(kk,jj,24)
          fcor(kk,jj,11)= cor(kk,jj,25)
          frms(kk,jj,11)= rms(kk,jj,25)
          fcor(kk,jj,12)= cor(kk,jj,29)
          frms(kk,jj,12)= rms(kk,jj,29)
          fcor(kk,jj,13)= cor(kk,jj,30)
          frms(kk,jj,13)= rms(kk,jj,30)
         enddo
        enddo
c ---- 3. 5 pairs      00Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          fcor(kk,jj,3) = 0.0
          frms(kk,jj,3) = 0.0
          ngood = 0
          do mm = 3, 12
           if (cor(kk,jj,mm).ne.9.9999) then
            ngood = ngood + 1
            fcor(kk,jj,3) = fcor(kk,jj,3) + cor(kk,jj,mm)
            frms(kk,jj,3) = frms(kk,jj,3) + rms(kk,jj,mm)
           endif
          enddo
          if ( ngood.ne.0 ) then
           fcor(kk,jj,3) = fcor(kk,jj,3)/float(ngood)
           frms(kk,jj,3) = frms(kk,jj,3)/float(ngood)
          endif
         enddo
        enddo
c ---- 5. 5 pairs      12Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          fcor(kk,jj,5) = 0.0 
          frms(kk,jj,5) = 0.0 
          ngood = 0
          do mm = 14, imem
           if (cor(kk,jj,mm).ne.9.9999) then
            ngood = ngood + 1
            fcor(kk,jj,5) = fcor(kk,jj,5) + cor(kk,jj,mm)
            frms(kk,jj,5) = frms(kk,jj,5) + rms(kk,jj,mm)
           endif
          enddo
          if ( ngood.ne.0 ) then
           fcor(kk,jj,5) = fcor(kk,jj,5)/float(ngood)
           frms(kk,jj,5) = frms(kk,jj,5)/float(ngood)
          endif
         enddo
        enddo
c      if (ii.gt.1) then
c ---- 6. 23 members ( totally ) scores mean
        do jj = 1, 4
         do kk = 1, 3  
          fcor(kk,jj,6) = 0.0
          frms(kk,jj,6) = 0.0
          ngood = 0
          do mm = 1, imem
           if (cor(kk,jj,mm).ne.9.9999) then
            ngood = ngood + 1
            fcor(kk,jj,6) = fcor(kk,jj,6) + cor(kk,jj,mm)
            frms(kk,jj,6) = frms(kk,jj,6) + rms(kk,jj,mm)
           endif
          enddo
          if ( ngood.ne.0 ) then
           fcor(kk,jj,6) = fcor(kk,jj,6)/float(ngood)
           frms(kk,jj,6) = frms(kk,jj,6)/float(ngood)
          endif
         enddo
        enddo
c      endif

       rel5 = 0.0
       do jj = 1, 3
        rel5(1,jj) = rel(1,jj)    ! relative to MRF
        rel5(2,jj) = rel(2,jj)    ! relative to MRZ
        rel5(4,jj) = rel(13,jj)   ! relative to AVN
        do kk = 1, 10             ! relative to 00Z 10 members
         rel5(3,jj) = rel5(3,jj) + rel(kk+2,jj)/10.0
        enddo
        do kk = 1, 10             ! relative to 12Z 10 members
c        rel5(5,jj) = rel5(5,jj) + rel(kk+13,jj)/4.0
         rel5(5,jj) = rel5(5,jj) + rel(kk+13,jj)/10.
        enddo
       enddo
c ----
c write out scores 
c ----
c--------+---------+---------+---------+---------+---------+---------+--
c ---- N Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,200) ilev,ndate,jdate
       print *, ' Anomaly Correlation For N Hemisphere at Valid Time ',
     &          nadte       
       do jj = 1, 13    
        write(*,201)  clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
       enddo
       write(81,221) clab(3), (cor(1,4,jj),jj=3,12)
       write(81,221) clab(5), (cor(1,4,jj),jj=14,23)
       write(81,222) clab(3), (rms(1,1,jj),jj=3,12)
       write(81,222) clab(5), (rms(1,1,jj),jj=14,23)
c--------+---------+---------+---------+---------+---------+---------+--
c ---- S Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,202) ilev,ndate,jdate
       print *, ' Anomaly Correlation For S Hemisphere at Valid Time ',
     &          ndate       
       do jj = 1, 13    
        write(*,201)  clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
       enddo
       write(81,221) clab(3), (cor(2,4,jj),jj=3,12)
       write(81,221) clab(5), (cor(2,4,jj),jj=14,23)
       write(81,222) clab(3), (rms(2,1,jj),jj=3,12)
       write(81,222) clab(5), (rms(2,1,jj),jj=14,23)
c--------+---------+---------+---------+---------+---------+---------+--
c ---- Tropical
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,217) ilev,ndate,jdate
       print *, ' Anomaly Correlation For Tropical at Valid Time ',
     &          ndate
       do jj = 1, 13   
        write(*,201)  clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
       enddo
       write(81,221) clab(3), (cor(3,4,jj),jj=3,12)
       write(81,221) clab(5), (cor(3,4,jj),jj=14,23)
       write(81,222) clab(3), (rms(3,1,jj),jj=3,12)
       write(81,222) clab(5), (rms(3,1,jj),jj=14,23)
c ----
       write(81,211) ilev,ndate
       print *, ' N+1 Contains Distrib. from Analysis at Valid Time ',
     &          ndate
c ----                
c      if (ii.eq.1) then
c       fit    = 0.0
c       fitavg = 0.0
c       f14avg = 0.0
c       fit101 = 0.0
c       fit102 = 0.0
c       rel    = 0.0
c       rel5   = 0.0
c       sprf   = 0.0
c      endif
       do i = 1, 3
        write(*,215)   chem(i)
        write(*,212)   flab(1),(fit(j,i,1),j=1,12)
        write(*,212)   flab(1),(fit(j,i,1),j=13,24)
        write(*,212)   flab(2),(fitavg(j,i),j=1,12)
        write(*,212)   flab(2),(fitavg(j,i),j=13,24)
        write(*,212)   flab(3),(fit(j,i,2),j=1,11)
        write(*,212)   flab(4),(fit101(j,i),j=1,11)
        write(*,212)   flab(5),(fit(j,i,3),j=1,11)
        write(*,212)   flab(6),(fit102(j,i),j=1,11)
        write(*,212)   flab(7),(fit(j,i,4),j=1,12)
        write(*,212)   flab(7),(fit(j,i,4),j=13,21)
        write(*,212)   flab(8),(rel(j,i),j=1,12)
        write(*,212)   flab(8),(rel(j,i),j=13,23)
        write(*,212)   flab(9),(rel5(j,i),j=1,5)
        write(*,212)   flab(10),(r101(j,i),j=1,10)
        write(*,212)   flab(11),(r102(j,i),j=1,10)
        write(*,212)   flab(12),(sprf(j,i),j=1,4)
        write(81,215)   chem(i)
        write(81,212)   flab(1),(fit(j,i,1),j=1,12)
        write(81,212)   flab(1),(fit(j,i,1),j=13,24)
        write(81,212)   flab(2),(fitavg(j,i),j=1,12)
        write(81,212)   flab(2),(fitavg(j,i),j=13,24)
        write(81,212)   flab(3),(fit(j,i,2),j=1,11)
        write(81,212)   flab(4),(fit101(j,i),j=1,11)
        write(81,212)   flab(5),(fit(j,i,3),j=1,11)
        write(81,212)   flab(6),(fit102(j,i),j=1,11)
        write(81,212)   flab(7),(fit(j,i,4),j=1,12)
        write(81,212)   flab(7),(fit(j,i,4),j=13,21)
        write(81,212)   flab(8),(rel(j,i),j=1,12)
        write(81,212)   flab(8),(rel(j,i),j=13,23)
        write(81,212)   flab(9),(rel5(j,i),j=1,5)
        write(81,212)   flab(10),(r101(j,i),j=1,10)
        write(81,212)   flab(11),(r102(j,i),j=1,10)
        write(81,212)   flab(12),(sprf(j,i),j=1,4)
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
      call baclose(61,iret)
      stop
      end
