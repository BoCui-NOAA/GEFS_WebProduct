
c     This is main program of ensemble forecast verification on Cray3
c     ----------- NCEP Ensemble Forecasts Version -------------------
c                Global verification for icoeff=0 or icoeff=1
c                 includes: Northern Hemisphere
c                           Southern Hemisphere
c                           Tropical            
c
c     main program    VRFYLN
c
c      subroutine     anomal ---> main routine to calculate anomal corr.
c                     rmsg   ---> to get mean error and RMS error
c                     latmn  ---> to get latitude mean values
c                     sum    ---> to sum the wave groups
c                     acgrid ---> to calculate anomally correlation at grid
c                     fanl   ---> transform from grid to wave
c                     zsave  ---> rearranged the array
c                     getcac ---> read cac climate database
c                     getanl ---> read analysis file ( format dependent)
c                     getfst ---> read forecast file ( format dependent)
c                     aatobb ---> transform from 1-d to 2-d
c                     
c
c     parameters      imax   ---> number of level to verification
c                     ihmax  ---> maximum hours to verify ( normally 360 hours ) 
c                     imem   ---> forecasting members ( NCEP are 17 members )
c                     ixy    ---> global two dimemsion array ( 144*73 = 10512 )
c
c
c      Fortran 77 on Cray ====== coded by Yuejian Zhu 07/15/95
c
c
      program VRFYEN
      parameter       (imax=2,ihmax=408,imem=17,ixy=10512)
      parameter       (imemp5=imem+5)
      dimension       agrid(ixy),fgrid(ixy,imemp5)
      dimension       ggrid(ixy,imem),pgrid(ixy,imem)
      dimension       cor(4,4,imemp5),rms(4,4,imemp5),acwt(73)
      dimension       fcor(3,4,11),frms(3,4,11),irel(imem),rel(imem,3)
      dimension       iprs(12),lvl(2),kdate(100),xrms(ixy),rel5(5,3)
      dimension       en(17),it(18,4),fit(18,3,4),fitavg(18,3)
      dimension       jk(17),it1(18),it2(9),it3(11),it4(15),ikk(5)
      dimension       spr(4),sprf(4,3),f14avg(15,3)
      character*5     chem(3),clab(11),flab(9)
      character*80    cfilea(2,100),cfilef(2),cfilep(2),filea(2)
      namelist/files/ cfilea,cfilef,cfilep
      namelist/kdata/ kdate
      namelist/namin/ la1,la2,lo1,lo2,l1,l2,nhours,ilv,icon,icoeff
      data iprs /1000,850,700,500,400,300,250,200,150,100,75,50/
      data ikk  /18,9,11,15,18/
      data chem /'N Hem','S Hem','Trop.'/
      data clab /' MRF ',' CTL ','00Zpa',' AVN ','12Zpa',
     &           '17tsa',' 8ems','10ems','14ems','17tms','Meds '/
      data flab /'T17  ','T-1  ','T08  ','T10  ','T14  ','T-1  ',
     &           'R17  ','Rs5  ','Sg4  '/
c ----
c job will be controled by read card
c ----
      read  (5,files,end=1020)
      write (6,files)
      read  (5,kdata,end=1020)
      write (6,kdata)
 1010 read  (5,namin,end=1020)
      write (6,namin)
c ---------------------------------------------------------------------+------
c convert ilv to real pressure values
c convert nhours to units ( unit=12 hours here )
c     plus 2 means add 00Z and -12Z step on
c ---------------------------------------------------------------------+------
      ilevel=iprs(ilv)
      if (nhours.gt.ihmax) nhours = ihmax
      iunit = nhours/12 + 2
c ----
      do ii = 1, iunit                  ! main loop to run each forecasts
       jcon     = ii   
       fit      = 0.0
       rel      = 0.0
       ifhr     = (ii-2)*12
c      ifhr     = (ii-1)*12
       ifhr24   = ifhr + 24 
       ndate    = kdate(ii+4)
       jdate    = kdate(3)
       mdate    = kdate(4)
       jdat1    = kdate(1)
       mdat1    = kdate(2)
c      filea(1) = cfilea(1,ii)
c      filea(2) = cfilea(2,ii)
       filea(1) = cfilea(1,1)
       filea(2) = cfilea(2,1)
c ----
c get analysis and forecasting data
c ----
       call getanl(agrid,ndate,ilv,filea,icon)
       print *, '------  Forcasts for current 00Z, 12Z ------'
       call getfst(ggrid,jdate,mdate,ifhr,ilv,cfilef,icon)
c ----
c to calculate talagrand histogram and N+1 distribution
c ----
       xrms = 0.0
       acwt = 0.0 
       acwf = 0.0
       do jj = 1, ixy                   ! do loop for each grid point   
c ----
c calculate the weight for each latitude
c ----
        lat = (jj - 1)/144
        weight     =sin( lat * 2.5 * 3.1415926 / 180.0 )
        acwt(lat+1)=weight                                   
        do kk = 1, 17
         fgrid(jj,kk) = ggrid(jj,kk)
         en(kk) = fgrid(jj,kk)
        enddo
         an     = agrid(jj)
c ----
c en --> forecast
c an --> analysis
c     ave ---> 17 members average
c     xmed --> the medium of 17 members
c ----
         call talagr(17,8,en,an,it2,ajk,xjk,pjk,jk,0)           
         call talagr(17,10,en,an,it3,ajk,xjk,pjk,jk,0)           
         call talagr(17,14,en,an,it4,ajk,xjk,pjk,jk,0)           
         call talagr(17,17,en,an,it1,ave,xmed,prms,irel,jcon)
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
         fgrid(jj,18) = ave
         fgrid(jj,19) = xmed
c ----
c     gave --> first 8 members of 00Z pertubation run
c ----
         igcon=1
         call fgroup(17,en,gave,igcon)
         fgrid(jj,20) = gave
c ----
c     gave --> first 10 members of 00Z pertubation run
c ----
         igcon=2
         call fgroup(17,en,gave,igcon)
         fgrid(jj,21) = gave
c ----
c     gave --> total 14 members of pertubation run
c ----
         igcon=3
         call fgroup(17,en,gave,igcon)
         fgrid(jj,22) = gave
c ----
c spread
c ----
c        spr1=spr(1)
c        spr2=spr(2)
c        spr3=spr(3)
c        spr4=spr(4)
         call spread(17,en,ave,spr2,2)
         call spread(17,en,ave,spr3,3)
         call spread(17,en,ave,spr4,4)
         call spread(17,en,ave,spr1,1)
         spr(1)=spr1
         spr(2)=spr2
         spr(3)=spr3
         spr(4)=spr4
c ----
c to calculate the rms for initial perturbation
c       ii=1 for -12 hours, ii=2 for 00 hours
c ----
        if (ii.le.2) then
        xrms(jj) = xrms(jj) + prms 
        endif
