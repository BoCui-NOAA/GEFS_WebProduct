       subroutine evalue(hr,far,im1,fv)
c
c      This program will calculate the economic value of forecasts
c      copied from ~wd20zt/value/value.f of sgi machine
c      modified by Yuejian Zhu    (02/09/2001)
c

c      xml    - mitigrated loss
c      xc     - cost
c      xl     - loss
c      clfr   - climate frequency of forecast
c

       parameter (clfr=0.1,im=100,icl=18)
c      dimension hr(*),   far(*),     v(11,2), xmefc(im)
       dimension hr(*),   far(*),     v(im1,2), xmefc(im)
       dimension xml(icl), xc(icl), xl(icl),     fv(icl)

ccc... data for assume xml, xc and xl for totally 18 levels
       data xml/1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,
     *          1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00/
       data xc /1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,
     *          1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00/
       data xl /1.05,1.10,1.25,1.50,2.00,3.00,5.00,8.00,10.0,
     *          18.0,27.0,40.0,60.0,90.0,140.,210.,350.,500./

ccc... loop over cost/loss ratios

        do j = 1, 18

         do i = 1, im1
          v(i,1) = i
         enddo 

c
c              |       Yes           |        No
c       ----------------------------------------------------
c         YES  |  h(its)             |   m(isses)
c              |  M(itigated) L(oss) |   L(oss)
c       ----------------------------------------------------
c         NO   |  f(alse alarms)     |   c(orrect rejections)
c              |  C(ost)             |   N(o cost)
c       ----------------------------------------------------
c
c       Mean Expense (general forecast) = h*ML + m*L + f*C
c       Mean Expense (perfect forecast) = o*ML
c       Mean Expense (climate forecast) = min[o*L,o*ML + (1-o)*C]
c        o     - climatological frequency
c        ML    - Mitigated Loss
c        C     - Cost
c        L     - Loss
c        h     - hites
c        m     - misses
c        f     - false alarms
c
c      Value = (ME(cl) - ME(fc))/(ME(cl) - ME(perf))

c      xmecl   - mean expense for climate forecast
c      xmeperf - mean expense for perfect forecast
c      xmehr   - mean expense for high resolution forecast 
c
c      xme1    - loss from climatological frequency  [ o*L ]
c      xme2    - loss from cost and mitigated loss [ o*ML + (1-o)*C ]
c       if xme2.lt.xme1    means need protect ( always )
c       if xme2.ge.xme1    means need giveup  ( never  )
c
         xme1 = clfr*xl(j)
         xme2 = clfr*xml(j)+(1-clfr)*xc(j)
         xme  = xme1
         if(xme2.lt.xme1) xme=xme2

c        if(xme2.lt.xme1) print *,'always protect'
         if(xme2.lt.xme1) np=1

c        if(xme2.ge.xme1) print *,'never  protect'
         if(xme2.ge.xme1) np=0

         xmecl  = xme
         xmeperf= clfr*xml(j)
c        print *, 'ens'
c  loop over ens probabilities
         do i = 1, im1
          xmefc(i) = clfr*hr(i)*xml(j) 
     *             + clfr*(1-hr(i))*xl(j)
     *             + (1-clfr)*far(i)*xc(j)
          v(i,2)   = (xmecl-xmefc(i))/(xmecl-xmeperf)
c         print *,v(i,2)
         enddo     

         call sortm(v,im1,2,2)

         fv(j) = v(im1,2)
         write(6,66)  kd,1./xl(j),np,v(im1,2),v(im1,1)
        enddo               ! do j = 1, 18

        write(6,67)
 66    format(1x,i2,f7.4,i2,2f8.3)
 67    format(1x)

       return
       end
C   generalized version of sort subroutine for multidim. arrays
C
C   a(n,nc) array of n rows, nc columns to be sorted by column k
C
C
      SUBROUTINE SORTm(A, N,nc,k)
      PARAMETER (M=50)
      INTEGER N, I, J, L, R, S, STACK(M, 2)
      REAL A(n,nc), X, W
C
      S = 1
      STACK(1, 1) = 1
      STACK(1, 2) = N
  100 CONTINUE
C  SIMULATE OUTER REPEAT LOOP ...
          L = STACK(S, 1)
          R = STACK(S, 2)
          S = S - 1
  200     CONTINUE
C  SIMULATE MIDDLE REPEAT LOOP ...
              I = L
              J = R
c   change last # for column to be sorted *********
              X = A ((L+R)/2, k)
  300         CONTINUE
C  SIMULATE INNER REPEAT LOOP
  400             CONTINUE
C  SIMULATE WHILE LOOP
c   change #  **************************************
                  IF (A(I, k).LT.X) THEN
                      I = I + 1
                      GOTO 400
                  ENDIF
  500             CONTINUE
C  SIMULATE WHILE LOOP
c   change #  **************************************
                  IF (X.LT.A(J, k)) THEN
                      J = J -1
                      GOTO 500
                  ENDIF
                  IF (I.LE.J) THEN
c  2nd # is total # of columns **********************
                      do 1000 icol = 1, nc, 1
                          W    = A(I, icol)

                          A(I, icol) = A(J, icol)
                          A(J, icol) = W
 1000                 continue
                      I = I + 1
                      J = J - 1
                  ENDIF
C  END OF INNER REPEAT LOOP
              IF (I.LE.J) GOTO 300
              IF (I.LT.R) THEN
                  S = S + 1
                  IF (S.GT.M) THEN
                      PRINT *, 'STACK OVERFLOW IN QSORT'
                      STOP 'STACK OVF'
                  ENDIF
                  STACK(S, 1) = I
                  STACK(S, 2) = R
              ENDIF
              R = J
C  END OF MIDDLE REPEAT LOOP
          IF (L.LT.R) GOTO 200
C  END OF OUTER REPEAT LOOP
      IF (S.GT.0) GOTO 100
      RETURN
      END

