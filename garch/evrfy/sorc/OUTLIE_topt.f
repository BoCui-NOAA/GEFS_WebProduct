      subroutine outlie(agrid,ggrid,pgrid,m,ogrid) 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: CALCULATE THE OUTLINE OF TOTAL 40 MEMBERS AND DISTANCE          C
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
      dimension enf(40),en(38)

      ogrid=0.0
c ----
c to calculate outlier dirtributions                             
c ----
      do lat = 1, 73               ! do loop for each latitude
       do lon = 1, 144             ! do loop for each logitude
        do ij = 1, 20              ! do loop for each pairs    
         do ijk = 1, 2             ! do loop for +/- members

          do kk = 3, 12            ! T00Z 10+10 members
           enf(kk-2)  = ggrid(lon,lat,kk)
           enf(kk+18) = pgrid(lon,lat,kk)
          enddo
          do kk = 14, 23           ! T12Z 10+10 members
           enf(kk-3)  = ggrid(lon,lat,kk)
           enf(kk+17) = pgrid(lon,lat,kk)
          enddo

          kk = ij*2 - 1
          kkk = kk + ijk -1
          enf(kk)     = enf(39)
          enf(kk+1)   = enf(40)

          do kk = 1, 38
           en(kk) = enf(kk)
          enddo 
          an      = ggrid(lon,lat,kkk)

c ----
c en   --> forecast ( 20 # days + 20 # day + 1 lead times )
c an   --> current analysis                    
c ave  --> 40 members average
c spr  --> 40 members spread 
c ----
          ave = 0.0
          spr = 0.0
          call sort(en,38)
          
          if (an.lt.en(1).or.an.gt.en(38)) then
           ogrid(lon,lat) = ogrid(lon,lat) + 1.0
          endif
c         if (an.lt.en(1).or.an.gt.en(38)) then
c          do kk = 1, 38
c           ave = ave + en(kk)/38.0
c          enddo
c          do kk = 1, 38
c           spr = spr + (ave - en(kk))*(ave - en(kk))
c          enddo
c          if (spr.eq.0.0) then
c           ogrid(lon,lat) = 0.0
c          else
c           ogrid(lon,lat) = (ave-an)/sqrt(spr/37.0)
c          endif
c         else
c          ogrid(lon,lat)  = -999.99
c         endif

         enddo                            ! end do loop for ijk
        enddo                             ! end do loop for ij
       enddo                              ! end do loop for lon=1,144
      enddo                               ! end do loop for lat=1,73
      return
      end