c ----
c for Northern Hemsphere, 77.5N-20.0N (24 lats, 6-29)
c     jj=721  ---> jj=4176 (3456 points)
c ----
        if ( jj.ge.721.and.jj.le.4176 ) then
         do i = 1, 4
          do kk = 1, ikk(i)
           fit(kk,1,i)=fit(kk,1,i) + it(kk,i)*weight/144.0
          enddo
         enddo
         do kk = 1, 17
          rel(kk,1) = rel(kk,1) + irel(kk)*weight/144.0
         enddo
         do kk = 1, 4
          sprf(kk,1)  = sprf(kk,1)  + spr(kk)*weight/144.0
         enddo
        endif
c ----
c for Southern Hemsphere, 20.0S-72.5S (24 lats, 45-68)
c     jj=6337 ---> jj=9792 (3456 points)
c ----
        if ( jj.ge.6337.and.jj.le.9792 ) then
         do i = 1, 4
          do kk = 1, ikk(i)
           fit(kk,2,i)=fit(kk,2,i) + it(kk,i)*weight/144.0
          enddo
         enddo
         do kk = 1, 17
          rel(kk,2) = rel(kk,2) + irel(kk)*weight/144.0
         enddo
         do kk = 1, 4
          sprf(kk,2)  = sprf(kk,2)  + spr(kk)*weight/144.0
         enddo
        endif
c ----
c for Tropical area, 20.0N-20.0S  (17 lats, 29-45)     
c     jj=4033 ---> jj=6480 (2448 points)
c ----
        if ( jj.ge.4033.and.jj.le.6480 ) then
         do i = 1, 4
          do kk = 1, ikk(i)
           fit(kk,3,i)=fit(kk,3,i) + it(kk,i)*weight/144.0
          enddo
         enddo
         do kk = 1, 17
          rel(kk,3) = rel(kk,3) + irel(kk)*weight/144.0
         enddo
         do kk = 1, 4
          sprf(kk,3)  = sprf(kk,3)  + spr(kk)*weight/144.0
         enddo
         endif
       enddo                               ! end do loop for jj=1,ixy
c ----
c normalize the N+1 distribution scores
c ----
        acwtn = 0.0
        acwts = 0.0
        acwtt = 0.0
        do kk = 1, 24
         acwtn = acwtn + acwt(kk+ 5)
         acwts = acwts + acwt(kk+44)
        enddo
        do kk = 1, 17
         acwtt = acwtt + acwt(kk+28)
        enddo
        do i = 1, 4
         do kk = 1, ikk(i)
          fit(kk,1,i)=fit(kk,1,i)*100.0/acwtn
          fit(kk,2,i)=fit(kk,2,i)*100.0/acwts
          fit(kk,3,i)=fit(kk,3,i)*100.0/acwtt
         enddo
        enddo
        do kk = 1, 17
         rel(kk,1) = rel(kk,1)*100.0/acwtn/2.0
         rel(kk,2) = rel(kk,2)*100.0/acwts/2.0
         rel(kk,3) = rel(kk,3)*100.0/acwtt/2.0
        enddo
         sprf(1,1)  = sqrt(sprf(1,1)/17.00/acwtn)
         sprf(1,2)  = sqrt(sprf(1,2)/17.00/acwts)
         sprf(1,3)  = sqrt(sprf(1,3)/17.00/acwtt)
         sprf(2,1)  = sqrt(sprf(2,1)/8.00/acwtn)
         sprf(2,2)  = sqrt(sprf(2,2)/8.00/acwts)
         sprf(2,3)  = sqrt(sprf(2,3)/8.00/acwtt)
         sprf(3,1)  = sqrt(sprf(3,1)/10.00/acwtn)
         sprf(3,2)  = sqrt(sprf(3,2)/10.00/acwts)
         sprf(3,3)  = sqrt(sprf(3,3)/10.00/acwtt)
         sprf(4,1)  = sqrt(sprf(4,1)/14.00/acwtn)
         sprf(4,2)  = sqrt(sprf(4,2)/14.00/acwts)
         sprf(4,3)  = sqrt(sprf(4,3)/14.00/acwtt)
       print *, '------ Forcasts for  24 hours before 00Z, 12Z ------ '
       call getfst(pgrid,jdat1,mdat1,ifhr24,ilv,cfilep,icon)
       call fptala(ggrid,pgrid,17,fitavg)
       call fptala(ggrid,pgrid,14,f14avg)
c ----
c to calculate amomaly corrlation and rms error
c ----
       call anomal(agrid,fgrid,cor,rms,
     &             ndate,ilv,la1,la2,lo1,lo2,l1,l2,imemp5,icoeff)
c ----
c output scores cor(2,4,22),rms(2,4,22) 
c        1. MRF ( T126 ) 00Z scores
c        2. MRFZ ( T62 ) 00Z scores
c     3-12. 5 pairs      00Z scores
c       13. AVN ( T126 ) 12Z scores
c    14-17. 2 pairs      12Z scores
c       18. Mean or average scores.
c       19. Medium scores
c       20. First  8 members scores
c       21. First 10 members scores
c       22. 14 members ( pertubation only )
c convert to fcor and frms 
c        1. MRF ( T126 ) 00Z scores
c        2. MRFZ ( T62 ) 00Z scores
c        3. 5 pairs      00Z scores
c        4. AVN ( T126 ) 12Z scores
c        5. 2 pairs      12Z scores
c        6. 17 members scores mean ( diff. from mean scores )
c        --------------------------
c        7. First  8 members mean scores
c        8. First 10 members mean scores
c        9. 14 members mean scores ( pertubation only )
c       10. 17 members mean scores ( totally )
c       11. Medium scores
c ----
       fcor=0.0
       frms=0.0
c ----
c ---- 1. MRF ( T126 ) 00Z scores
c ---- 2. MRFZ ( T62 ) 00Z scores
c ---- 4. AVN ( T126 ) 12Z scores
c ---- 7. First  8 members mean scores
c ---- 8. First 10 members mean scores
c ---- 9. 14 members mean scores ( pertubation only )
c ----10. 17 members mean scores ( totally )
c ----11. Medium scores
c
c         For tropical region:
c             anhw = sum(acwt(29--37))
c             ashw = 1.0 - anhw
c ----
       anhw = ((acwtt-1.0)/2.0 + 1.0)/acwtt
       print *, 'anhw=',anhw
       ashw = 1.0 - anhw
       do jj = 1, 4
          fcor(1,jj,1)   = cor(1,jj,1)
          fcor(2,jj,1)   = cor(2,jj,1)
          fcor(3,jj,1)   = cor(3,jj,1)*anhw+cor(4,jj,1)*ashw
          frms(1,jj,1)   = rms(1,jj,1)
          frms(2,jj,1)   = rms(2,jj,1)
          frms(3,jj,1)   = rms(3,jj,1)*anhw+rms(4,jj,1)*ashw
