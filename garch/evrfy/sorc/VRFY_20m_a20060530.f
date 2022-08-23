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
c      To modify for verifying 14+control+gfs   
c       Modified by Yuejian Zhu 03/09/06  
c
c
      program VRFYEN
      parameter (ihmax=408,imem=22,imemp1=imem+1,imemp8=imem+8)

      dimension agrid(144,73),ogrid(144,73),fgrid(144,73,imem)
      dimension dgrid(144,73,8),pgrid(144,73,imem)
      dimension cor(3,4,imemp8),rms(3,4,imemp8),acwt(73)
      dimension fcor(3,4,14),frms(3,4,14)
      dimension xrms(144,73),rel5(5,3),acwta(3)
      dimension en(imem),fit(imemp1,3,4),it(imemp1,4)
      dimension ir10(10),ir14(14),ir15(15),ir16(16)
      dimension it10(11),it14(15),it15(16),it16(17)
      dimension fit10(11,3),fit14(15,3),fit15(16,3),fit16(17,3)
      dimension rel10(10,3),rel14(14,3),rel15(15,3),rel16(16,3)
      dimension spr(4),sprf(4,3),dummy(100)
      dimension kdate(4,100),ikk(4)

      character*5  chem(3),clab(16),flab(14)
      character*80 cfiles(6,100)
      character*80 cpgba,cpgbf,cpgbp                     

      namelist/files/ cfiles
      namelist/namin/ nhours,ilv,icoeff,iclim,ndate,kdate

      data ikk  /10,14,15,16/
      data chem /'N Hem','S Hem','Trop.'/
C--------+---------+----------+---------+----------+---------+---------+--
      data clab/' GFS ',' CTL ','10mpa','14mpa','15mpa','16mpa','10map',
     &          '14map','15map','16map','10Med','14Med','15Med','16Med',
     &          '14pac','14rms'/
      data flab/'T10  ','T+1  ','T14  ','T14+1','T15  ','T15+1','T16  ',
     &          'T16+1','R10  ','R14  ','R15  ','R16  ','Rs5  ','Sg4  '/

      dummy=0.0
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
      do ii = 1, iunit                  ! main loop to run each forecasts
       fcor     = 9.9999
       frms     = 9999.99
       jcon     = ii   
       fit      = 0.0
       rel10    = 0.0
       rel14    = 0.0
       rel15    = 0.0
       rel16    = 0.0
       rel5     = 0.0
       sprf     = 0.0
       ifhr     = (ii-1)*12
       ifhr24   = ifhr - 24 
       ndate    = ndate      
       jdate    = kdate(3,ii)
       mdate    = kdate(4,ii)
       jdat1    = kdate(1,ii)
       mdat1    = kdate(2,ii)
       cpgba    = cfiles(1,1)
       cpgbf    = cfiles(3,ii)
       cpgbp    = cfiles(5,ii)
       ifld     = 7
c ----
c get analysis and forecasting data
c ----
       print *, '------  Analysis for current 00Z, 12Z ------'
       print *, 'ndate=',ndate
       call getanl(agrid,cpgba,ifld,ilev,ndate,0)
       print *, '------  Forcasts for current 00Z, 12Z ------'
       call getgrb(fgrid,cpgbf,ifld,ilev,jdate,ifhr,11)
       print *, 'jdate=',jdate,' ifhr=',ifhr
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

         do im = 1, imem                 ! 16 ensemble members
          en(im) = fgrid(lon,lat,im)
         enddo
         an      = agrid(lon,lat)
c ----
c en --> forecast
c an --> analysis
c ----
c ----
c spread
c ----
         call spread(16,10,en,av10,spr1)   ! 1st 10 members
         call spread(16,14,en,av14,spr2)   !     14 members
         call spread(16,15,en,av15,spr3)   ! ctl+14 members
         call spread(16,16,en,av16,spr4)   ! 16 members
         spr(1) = spr1
         spr(2) = spr2
         spr(3) = spr3
         spr(4) = spr4
c ----
         call talagr(16,10,en,an,it10,av10,xm10,rms10,ir10)           
         call talagr(16,14,en,an,it14,av14,xm14,rms14,ir14)           
         call talagr(16,15,en,an,it15,av15,xm15,rms15,ir15)           
         call talagr(16,16,en,an,it16,av16,xm16,rms16,ir16)
c ----
c to calculate the rms for initial perturbation
c       ii=1 for -12 hours, ii=2 for 00 hours
c ----
         if (ii.le.2) then
          xrms(lon,lat) = xrms(lon,lat) + prms 
         endif
