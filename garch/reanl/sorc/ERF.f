C===================================================== ERF.FOR
C     DOUBLE PRECISION FUNCTION ERF(X)
      FUNCTION ERF(X)
C***********************************************************************
C*                                                                     *
C*  FORTRAN CODE WRITTEN FOR INCLUSION IN IBM RESEARCH REPORT RC20525, *
C*  'FORTRAN ROUTINES FOR USE WITH THE METHOD OF L-MOMENTS, VERSION 3' *
C*                                                                     *
C*  J. R. M. HOSKING                                                   *
C*  IBM RESEARCH DIVISION                                              *
C*  T. J. WATSON RESEARCH CENTER                                       *
C*  YORKTOWN HEIGHTS                                                   *
C*  NEW YORK 10598, U.S.A.                                             *
C*                                                                     *
C*  VERSION 3     AUGUST 1996                                          *
C*                                                                     *
C***********************************************************************
C
C  ERROR FUNCTION
C
C  BASED ON ALGORITHM 5666, J.F.HART ET AL. (1968) 'COMPUTER
C  APPROXIMATIONS'
C
C  ACCURATE TO 15 DECIMAL PLACES
C
      IMPLICIT DOUBLE PRECISION (A-H, O-Z)
      DATA ZERO/0D0/,ONE/1D0/,TWO/2D0/,THREE/3D0/,FOUR/4D0/,P65/0.65D0/
C
C         COEFFICIENTS OF RATIONAL-FUNCTION APPROXIMATION
C
      DATA P0,P1,P2,P3,P4,P5,P6/
     *  0.2202068679123761D3,    0.2212135961699311D3,
     *  0.1120792914978709D3,    0.3391286607838300D2,
     *  0.6373962203531650D1,    0.7003830644436881D0,
     *  0.3526249659989109D-1/
      DATA Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7/
     *  0.4404137358247522D3,   0.7938265125199484D3,
     *  0.6373336333788311D3,   0.2965642487796737D3,
     *  0.8678073220294608D2,   0.1606417757920695D2,
     *  0.1755667163182642D1,   0.8838834764831844D-1/
C
C         C1 IS SQRT(2), C2 IS SQRT(2/PI)
C         BIG IS THE POINT AT WHICH ERF=1 TO MACHINE PRECISION
C
      DATA C1/1.414213562373095D0/
      DATA C2/7.978845608028654D-1/
      DATA BIG/6.25D0/,CRIT/5D0/
C
      ERF=ZERO
      IF(X.EQ.ZERO)RETURN
      XX=ABS(X)
      IF(XX.GT.BIG)GOTO 20
      EXPNTL=EXP(-X*X)
      ZZ=ABS(X*C1)
      IF(XX.GT.CRIT)GOTO 10
      ERF=EXPNTL*((((((P6*ZZ+P5)*ZZ+P4)*ZZ+P3)*ZZ+P2)*ZZ+P1)*ZZ+P0)/
     *  (((((((Q7*ZZ+Q6)*ZZ+Q5)*ZZ+Q4)*ZZ+Q3)*ZZ+Q2)*ZZ+Q1)*ZZ+Q0)
      IF(X.GT.ZERO)ERF=ONE-TWO*ERF
      IF(X.LT.ZERO)ERF=TWO*ERF-ONE
      RETURN
C
   10 ERF=EXPNTL*C2/(ZZ+ONE/(ZZ+TWO/(ZZ+THREE/(ZZ+FOUR/(ZZ+P65)))))
      IF(X.GT.ZERO)ERF=ONE-ERF
      IF(X.LT.ZERO)ERF=ERF-ONE
      RETURN
C
   20 ERF=ONE
      IF(X.LT.ZERO)ERF=-ONE
      RETURN
      END
