      subroutine fptala(ggrid,pgrid,m,fita)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: CALCULATE TALAGRANT FOR THE DIFFERENT FORECASTS                 C
C     CODE : F77 on IBMSP --- Yuejian Zhu (07/08/99)                         C
C                                                                            C
C     INPUT: ggrid(144,73,17) - current forecasts                            C
C            fgrid(144,73,17) - day +/- 1 forecasts                          C
C            m - numbers of members need evaluated                           C
C                                                                            C
C     OUTPUT: fita(m+1)                                                      C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      parameter (imem=23)
      dimension ggrid(144,73,imem),pgrid(144,73,imem)
      dimension fit(m+1,m,3),fita(m+1,3)
      dimension it(m+1),en(imem),irel(imem),acwt(73)
      dimension ikk(14),ikk0(10),ikk2(10)
      data ikk /3,4,5,6,7,8,9,10,11,12,14,15,16,17/
      data ikk0/3,4,5,6,7,8,9,10,11,12/
      data ikk2/14,15,16,17,18,19,20,21,22,23/

c ----
c to calculate talagrand histogram and N+1 distribution
c ----
      acwt = 0.0
      fit  = 0.0
      fita = 0.0
      if (m.gt.100) then
       mm = m/10
      else
       mm = m
       jcon = 0
      endif

      do ii = 1, mm
       if (m.eq.14) then
        iii=ikk(ii)
       elseif (m.eq.101) then
        iii=ikk0(ii)
       elseif (m.eq.102) then
        iii=ikk2(ii)
       else
        iii=ii
       endif

       do lat = 1, 73               ! do loop for each latitude
c ----
c calculate the weight for each latitude
c ----
        weight     =sin( (lat-1) * 2.5 * 3.1415926 / 180.0 )
        acwt(lat)  =weight
        do lon = 1, 144             ! do loop for each logitude
         do kk = 1, imem
          en(kk) = ggrid(lon,lat,kk)
         enddo
         an     = pgrid(lon,lat,iii)
c ----
c en --> forecast
c an --> previous 24 hours forecast
c     ave ---> 23 members average
c     xmed --> the medium of 27 members
c ----
         call talagr(imem,mm,en,an,it,ave,xmed,prms,irel,m)
c ----
c for Northern Hemsphere, 77.5N-20.0N (24 lats, 6-29)
c     jj=721  ---> jj=4176 (3456 points)
c ----
         if ( lat.ge.6.and.lat.le.29 ) then
          do kk = 1, mm+1
           fit(kk,ii,1) = fit(kk,ii,1) + it(kk)*weight/144.0
          enddo
         endif
c ----
c for Southern Hemsphere, 20.0S-72.5S (24 lats, 45-68)
c     jj=6337 ---> jj=9792 (3456 points)
c ----
         if ( lat.ge.45.and.lat.le.68 ) then
          do kk = 1,  mm+1
           fit(kk,ii,2) = fit(kk,ii,2) + it(kk)*weight/144.0
          enddo
         endif
c ----
c for Tropical area, 20.0N-20.0S  (17 lats, 29-45)
c     jj=4033 ---> jj=6480 (2448 points)
c ----
c ---- notes: changed 08/09/2000

c        if ( lat.ge.29.and.lat.le.45 ) then
         if ( lat.gt.29.and.lat.lt.45 ) then
          do kk = 1, mm+1
           fit(kk,ii,3) = fit(kk,ii,3) + it(kk)*weight/144.0
          enddo
         endif
        enddo                              ! end do loop for lon=1,144
       enddo                               ! end do loop for lat=1,73
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
c ---- notes: changed 08/09/2000
c      do kk = 1, 17
c       acwtt = acwtt + acwt(kk+28)
c      enddo
       do kk = 1, 15
        acwtt = acwtt + acwt(kk+29)
       enddo
       do kk = 1, mm+1
        fit(kk,ii,1) = fit(kk,ii,1)*100.0/acwtn
        fit(kk,ii,2) = fit(kk,ii,2)*100.0/acwts
        fit(kk,ii,3) = fit(kk,ii,3)*100.0/acwtt
       enddo
      enddo                               ! end do loop for ii=1,17
      rm=m
      do kk = 1,  mm+1
       do ii = 1, mm
        fita(kk,1) = fita(kk,1) + fit(kk,ii,1)/rm
        fita(kk,2) = fita(kk,2) + fit(kk,ii,2)/rm
        fita(kk,3) = fita(kk,3) + fit(kk,ii,3)/rm
       enddo
      enddo
      return
      end