c ----
          fcor(1,jj,2)   = cor(1,jj,2)
          fcor(2,jj,2)   = cor(2,jj,2)
          fcor(3,jj,2)   = cor(3,jj,2)*anhw+cor(4,jj,2)*ashw
          frms(1,jj,2)   = rms(1,jj,2)
          frms(2,jj,2)   = rms(2,jj,2)
          frms(3,jj,2)   = rms(3,jj,2)*anhw+rms(4,jj,2)*ashw
c ----
          fcor(1,jj,4)   = cor(1,jj,13)
          fcor(2,jj,4)   = cor(2,jj,13)
          fcor(3,jj,4)   = cor(3,jj,13)*anhw+cor(4,jj,13)*ashw
          frms(1,jj,4)   = rms(1,jj,13)
          frms(2,jj,4)   = rms(2,jj,13)
          frms(3,jj,4)   = rms(3,jj,13)*anhw+rms(4,jj,13)*ashw
c ----
          fcor(1,jj,7)   = cor(1,jj,20)
          fcor(2,jj,7)   = cor(2,jj,20)
          fcor(3,jj,7)   = cor(3,jj,20)*anhw+cor(4,jj,20)*ashw
          frms(1,jj,7)   = rms(1,jj,20)
          frms(2,jj,7)   = rms(2,jj,20)
          frms(3,jj,7)   = rms(3,jj,20)*anhw+rms(4,jj,20)*ashw
c ----
          fcor(1,jj,8)   = cor(1,jj,21)
          fcor(2,jj,8)   = cor(2,jj,21)
          fcor(3,jj,8)   = cor(3,jj,21)*anhw+cor(4,jj,21)*ashw
          frms(1,jj,8)   = rms(1,jj,21)
          frms(2,jj,8)   = rms(2,jj,21)
          frms(3,jj,8)   = rms(3,jj,21)*anhw+rms(4,jj,21)*ashw
c ----
          fcor(1,jj,9)   = cor(1,jj,22)
          fcor(2,jj,9)   = cor(2,jj,22)
          fcor(3,jj,9)   = cor(3,jj,22)*anhw+cor(4,jj,22)*ashw
          frms(1,jj,9)   = rms(1,jj,22)
          frms(2,jj,9)   = rms(2,jj,22)
          frms(3,jj,9)   = rms(3,jj,22)*anhw+rms(4,jj,22)*ashw
c ----
          fcor(1,jj,10)  = cor(1,jj,18)
          fcor(2,jj,10)  = cor(2,jj,18)
          fcor(3,jj,10)  = cor(3,jj,18)*anhw+cor(4,jj,18)*ashw
          frms(1,jj,10)  = rms(1,jj,18)
          frms(2,jj,10)  = rms(2,jj,18)
          frms(3,jj,10)  = rms(3,jj,18)*anhw+rms(4,jj,18)*ashw
c ----
          fcor(1,jj,11)  = cor(1,jj,19)
          fcor(2,jj,11)  = cor(2,jj,19)
          fcor(3,jj,11)  = cor(3,jj,19)*anhw+cor(4,jj,19)*ashw
          frms(1,jj,11)  = rms(1,jj,19)
          frms(2,jj,11)  = rms(2,jj,19)
          frms(3,jj,11)  = rms(3,jj,19)*anhw+rms(4,jj,19)*ashw
       enddo
c ---- 3. 5 pairs      00Z scores
       do jj = 1, 4
         do kk = 3, 12
          fcor(1,jj,3)   = fcor(1,jj,3)  + cor(1,jj,kk)/10.0
          fcor(2,jj,3)   = fcor(2,jj,3)  + cor(2,jj,kk)/10.0
          fcor(3,jj,3)   = fcor(3,jj,3)  + cor(3,jj,kk)*anhw/10.0
          fcor(3,jj,3)   = fcor(3,jj,3)  + cor(4,jj,kk)*ashw/10.0
          frms(1,jj,3)   = frms(1,jj,3)  + rms(1,jj,kk)/10.0
          frms(2,jj,3)   = frms(2,jj,3)  + rms(2,jj,kk)/10.0
          frms(3,jj,3)   = frms(3,jj,3)  + rms(3,jj,kk)*anhw/10.0
          frms(3,jj,3)   = frms(3,jj,3)  + rms(4,jj,kk)*ashw/10.0
         enddo
       enddo
c ---- 5. 2 pairs      12Z scores 
       do jj = 1, 4
         do kk = 14, 17
          fcor(1,jj,5)   = fcor(1,jj,5)  + cor(1,jj,kk)/4.0
          fcor(2,jj,5)   = fcor(2,jj,5)  + cor(2,jj,kk)/4.0
          fcor(3,jj,5)   = fcor(3,jj,5)  + cor(3,jj,kk)*anhw/4.0
          fcor(3,jj,5)   = fcor(3,jj,5)  + cor(4,jj,kk)*ashw/4.0
          frms(1,jj,5)   = frms(1,jj,5)  + rms(1,jj,kk)/4.0
          frms(2,jj,5)   = frms(2,jj,5)  + rms(2,jj,kk)/4.0
          frms(3,jj,5)   = frms(3,jj,5)  + rms(3,jj,kk)*anhw/4.0
          frms(3,jj,5)   = frms(3,jj,5)  + rms(4,jj,kk)*ashw/4.0
         enddo
       enddo
c ----11. 17 members ( totally )
       do jj = 1, 4
         do kk = 1, 17  
          fcor(1,jj,6)   = fcor(1,jj,6)  + cor(1,jj,kk)/17.0
          fcor(2,jj,6)   = fcor(2,jj,6)  + cor(2,jj,kk)/17.0
          fcor(3,jj,6)   = fcor(3,jj,6)  + cor(3,jj,kk)*anhw/17.0
          fcor(3,jj,6)   = fcor(3,jj,6)  + cor(4,jj,kk)*ashw/17.0
          frms(1,jj,6)   = frms(1,jj,6)  + rms(1,jj,kk)/17.0
          frms(2,jj,6)   = frms(2,jj,6)  + rms(2,jj,kk)/17.0
          frms(3,jj,6)   = frms(3,jj,6)  + rms(3,jj,kk)*anhw/17.0
          frms(3,jj,6)   = frms(3,jj,6)  + rms(4,jj,kk)*ashw/17.0
         enddo
       enddo
       do jj = 1, 17
          cor(3,4,jj) = cor(3,4,jj)*anhw + cor(4,4,jj)*ashw
          rms(3,4,jj) = rms(3,4,jj)*anhw + rms(4,4,jj)*ashw
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
       write(81,200) ilevel,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For N Hemisphere at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 11    
       write(*,201)  clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
       write(81,201) clab(jj),(fcor(1,j,jj),j=1,4),(frms(1,j,jj),j=1,4)
       enddo
       write(81,221) clab(3), (cor(1,4,jj),jj=3,12)
       write(81,221) clab(5), (cor(1,4,jj),jj=14,17)
       write(81,222) clab(3), (rms(1,1,jj),jj=3,12)
       write(81,222) clab(5), (rms(1,1,jj),jj=14,17)
