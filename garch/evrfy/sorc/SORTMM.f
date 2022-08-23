      subroutine sortmm(a,n,nc,k)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: SORT ONE DIMENSION DATA WITH LENGTH N                   C
C     CODE : F77 on IBMSP --- Yuejian Zhu (07/08/99)                 C
C                                                                    C
C     INPUT: array a(n,nc)                                           C
C                                                                    C
C     OUTPUT: re-order array a(n,nc)                                 C
C                                                                    C
C     Arguments:                                                     C
C               1. n  ( data length )                                C
C               2. nc ( nc=3 here )                                  C
C               3. k  ( real data location, k=2 )                    C
C     Notes    :                                                     C
C               a(n,1) -- original order number ( 1,2,... )          C
C               a(n,2) -- data                                       C
C               a(n,3) -- new output at old order                    C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c--------+----------+----------+----------+----------+----------+----------+--
      dimension a(n,nc),b(n,nc),js(n)
      do i1 = 1, n
      iless = 0
      imore = 0
      ieq   = 0
      aa=a(i1,k)
      do i2 = 1, n
       bb=a(i2,k)
       if ( aa.lt.bb ) iless = iless + 1
       if ( aa.gt.bb ) imore = imore + 1
       if ( aa.eq.bb ) then
          ieq   = ieq   + 1
          js(ieq) = i2
       endif
      enddo
       if ( ieq.eq.1) then
          b(imore+1,2)=aa
          b(imore+1,1)=i1
       else
        do i3 = 1, ieq
          b(imore+i3,2)=aa
          b(imore+i3,1)=js(i3)
        enddo
       endif
      enddo
      do jj= 1, n
        a(jj,3) = b(jj,1)
        a(jj,2) = b(jj,2)
      enddo
      return
      end

