      subroutine spread(num,en,ave,spr,kcnt)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: TO CALCULATE ENSEMBLE SPREAD                                    C
C     CODE : F77 on IBMSP --- Yuejian Zhu (07/12/99)                         C
C                                                                            C
C     INPUT: en(num)   ( array with length num )                             C
C            kcnt      ( control the groups )                                C
C                                                                            C
C     OUTPUT: spr      ( spread )                                            C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      dimension en(num),em(num)
      dimension igrp(7)
c ----
c kcnt is a control number
c   kcnt ---> 1 for ECMWF full (11) members
c   kcnt ---> 2 for ECMWF 10 ensemble members                 
c ----
      spr     =  9999.99
      ave     = -9999.99
      av      = 0.0
      igrp(1) = 51
      igrp(2) = 50
c ----
c     do i = 1,num
c      if (en(i).eq.-9999.99) goto 100
c     enddo
c ----

      if (kcnt.eq.1) then
       if (en(1).eq.-9999.99) then
        spr = 0.00
        goto 100
       endif
      endif

      if (kcnt.eq.2.and.en(2).eq.-9999.99) then
       spr = 0.00
       goto 100
      endif

      icnt = 0
      do i = 1,igrp(kcnt)
       icnt = icnt + 1
       if (kcnt.eq.1) then
        j = i
       elseif (kcnt.eq.2) then
        j = i+1
       endif
       em(icnt) = en(j)
       av = av + en(j)/float(igrp(kcnt))
      enddo

      asum = 0.0
      do i = 1, igrp(kcnt)
       asum=asum + (av-em(i))*(av-em(i))
      enddo

      spr=asum
      ave=av

 100  return
      end