c ---- S Hemisphere
       write(81,202) ilevel,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For S Hemisphere at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 11    
       write(*,201)  clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
       write(81,201) clab(jj),(fcor(2,j,jj),j=1,4),(frms(2,j,jj),j=1,4)
       enddo
       write(81,221) clab(3), (cor(2,4,jj),jj=3,12)
       write(81,221) clab(5), (cor(2,4,jj),jj=14,17)
       write(81,222) clab(3), (rms(2,1,jj),jj=3,12)
       write(81,222) clab(5), (rms(2,1,jj),jj=14,17)
c ---- Tropical
       write(81,217) ilevel,kdate(ii+4),jdate
       print *, ' Anomaly Correlation For Tropical at Valid Time ',
     &          kdate(ii+4)
       do jj = 1, 11   
       write(*,201)  clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
       write(81,201) clab(jj),(fcor(3,j,jj),j=1,4),(frms(3,j,jj),j=1,4)
       enddo
       write(81,221) clab(3), (cor(3,4,jj),jj=3,12)
       write(81,221) clab(5), (cor(3,4,jj),jj=14,17)
       write(81,222) clab(3), (rms(3,1,jj),jj=3,12)
       write(81,222) clab(5), (rms(3,1,jj),jj=14,17)
c ----
       write(81,211) ilevel,kdate(ii+4)
       print *, ' N+1 Contains Distrib. from Analysis at Valid Time ',
     &          kdate(ii+4)
c ---- N. Hemsphere
       do i = 1, 3
       write(*,215)   chem(i)
       write(*,212)   flab(1),(fit(j,i,1),j=1,9)
       write(*,212)   flab(1),(fit(j,i,1),j=10,18)
       write(*,212)   flab(2),(fitavg(j,i),j=1,9)
       write(*,212)   flab(2),(fitavg(j,i),j=10,18)
       write(*,212)   flab(3),(fit(j,i,2),j=1,9)
       write(*,212)   flab(4),(fit(j,i,3),j=1,11)
       write(*,212)   flab(5),(fit(j,i,4),j=1,9)
       write(*,212)   flab(5),(fit(j,i,4),j=10,15)
       write(*,212)   flab(6),(f14avg(j,i),j=1,9)
       write(*,212)   flab(6),(f14avg(j,i),j=10,15)
       write(*,212)   flab(7),(rel(j,i),j=1,9)
       write(*,212)   flab(7),(rel(j,i),j=10,17)
       write(*,212)   flab(8),(rel5(j,i),j=1,5)
       write(*,212)   flab(9),(sprf(j,i),j=1,4)
       write(81,215)   chem(i)
       write(81,212)   flab(1),(fit(j,i,1),j=1,9)
       write(81,212)   flab(1),(fit(j,i,1),j=10,18)
       write(81,212)   flab(2),(fitavg(j,i),j=1,9)
       write(81,212)   flab(2),(fitavg(j,i),j=10,18)
       write(81,212)   flab(3),(fit(j,i,2),j=1,9)
       write(81,212)   flab(4),(fit(j,i,3),j=1,11)
       write(81,212)   flab(5),(fit(j,i,4),j=1,9)
       write(81,212)   flab(5),(fit(j,i,4),j=10,15)
       write(81,212)   flab(6),(f14avg(j,i),j=1,9)
       write(81,212)   flab(6),(f14avg(j,i),j=10,15)
       write(81,212)   flab(7),(rel(j,i),j=1,9)
       write(81,212)   flab(7),(rel(j,i),j=10,17)
       write(81,212)   flab(8),(rel5(j,i),j=1,5)
       write(81,212)   flab(9),(sprf(j,i),j=1,4)
       enddo
c
      enddo                              ! end loop for main do loop ii   
c
 200  format(' Anomaly Corr. For N Hem. ',
     .       i4,' mb at Valid Time ',i8,' (ini. ',i8,')')
 202  format(' Anomaly Corr. For S Hem. ',
     .       i4,' mb at Valid Time ',i8,' (ini. ',i8,')')
 201  format(a5,4(f8.4),4(f9.2))
 211  format('Group Talagrand, Spread etc. from Analysis ',
     .       'for ',i4,' mb at Valid Time ',i8)
 212  format(a5,12(f6.2)) 
 215  format('    ---- for ',a5,' ----' )
 213  format('   ------- Northern Hemisphere -------   ')
 214  format('   ------- Southern Hemisphere -------   ')
 216  format('   ------- Tropical area       -------   ')
 217  format(' Anomaly Corr. For Tropic.',
     .       i4,' mb at Valid Time ',i8,' (ini. ',i8,')')
 221  format(a5,1x,10(f7.4))
 222  format(a5,10(f7.2))
c ---- finished output
c     write out initial perturbation to unit 82
      do mm = 1, 10512
       xrms(mm) = sqrt(xrms(mm)/14.0)
      enddo
c     print *, xrms(1)
      write (82) xrms
c
c     back to 1010 to read input data card
c
      goto 1010
c
c     after end of input card, end of program
c
 1020 continue
c -----------------------------
      stop
      end
c**********************************************************************
      subroutine anomal(agrid,fgrid,cor,rms,
     &            ndate,ilv,la1,la2,lo1,lo2,l1,l2,imemp5,icoeff)
c
      dimension zunp(145,73),weight(73)
      dimension ao(20,37),af(20,37),ac(20,37)
      dimension bo(21,37),bf(21,37),bc(21,37)
      dimension fcst (145,73),anl (145,73),clim (145,73)
      dimension fcstc(145,37),anlc(145,37),climc(145,37)
      dimension fsh  (145,37),fnh (145,37)
      dimension fsh1 (145,37),fnh1(145,37)
      dimension fnum (20,37), denom1(20,37),denom2(20,37)
      dimension q1(4,37),q2(4,37),q3(4,37)
      dimension qx1(4),  qx2(4),  qx3(4),  qx4(5)
      dimension w1(37),  w2(37),  w3(37)
      dimension agrid(10512),fgrid(10512,imemp5)
      dimension cor(4,4,imemp5),rms(4,4,imemp5)
c     dimension cor(2,4,imemp5),rms(2,4,imemp5)
c ----
      do jj= 37,73
        j  =jj-36
        xlat=(2.5*j - 2.5 )/57.296
        weight(j)  = sin(xlat)
        weight(jj) = sin(1.571-xlat)
      enddo    
   10 continue
c ----
c for hemsphere loop
c ----
      do ihem = 1, 4
