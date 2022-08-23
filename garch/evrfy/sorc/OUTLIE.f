      subroutine outlie(agrid,ggrid,pgrid,m,ogrid) 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: CALCULATE THE OUTLIER OF TOTAL 40 MEMBERS AND DISTANCE          C
C     CODE : F77 on IBMSP --- Yuejian Zhu (09/08/00)                         C
C                                                                            C
C     INPUT: agrid(144,73)   - current analysis                              C
C            ggrid(144,73,m) - current forecasts                             C
C            fgrid(144,73,m) - day +/- 1 forecasts                           C
C            m - numbers of members need evaluated                           C
C                                                                            C
C     OUTPUT: ogrid(144,73) - zero or non-zero numbers                       C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      dimension ggrid(144,73,m),pgrid(144,73,m)
      dimension agrid(144,73),ogrid(144,73)
      dimension en(40)

c ----
c to calculate talagrand histogram and N+1 distribution
c ----
      do lat = 1, 73               ! do loop for each latitude
       do lon = 1, 144             ! do loop for each logitude
        do kk = 3, 12  
         en(kk-2)  = ggrid(lon,lat,kk)
         en(kk+18) = pgrid(lon,lat,kk)
        enddo
        do kk = 14, 23  
         en(kk-3)  = ggrid(lon,lat,kk)
         en(kk+17) = pgrid(lon,lat,kk)
        enddo
        an     = agrid(lon,lat)
c ----
c en   --> forecast ( 20 # days + 20 # day + 1 lead times )
c an   --> current analysis                    
c ave  --> 40 members average
c spr  --> 40 members spread 
c ----
        ave = 0.0
        spr = 0.0
c ----
c considering missing forecast cycles
c ----
        call sort(en,40)
        icnt = 0
        do kk = 1, 40
         if (en(kk).ne.-9999.99) then
          icnt = icnt + 1
          en(icnt)=en(kk)
         endif
        enddo
        if (an.lt.en(1).or.an.gt.en(icnt)) then
c       if (an.lt.en(1).or.an.gt.en(40)) then
         do kk = 1, icnt
c        do kk = 1, 40
          ave = ave + en(kk)/float(icnt)
c         ave = ave + en(kk)/40.0
         enddo
         do kk = 1, icnt
c        do kk = 1, 40
          spr = spr + (ave - en(kk))*(ave - en(kk))
         enddo
         if (spr.eq.0.0) then
          ogrid(lon,lat) = 0.0
         else
c         ogrid(lon,lat) = (an-ave)*39.0/sqrt(spr*spr)
c         ogrid(lon,lat) = (ave-an)/sqrt(spr/39.0)
          ogrid(lon,lat) = (ave-an)/sqrt(spr/float(icnt-1))
         endif
        else
         ogrid(lon,lat)  = -999.99
        endif
       enddo                              ! end do loop for lon=1,144
      enddo                               ! end do loop for lat=1,73
      return
      end

