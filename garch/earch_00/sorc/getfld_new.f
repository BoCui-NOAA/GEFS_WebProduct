C$$$  MAIN PROGRAM DOCUMENTATION BLOCK
C
C MAIN PROGRAM: GETFLD        GET PRESSURE FIELDS
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C 
C ABSTRACT: THIS PROGRAM WILL EXTRACT 19 PRE-SELECTED PRESSURE
C           FIELDS FROM DAILY ENSEMBLE PGB FILES.
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C
C USAGE:
C
C   INPUT FILES:
C     UNIT  11  GRIB FILE
C     UNIT  21  GRIB INDEX FILE
C
C   OUTPUT FILES:
C     UNIT  51  1000 mb geopotential height
C     UNIT  52   700 mb geopotential height
C     UNIT  53   500 mb geopotential height
C     UNIT  54   250 mb geopotential height
C     UNIT  55    10 meter u field
C     UNIT  56   850 mb u field
C     UNIT  57   500 mb u field
C     UNIT  58   250 mb u field
C     UNIT  59    10 meter v field
C     UNIT  60   850 mb v field
C     UNIT  61   500 mb v field
C     UNIT  62   250 mb v field
C     UNIT  63     2 meter temperature
C     UNIT  64   850 mb temperature
C     UNIT  65   700 mb relative humidity
C     UNIT  66   sfc acumulation precipitation
C     UNIT  67   PRMSL-pressure reduced mean sea level
C     UNIT  68     2 meter Maximum Temperature
C     UNIT  69     2 meter Minimum Temperature
C
C   SUBPROGRAMS CALLED:
C     GETGBE -- W3LIB ROUTINE
C     PUTGBE -- W3LIB ROUTINE
C     GRANGE -- LOCAL ROUTINE ( included after main program )
C     I1D25D -- LOCAL ROUTINE ( included after main program )     
C     INTP2D -- LOCAL ROUTINE ( included after main program )     
C
C   EXIT STATES:
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      program getfld                                            
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC
CCC order jpds(5) jpds(6) jpds(7)
CCC   1     7      100    1000    1000 mb geopotential height
CCC   2     7      100     700     700 mb geopotential height
CCC   3     7      100     500     500 mb geopotential height
CCC   4     7      100     250     250 mb geopotential height
CCC   5    33      105      10      10 meter u field
CCC   6    33      100     850     850 mb u field
CCC   7    33      100     500     500 mb u field
CCC   8    33      100     250     250 mb u field
CCC   9    34      105      10      10 meter v field
CCC  10    34      100     850     850 mb v field
CCC  11    34      100     500     500 mb v field
CCC  12    34      100     250     250 mb v field
CCC  13    11      105       2       2 meter temperature
CCC  14    11      100     850     850 mb temperature
CCC  15    52      100     700     700 mb relative humidity 
CCC  16    61(59)    1       0     sfc acumulation precipitation
CCC  17    59(61)    1       0     sfc precipitation rate
CCC  18     2      102       0     PRMSL-pressure reduced mean sea level
CCC  19    15      105       2       2 meter Maximum Temperature
CCC  20    16      105       2       2 meter Minimum Temperature
CCC
      parameter(jf=66000)
      dimension f(jf),fout(144,73)
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      dimension jpds5(100),jpds6(100),jpds7(100),iout(100)
      logical lb(jf)
      data jpds5/   7,  7,  7,  7, 33, 33, 33, 33, 34, 34,
     &             34, 34, 11, 11, 52, 61, 59,  2, 15, 16/
      data jpds6/ 100,100,100,100,105,100,100,100,105,100,
     &            100,100,105,100,100,  1,  1,102,105,105/
      data jpds7/1000,700,500,250, 10,850,500,250, 10,850,
     &            500,250,  2,850,700,  0,  0,  0,  2,  2/
      data iout /  51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
     &             61, 62, 63, 64, 65, 66, 66, 67, 68, 69/
c
      CALL W3LOG('$S97118.73','GETENFLD')
      CALL W3TAGB('GETENFLD',0097,0118,0073,'NP20   ')

      ncnt=0
      do n=1,20   
      j=0   
      jpds=-1
      jgds=-1
      jens=-1
      kens=0