c ----
         do kk=1,11
          it(kk,1) = it10(kk)
         enddo
         do kk=1,15
          it(kk,2) = it14(kk)
         enddo
         do kk=1,16
          it(kk,3) = it15(kk)
         enddo
         do kk=1,17
          it(kk,4) = it16(kk)
         enddo

c ----
c average and medium
c ----

         dgrid(lon,lat,1) = av10         ! 10 members            
         dgrid(lon,lat,2) = av14         ! 14 members          
         dgrid(lon,lat,3) = av15         ! 15 members          
         dgrid(lon,lat,4) = av16         ! 16 members
         dgrid(lon,lat,5) = xm10         ! 10 members            
         dgrid(lon,lat,6) = xm14         ! 14 members          
         dgrid(lon,lat,7) = xm15         ! 15 members          
         dgrid(lon,lat,8) = xm16         ! 16 members
c        spr(1) = rms10
c        spr(2) = rms14
c        spr(3) = rms15
c        spr(4) = rms16

CCC
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
         do i = 1, 4
          do kk = 1, ikk(i)+1
           fit(kk,jj,i) = fit(kk,jj,i) + it(kk,i)*weight/144.0
          enddo
         enddo

         do kk = 1, 16
          rel16(kk,jj)  = rel16(kk,jj)   + ir16(kk)*weight/144.0
         enddo
         do kk = 1, 15
          rel15(kk,jj)  = rel15(kk,jj)   + ir15(kk)*weight/144.0
         enddo
         do kk = 1, 14
          rel14(kk,jj)  = rel14(kk,jj)   + ir14(kk)*weight/144.0
         enddo
         do kk = 1, 10
          rel10(kk,jj)  = rel10(kk,jj)   + ir10(kk)*weight/144.0
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
       do kk = 1, 15
        acwta(3) = acwta(3) + acwt(kk+29)
       enddo

       do i = 1, 4
        do kk = 1, ikk(i)+1
         do jj = 1,3
          fit(kk,jj,i)=fit(kk,jj,i)*100.0/acwta(jj)
         enddo
        enddo
       enddo

       do kk = 1, imem
        do jj = 1, 3
         rel16(kk,jj) = rel16(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 15  
        do jj = 1, 3
         rel15(kk,jj) = rel15(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 14  
        do jj = 1, 3
         rel14(kk,jj) = rel14(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 10  
        do jj = 1, 3
         rel10(kk,jj) = rel10(kk,jj)*100.0/acwta(jj)/2.0
        enddo
       enddo
       do kk = 1, 4
        do jj = 1, 3
         sprf(kk,jj) = sqrt(sprf(kk,jj)/float(ikk(kk)-1)/acwta(jj))
        enddo
       enddo
        print *, '------ Forcasts for  24 hours after 00Z, 12Z ------ '
        call getgrb(pgrid,cpgbp,ifld,ilev,jdat1,ifhr24,21)
        call fptala(fgrid,pgrid,16,10,fit10)   ! 10 members
        call fptala(fgrid,pgrid,16,14,fit14)   ! 14 members
        call fptala(fgrid,pgrid,16,15,fit15)   ! 15 members
        call fptala(fgrid,pgrid,16,16,fit16)   ! 16 members
c ----
c to calculate the outliers and distances
c ----
c ----
c to calculate amomaly corrlation and rms error
c ----
        do im=1,imem
         call states(agrid,fgrid(1,1,im),ifld,ilev,jdate,cor(1,1,im),
     *               rms(1,1,im),icoeff,iclim)
        enddo
        do im=1,8
         call states(agrid,dgrid(1,1,im),ifld,ilev,jdate,
     *               cor(1,1,imem+im),rms(1,1,imem+im),icoeff,iclim)
        enddo
c ----
c output scores cor(3,4,22),rms(3,4,22) 
c        1. GFS          00Z scores
c        2. CTL          00Z scores
c     3-16. 14 perts     00Z scores
c       17. 16m mean         scores
c       18. 15m mean         scores
c       19. 14m mean         scores
c       20. 10m mean         scores
c       21. 16m medium       scores
c       22. 15m medium       scores
c       23. 14m medium       scores
c       24. 10m medium       scores
c convert to fcor and frms 
c        1. GFS          00Z scores
c        2. CTL          00Z scores
c        3. 10m sa       00Z scores
c        4. 14m sa       00Z scores
c        5. 15m sa       00Z scores
c        6. 16m sa       00Z scores( diff. from mean scores )
c        --------------------------
c        7. 10m         mean scores
c        8. 14m         mean scores (pertubation only)
c        9. 15m         mean scores 
c       10. 16m         mean scores ( totally )
c       11. 10m       medium scores
c       12. 14m       medium scores (pertubation only)
c       13. 15m       medium scores 
c       14. 16m       medium scores ( totally )
c ----
c       if (ii.eq.1) then
c        fcor=9.9999
c        frms=9999.99
c       else
c        fcor=0.0
c        frms=0.0
c       endif
c ----
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
          fcor(kk,jj,7) = cor(kk,jj,17)
          frms(kk,jj,7) = rms(kk,jj,17)
          fcor(kk,jj,8) = cor(kk,jj,18)
          frms(kk,jj,8) = rms(kk,jj,18)
          fcor(kk,jj,9) = cor(kk,jj,19)
          frms(kk,jj,9) = rms(kk,jj,19)
          fcor(kk,jj,10)= cor(kk,jj,20)
          frms(kk,jj,10)= rms(kk,jj,20)
          fcor(kk,jj,11)= cor(kk,jj,21)
          frms(kk,jj,11)= rms(kk,jj,21)
          fcor(kk,jj,12)= cor(kk,jj,22)
          frms(kk,jj,12)= rms(kk,jj,22)
          fcor(kk,jj,13)= cor(kk,jj,23)
          frms(kk,jj,13)= rms(kk,jj,23)
          fcor(kk,jj,14)= cor(kk,jj,24)
          frms(kk,jj,14)= rms(kk,jj,24)
         enddo
        enddo
c ---- 3. 10m 00Z scores mean
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
c ---- 4. 14m 00Z scores mean
        do jj = 1, 4
         do kk = 1, 3  
          fcor(kk,jj,4) = 0.0 
          frms(kk,jj,4) = 0.0 
          ngood = 0
          do mm = 3, 16    
           if (cor(kk,jj,mm).ne.9.9999) then
            ngood = ngood + 1
            fcor(kk,jj,4) = fcor(kk,jj,4) + cor(kk,jj,mm)
            frms(kk,jj,4) = frms(kk,jj,4) + rms(kk,jj,mm)
           endif
          enddo
          if ( ngood.ne.0 ) then
           fcor(kk,jj,4) = fcor(kk,jj,4)/float(ngood)
           frms(kk,jj,4) = frms(kk,jj,4)/float(ngood)
          endif
         enddo
        enddo
c ---- 5. 15m scores mean
        do jj = 1, 4
         do kk = 1, 3
          fcor(kk,jj,5) = 0.0
          frms(kk,jj,5) = 0.0
          ngood = 0
          do mm = 2, 16
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
c ---- 6. 16m score mean
        do jj = 1, 4
         do kk = 1, 3  
          fcor(kk,jj,6) = 0.0
          frms(kk,jj,6) = 0.0
          ngood = 0
          do mm = 1, 16   
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

       rel5 = 0.0
       do jj = 1, 3
        rel5(1,jj) = rel16(1,jj)    ! relative to GFS
        rel5(2,jj) = rel16(2,jj)    ! relative to CTL
        do kk = 1, 10               ! relative to 10m             
         rel5(3,jj) = rel5(3,jj) + rel16(kk+2,jj)/10.0
        enddo
        do kk = 1, 14               ! relative to 14m             
         rel5(4,jj) = rel5(4,jj) + rel16(kk+2,jj)/14.0
        enddo
        do kk = 1, 15               ! relative to 15m              
         rel5(5,jj) = rel5(5,jj) + rel16(kk+1,jj)/15.0
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
     &          ndate       
       do jj = 1, 14    
        write(*,201)  clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
       enddo
       if (cor(3,4,3).gt.9.9) then
       write(81,221) clab(15), (dummy(jj),jj=3,16)
       write(81,222) clab(16), (dummy(jj),jj=3,16)
       else
       write(81,221) clab(15), (cor(1,4,jj),jj=3,16)
       write(81,222) clab(16), (rms(1,1,jj),jj=3,16)
       endif
c--------+---------+---------+---------+---------+---------+---------+--
c ---- S Hemisphere
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,202) ilev,ndate,jdate
       print *, ' Anomaly Correlation For S Hemisphere at Valid Time ',
     &          ndate       
       do jj = 1, 14    
        write(*,201)  clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
       enddo
       if (cor(3,4,3).gt.9.9) then
       write(81,221) clab(15), (dummy(jj),jj=3,16)
       write(81,222) clab(16), (dummy(jj),jj=3,16)
       else
       write(81,221) clab(15), (cor(2,4,jj),jj=3,16)
       write(81,222) clab(16), (rms(2,1,jj),jj=3,16)
       endif
c--------+---------+---------+---------+---------+---------+---------+--
c ---- Tropical
c--------+---------+---------+---------+---------+---------+---------+--
       write(81,217) ilev,ndate,jdate
       print *, ' Anomaly Correlation For Tropical at Valid Time ',
     &          ndate
       do jj = 1, 14   
        write(*,201)  clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
        write(81,201) clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
       enddo
       if (cor(3,4,3).gt.9.9) then
       write(81,221) clab(15), (dummy(jj),jj=3,16)
       write(81,222) clab(16), (dummy(jj),jj=3,16)
       else
       write(81,221) clab(15), (cor(3,4,jj),jj=3,16)
       write(81,222) clab(16), (rms(3,1,jj),jj=3,16)
       endif
c ----
       write(81,211) ilev,ndate
       print *, ' N+1 Contains Distrib. from Analysis at Valid Time ',
     &          ndate
c ----                
       do i = 1, 3
        write(*,215)   chem(i)
        write(*,212)   flab(1),(fit(j,i,1),j=1,11)
        write(*,212)   flab(2),(fit10(j,i),j=1,11)
        write(*,212)   flab(3),(fit(j,i,2),j=1,12)
        write(*,212)   flab(3),(fit(j,i,2),j=13,15)
        write(*,212)   flab(4),(fit14(j,i),j=1,12)
        write(*,212)   flab(4),(fit14(j,i),j=13,15)
        write(*,212)   flab(5),(fit(j,i,3),j=1,12)
        write(*,212)   flab(5),(fit(j,i,3),j=13,16)
        write(*,212)   flab(6),(fit15(j,i),j=1,12)
        write(*,212)   flab(6),(fit15(j,i),j=13,16)
        write(*,212)   flab(7),(fit(j,i,4),j=1,12)
        write(*,212)   flab(7),(fit(j,i,4),j=13,17)
        write(*,212)   flab(8),(fit16(j,i),j=1,12)
        write(*,212)   flab(8),(fit16(j,i),j=13,17)
        write(*,212)   flab(9),(rel10(j,i),j=1,10)
        write(*,212)   flab(10),(rel14(j,i),j=1,12)
        write(*,212)   flab(10),(rel14(j,i),j=13,14)
        write(*,212)   flab(11),(rel14(j,i),j=1,12)
        write(*,212)   flab(11),(rel14(j,i),j=13,15)
        write(*,212)   flab(12),(rel14(j,i),j=1,12)
        write(*,212)   flab(12),(rel14(j,i),j=13,16)
        write(*,212)   flab(13),(rel5(j,i),j=1,5)
        write(*,212)   flab(14),(sprf(j,i),j=1,4)
        write(81,215)   chem(i)
        write(81,212)   flab(1),(fit(j,i,1),j=1,11)
        write(81,212)   flab(2),(fit10(j,i),j=1,11)
        write(81,212)   flab(3),(fit(j,i,2),j=1,12)
        write(81,212)   flab(3),(fit(j,i,2),j=13,15)
        write(81,212)   flab(4),(fit14(j,i),j=1,12)
        write(81,212)   flab(4),(fit14(j,i),j=13,15)
        write(81,212)   flab(5),(fit(j,i,3),j=1,12)
        write(81,212)   flab(5),(fit(j,i,3),j=13,16)
        write(81,212)   flab(6),(fit15(j,i),j=1,12)
        write(81,212)   flab(6),(fit15(j,i),j=13,16)
        write(81,212)   flab(7),(fit(j,i,4),j=1,12)
        write(81,212)   flab(7),(fit(j,i,4),j=13,17)
        write(81,212)   flab(8),(fit16(j,i),j=1,12)
        write(81,212)   flab(8),(fit16(j,i),j=13,17)
        write(81,212)   flab(9),(rel10(j,i),j=1,10)
        write(81,212)   flab(10),(rel14(j,i),j=1,12)
        write(81,212)   flab(10),(rel14(j,i),j=13,14)
        write(81,212)   flab(11),(rel14(j,i),j=1,12)
        write(81,212)   flab(11),(rel14(j,i),j=13,15)
        write(81,212)   flab(12),(rel14(j,i),j=1,12)
        write(81,212)   flab(12),(rel14(j,i),j=13,16)
        write(81,212)   flab(13),(rel5(j,i),j=1,5)
        write(81,212)   flab(14),(sprf(j,i),j=1,4)
       enddo
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
 221  format(a5,1x,14(f5.3))
 222  format(a5,1x,14(f5.1))
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
