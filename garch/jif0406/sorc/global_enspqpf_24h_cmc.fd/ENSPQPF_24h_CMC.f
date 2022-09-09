C$$$  MAIN PROGRAM DOCUMENTATION BLOCK
C
C MAIN PROGRAM: ENSPQPF       ENNSEMBLE BASED PQPF FOR 24 HOURS PERIOD
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 04-05-21
C
C ABSTRACT: THIS PROGRAM WILL CALCULATE ENSEMBLE BASED PROBABILISTIC
C           QUANTITATIVE PRECIPITATION FORECAST (PQPF)
C
C PROGRAM HISTORY LOG:
C   04-04-28   YUEJIAN ZHU (WX20YZ) WROTE THIS PROGRAM TO APPLY CMC'S
C              ENSEMBLE FORECAST ( 16 MEMBERS AT 1x1 degree resoution )
C   05-12-22   Bo Cui (WX20CB) MODIFY THIS PROGRAM TO READ CMC NEW
C              ENSEMBLE FORECAST (384 h forecast with 6 h interval)
C   06-03-28   Bo Cui (WX20CB) MODIFY THIS PROGRAM TO READ CMC 
C              ENSEMBLE FORECAST WITH NEW KENS2 and KENS3 MESSAGE
C
C USAGE:
C
C   INPUT FILES:
C     UNIT  11  PRECIPITATION GRIB FILE ( 360*181)
C     UNIT  21  PRECIPITATION GRIB INDEX FILE
C
C   OUTPUT FILES:
C     UNIT  51  PQPF GRIB FILE ( 360*181 )
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
      program enspqpf                                           
      parameter(jf=65160,len=64,mem=17)
      dimension f(jf),ff(jf,mem),pp(jf,mem),aa(jf)
      dimension pp1(jf,mem),pp2(jf,mem),pp3(jf,mem)
      dimension rk(9),xprob(2),imembr(80)
      dimension ipds(200),igds(200),iens(200),iprob(2),iclust(16)             
      dimension jpds(200),jgds(200),jens(200)             
      dimension kpds(200),kgds(200),kens(200)
      dimension kens2(mem),kens3(mem)
      logical*1 lb(jf)
      character*255 cpgb,cpge
      namelist /namin/ cpgb,cpge
      data kens2/1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3/
      data kens3/2,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16/
      data rk/0.254,1.00,2.54,5.00,6.35,10.00,12.7,25.4,50.8/
ccc
c     CALL W3LOG('$S97118.73','ENSPPF')
      CALL W3TAGB('ENSPPF',2004,0428,0073,'NP20   ')

      read (5,namin)
      lpgb=len_trim(cpgb)
      lpge=len_trim(cpge)
      print *, cpgb(1:lpgb)
      print *, cpge(1:lpge)
      call baopenr(11,cpgb(1:lpgb),iretb)
      call baopen (51,cpge(1:lpge),irete)

      pp1=0.0
      pp2=0.0
      pp3=0.0

      ncnt=0
      iprob=0
      xprob=0.0
      iclust=0
      imembr=0
      do n=1,len !### len=steps
ccc
CCC Part I: get 17 ensemble members precipitation data
ccc
       icnt=0
       ff=0.0

       do m=1,mem
        j=n-1
        jpds=-1
        jgds=-1
        jens=-1
        jpds(23)=2
c        jpds(13)=1
c        jpds(14)=(n-1)*6
c        jpds(15)=(n+0)*6
c        if (n.ge.43) then
   	 jpds(13)=11
         jpds(14)=n-1
	 jpds(15)=n  
c        endif
        jens(2)=kens2(m)
        jens(3)=kens3(m)
        call getgbe(11,0,jf,j,jpds,jgds,jens,
     &              kf,k,kpds,kgds,kens,lb,f,iret)
	if(iret.ne.0) then
	  print*, 'member is',m, ' hour is', jpds(14), jpds(15)
        endif
        if(iret.eq.0) then
         icnt=icnt + 1
         call grange(kf,lb,f,dmin,dmax)
         print '(i4,i3,2i5,4i3,2i4,4i2,i4,i7,2g12.4)',
     &    n,(kpds(i),i=5,11),kpds(14),kpds(15),(kens(i),i=1,5),
     &    kf,dmin,dmax
         do ii=1,jf
          ff(ii,icnt)=f(ii)
         enddo
ccc
         if (icnt.eq.1) then
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
CCC PART II: to calculate the probabilistic quatitative precipitation forecast
ccc
ccc to calculate poosible 24 hrs interval PQPF
ccc    such as 00-24 hrs
ccc            12-36 hrs
ccc            24-48 hrs
ccc            ......       
ccc            360-384 hrs
       if (n.ge.4.and.mod(n,2).eq.0) then
        do k = 1, 9
         aa=0.0
         do ii = 1, jf
          do m = 1, icnt
           bb=(ff(ii,m)+pp1(ii,m)+pp2(ii,m)+pp3(ii,m))
           if (bb.ge.rk(k)) then
            aa(ii) = aa(ii) + 1.0
           endif
          enddo
         enddo
         do ii = 1, jf 
          aa(ii) = aa(ii)*100.0/float(icnt)
          if (aa(ii).ge.99.0) then
           aa(ii) = 100.0
          endif
         enddo
CCC 
CCC     testing print
CCC
c        if (n.eq.2.and.k.eq.2) then 
c         write(*,999) (aa(ii),ii=1001,1100)
c        endif
c999     format (10f8.1)
c
         ipds(5)=191         !: OCT 9
         ipds(13)=11
         ipds(14)=n-4
         ipds(15)=n
         iens(2)=5           !: OCT 42
         iens(3)=0           !: OCT 43
         iens(4)=0           !: OCT 44
         iprob(1)=61         !: OCT 46
         iprob(2)=2          !: OCT 47
         xprob(1)=0.0        !: OCT 48-51
         xprob(2)=rk(k)      !: OCT 52-55
         iclust(1)=icnt      !: OCT 61
         call putgbex(51,jf,ipds,igds,iens,iprob,xprob,
     &                iclust,imembr,lb,aa,iret)
        enddo
       endif
       if (icnt.gt.0) then
        do ii = 1, jf
         do jj = 1, mem
	  if(n.eq.1) pp1(ii,jj)=ff(ii,jj)
	  if(n.eq.2) pp2(ii,jj)=ff(ii,jj)
	  if(n.eq.3) pp3(ii,jj)=ff(ii,jj)
	  if(n.ge.4) then
	   pp1(ii,jj)=pp2(ii,jj)
	   pp2(ii,jj)=pp3(ii,jj)
	   pp3(ii,jj)=ff(ii,jj)
	  endif
         enddo
        enddo
       endif
      enddo

      call baclose(11,iretb)
      call baclose(21,ireti)
      call baclose(51,irete)

c     CALL W3LOG('$E')
      CALL W3TAGE('ENSPQPF')

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
      logical*1 ld
      dimension ld(n),d(n)
      dmin=1.e30
      dmax=-1.e30
      do i=1,n
        if(ld(i)) then
          dmin=min(dmin,d(i))
          dmax=max(dmax,d(i))
        endif
      enddo
      return
      end

