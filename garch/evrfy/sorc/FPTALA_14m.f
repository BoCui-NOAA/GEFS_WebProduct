      subroutine fptala(ggrid,pgrid,n,m,fita)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: CALCULATE TALAGRANT FOR THE DIFFERENT FORECASTS                 C
C     CODE : F77 on IBMSP --- Yuejian Zhu (07/08/99)                         C
C                                                                            C
C     INPUT: ggrid(144,73,16) - current forecasts                            C
C            fgrid(144,73,16) - day +/- 1 forecasts                          C
C            n - numbers of members forecasts                                C
C            m - numbers of members need evaluated                           C
C                                                                            C
C     OUTPUT: fita(m+1)                                                      C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      dimension ggrid(144,73,n),pgrid(144,73,n)
      dimension fit(m+1,m,3),fita(m+1,3)
      dimension it(m+1),en(n),irel(m),acwt(73)
      dimension ik10(10),ik14(14),ik15(15),ik16(16)
      data ik10 /3,4,5,6,7,8,9,10,11,12/
      data ik14 /3,4,5,6,7,8,9,10,11,12,13,14,15,16/
      data ik15 /2,3,4,5,6,7,8,9,10,11,12,13,14,15,16/
      data ik16 /1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16/

c ----
c to calculate talagrand histogram and N+1 distribution
c ----
      acwt = 0.0
      fit  = 0.0
      fita = 0.0

      do ii = 1, m
       if (m.eq.10) then
        iii=ik10(ii)
       elseif (m.eq.14) then
        iii=ik14(ii)
       elseif (m.eq.15) then
        iii=ik15(ii)
       else
        iii=ii
       endif

       nncnt = 0
       nscnt = 0
       do lat = 1, 73               ! do loop for each latitude
c ----
c calculate the weight for each latitude
c ----
        weight     =sin( (lat-1) * 2.5 * 3.1415926 / 180.0 )
        acwt(lat)  =weight
        do lon = 1, 144             ! do loop for each logitude
         do kk = 1, n
          en(kk) = ggrid(lon,lat,kk)
         enddo
         an     = pgrid(lon,lat,iii)
c ----
c en --> forecast
c an --> previous 24 hours forecast
c     ave ---> 16 members average
c     xmed --> the medium of 16 members
c ----
         call talagr(n,m,en,an,it,ave,xmed,prms,irel)
c ----
c for Northern Hemsphere, 77.5N-20.0N (24 lats, 6-29)
c     jj=721  ---> jj=4176 (3456 points)
c ----
         if ( lat.ge.6.and.lat.le.29 ) then
          nncnt=nncnt+1
          do kk = 1, m+1
           fit(kk,ii,1) = fit(kk,ii,1) + float(it(kk))*weight/144.0
          enddo
         endif
c ----
c for Southern Hemsphere, 20.0S-72.5S (24 lats, 45-68)
c     jj=6337 ---> jj=9792 (3456 points)
c ----
         if ( lat.ge.45.and.lat.le.68 ) then
          nscnt=nscnt+1
          do kk = 1,  m+1
           fit(kk,ii,2) = fit(kk,ii,2) + it(kk)*weight/144.0
          enddo
         endif
c ----
c for Tropical area, 20.0N-20.0S  (17 lats, 29-45)
c     jj=4033 ---> jj=6480 (2448 points)
c ----
c ---- notes: changed 08/09/2000

         if ( lat.gt.29.and.lat.lt.45 ) then
          do kk = 1, m+1
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
       do kk = 1, 15
        acwtt = acwtt + acwt(kk+29)
       enddo
       do kk = 1, m+1
        fit(kk,ii,1) = fit(kk,ii,1)*100.0/acwtn
        fit(kk,ii,2) = fit(kk,ii,2)*100.0/acwts
        fit(kk,ii,3) = fit(kk,ii,3)*100.0/acwtt
       enddo
      enddo                               ! end do loop for ii=1,imem

      print *, 'imem=',n,'ncnt=',nncnt,'m=',m,' acwtn=',acwtn
      print *, 'imem=',n,'scnt=',nscnt,'m=',m,' acwts=',acwts

      do kk = 1,  m+1
       do ii = 1, m
        fita(kk,1) = fita(kk,1) + fit(kk,ii,1)/float(m)
        fita(kk,2) = fita(kk,2) + fit(kk,ii,2)/float(m)
        fita(kk,3) = fita(kk,3) + fit(kk,ii,3)/float(m)
       enddo
      enddo
      return
      end

