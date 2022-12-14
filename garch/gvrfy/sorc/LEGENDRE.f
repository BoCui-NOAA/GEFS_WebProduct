C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:  LEGENDRE   COMPUTE LEGENDRE POLYNOMIALS.
C   PRGMMR: IREDELL       ORG: W/NMC23       DATE: 92-04-16
C
C ABSTRACT: EVALUATES THE NORMALIZED ASSOCIATED LEGENDRE POLYNOMIALS
C   AT A GIVEN COSINE OF COLATITUDE.
C
C PROGRAM HISTORY LOG:
C   92-04-16  IREDELL
C
C USAGE:    CALL LEGENDRE(IPD,COSCLT,MAXWV,IROMB,EX,PX,PNM)
C
C   INPUT ARGUMENT LIST:
C     IPD      - IPD = 0 TO EVALUATE POLYNOMIAL ITSELF,
C                IPD = 1 TO EVALUATE POLYNOMIAL DERIVATIVE.
C     COSCLT   - COSINE OF COLATITUDE AT WHICH TO EVALUTATE.
C     MAXWV    - SPECTRAL TRUNCATION
C     IROMB    - IROMB = 0 FOR TRIANGULAR TRUNCATION
C                IROMB = 1 FOR RHOMBOIDAL TRUNCATION
C
C   WORK ARGUMENT LIST:
C     EX       - REAL (MAXWV+2) WORK AREA
C     PX       - REAL (MAXWV+3) WORK AREA
C
C   OUTPUT ARGUMENT LIST:
C     PNM      - REAL (KMAX) POLYNOMIAL VALUES,
C                WHERE KMAX=(MAXWV+1)*(IROMB+1)*MAXWV+2)/2.
C
C   REMARKS: FORTRAN 9X EXTENSIONS ARE USED.
C
C ATTRIBUTES:
C   CRAY YMP.
C
C$$$
      SUBROUTINE LEGENDRE(IPD,COSCLT,MAXWV,IROMB,EX,PX,PNM)
      DIMENSION PNM((MAXWV+1)*((IROMB+1)*MAXWV+2)/2)
      DIMENSION EX(0:MAXWV+1),PX(-1:MAXWV+1)
      SINCLT=SQRT(1.-COSCLT**2)
      K=0
      EX(0)=0.
      PX(-1)=0.
      PX(0)=SQRT(0.5)
      DO M=0,MAXWV
        IF(M.GT.0) PX(0)=PX(0)*SINCLT/(EX(1)*SQRT(FLOAT(2*M)))
        DO N=M+1,MAXWV+IROMB*M+1
          EX(N-M)=SQRT(FLOAT(N**2-M**2)/FLOAT(4*N**2-1))
        ENDDO
CDIR$ NEXTSCALAR
        DO N=M+1,MAXWV+IROMB*M+1
          PX(N-M)=(COSCLT*PX(N-M-1)-EX(N-M-1)*PX(N-M-2))/EX(N-M)
        ENDDO
        IF(IPD.EQ.0) THEN
          DO N=M,MAXWV+IROMB*M
            K=K+1
            PNM(K)=PX(N-M)
          ENDDO
        ELSE
          DO N=M,MAXWV+IROMB*M
            K=K+1
            PNM(K)=N*EX(N-M+1)*PX(N-M+1)-(N+1)*EX(N-M)*PX(N-M-1)
          ENDDO
        ENDIF
      ENDDO
      RETURN
      END

