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
      dimension igrp(4)
c ----
c kcnt is a control number
c   kcnt ---> 1 for NCEP or ECMWF full (17 or 34) members
c   kcnt ---> 2 for NCEP first  8 pertubation members
c   kcnt ---> 3 for NCEP first 10 pertubation members
c   kcnt ---> 4 for NCEP first 14 pertubation members
c ----
      spr     =  9999.99
      ave     = -9999.99
      av      = 0.0
      igrp(1) = 17
      igrp(2) = 8
      igrp(3) = 10
      igrp(4) = 14
c ----
c     do i = 1,num
c      if (en(i).eq.-9999.99) goto 100
c     enddo
c ----

      if (kcnt.eq.1) then
       if (en(1).eq.-9999.99.or.en(13).eq.-9999.99) then
       spr = 0.00
       goto 100
       endif
      endif
      if (kcnt.eq.2.and.en(3).eq.-9999.99) then
       spr = 0.00
       goto 100
      endif
      if (kcnt.eq.3.and.en(3).eq.-9999.99) then
       spr = 0.00
       goto 100
      endif
      if (kcnt.eq.4) then
       if (en(3).eq.-9999.99.or.en(14).eq.-9999.99) then
       spr = 0.00
       goto 100
       endif
      endif

      icnt = 0
      do i = 1,igrp(kcnt) 
       icnt = icnt + 1
       if (kcnt.ne.4) then
        if (kcnt.eq.1) then
         j = i
        else
         j = i+2
        endif
        em(icnt) = en(j)
        av = av + en(j)/float(igrp(kcnt))
       else
        if (i.le.10) then
         j = i+2
        else
         j = i+3
        endif
        em(icnt) = en(j)
        av = av + en(j)/float(igrp(kcnt))
       endif
      enddo
      asum = 0.0
      do i = 1, igrp(kcnt)
         asum=asum + (av-em(i))*(av-em(i))
      enddo
      spr=asum
      ave=av
 100  return
      end

