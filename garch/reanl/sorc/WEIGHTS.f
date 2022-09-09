c
c  Main program    ANOMALY
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2006-04-04
c
c This is main program to generate ensemble weights.             
c
c   subroutine                                                    
c              IADDATE---> to add forecast hours to initial data    
c              GETGB  ---> to get GRIB format data                  
c              GRANGE ---> to calculate max. and min value of array
c
c   parameters:
c      ix    -- x-dimensional
c      iy    -- y-dimensional
c      ixy   -- ix*iy
c      iv    -- 35 variables
c   Notes:
c      members is the total ensemble members include ensemble control
c
c   Fortran 77 on IBMSP 
c
C--------+---------+---------+---------+---------+----------+---------+--
      program WEIGHTS
      parameter (ix=360,iy=181,ixy=ix*iy,iv=35)            
      dimension fcst(ixy),wght(ixy)
      dimension ipds(200),igds(200),iens(5)
      dimension jpds(200),jgds(200),jens(5)
      dimension kpds(200),kgds(200),kens(5)
      dimension ifld(iv),ityp(iv),ilev(iv)
      logical*1 lb(ixy)
      character*80 cfcst,cwght
      namelist /namin/ cfcst,cwght,members
      data ifld/7, 7, 7, 7, 7, 7, 7,11,11,11,11,11,11,11,
     &         33,33,33,33,33,33,33,34,34,34,34,34,34,34,
     &         2,1,11,33,34,15,16/
      data ityp/100,100,100,100,100,100,100,100,100,100,
     &         100,100,100,100,100,100,100,100,100,100,
     &         100,100,100,100,100,100,100,100,
     &         102,1,105,105,105,105,105/
      data ilev/1000,925,850,700,500,250,200,
     &         1000,925,850,700,500,250,200,
     &         1000,925,850,700,500,250,200,
     &         1000,925,850,700,500,250,200,
     &         0,0,2,10,10,2,2/

      read (5,namin,end=100)
      write(6,namin)

 100  continue

      lfcst = len_trim(cfcst)
      lwght = len_trim(cwght)
      print *, 'Forecast      file is ',cfcst(1:lfcst)
      print *, 'Weights otput file is ',cwght(1:lwght)
      call baopen (81,cwght(1:lwght),irwght)
      
      icnt = 0
c     do ii = 1, iv
      do ii = 1, 1  
       call baopenr(11,cfcst(1:lfcst),irfcst)
       if (irfcst.ne.0) goto 882
c
c     get forecast
c
       jj      = 0
       jpds    = -1
       jgds    = -1
       jens    = -1
       jpds(5) = ifld(ii)
       jpds(6) = ityp(ii)
       jpds(7) = ilev(ii)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgbe(11,0,ixy,jj,jpds,jgds,jens,kf,k,kpds,kgds,kens,
     *             lb,fcst,iret)
       if(iret.eq.0) then
        ipds = kpds
        igds = kgds
        iens = kens
        call grange(kf,lb,fcst,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
         icnt=1
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
c       print *,'pds14=',kpds(14),' pds15=',kpds(15),'pds16=',kpds(16)
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif

       idate=ipds(8)*1000000 + ipds(9)*10000 + ipds(10)*100 + ipds(11)
       idate=idate + 2000000000
       if (ipds(16).eq.2) then
        call iaddate(idate,ipds(15),jdate)
       else
        call iaddate(idate,ipds(14),jdate)
       endif
       jpds9  = mod(jdate/10000,  100)
       jpds10 = mod(jdate/100,    100)
       jpds11 = mod(jdate,        100)
       call iaddate(jdate,-6,kdate)
       kpds9  = mod(kdate/10000,  100)
       kpds10 = mod(kdate/100,    100)
       kpds11 = mod(kdate,        100)

c
c     to calculate weights for ensemble forecasts
c

       write (*,889) ifld(ii),ityp(ii),ilev(ii),members
       do ij = 1, ixy
        wght(ij)=1.0/float(members)
       enddo
       iens(4)  = 5
       ipds(5)  = 184  ! Octet 9 = 184 (ensemble weights)
c      ipds(6)  = 255  ! Octet 10 : need define
c      ipds(7)  = 255  ! Octet 11-12: need define
       ipds(6)  = 200  ! Octet 10 : Brent suggestted: for whole atmosphere
       ipds(7)  = 0    ! Octet 11-12: Brent suggestted
       ipds(19) = 129  ! Octet 4 = 129 (using 129 parameter table)
       ipds(22) = 4
       call putgbe(81,ixy,ipds,igds,iens,lb,wght,iret)

       call baclose(11,iret)
      enddo

      call baclose(81,iret)
  881 continue
  991 continue
  883 format('ij=',i5,'  m1=',e10.4,'  m2=',e10.4,'  fc=',e10.4,
     *       '  an=',e10.4)
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       '  ndata  Maximun  Minimum')
  888 format (i4,2x,8i5,i8,2f9.2)
  889 format ('ID = ',3i6,' Members = ',i3)

      stop   

  882 print *, 'Missing input file, please check! stop!!!'

      stop
      end
c
c
c
      subroutine grange(n,ld,d,dmin,dmax)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: DETERMINE THE MAXIMUM AND MINIMUM VALUES OF ARRAY       C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: one dimension array d and ld                            C
C                                                                    C
C     OUTPUT:maximum and minimum values                              C
C                                                                    C
C     Arguments:                                                     C
C               1. n ( int number of dimension of d and ld )         C
C               2. ld ( logical array of dimension n )               C
C               3. d  ( real array of dimension n )                  C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      logical*1   ld
      dimension ld(n),d(n)
      dmin=  1.e40
      dmax= -1.e40
      do i=1,n
        if(ld(i)) then
          dmin=min(dmin,d(i))
          dmax=max(dmax,d(i))
        endif
      enddo
      return
      end
C-----------------------------------------------------------------------
      SUBROUTINE IADDATE(IDATE,IHOUR,JDATE)
      DIMENSION   MON(12)
      DATA MON/31,28,31,30,31,30,31,31,30,31,30,31/
C-----------------------------------------------------------------------
      IC = MOD(IDATE/100000000,100 )
      IY = MOD(IDATE/1000000,100 )
      IM = MOD(IDATE/10000  ,100 )
      ID = MOD(IDATE/100    ,100 )
      IHR= MOD(IDATE        ,100 ) + IHOUR
C
      IF(MOD(IY,4).EQ.0) MON(2) = 29
1     IF(IHR.LT.0) THEN
       IHR = IHR+24
       ID = ID-1
       IF(ID.EQ.0) THEN
        IM = IM-1
        IF(IM.EQ.0) THEN
         IM = 12
         IY = IY-1
         IF(IY.LT.0) IY = 99
        ENDIF
        ID = MON(IM)
       ENDIF
       GOTO 1
      ELSEIF(IHR.GE.24) THEN
       IHR = IHR-24
       ID = ID+1
       IF(ID.GT.MON(IM)) THEN
        ID = 1
        IM = IM+1
        IF(IM.GT.12) THEN
         IM = 1
         IY = MOD(IY+1,100)
        ENDIF
       ENDIF
       GOTO 1
      ENDIF
      JDATE = IC*100000000 + IY*1000000 + IM*10000 + ID*100 + IHR
      RETURN
      END