c ----
c  convert la1, la2 to lat1 and lat2 to different hemisphere
c ----
      ijdata=0
      if (ihem.eq.1) then
         lat1=74-la2
         lat2=74-la1
         l1  =9
         l2  =32
      endif
      if (ihem.eq.2) then
         lat1=la1
         lat2=la2
         l1  =9
         l2  =32
      endif
      if (ihem.eq.3) then
         lat1=37    
         lat2=45     
         l1  =1
         l2  =9
      endif
      if (ihem.eq.4) then
         lat1=29 
         lat2=36 
         l1  =2
         l2  =9
      endif
c ----
c  get the verifying analysis field
c ----
      call aatobb(agrid,zunp)
      if(zunp(1,1).eq.999999.0) then
        ijdata=1
      endif
      call zsave (zunp,anl,anlc,ihem)
      do lat = 1,37
c      if(lat.eq.1) write (*,202) (anlc(jj,lat),jj=1,145)
       call fanl(ao(1,lat),bo(1,lat),anlc(1,lat))
      enddo
  202 format (10f8.2)
c ----
c calculate year, month and day
c ----
      call nd2ymd(ndate,jyar,jmth,jday,jhour)
      print *, ' The Climate Data based on YMD=',jyar,jmth,jday
c     jyar = ndate/10000
c     jjy  = jyar*10000
c     jmth = (ndate-jjy)/100
c     jjm  = jmth*100
c     jday = ndate - jjy - jjm
c-----------    climo from cac data base ---------------
c     we need two important parameters
c      1). jmth --- which month
c      2). jday --- which day
c-------------------------------------------------------
      im1=jmth
      if (jday.le.15) im2=jmth - 1
      if (im2.lt.1)   im2=im2  + 12
      if (jday.gt.15) im2=jmth + 1
      if (im2.gt.12)  im2=im2  - 12
      if (ihem.eq.1.or.ihem.eq.3)  iucac=53
      if (ihem.eq.2.or.ihem.eq.4)  iucac=54
c ----
c calc daily norm from norms of pres mon & preceding or nextmon
c     inum=ijk;  i=variable (1=u,2=v,3=t,4=h), j=1 , k=cac level
c     inum=ijk;  i=variable (1=u,2=v,3=t,4=h), j=1 , k=cac level
c ----
      call getcac(fnh,fsh,4,im1,ilv,iucac)
      call getcac(fnh1,fsh1,4,im2,ilv,iucac)
      temp=(float(jday)-15.)/30.
      percnt = 1.00-abs(temp)
      do i = 1,145
       do j = 1,37
c ----
c due to fnh from eq to pole. and fsh from eq to pole
c choose j1=38-j and j2=j+36 and zunp is global from n-s
c ----
        if (ihem.eq.1.or.ihem.eq.3) then
        j1=38-j
        j2=36+j
        endif
        if (ihem.eq.2.or.ihem.eq.4) then
        j1=j
        j2=74-j
        endif
        zunp(i,j1) = fnh(i,j)*percnt+(1.0-percnt)*fnh1(i,j)
        zunp(i,j2) = fsh(i,j)*percnt+(1.0-percnt)*fsh1(i,j)
       enddo    
      enddo
c ----
c end of cac climate
c ----
      call zsave(zunp,clim,climc,ihem)
      do lat = 1,37
        call fanl(ac(1,lat),bc(1,lat),climc(1,lat))
      enddo    
c ----
c verify for each member ( total 20 members )
c ----
      do ivrfy = 1, imemp5
c ----
c get the verifying forecasting field
c ----
      call aatobb(fgrid(1,ivrfy),zunp)
      if(zunp(1,1).eq.999999.0.or.ijdata.eq.1) goto 998
      call zsave(zunp,fcst,fcstc,ihem)
c ----
c if icoeff=1, using coefficients to calculate AC
c if icoeff=0, using grid points  to calculate AC
c ----
      if (icoeff .eq. 1) then        
      do lat = 1,37
        call fanl(af(1,lat),bf(1,lat),fcstc(1,lat))
      enddo    
      do i =1,20
       do l = 1,37
        fnum(i,l)=(af(i,l)-ac(i,l))*(ao(i,l)-ac(i,l))+
     1         (bf(i,l)-bc(i,l))*(bo(i,l)-bc(i,l))
        denom1(i,l)=(af(i,l)-ac(i,l))**2+(bf(i,l)-bc(i,l))**2
        denom2(i,l)=(ao(i,l)-ac(i,l))**2+(bo(i,l)-bc(i,l))**2
       enddo
      enddo
      do l = 1,37
        call sum(fnum(1,l),q1(1,l))
        call sum(denom1(1,l),q2(1,l))
        call sum(denom2(1,l),q3(1,l))
      enddo    
c ----
c avg over lat band l1-l2, pole(n or s) at 37, eq at 1
c normaly l1=9 (20N or 20S)  and l2=32 (77.5N or 77.5S)
c ----
      do j = 1,4
        do l = 1,37
          w1(l)=q1(j,l)
          w2(l)=q2(j,l)
          w3(l)=q3(j,l)
        enddo    
        call latmn(w1,l1,l2,qx1(j))
        call latmn(w2,l1,l2,qx2(j))
        call latmn(w3,l1,l2,qx3(j))
      enddo   
c ----
c combine terms to get anom corr for this day
c ----
      do j = 1,4
        qx4(j)=qx1(j)/(sqrt(qx2(j))*sqrt(qx3(j)))
      enddo    
      else    
      call acgrid(anl,fcst,clim,weight,lat1,lat2,lo1,lo2,qx4)
      endif   
      do j = 1,4
        cor(ihem,j,ivrfy) = qx4(j)
      enddo
      call rmsg(rmsf,ermf,anl,fcst,weight,lat1,lat2,lo1,lo2)
      call rmsg(rmsc,ermc,clim,anl,weight,lat1,lat2,lo1,lo2)
      rms(ihem,1,ivrfy) = rmsf  
      rms(ihem,2,ivrfy) = ermf  
      rms(ihem,3,ivrfy) = rmsc  
      rms(ihem,4,ivrfy) = ermc 
      goto 997
c ----
c if the analysis or forecast file has a problems (missing or misplace)
c then, we set up a constants (called default values) for scores
c ----
  998 continue
      do j = 1,4
        cor(ihem,j,ivrfy) = 9.999
      enddo    
        rms(ihem,1,ivrfy) = 99.99
        rms(ihem,2,ivrfy) = 99.99
        rms(ihem,3,ivrfy) = 99.99
        rms(ihem,4,ivrfy) = 99.99
  997 continue
      enddo                       ! end of ivrfy loop
      enddo                       ! end of ihem loop
      return
  106 format('0,polate error,ier=',i4)
  109 format(1h0,'trouble in w3fm04, ier=',i4)
  110 format(1h0,'number of scans in w3fm05 more than 100'/t10,
     1 'ier=',i4)
  119 format (/ ' anomal ilv=', i2, '  cor=', 4f8.3, 4(1x, e14.7))
      end
