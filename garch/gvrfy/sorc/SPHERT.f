C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:  SPHERT     SPHERICAL TRANSFORM
C   PRGMMR: KANAMITSU     ORG: W/NMC23       DATE: 92-04-16
C
C ABSTRACT: TRANSFORMS A FIELD BETWEEN GRID AND SPECTRAL DOMAINS.
C   THIS VERSATILE ROUTINE WILL:
C     ...TRANSFORM GRID TO SPECTRAL OR TRANSFORM SPECTRAL TO GRID;
C     ...PASS A GAUSSIAN GRID OR AN EQUALLY-SPACE GRID;
C     ...PASS A TRIANGULAR TRUNCATION OR A RHOMBOIDAL TRUNCATION;
C     ...OPTIONALLY TRANSFORM WITH DERIVATIVES OF LEGENDRE FUNCTIONS;
C     ...OPTIONALLY TRANSFORM FROM GRID DIVIDING BY COSLAT**2;
C     ...OPTIONALLY MULTIPLY SPECTRAL FIELD BY COMPLEX FACTORS.
C
C PROGRAM HISTORY LOG:
C   92-04-16  IREDELL
C
C USAGE:    CALL SPHERT(IDIR,GRID,WAVE,MLT,FAC,IMAX,JMAX,MAXWV,IROMB)
C
C   INPUT ARGUMENT LIST:
C     IDIR     - MUST BE ONE OF 1,2,3,4,101,102,103,104,-1,-2,-101,-102,
C                IDIR > 0 TO TRANSFORM GRID TO WAVE,
C                IDIR < 0 TO TRANSFORM WAVE TO GRID,
C                ABS(IDIR) < 100 FOR GAUSSIAN GRID,
C                ABS(IDIR) > 100 FOR EQUALLY-SPACED GRID,
C                IDIR IS ODD FOR NORMAL TRANSFORM,
C                IDIR IS EVEN FOR LEGENDRE DERIVATIVE TRANSFORM,
C                IDIR LAST DIGIT > 2 TO TRANSFORM WITH COSINE LATITUDE.
C     GRID     - IF IDIR > 0, REAL (IMAX,JMAX) FIELD TO TRANSFORM.
C                GRID STARTS AT NORTH POLE AND GREENWICH MERIDIAN.
C     WAVE     - IF IDIR < 0, COMPLEX (KMAX) FIELD TO TRANSFORM,
C                WHERE KMAX=(MAXWV+1)*(IROMB+1)*MAXWV+2)/2.
C                WAVE STARTS AT THE GLOBAL MEAN COMPONENT AND THEN
C                CONTAINS THE ZONALLY SYMMETRIC COMPONENTS.
C     MLT      - MULTIPLICATION OPTION ON WAVE VALUES.
C                MLT = 0 FOR NO MULTIPLICATION,
C                MLT = 1 TO MULTIPLY WAVE BY FAC
C                MLT = -1 TO MULTIPLY WAVE BY SQRT(-1)*FAC
C     FAC      - IF MLT.NE.0, REAL (KMAX) FIELD TO MULTIPLY WAVE.
C     IMAX     - LONGITUDINAL DIMENSION OF THE GRID
C     JMAX     - LATITUDINAL DIMENSION OF THE GRID
C     MAXWV    - SPECTRAL TRUNCATION OF THE WAVE
C     IROMB    - IROMB = 0 FOR TRIANGULAR TRUNCATION
C                IROMB = 1 FOR RHOMBOIDAL TRUNCATION
C
C   OUTPUT ARGUMENT LIST:
C     GRID     - IF IDIR < 0, REAL (IMAX,JMAX) FIELD OUTPUT.
C                GRID STARTS AT NORTH POLE AND GREENWICH MERIDIAN.
C     WAVE     - IF IDIR > 0, COMPLEX (KMAX) FIELD OUTPUT,
C                WHERE KMAX=(MAXWV+1)*(IROMB+1)*MAXWV+2)/2.
C                WAVE STARTS AT THE GLOBAL MEAN COMPONENT AND THEN
C                CONTAINS THE ZONALLY SYMMETRIC COMPONENTS.
C
C   SUBPROGRAMS CALLED:
C     UNIQUE:
C     GAUSSLAT   - COMPUTE GAUSSIAN LATITUDES
C     EQUALLAT   - COMPUTE EQUALLY-SPACED LATITUDES
C     (LEGENDRE) - COMPUTE LEGENDRE POLYNOMIALS
C     FFTFAX     - FFT (LIBRARY CALL CAN BE SUBSTITUTED)
C     RFFTMLT    - FFT (LIBRARY CALL CAN BE SUBSTITUTED)
C
C   REMARKS: FORTRAN 9X EXTENSIONS ARE USED.
C     FPP CAN BE USED TO INLINE SUBPROGRAMS.
C     TRANSFORMING WITH AN EQUALLY-SPACED GRID IS IRREVERSIBLE.
C
C ATTRIBUTES:
C   CRAY YMP.
C
C$$$
CFPP$ EXPAND(LEGENDRE)
      SUBROUTINE SPHERT(IDIR,GRID,WAVE,MLT,FAC,IMAX,JMAX,MAXWV,IROMB)
      REAL GRID(IMAX,JMAX)
      COMPLEX WAVE((MAXWV+1)*((IROMB+1)*MAXWV+2)/2)
      REAL FAC((MAXWV+1)*((IROMB+1)*MAXWV+2)/2)
      REAL GG(2*(1+(IMAX+1)/2),JMAX)
      COMPLEX WW((MAXWV+1)*((IROMB+1)*MAXWV+2)/2),W2(-1:1),WS
      REAL TRIGS(2*IMAX),IFAX(20)
      REAL COSCLT(JMAX),WGTCLT(JMAX)
      REAL WRKFFT(2*IMAX*JMAX)
      INTEGER IS((MAXWV+1)*((IROMB+1)*MAXWV+2)/2)
      REAL PNM((MAXWV+1)*((IROMB+1)*MAXWV+2)/2)
      REAL EX(0:MAXWV+1),PX(-1:MAXWV+1)
      KMAX=(MAXWV+1)*((IROMB+1)*MAXWV+2)/2
      IPD=1-MOD(ABS(IDIR),2)
      ISD=1-2*IPD
      ICD=(MOD(ABS(IDIR),10)-1)/2
      JUMP=2*(1+(IMAX+1)/2)
      MAXWVM=MIN(MAXWV,(IMAX+1)/2)
      CALL FFTFAX(IMAX,IFAX,TRIGS)
      IF(ABS(IDIR).LT.100) THEN
        CALL GAUSSLAT(JMAX,COSCLT,WGTCLT)
      ELSE
        CALL EQUALLAT(JMAX,COSCLT,WGTCLT)
      ENDIF
      K=0
      DO M=0,MAXWVM
        DO N=M,IROMB*M+MAXWV
          K=K+1
          IS(K)=ISD*(1-2*MOD(N-M,2))
        ENDDO
      ENDDO

      IF(IDIR.GT.0) THEN

        DO J=1,JMAX
          DO I=1,IMAX
            GG(I,J)=GRID(I,J)
          ENDDO
        ENDDO
        CALL RFFTMLT(GG,WRKFFT,TRIGS,IFAX,1,JUMP,IMAX,JMAX,-1)
        DO K=1,KMAX
          WAVE(K)=0.
        ENDDO
        DO J=1,(JMAX+1)/2
          JR=JMAX+1-J
          CALL LEGENDRE(IPD,COSCLT(J),MAXWV,IROMB,EX,PX,PNM)
          WJ=WGTCLT(J)
          IF(ICD.NE.0.AND.COSCLT(J).LT.1.) WJ=WJ/(1.-COSCLT(J)**2)
          K=0
          DO M=0,MAXWVM
            W2(1)=WJ*CMPLX(GG(2*M+1,J)+GG(2*M+1,JR),
     &                     GG(2*M+2,J)+GG(2*M+2,JR))
            W2(-1)=WJ*CMPLX(GG(2*M+1,J)-GG(2*M+1,JR),
     &                      GG(2*M+2,J)-GG(2*M+2,JR))
            DO N=M,IROMB*M+MAXWV
              K=K+1
              WAVE(K)=WAVE(K)+W2(IS(K))*PNM(K)
            ENDDO
          ENDDO
        ENDDO
        IF(MLT.NE.0) THEN
          WS=CMPLX(1.,0.)
          IF(MLT.LT.0) WS=CMPLX(0.,1.)
          DO K=1,KMAX
            WAVE(K)=WAVE(K)*WS*FAC(K)
          ENDDO
        ENDIF

      ELSE

        IF(MLT.NE.0) THEN
          WS=CMPLX(1.,0.)
          IF(MLT.LT.0) WS=CMPLX(0.,1.)
          DO K=1,KMAX
            WW(K)=WAVE(K)*WS*FAC(K)
          ENDDO
        ELSE
          DO K=1,KMAX
            WW(K)=WAVE(K)
          ENDDO
        ENDIF
        DO J=1,(JMAX+1)/2
          CALL LEGENDRE(IPD,COSCLT(J),MAXWV,IROMB,EX,PX,PNM)
          K=0
          DO M=0,MAXWVM
            W2(1)=0.
            W2(-1)=0.
            DO N=M,IROMB*M+MAXWV
              K=K+1
              W2(1)=W2(1)+WW(K)*PNM(K)
              W2(-1)=W2(-1)+WW(K)*PNM(K)*IS(K)
            ENDDO
            GG(2*M+1,JMAX+1-J)=REAL(W2(-1))
            GG(2*M+2,JMAX+1-J)=AIMAG(W2(-1))
            GG(2*M+1,J)=REAL(W2(1))
            GG(2*M+2,J)=AIMAG(W2(1))
          ENDDO
        ENDDO
        DO I=2*MAXWVM+3,JUMP
          DO J=1,JMAX
            GG(I,J)=0.
          ENDDO
        ENDDO
        CALL RFFTMLT(GG,WRKFFT,TRIGS,IFAX,1,JUMP,IMAX,JMAX, 1)
        DO J=1,JMAX
          DO I=1,IMAX
            GRID(I,J)=GG(I,J)
          ENDDO
        ENDDO

      ENDIF

      RETURN
      END

