C$$$  MAIN PROGRAM DOCUMENTATION BLOCK
C
C MAIN PROGRAM: PRCPCV        CONVET PRECIPITATION FIELD
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: THIS PROGRAM WILL CONVERT 6 HOURS PERIOD PRECIP.  
C           TO 12 HOURS ACCUMULATION, CONVERT PRECIP. RATE
C           TO ACCUMULATION PRECIPITATION AND ETC.
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C   99-07-27   YUEJIAN ZHU (WX20YZ) MODIFY TO IBM-SP
C
C USAGE:
C
C   INPUT FILES:
C     UNIT  11  PRECIPITATION GRIB FILE ( 144*73 )
C     UNIT  21  PRECIPITATION GRIB INDEX FILE
C
C   OUTPUT FILES:
C     UNIT  51  PRECIPITATION GRIB FILE ( 144*73 )
C
C   SUBPROGRAMS CALLED:
C     GETGBE -- W3LIB ROUTINE
C     PUTGBE -- W3LIB ROUTINE
C     CHECK1 -- LOCAL ROUTINE ( included after main program )
C     GRANGE -- LOCAL ROUTINE ( included after main program )
C
C   EXIT STATES:
C     COND =  0 - SUCCESSFUL RUN
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      program prcpcv                                            
      parameter(jf=20000)
      dimension f(jf),fold(jf)
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      character*80 cpgb,cpgi,cpge
      logical lb(jf)
      namelist /namin/ cpgb,cpgi,cpge
c
c     CALL W3LOG('$S97118.73','PRCPCV')
      CALL W3TAGB('PRCPCV',0097,0118,0073,'NP20   ')
c
      read (5,namin,end=1000)

      lpgb=len_trim(cpgb)
      lpgi=len_trim(cpgi)
      lpge=len_trim(cpge)
      print *, cpgb(1:lpgb),cpgi(1:lpgi),cpge(1:lpge)
      call baopenr(11,cpgb(1:lpgb),iretb)
      call baopenr(21,cpgi(1:lpgi),ireti)
      call baopen (51,cpge(1:lpge),irete)

      fold=0.0
      ncnt=0
      do n=1,800  
      j=n-1
      jpds=-1
      jgds=-1
      jens=-1
