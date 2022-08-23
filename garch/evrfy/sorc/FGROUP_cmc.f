      subroutine fgroup(num,en,gave,igcon)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: RE-GROUP THE FORECAST DATA AND TAKE AVERAGE             C
C     CODE : F77 on IBMSP --- Yuejian Zhu (07/08/99)                 C
C                                                                    C
C     INPUT: ensemble group data at grid point                       C
C                                                                    C
C     OUTPUT: group average value                                    C
C                                                                    C
C     Arguments:                                                     C
C               1. en(num)                                           C
C               2. num ( total numbers )                             C
C               3. gave ( group average values )                     C
C               4. igcon ( control values )                          C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c--------+----------+----------+----------+----------+----------+----------+--
      dimension en(num)
c ----
c if igcon = 1,  8 members for 00Z pertubation running
c if igcon = 2, 10 members for 00Z pertubation running
c if igcon = 3, 16 members for 00Z pertubation running
c if igcon = 4,  4 members for 12Z pertubation running
c if igcon = 5, 10 members for 12Z pertubation running
c if igcon = 6, 20 members for 00Z 12Z pertubation running
c ----
      gave=0.0
      if (igcon.eq.1) then
       do i=2,9
        if (en(i).eq.-9999.99) goto 100
        gave=gave+en(i)/8.0
       enddo
      else if (igcon.eq.2) then
       do i=2,11
        if (en(i).eq.-9999.99) goto 100
        gave=gave+en(i)/10.0
       enddo
      else if (igcon.eq.3) then
       do i=2,17
        if (en(i).eq.-9999.99) goto 100
        gave=gave+en(i)/16.0
       enddo
      else if (igcon.eq.4) then
       do i=14,17
        if (en(i).eq.-9999.99) goto 100
        gave=gave+en(i)/4.0
       enddo
      else if (igcon.eq.5) then
       do i=14,23
        if (en(i).eq.-9999.99) goto 100
        gave=gave+en(i)/10.0
       enddo
      else if (igcon.eq.6) then
       do i=3,12
        if (en(i).eq.-9999.99) goto 100
        gave=gave+en(i)/20.0
       enddo
       do i=14,23
        if (en(i).eq.-9999.99) goto 100
        gave=gave+en(i)/20.0
       enddo
      else
       print *, " igcon=",igcon," didn't defined "
       goto 100       
      endif
      return
 100  gave=-9999.99
      return
      end

