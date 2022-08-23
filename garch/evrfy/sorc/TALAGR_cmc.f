      subroutine talagr(n,m,en,ve,it,ave,xmed,prms,irel,jcon)
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
C                                                                            C
C     OUTPUT: it   vector of n+1 containing zeroes except 1 for              C
C                  bin containing truth                                      C
C             ave  average of ensemble fcsts                                 C
C             xmed median of ensemble fcsts                                  C
C             prms rms error for initial time                                C
C             irel vector of n containning the relative position             C
C                  between analysis and forecasts                            C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      dimension en(n),em(n),enb(m,2),ena(m,3),irel(n)
c     dimension it(n+1)
      dimension it(m+1)
      irel = 0
      it   = 0
      ave  = -9999.99
      xmed = -9999.99
      prms = 0.
      do i=1,n
       em(i)=en(i)
      enddo
c ----
c calculate rms -- Yuejian Zhu
c ----
      if(jcon.eq.1) then         ! for 12z run two pairs
        do i=14,17
          prms=prms + (ve-en(i))*(ve-en(i))
        enddo
      endif
      if(jcon.eq.2) then         ! for 00Z run five pairs
        do i=3,12
          prms=prms + (ve-en(i))*(ve-en(i))
        enddo
      endif
      if (m.eq.17.and.en(1).eq.-9999.99) goto 999
c--------+----------+----------+----------+----------+----------+----------+--
      if (m.eq.16.and.en(2).eq.-9999.99) goto 999
      if (m.eq.10.and.en(2).eq.-9999.99) goto 999
      if (m.eq.8.and.en(2).eq.-9999.99) goto 999
c ----
c For kcnt regroup the input arrary
c     kcnt=1  keep original arrangment.(17 for NCEP, 34 for ECM)
c     kcnt=2  choose 14 members to group
c     kcnt=3  choose 32 members to group
c ----
      if (m.eq.16) then
       do i=1,16
        en(i)=en(i+1)
       enddo
      else if (m.eq.8.or.m.eq.10) then
       do i=1,10
        en(i)=en(i+1)
       enddo
      else if (m.eq.32) then
       do i=1,32
        en(i)=en(i+2)
       enddo
      endif
      do i=1,m
        enb(i,1)=i
        enb(i,2)=en(i)
        ena(i,1)=i
        ena(i,2)=en(i)
        it(i)=0
c ----
c calculate the average
c ----
        ave=ave+en(i)/float(m)
      enddo
c ----
c to order data
c ----
       call sortmm(ena,m,3,2)
c ----
c get relative position for analysis
c ---- Yuejian Zhu
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

