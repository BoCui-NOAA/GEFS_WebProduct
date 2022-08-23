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
c   kcnt ---> 1 for NCEP or ECMWF full (17 or 34) members
c   kcnt ---> 2 for NCEP first  8 pertubation members
c   kcnt ---> 3 for NCEP first 10 pertubation members
c   kcnt ---> 4 for NCEP first 14 pertubation members
c   kcnt ---> 5 for NCEP 23 ensemble members
c   kcnt ---> 6 for NCEP second 10 pertubation members
c   kcnt ---> 7 for NCEP 10 + 10   pertubation members
c ----
      spr     =  9999.99
      ave     = -9999.99
      av      = 0.0
      igrp(1) = 17
      igrp(2) = 8
      igrp(3) = 10
      igrp(4) = 14
      igrp(5) = 23
      igrp(6) = 10
      igrp(7) = 20
c ----
c     do i = 1,num
c      if (en(i).eq.-9999.99) goto 100
c     enddo
c ----

      if (kcnt.eq.1.or.kcnt.eq.5) then
       do i = 1, num
        if (en(i).eq.-9999.99) then
         spr = 0.00
         goto 100
        endif
       enddo
      endif

      if (kcnt.eq.2) then
       do i = 3, 10
        if (en(i).eq.-9999.99) then
         spr = 0.00
         goto 100
        endif
       enddo
      endif

      if (kcnt.eq.3) then
       do i = 3, 12
        if (en(i).eq.-9999.99) then
         spr = 0.00
         goto 100
        endif
       enddo
      endif

      if (kcnt.eq.4.or.kcnt.eq.7) then
       do i = 3, 12
        if (en(i).eq.-9999.99) then
         spr = 0.00
         goto 100
        endif
       enddo
       do i = 14, num
        if (en(i).eq.-9999.99) then
         spr = 0.00
         goto 100
        endif
       enddo
      endif

      if (kcnt.eq.6) then
       do i = 14, inum
        if (en(i).eq.-9999.99) then
         spr = 0.00
         goto 100
        endif
       enddo
      endif

      icnt = 0
      do i = 1,igrp(kcnt)
       icnt = icnt + 1
       if (kcnt.eq.1.or.kcnt.eq.5) then
        j = i
       elseif (kcnt.eq.2.or.kcnt.eq.3) then
        j = i+2
       elseif (kcnt.eq.4.or.kcnt.eq.7) then
        if (i.le.10) then
         j = i+2
        else
         j = i+3
        endif
       else
        j = i+13
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

