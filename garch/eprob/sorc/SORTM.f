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

