C$$$  MAIN PROGRAM DOCUMENTATION BLOCK
C
C MAIN PROGRAM: ENSPPF        ENNSEMBLE PRECIP. PROBABILITY 
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: THIS PROGRAM WILL CALCULATE ENSEMBLE BASED PRECIP.
C           PROBABILITY FORECAST (PPF)
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C   99-07-26   YUEJIAN ZHU (WX20YZ) MODITY TO IBM-SP
C
C USAGE:
C
C   INPUT FILES:
C     UNIT  11  PRECIPITATION GRIB FILE ( 144*73 )
C     UNIT  21  PRECIPITATION GRIB INDEX FILE
C
C   OUTPUT FILES:
C     UNIT  51  PPF GRIB FILE ( 144*73 )
C
C   SUBPROGRAMS CALLED:
C     GETGBE -- W3LIB ROUTINE
C     PUTGBEX-- W3LIB ROUTINE
C     GRANGE -- LOCAL ROUTINE ( included after main program )
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      program ensppf                                            
      parameter(jf=15000,len=30)
      dimension f(jf),ff(10512,17),pp(10512,17),aa(10512)
      dimension rk(9),xprob(2),imembr(80)
      dimension ipds(25),igds(22),iens(5),iprob(2),iclust(16)             
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      dimension kens2(17),kens3(17)
      logical lb(jf)
      character*80 cpgb,cpgi,cpge
      namelist /namin/ cpgb,cpgi,cpge
      data kens2/1,1,2,3,2,3,2,3,2,3,2,3,1,2,3,2,3/
      data kens3/1,2,1,1,2,2,3,3,4,4,5,5,1,1,1,2,2/
      data rk/0.254,1.00,2.54,5.00,6.35,10.00,12.7,25.4,50.8/
ccc
c     CALL W3LOG('$S97118.73','ENSPPF')
      CALL W3TAGB('ENSPPF',1999,0118,0073,'NP20   ')

      read (5,namin)
      lpgb=len_trim(cpgb)
      lpgi=len_trim(cpgi)
      lpge=len_trim(cpge)
      print *, cpgb(1:lpgb)
      print *, cpgi(1:lpgi)
      print *, cpge(1:lpge)
      call baopenr(11,cpgb(1:lpgb),iretb)
      call baopenr(21,cpgi(1:lpgi),ireti)
      call baopen (51,cpge(1:lpge),irete)

      ncnt=0
      iprob=0
      xprob=0.0
      iclust=0
      imembr=0
      do n=1,len  
ccc
CCC Part I: get 17 ensemble members precipitation data
ccc
       icnt=0
       ff=0.0
       do m=1,17
        j=n-1
        jpds=-1
        jgds=-1
        jens=-1
        jpds(23)=2
       if (m.le.12) then
        jpds(11)=00
        jpds(13)=12
        jpds(14)=(n-1)
       else
        jpds(11)=12
        jpds(13)=12
        jpds(14)=n
       endif
       jens(2)=kens2(m)
       jens(3)=kens3(m)
       call getgbe(11,21,jf,j,jpds,jgds,jens,
     &                         kf,k,kpds,kgds,kens,lb,f,iret)
       if(iret.eq.0) then
         icnt=icnt + 1
         call grange(kf,lb,f,dmin,dmax)
         print '(i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &    n,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
         do ii=1,10512
         ff(ii,icnt)=f(ii)
         enddo
ccc
         if (icnt.le.12) then
          do ii = 1, 25
           ipds(ii)=kpds(ii)
          enddo
          do ii = 1, 22
           igds(ii)=kgds(ii)
          enddo
          do ii = 1, 5 
           iens(ii)=kens(ii)
          enddo 
         endif
       else
         ncnt=ncnt+1
         if ( ncnt.le.1 ) then
         print *,' n=',n,' iret=',iret
         endif
       endif
       enddo
ccc
CCC PART II: to calculate the probability scores
ccc
ccc skip n=1 when you calculate the every 24 hours
      if (n.ge.2) then
       do k = 1, 9
        aa=0.0
        do ii = 1, 10512
         do m = 1, icnt
          bb=(ff(ii,m)+pp(ii,m))
          if (bb.ge.rk(k)) then
          aa(ii) = aa(ii) + 1.0
          endif
         enddo
        enddo
        do ii = 1, 10512
         aa(ii) = aa(ii)*100.0/float(icnt)
         if (aa(ii).ge.99.0) then
         aa(ii) = 100.0
         endif
        enddo
c
        ipds(5)=191         !: OCT 9
        ipds(13)=12
        ipds(14)=n-2
        ipds(15)=n
c       ipds(14)=(n-2)*12
c       ipds(15)=(n+0)*12
        iens(2)=5           !: OCT 42
        iens(3)=0           !: OCT 43
        iens(4)=0           !: OCT 44
        iprob(1)=61         !: OCT 46
        iprob(2)=2          !: OCT 47
        xprob(1)=0.0        !: OCT 48-51
        xprob(2)=rk(k)      !: OCT 52-55
        iclust(1)=icnt      !: OCT 61
        call putgbex(51,10512,ipds,igds,iens,iprob,xprob,
     &                iclust,imembr,lb,aa,iret)
       enddo
      endif
       do ii = 1, 10512
        do jj = 1, 17
         pp(ii,jj)=ff(ii,jj)
        enddo
       enddo
      enddo

      call baclose(11,iretb)
      call baclose(21,ireti)
      call baclose(51,irete)

c     CALL W3LOG('$E')
      CALL W3TAGE('ENSPPF')

c
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

