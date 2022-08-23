      subroutine talagr(n,m,en,ve,it,xave,xmed,irel,xspr,jcon)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: TO CALCULATE TALAGRAND HISTOGRAM FOR ENSEMBLE FORECASTS         C
C            ON ONE GRID POINT                                               C
C     CODE : F77 on IBMSP --- Yuejian Zhu (07/12/99)                         C
C                                                                            C
C     INPUT: n    number of ensember forecasts                               C
C            m    number of ensember forecasts to be verify                  C
C            en   vector of n containning forecasts at gridpoint             C
C            ve   value of verification at gridpoint ( analysis )            C
C            jcon control the initial rms calculation                        C
C                 if jcon=101 --> 00Z 10 members                             C
C                 if jcon=102 --> 18Z 10 members                             C
C                 if jcon=103 --> 12Z 10 members                             C
C                 if jcon=104 --> 06Z 10 members                             C
C                 if jcon=105 --> 10 members from (5,5,0,0)                  C
C                 if jcon=106 --> 10 members from (4,3,3,0)                  C
C                 if jcon=107 --> 10 members from (3,3,2,2)                  C
C                 if jcon=201 --> 00Z 10 members + 18Z 10 members            C
C                 if jcon=202 --> 00Z 10 members + 12Z 10 members            C
C                                                                            C
C     OUTPUT: it   vector of n+1 containing zeroes except 1 for              C
C                  bin containing truth                                      C
C             ave  average of ensemble fcsts                                 C
C             xmed median of ensemble fcsts                                  C
C             irel vector of n containning the relative position             C
C                  between analysis and forecasts                            C
C             xspr ensemble spread ( not normalized )                        C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      dimension en(n),em(n),enb(m,2),ena(m,3),irel(n)
      dimension it(n+1)

c ---
c Initial the data
c ---
      irel = 0
      it   = 0
      xave = -9999.99
      ave  = 0.
      xmed = -9999.99
      prms = 0.
      do i=1,n
       em(i)=en(i)
      enddo

      if (m.eq.45) then     
       if (en(1).eq.-9999.99) goto 999
       if (en(13).eq.-9999.99) goto 999
       if (en(24).eq.-9999.99) goto 999
       if (en(35).eq.-9999.99) goto 999
      endif
      if (m.eq.40) then
       if (en(3).eq.-9999.99) goto 999
       if (en(14).eq.-9999.99) goto 999
       if (en(25).eq.-9999.99) goto 999
       if (en(36).eq.-9999.99) goto 999
      endif
      if (m.eq.30) then
       if (en(3).eq.-9999.99) goto 999
       if (en(14).eq.-9999.99) goto 999
       if (en(25).eq.-9999.99) goto 999
      endif
      if (m.eq.23.and.en(1).eq.-9999.99) goto 999
      if (m.eq.20.and.jcon.eq.201) then
       if (en(3).eq.-9999.99) goto 999
       if (en(14).eq.-9999.99) goto 999
      endif
      if (m.eq.20.and.jcon.eq.202) then
       if (en(3).eq.-9999.99) goto 999
       if (en(25).eq.-9999.99) goto 999
      endif
      if (m.eq.10) then
       if (jcon.eq.101.and.en(3).eq.-9999.99) goto 999
       if (jcon.eq.102.and.en(14).eq.-9999.99) goto 999
       if (jcon.eq.103.and.en(25).eq.-9999.99) goto 999
       if (jcon.eq.104.and.en(36).eq.-9999.99) goto 999
       if (jcon.eq.105.and.en(3).eq.-9999.99) goto 999
       if (jcon.eq.106.and.en(3).eq.-9999.99) goto 999
       if (jcon.eq.107.and.en(3).eq.-9999.99) goto 999
      endif
