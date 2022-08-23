      subroutine outlie_new(agrid,ggrid,pgrid,m,ogrid,qgrid) 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: CALCULATE THE OUTLIER OF TOTAL 80 MEMBERS AND DISTANCE          C
C     CODE : F77 on IBMSP --- Yuejian Zhu (09/08/00)                         C
C                                                                            C
C     INPUT: agrid(144,73)   - current analysis                              C
C            ggrid(144,73,m) - current forecasts                             C
C            fgrid(144,73,m) - day +/- 1 forecasts                           C
C            m - numbers of members need evaluated                           C
C                                                                            C
C     OUTPUT: ogrid(144,73) - zero or non-zero numbers                       C
C             qgrid(144,73) - 80 ensemble mean                               C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      dimension ggrid(144,73,m),pgrid(144,73,m)
      dimension agrid(144,73),ogrid(144,73),qgrid(144,73)
      dimension en(80)

      qgrid = -9999.99
c ----
c to calculate talagrand histogram and N+1 distribution
c ----
      do lat = 1, 73               ! do loop for each latitude
       do lon = 1, 144             ! do loop for each logitude
        do kk = 1, 20  
         en(kk)  = ggrid(lon,lat,kk)
         en(kk+40) = pgrid(lon,lat,kk)
        enddo
        do kk = 21, 40  
         en(kk)  = ggrid(lon,lat,kk)
         en(kk+40) = pgrid(lon,lat,kk)
        enddo
        an     = agrid(lon,lat)
c ----
c en   --> forecast ( 20 # days + 20 # day + 1 lead times )
c an   --> current analysis                    
c ave  --> 80 members average
c spr  --> 80 members spread 
c ----
        ave = 0.0
        spr = 0.0
c ----
c considering missing forecast cycles
c ----
        call sort(en,80)
        icnt = 0
        do kk = 1, 80
         if (en(kk).ne.-9999.99) then
          icnt = icnt + 1
          en(icnt)=en(kk)
         endif
        enddo

c ----
c making 80 ensemble average               
c ----
        do kk = 1, icnt
         ave = ave + en(kk)/float(icnt)
        enddo
       
        qgrid(lon,lat) = ave

        if (an.lt.en(1).or.an.gt.en(icnt)) then
         do kk = 1, icnt
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
       enddo                              ! end do loop f,qgrid(144,73)or lon=1,144
      enddo                               ! end do loop for lat=1,73
      return
      end