c---------------------------------------------------------------
      subroutine rmsg(rmsx,ermx,y,x,weight,lamin,lamax,lomin,lomax)
c ---------------------------------------------------------------
c      calculate area-weighted rms and mean error between fields y and x
c       return single values of rms,erm
c             rms=rms error     erm=mean error
c ---------------------------------------------------------------
      dimension y(145,37),x(145,37),weight(37)
      flodif=lomax-lomin+1
      sumsq= 0.
      sumerr=0.
      sumwgt=0.
      do 37 lat=lamin,lamax
        tlatm =0.
        tlatms=0.
        do 73 lon=lomin,lomax
          error  = x(lon,lat) - y(lon,lat)
          tlatm  = tlatm  + error
          tlatms = tlatms + error*error
   73   continue
        sumsq = sumsq + tlatms*weight(lat)
        sumerr= sumerr+ tlatm *weight(lat)
        sumwgt= sumwgt + weight(lat)
   37 continue
      rmsx=sqrt((sumsq/sumwgt)/flodif)
      ermx=    (sumerr/sumwgt)/flodif
      return
      end
      subroutine zsave(z,field,fieldc,ihem)
      dimension  z(145,73),field(145,73),fieldc(145,37)
c ----
c input:  z array from N pole to S pole
c
c output: all logitude shifted 3 position
c         New: field(1,1) = z(4,73)
c          field ---> from south pole to north pole
c          fieldc---> from equator to pole (hemisphere dependent)
c ----
      do 10 j=1,73
      do 11 i=1,145
        if(i.gt.141) field(i-141,j) = z(i,74-j)
        if(i.le.141) field(i+3,j)   = z(i,74-j)
  11  continue
        field(145,74-j) = field(1,74-j)
  10  continue
c ----
c set up 1-37 array from equator to pole, both hemispheres
c ----
      do 20 j=1,37
         jj =j+36
         jjj=38-j
         do 20 i=1,145
           if(ihem.eq.1) fieldc(i,j)=field(i,jj )
           if(ihem.eq.2) fieldc(i,j)=field(i,jjj)
           if(ihem.eq.3) fieldc(i,j)=field(i,jj )
           if(ihem.eq.4) fieldc(i,j)=field(i,jjj)
   20 continue
      return
      end
      subroutine sum(w,y)
c ----
c sum sums over 4 wave no. groups
c   1=  k=1-3    2=  k=4-9  3=  k=10-20  4=  1-20
c ----
      dimension w(20),y(4)
      do 100 k=1,4
      y(k)=0.0
  100 continue
      do 200 k=1,3
      y(1)=y(1)+w(k)
  200 continue
      do 300 k=4,9
      y(2)=y(2)+w(k)
  300 continue
      do 400 k=10,20
      y(3)=y(3)+w(k)
  400 continue
      do 500 k=1,20
      y(4)=y(4)+w(k)
  500 continue
      return
      end
      subroutine latmn(w1,l1,l2,xmean)
c
c     latmn obtains mean of w1 over latitudinal belt l1-l2
c
      common/data3/ihem
      dimension w1(37)
      data pi/3.14159/
      rad = 180.0/pi
      xmean=0.0
      dl=0.0
      dlat=pi*2.5/180.
      do 100 l=l1,l2
      alat=(float(l)-.5)*2.5*pi/180.
      if(ihem.eq.2) alat=alat-(90.0/rad)
      xmean=xmean+cos(alat)*dlat*.5*(w1(l)+w1(l+1))
      dl=dl+cos(alat)*dlat
  100 continue
      xmean=xmean/dl
      return
      end
c ------- fanl for dey stat codes----------
      subroutine fanl(a,b,f)
      dimension f(145),a(20),b(21),w(200)
      complex w,c
      nn=145
      n2=20
      an = nn/2
      nn2 = nn-1
      pi = 3.14159265897932
      cnst = 1./an
      ang = cnst * pi
      ca = cos(ang)
      sa = sin(ang)
      c = cmplx(ca,sa)
      w(1) = (1.0,0.0)
      do 13 j = 2,nn
      w(j) = c*w(j-1)
   13 continue
      do 3 k = 1,n2
      a(k) = 0.0
      b(k) = 0.0
      do 4 j = 1,nn2
      i = mod(k*(j-1),nn2) + 1
      ca = real(w(i))
      sa = aimag(w(i))
      a(k) = f(j)*sa + a(k)
      b(k) = f(j)*ca + b(k)
    4 continue
      a(k) = a(k)/an
      b(k) = b(k)/an
    3 continue
  100 format(1h0/(7e15.4))
      xbar=0.0
      do 30 i=1,nn2
      xbar=xbar+f(i)/nn2
   30 continue
      b(n2+1)=xbar
      return
      end
      subroutine acgrid(y,x,c,weight,lamin,lamax,lomin,lomax,qx4)
c ---------------------------------------------------------------
c      calculate anomaly correlation on the 2.5-degree grid over a
c       limited area - y=anl,x=fcst,c=climatology
c       using ed epstein's formulas
c      special global version for basu (73 lats) - member acbasu
c ---------------------------------------------------------------
      dimension y(145,73),x(145,73),c(145,73),weight(73),qx4(5)
      sumwt = 0.
      sumcov= 0.
      sumvrx= 0.
      sumvry= 0.
      sumxb = 0.
      sumyb = 0.
      smxbyb= 0.
      sumxbs= 0.
      sumybs= 0.
      cntla=0.
      sumx=0.
      sumy=0.
      do 37 la=lamin, lamax
        cntla=0.
        sumx =0.
        sumy =0.
        sumxy=0.
        sumxx=0.
        sumyy=0.
        do 73 lo=lomin,lomax
          xa=x(lo,la)-c(lo,la)
          ya=y(lo,la)-c(lo,la)
          cntla=cntla + 1.
          sumx = sumx + xa
          sumy = sumy + ya
          sumxy= sumxy+ xa*ya
          sumxx= sumxx+ xa*xa
          sumyy= sumyy+ ya*ya
   73   continue
c
        xbar = sumx /cntla
        ybar = sumy /cntla
        xybar= sumxy/cntla
        xxbar= sumxx/cntla
        yybar= sumyy/cntla
c - - - - get averages over the current latitude belt
        covla = xybar - xbar*ybar
        varxla= xxbar - xbar*xbar
        varyla= yybar - ybar*ybar