ccc ....
ccc   We need to set jpds(23)=2 for extended message
ccc ....
      jpds(23)=2
      jpds(5)=jpds5(n)
      jpds(6)=jpds6(n)
      jpds(7)=jpds7(n)
      call getgb(11,21,jf,j,jpds,jgds,
     &                        kf,k,kpds,kgds,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
        print '(2i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &   n,k,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
ccc ...
ccc   condition show here
ccc    1. every 12 hours for all fields
ccc    2. accumulation precipitation for each step ( 6 hours for AVN )
ccc    3. max and mim temperature for each step ( 6 hours for AVN )
ccc ...
       if (mod(kpds(14),12).eq.0.or.kpds(5).eq.61
     .                          .or.kpds(5).eq.15
     .                          .or.kpds(5).eq.16) then
ccc ....
ccc   check if it is high resolution ( 360*181 )
ccc ....
       if(kpds(3).eq.3.and.kf.eq.65160) then
        print *,'This is high resolution grid data, need intepolation'
        call i1d25d (f,fout)
         iijj=1
         do jj=1,73
          do ii=1,144
           f(iijj)=fout(ii,jj)
           iijj=iijj + 1
          enddo
         enddo
        kf      = 10512
        kpds(3) = 2         ! Grid Identification, 2=10512(144*73) points
        kpds(4) = 128       ! Flag for GDS or BMS, 128=10000000
        kgds(2) = 144
        kgds(3) = 73
        kgds(4) = 90000
        kgds(5) = 0
        kgds(6) = 128
        kgds(7) = -90000
        kgds(8) = -2500
        kgds(9) = 2500
        kgds(10)= 2500
       endif
        call putgb(iout(n),kf,kpds,kgds,lb,f,iret)
       endif                         
ccc
      else
        ncnt=ncnt+1
        if ( ncnt.le.1 ) then
        print *,' n=',n,' iret=',iret
        endif
      endif
      enddo

      CALL W3LOG('$E')
      CALL W3TAGE('GETENFLD')

      stop    
      end
CCC
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
      subroutine i1d25d(glob,rout)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM: I1D25D                           
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: THIS SUBROUTINE WILL INTERPOLATE PRESSURE GLOBAL
C           FIELD FROM 1*1 DEGREE ( 360*181 ) GRID POINTS TO
C           2.5*2.5 DEGREE ( 144*73 ) GRID POINTS USING 
C           LINEAR INTERPOLATION SCHEME.
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C
C USAGE:
C   I1D25D (GLOB,ROUT)
C
C   INPUT ARGUMENTS:
C     GLOB     -- REAL ARRAY WITH DIMENSION (360*181)
C
C   OUTPUT ARGUMENTS:
C     ROUT     -- REAL ARRAY WITH DIMENSION (144*73)
C
C SUBPROGRAMS:
C   INTP2D  --- LOCAL SUBROUTINE ( WILL INCLUDE AFTER )
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      parameter (imax=360,jmax=181)
      parameter (idim=144,jdim=73)
      dimension glob(*),band(360,181),rout(144,73)
      dimension xa(700),xb(700),ya(700),yb(700)
c
      dlxa = 360./float(imax)
      dlxb = 360./float(idim)
      dlya = 180./float(jmax-1)
      dlyb = 180./float(jdim-1)
      do 10 i = 1,imax
   10   xa(i) = dlxa*float(i-1)
      if (jmax.eq.0) goto 100
      do 20 j = 1,jmax
   20   ya(j) = dlya*float(j-1)
  100 continue
      do 30 i = 1,idim
   30   xb(i) = dlxb*float(i-1)
      if (jdim.eq.0) goto 200
      do 40 j = 1,jdim
   40   yb(j) = dlyb*float(j-1)
  200 continue
c
        ij = 0
        do 70 j = 1,jmax
        do 70 i = 1,imax
        ij = ij + 1
   70   band(i,j) = glob(ij)
        call intp2d(band,imax,jmax,xa,ya,rout,idim,jdim,xb,yb,0)
      return
      end
c
      subroutine intp2d(a,imx,imy,xa,ya,b,jmx,jmy,xb,yb,mflg)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM: INTP2D 
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: THIS SUBROUTINE WILL INTERPOLATE PRESSURE GLOBAL
C           FIELD FROM 1*1 DEGREE ( 360*181 ) GRID POINTS TO
C           2.5*2.5 DEGREE ( 144*73 ) GRID POINTS USING
C           LINEAR INTERPOLATION SCHEME.
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C
C USAGE:
C   INTP2D (A,IMX,IMY,XA,YA,B,JMX,JMY,XB,YB,MFLG)
C
C   INPUT ARGUMENTS:
C     A        -- REAL ARRAY WITH DIMENSION (IMX*IMY)
C     IMX      -- INTEGER
C     IMY      -- INTEGER
C     XA       -- REAL ARRAY STORED IMX POSITION
C     YA       -- REAL ARRAY STORED IMY POSITION
C     JMX      -- INTEGER
C     JMY      -- INTEGER
C     YA       -- REAL ARRAY STORED JMX POSITION
C     YB       -- REAL ARRAY STORED JMY POSITION
C     MFLG     -- CONTROL FLAY
C                 1--USING MASK,0--NOT USE MASK
C
C   OUTPUT ARGUMENTS:
C     B        -- REAL ARRAY WITH DIMENSION (JMX*JMY)
C
C SUBPRGRAMS:
C   SETPTR     -- LOCAL SUBROUTINE ( WILL INCLUDE AFTER )
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      parameter(max=721,maxp=384*190)
      integer*2 mask(maxp)
      dimension dxp(max),dyp(max),dxm(max),dym(max),
     1          iptr(max),jptr(max),wgt(4)
      dimension a(imx,*),b(jmx,*),xa(*),ya(*),xb(*),yb(*)
      call setptr(xa,imx,xb,jmx,iptr,dxp,dxm,ierr)
      call setptr(ya,imy,yb,jmy,jptr,dyp,dym,jerr)
      do 1 i = 1,4
  1   wgt(i) = 1.0
      if (mflg.eq.0) deflt = 0.0
      if (mflg.ge.0) then
        do 2 j = 1,jmy
        do 2 i = 1,jmx
  2     b(i,j) = deflt
      endif
c
      do 10 j = 1,jmy
        jm = jptr(j)
        if (jm.lt.0) goto 10
        jp = jm + 1
      do 20 i = 1,jmx
        im = iptr(i)
        if (im.lt.0) goto 20
        ip = im + 1
        d1 = dxm(i)*dym(j)*wgt(1)
        d2 = dxm(i)*dyp(j)*wgt(2)
        d3 = dxp(i)*dym(j)*wgt(3)
        d4 = dxp(i)*dyp(j)*wgt(4)
        dd = d1 + d2 +d3 + d4
        if (dd.eq.0.0) goto 20
c       print *, a(im,jm),a(im,jp),a(ip,jm),a(jp,jp)
        b(i,j) = (d4*a(im,jm)+d3*a(im,jp)+d2*a(ip,jm)+d1*a(ip,jp))/dd
   20 continue
   10 continue
      return
      end
c
      subroutine setptr(x,m,y,n,iptr,dp,dm,ierr)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM: SETPTR
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: THIS SUBROUTINE WILL SET THE POSITION AND INCREMENT
C           FOR LINEAR INTERPOLATION
C
C PROGRAM HISTORY LOG:
C   97-03-17   YUEJIAN ZHU (WD20YZ)
C
C USAGE:
C   SETPTR (X,M,Y,N,IPTR,DP,DM,IERR)
C
C   INPUT ARGUMENTS:
C     X        -- REAL ARRAY WITH DIMENSION OF M      
C     M        -- INTEGER
C     Y        -- REAL ARRAY WITH DIMENSION OF N
C     N        -- INTEGER
C
C   OUTPUT ARGUMENTS:
C     IPTR     -- INTEGER ARRAY RELATED POSITION
C     DP       -- REAL ARRAY OF POSITIVE INCREMENT
C     DM       -- REAL ARRAY OF NEGITIVE INCREMENT
C     IERR     -- INTEGER - POINTS OUTSIDE OF THE DOMAIN
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      dimension x(*),y(*),iptr(*),dp(*),dm(*)
      ierr = 0
      do 10 j = 1,n
        yl = y(j)
        if (yl.lt.x(1)) then
          ierr = ierr + 1
          iptr(j) = -1
          goto 10
        elseif (yl.gt.x(m)) then
          ierr = ierr + 1
          iptr(j) = -1
          goto 10
        endif
        do 20 i = 1,m-1
          if (yl.gt.x(i+1)) goto 20
          dm(j) = yl-x(i)
          dp(j) = x(i+1)-yl
          iptr(j) = i
          goto 10
  20    continue
  10  continue
      return
      end

