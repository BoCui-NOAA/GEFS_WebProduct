      subroutine spread(n,m,en,ave,spr)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: TO CALCULATE ENSEMBLE SPREAD                                    C
C     CODE : F77 on IBMSP --- Yuejian Zhu (07/12/99)                         C
C                                                                            C
C     INPUT: en(n)   ( array with length n )                                 C
C            m members for spread and average                                C
C                                                                            C
C     OUTPUT: spr      ( spread )                                            C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      dimension en(n),em(m)
c ----
c kcnt is a control number
c   m ---> 10 for NCEP first 10 members               
c   m ---> 14 for NCEP first 14 members               
c   m ---> 20 for NCEP first 14 members + control               
c   m ---> 22 for NCEP first 10 members + control + gfs
c ----
      ave     = -9999.99
c     spr     = -9999.99
      spr     = 0.0      

      if (m.eq.10) then
       do i = 3, 12 
        if (en(i).eq.-9999.99) then
         goto 100
        endif
       enddo
      endif

      if (m.eq.14) then
       do i = 3, 16
        if (en(i).eq.-9999.99) then
         goto 100
        endif
       enddo
      endif

      if (m.eq.20) then
       do i = 3, 22
        if (en(i).eq.-9999.99) then
         goto 100
        endif
       enddo
      endif

      if (m.eq.22) then
       do i = 1, 22
        if (en(i).eq.-9999.99) then
         goto 100
        endif
       enddo
      endif

      av = 0.0
      do i = 1, m         
       if (m.eq.10.or.m.eq.14.or.m.eq.20) then
        j = i+2
       elseif (m.eq.22) then
        j = i
       endif
       em(i) = en(j)
       av = av + en(j)/float(m)
      enddo

      asum = 0.0
      do i = 1, m    
       asum=asum + (av-em(i))*(av-em(i))
      enddo

      spr=asum
      ave=av

 100  return
      end