c - - - - increment weighted sums over all latitudes
        w=weight(la)
        sumwt=sumwt + w
        sumcov = sumcov + w*covla
        sumvrx = sumvrx + w*varxla
        sumvry = sumvry + w*varyla
        sumxb  = sumxb  + w*xbar
        sumyb  = sumyb  + w*ybar
        smxbyb = smxbyb + w*xbar*ybar
        sumxbs = sumxbs + w*xbar*xbar
        sumybs = sumybs + w*ybar*ybar
   37 continue
      cov = (sumcov + smxbyb- sumxb*sumyb/sumwt)/sumwt
      varx =(sumvrx + sumxbs- sumxb*sumxb/sumwt)/sumwt
      vary =(sumvry + sumybs- sumyb*sumyb/sumwt)/sumwt
      if( (varx.gt.0.).or.(vary.gt.0.))go to 12
        write(6,101)
        correl=99.
        go to 13
   12 correl = cov/sqrt(varx*vary)
   13 do 10 j = 1,4
   10 qx4(j)=correl
  101 format ( '%%%% trouble in ancoree %%%%')
      return
      end
      subroutine fgroup(num,en,gave,igcon)
      dimension en(num)
c ----
c if igcon = 1,  8 members for 00Z pertubation running
c if igcon = 2, 10 members for 00Z pertubation running
c if igcon = 3, 14 members for 00Z 12Z pertubation running
c ---- 
      gave=0.0
      if (igcon.eq.1) then
        do i=3,10
        gave=gave+en(i)/8.0
        enddo
      else if (igcon.eq.2) then
        do i=3,12
        gave=gave+en(i)/10.0
        enddo
      else if (igcon.eq.3) then
        do i=3,12
        gave=gave+en(i)/14.0
        enddo
        do i=14,17
        gave=gave+en(i)/14.0
        enddo
      else
        gave=999999.0
      endif
      return
      end
      subroutine spread(num,en,ave,spr,kcnt)
      dimension en(num),em(num)
c ----
c kcnt is a control number
c   kcnt ---> 1 or 34 for total NCEP or ECMWF members
c   kcnt ---> 2 for NCEP first 8 pertubation members
c   kcnt ---> 3 for NCEP first 10 pertubation members
c   kcnt ---> 4 for NCEP first 14 pertubation members
c ----
      m=num
      av=ave
      asum=0.0
      do i=1,num
       em(i)=en(i)
      enddo
      if (kcnt.eq.2) then
       m=8
       av=0.0
       do i=1,8
          en(i) = en(i+2)
          av   = av + en(i)/8.0
       enddo
      else if (kcnt.eq.3) then
       m=10
       av=0.0
       do i=1,10
          en(i) = en(i+2)
          av   = av + en(i)/10.0
       enddo
      else if (kcnt.eq.4) then
       m=14
       av=0.0
       do i=1,10
          en(i) = en(i+2)
          av   = av + en(i)/14.0
       enddo
       do i=11,14
          en(i) = en(i+3)
          av   = av + en(i)/14.0
       enddo
      endif
      do j=1,m
         aa=(av-en(j))*(av-en(j))
         asum=asum+aa
      enddo
      spr=asum
      do i=1,num
       en(i)=em(i)
      enddo
      return
      end
      subroutine spreax(num,en,ave,spr)
      dimension en(num)                                      
      asum17=0.0
      do j=1,num 
         aa=(ave-en(j))*(ave-en(j))                      
         asum17=asum17+aa
      enddo
      spr=asum17             
      return
      end
      subroutine aatobb(grid,zunp)
c ----
c convert data from 1-dimension to 2-dimension
c output:  i(lat)=1 ---> north pole
c          i(lat)=37---> equator
c          i(lat)=73---> south pole
c ----
      dimension grid(10512),zunp(145,73)
      icnt = 0
       do i = 1, 73
         do j = 1, 144
            icnt = icnt + 1
c           zunp(j,73-i+1) = grid(icnt)
            zunp(j,i)   = grid(icnt)
         enddo
            zunp(145,i) = zunp(1,i)
       enddo
      return
      end
      subroutine talagr(n,m,en,ve,it,ave,xmed,prms,irel,jcon)
c ----
c Subroutine to calculate talagrand histogram for ensemble fcsts
c     call in a do loop over gridpoints
c     input:
c            n   ---> # of ensember forecasts
c            m   ---> # of ensember forecasts to be verify ( need specify)
c            en  ---> vector of n containning forecasts at gridpoint
c            ve  ---> value of verification at gridpoint ( analysis )
c            jcnt---> control the initial tms calculation
c     output:
c            it  ---> vector of n+1 containing zeroes except 1 for bin containing truth
c            ave ---> average of ensemble fcsts
c            xmed---> median of ensemble fcsts
c            prms---> rms error for initial time
c            irel---> vector of n containning the relative position
c                     between analysis and forecasts
c ----
      dimension en(n),em(n),enb(m,2),ena(m,3),irel(n)
      dimension it(n+1)
      irel = 0
      it   = 0
      ave  = 0.
      xmed = 0.
      prms = 0.
      do i=1,n
       em(i)=en(i)
      enddo
c ----
c calculate rms -- Yuejian Zhu
c ----
      if(jcon.eq.1) then         ! for 12z run two pairs
        do i=14,17
          prms=prms + (ve-en(i))*(ve-en(i))
        enddo
      endif
      if(jcon.eq.2) then         ! for 00Z run five pairs
        do i=3,12
          prms=prms + (ve-en(i))*(ve-en(i))
        enddo
      endif
c ----
c For kcnt regroup the input arrary
c     kcnt=1  keep original arrangment.(17 for NCEP, 34 for ECM)
c     kcnt=2  choose 14 members to group
c     kcnt=3  choose 32 members to group
c ----
      if (m.eq.14) then
       do i=1,10
        en(i)=en(i+2)
       enddo
       do i=11,14
        en(i)=en(i+3)
       enddo
      else if (m.eq.32) then
       do i=1,32
        en(i)=en(i+2)
       enddo
      endif
      do i=1,m
        enb(i,1)=i
        enb(i,2)=en(i)
        ena(i,1)=i
        ena(i,2)=en(i)
        it(i)=0
c ----
c calculate the average
c ----
        ave=ave+en(i)/float(m)
      enddo
c ----
c to order data
c ----
       call sortm(ena,m,3,2)
c ----
c get relative position for analysis
c ---- Yuejian Zhu
c ----
       do i = 1, m
        if (ve.le.ena(i,2)) then
          if (i.eq.1) then
           iii=ena(i,3)
           irel(iii) = 2
          else
           iii=ena(i,3)
           jjj=ena(i-1,3)
           irel(iii) = 1
           irel(jjj) = 1
          endif
          goto 100
        endif
       enddo
        iii=ena(m,3)
        irel(iii) = 2
 100  continue
c ----
c to calculate the talagrand histogram
c ----
       do i=1,m
         if(ve.le.ena(i,2)) then
          it(i)=1
          goto 200
         endif
       enddo
          it(m+1)=1
 200  continue
c ----
c to calculate the median
c ----
      im=m/2
      if(mod(m,2).eq.1) then
          xmed=ena(im+1,2)
      else
          xmed=(ena(im,2)+ena(im+1,2))/2.
      endif
      do i=1,n
       en(i)=em(i)
      enddo
      return
      end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	subroutine to compute talagrand histogram for ensemble fcsts