c ----
c Regrouping the data arrary
c     for m = 45  do nothing
c         m = 23  group out 23 members for old configuration
c         m = 10 jcon = 101 00Z 10 members
c         m = 10 jcon = 102 18Z 10 members
c         m = 10 jcon = 103 12Z 10 members
c         m = 10 jcon = 104 06Z 10 members
c         m = 10 jcon = 105 10 members from 5,5,0,0
c         m = 10 jcon = 106 10 members from 4,3,3,0
c         m = 10 jcon = 107 10 members from 3,3,2,2
c         m = 20 jcon = 201 for t00z and t18z 20 ensemble members
c         m = 20 jcon = 202 for t00z and t12z 20 ensemble members
c         m = 40 for 40 ensemble members
c ----
      if (m.eq.40) then
       do i=1,10
        en(i)=em(i+2)
       enddo
       do i=11,20
        en(i)=em(i+3)
       enddo
       do i=21,30
        en(i)=em(i+4)
       enddo
       do i=31,40
        en(i)=em(i+5)
       enddo
      elseif (m.eq.30) then
       do i=1,10
        en(i)=em(i+2)
       enddo
       do i=11,20
        en(i)=em(i+3)
       enddo
       do i=21,30
        en(i)=em(i+4)
       enddo
      elseif (m.eq.20.and.jcon.eq.201) then
       do i=1,10
        en(i)=em(i+2)
       enddo
       do i=11,20
        en(i)=em(i+3)
       enddo
      elseif (m.eq.20.and.jcon.eq.202) then
       do i=1,10
        en(i)=em(i+2)
       enddo
       do i=11,20
        en(i)=em(i+14)
       enddo
      elseif (m.eq.10.and.jcon.eq.101) then
       do i=1,10
        en(i)=em(i+2)
       enddo
      elseif (m.eq.10.and.jcon.eq.102) then
       do i=1,10
        en(i)=em(i+13)
       enddo
      elseif (m.eq.10.and.jcon.eq.103) then
       do i=1,10
        en(i)=em(i+24)
       enddo
      elseif (m.eq.10.and.jcon.eq.104) then
       do i=1,10
        en(i)=em(i+35)
       enddo
      elseif (m.eq.10.and.jcon.eq.105) then
       do i=1,5
        en(i)=em(i+2)
       enddo
       do i=6,9
        en(i)=em(i+8)
       enddo
        en(10)=em(19)
      elseif (m.eq.10.and.jcon.eq.106) then
       do i=1,4
        en(i)=em(i+2)
       enddo
       do i=5,7 
        en(i)=em(i+9)
       enddo
        en(8)=em(25)
        en(9)=em(26)
        en(10)=em(28)
      elseif (m.eq.10.and.jcon.eq.107) then
       en(1)=em(3)
       en(2)=em(4)
       en(3)=em(5)
       en(4)=em(14)
       en(5)=em(15)
       en(6)=em(17)
       en(7)=em(25)
       en(8)=em(26)
       en(9)=em(36)
       en(10)=em(37)
      endif
c ----
c to calculate the average
c ----
      do i = 1, m
       enb(i,1) = i
       enb(i,2) = en(i)
       ena(i,1) = i
       ena(i,2) = en(i)
       it(i)    = 0
       ave=ave+en(i)/float(m)  
      enddo
      xave=ave
c ----
c to calculate the ensemble spread
c ----
      xsum=0.0
      do i = 1, m
       xsum=xsum+(ave-en(i))*(ave-en(i))
      enddo
      xspr=xsum
c     xspr=1.0/float(m-1) * xsum
c ----
c to order data
c ----
      call sortmm(ena,m,3,2)
c ----
c get relative position for analysis - Yuejian Zhu
c ----
       do i = 1, m
        if (ve.le.ena(i,2)) then
         if (i.eq.1) then
          iii=ena(i,3)
          irel(iii) = 2
         else
          iii=ena(i,3)
          jjj=ena(i-1,3)
          irel(iii) = 1
          irel(jjj) = 1
         endif
         goto 100
        endif
       enddo
       iii=ena(m,3)
       irel(iii) = 2
 100  continue

c ----
c to calculate the talagrand histogram
c ----
      do i=1,m
       if(ve.le.ena(i,2)) then
        it(i)=1
        goto 200
       endif
      enddo
      it(m+1)=1
 200  continue

c ----
c to calculate the median
c ----
      im=m/2
      if(mod(m,2).eq.1) then
       xmed=ena(im+1,2)
      else
       xmed=(ena(im,2)+ena(im+1,2))/2.
      endif
      do i=1,n
       en(i)=em(i)
      enddo
 999  continue
      return
      end