ccc ....
ccc   late notes:  We need to put jpds(23)=2 for extended message 
ccc ....
      jpds(23)=2
      call getgbe(11,21,jf,j,jpds,jgds,jens,
     &                        kf,k,kpds,kgds,kens,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
        print '(i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &   n,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
ccc ....
ccc   check:  runs
ccc           fhours
ccc           determined add, substract or keep
ccc ....
      call check1(kpds,kens,kf,fold,f,ictl)
      if (ictl.eq.1) then
      call putgbe(51,kf,kpds,kgds,kens,lb,f,iret)
      endif
        do i = 1, kf
           fold(i)=f(i)
        enddo
ccc
      else
        ncnt=ncnt+1
        if ( ncnt.le.1 ) then
        print *,' n=',n,' iret=',iret
        endif
      endif
      enddo

      call baclose(11,iretb)
      call baclose(21,ireti)
      call baclose(51,irete)

 1000 continue

c     CALL W3LOG('$E')
      CALL W3TAGE('PRCPCV')

      stop    
      end
      subroutine grange(n,ld,d,dmin,dmax)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM: GRANGE(N,LD,D,DMIN,DMAX)          
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: THIS SUBROUTINE WILL ALCULATE THE MAXIMUM AND      
C           MINIMUM OF A ARRAY
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C
C USAGE:
C
C   INPUT ARGUMENTS:
C     N        -- INTEGER              
C     LD(N)    -- LOGICAL OF DIMENSION N
C     D(N)     -- REAL ARRAY OF DIMENSION N
C
C   OUTPUT ARGUMENTS:
C     DMIN     -- REAL NUMBER ( MINIMUM )
C     DMAX     -- REAL NUMBER ( MAXIMUM )
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      logical ld
      dimension ld(n),d(n)
      dmin=1.e40
      dmax=-1.e40
      do i=1,n
        if(ld(i)) then
          dmin=min(dmin,d(i))
          dmax=max(dmax,d(i))
        endif
      enddo
      return
      end
      subroutine check1(kpds,kens,kkf,f1,f2,ictl)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM: CHECK1(KPDS,KENS,KKF,F1,F2,ICT)          
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: THIS SUBROUTINE WILL CHECK THE PRECIPITATION FIELDS
C           ARRANGEMENT AND CONVERT TO 12 HOURS PERIOD, OR 
C           CONVERT PRATE TO ACCUMULATION AMOUNT.
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C   98-05-13   YUEJIAN ZHU (WD20YZ) -- REMOVE 24 HOURS CONVERSION
C
C USAGE:
C   SUBROUTINE CHECK1(KPDS,KENS,KKF,F1,F2,ICT)
C
C   INPUT ARGUMENTS:
C     KPDS(25) -- GRIB PDS MESSGAE
C     KENS(5)  -- GRIB ENSEMBLE MESSAGE 
C     F1(KKF)  -- FIELD OF DIMENSION KKF
C     F2(KKF)  -- FIELD OF DIMENSION KKF
C     KKF      -- INTEGER NUMBER
C
C   OUTPUT ARGUMENTS:
C     F2(KKF)  -- FIELD OF DIMENSION KKF
C     ICTL     -- INTEGER TO CONTROL CONVERSION
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      dimension f1(kkf),f2(kkf)
      dimension kpds(25),kens(5)        
ccc
      ictl=1
       if (kens(2).le.1.and.kens(3).le.1) then
         if (kpds(11).eq.00) then
ccc....
ccc   for T00Z forecasting after 264 hours (MRF running )
ccc....
          if (kpds(14).ge.264) then
           print *,' kpds14=',kpds(14)
           do i=1,kkf
              f2(i) = f2(i)*12*3600.00           
           enddo
           kpds(14) = kpds(14) - 12
           kpds(5)  = 61
           kpds(15) = 255
          endif
         else
ccc....
ccc   for T12Z forecasting up to 72 hours  ( AVN running )
ccc....
         if (kpds(14).le.66) then
          if (mod(kpds(15),12).eq.0) then
           do i=1,kkf
             f2(i) = f2(i) + f1(i)
             if (f2(i).lt.0.0) then
                f2(i) = 0.0
             endif
           enddo
           kpds(14) = kpds(14) - 6
          else
           ictl=0
          endif
         endif
ccc....
ccc   for T12Z forecasting 72 - 252 hours period ( AVN running )
ccc       do nothing
ccc....
ccc....
ccc   for T12Z forecasting after 252 hours (AVN running )
ccc....
        if (kpds(14).ge.264) then
         print *,' kpds14=',kpds(14)
          do i=1,kkf
             f2(i) = f2(i)*12.0*3600.0               
          enddo
          kpds(14) = kpds(14) - 12
          kpds(5)  = 61
        endif
       endif
ccc
      else
ccc....
ccc   for CTL and PAIRS forecasting upto 252 hours
ccc       do nothing
ccc....
ccc....
ccc   for CTL and PAIRS forecasting after 252 hours         
ccc....
       if (kpds(14).ge.264) then
ccc   kpds(15) greater than 252 is not present
ccc      ihrs=kpds(15)-kpds(14)
         print *,' kpds14=',kpds(14)
          do i=1,kkf
             f2(i) = f2(i)*12.0*3600.0               
          enddo
          kpds(14) = kpds(14) - 12 
          kpds(5)  = 61
       endif
      endif
          kpds(5)  = 61
          kpds(14) = kpds(14)/12
          kpds(15) = kpds(14)+1 
          kpds(13) = 12
          kpds(16) = 4
      return
      end