c	call in a do loop over gridpoints
c	input:
c	n=number of ensemble fcsts
c	en=vector of n containing values from ensemble at gridpoint considered
c	ve=value of verification at gridpoint
c	output:
c	it=vector of n+1 containing zeroes except 1 for bin containing truth
c	ave=average of ensemble fcsts
c	xmed=median of ensemble fcsts
c	add up "it" vectors for each gridpoint in region considered to arrive at final
c		count. these vectors will need to be added up to get statistics over a
c		month or season etc.
      subroutine talag(n,en,ve,it,ave,xmed,prms,irel,jcon)
      dimension en(n),enb(n,2),ena(n,3),irel(n)
      integer it(n+1)
      irel=0
      ave=0.
      xmed=0.
      prms=0.
c calculate rms -- Yuejian Zhu
          if(jcon.eq.1) then         ! for 12z run two pairs
           do i=14,17                    
           prms=prms + (ve-en(i))*(ve-en(i))
           enddo
          endif
          if(jcon.eq.2) then         ! for 00Z run five pairs
           do i=3,12                    
           prms=prms + (ve-en(i))*(ve-en(i))
           enddo
          endif
c
	  do 100 i=1,n
	  enb(i,1)=i
	  enb(i,2)=en(i)
	  ena(i,1)=i
	  ena(i,2)=en(i)
	  it(i)=0
c	average
	  ave=ave+en(i)/float(n)
 100  continue
	  it(n+1)=0
c	ordering data
	  call sortm(ena,n,3,2)
c ----
c get relative position for analysis
c ---- Yuejian Zhu
c ----
          do i = 1, n
          if (ve.le.ena(i,2)) then
           if (i.eq.1) then
            iii=ena(i,3)
            irel(iii) = 2
           else
            iii=ena(i,3)
            jjj=ena(i-1,3)
            irel(iii) = 1
            irel(jjj) = 1
           endif
           goto 101
          endif
          enddo
            iii=ena(n,3)
            irel(iii) = 2
 101  continue
c	talagrand histogram
	  do 110 i=1,n
	  if(ve.le.ena(i,2)) then
	  it(i)=1
	  go to 200
	  endif
 110  continue
	  it(n+1)=1
 200  continue
c	median
	  im=n/2
      if(mod(n,2).eq.1) then
	  xmed=ena(im+1,2)
	  else
	  xmed=(ena(im,2)+ena(im+1,2))/2.
	  endif
	  return
	  end
      subroutine sortm(a,n,nc,k)
      dimension a(n,nc),b(n,nc),js(n)
c ----
c
c ----
      do i1 = 1, n
      iless = 0
      imore = 0
      ieq   = 0
      aa=a(i1,k)
      do i2 = 1, n
       bb=a(i2,k)
       if ( aa.lt.bb ) iless = iless + 1
       if ( aa.gt.bb ) imore = imore + 1
       if ( aa.eq.bb ) then
          ieq   = ieq   + 1
          js(ieq) = i2
       endif
      enddo
       if ( ieq.eq.1) then
          b(imore+1,2)=aa
          b(imore+1,1)=i1
       else
        do i3 = 1, ieq
          b(imore+i3,2)=aa
          b(imore+i3,1)=js(i3)
        enddo
       endif
      enddo
      do jj= 1, n
        a(jj,3) = b(jj,1)
        a(jj,2) = b(jj,2)
      enddo
      return
      end
      subroutine fptala(ggrid,pgrid,m,fita)
      dimension ggrid(10512,17),pgrid(10512,17)
      dimension fit(m+1,m,3),fita(m+1,3)       
      dimension it(m+1),en(17),irel(17),acwt(73)
      dimension ikk(14)
      data ikk /3,4,5,6,7,8,9,10,11,12,14,15,16,17/
c ----
c to calculate talagrand histogram and N+1 distribution
c ----
       acwt = 0.0 
       fit  = 0.0
       fita = 0.0
       do ii = 1, m 
         if (m.eq.14) then
             iii=ikk(ii)
         else
             iii=ii
         endif
       do jj = 1, 10512             ! do loop for each grid point   
c ----
c calculate the weight for each latitude
c ----
        lat = (jj -1)/144     
        weight     =sin( lat * 2.5 * 3.1415926 / 180.0 )
        acwt(lat+1)=weight                                 
        do kk = 1, 17
         en(kk) = ggrid(jj,kk)
        enddo
         an     = pgrid(jj,iii)
c ----
c en --> forecast
c an --> previous 24 hours forecast
c     ave ---> 17 members average
c     xmed --> the medium of 17 members
c ----
         call talagr(17,m,en,an,it,ave,xmed,prms,irel,jcon)
c ----
c for Northern Hemsphere, 77.5N-20.0N (24 lats, 6-29)
c     jj=721  ---> jj=4176 (3456 points)
c ----
        if ( jj.ge.721.and.jj.le.4176 ) then
        do kk = 1, m+1
         fit(kk,ii,1) = fit(kk,ii,1) + it(kk)*weight/144.0
        enddo
        endif
c ----
c for Southern Hemsphere, 20.0S-72.5S (24 lats, 45-68)
c     jj=6337 ---> jj=9792 (3456 points)
c ----
        if ( jj.ge.6337.and.jj.le.9792 ) then
        do kk = 1,  m+1
         fit(kk,ii,2) = fit(kk,ii,2) + it(kk)*weight/144.0
        enddo
        endif
c ----
c for Tropical area, 20.0N-20.0S  (17 lats, 29-45)     
c     jj=4033 ---> jj=6480 (2448 points)
c ----
        if ( jj.ge.4033.and.jj.le.6480 ) then
        do kk = 1, m+1
         fit(kk,ii,3) = fit(kk,ii,3) + it(kk)*weight/144.0
        enddo
        endif
       enddo                               ! end do loop for jj=1,ixy
c ----
c normalize the N+1 distribution scores
c ----
        acwtn = 0.0
        acwts = 0.0
        acwtt = 0.0
        do kk = 1, 24
         acwtn = acwtn + acwt(kk+ 5)
         acwts = acwts + acwt(kk+44)
        enddo
        do kk = 1, 17
         acwtt = acwtt + acwt(kk+28)
        enddo
        do kk = 1, m+1
         fit(kk,ii,1) = fit(kk,ii,1)*100.0/acwtn
         fit(kk,ii,2) = fit(kk,ii,2)*100.0/acwts
         fit(kk,ii,3) = fit(kk,ii,3)*100.0/acwtt
        enddo
      enddo                               ! end do loop for ii=1,17
      rm=m
      do kk = 1,  m+1
       do ii = 1, m 
          fita(kk,1) = fita(kk,1) + fit(kk,ii,1)/rm   
          fita(kk,2) = fita(kk,2) + fit(kk,ii,2)/rm    
          fita(kk,3) = fita(kk,3) + fit(kk,ii,3)/rm    
       enddo
      enddo
      return
      end
