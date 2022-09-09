c
c  Main program    ANOMALY
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2005-10-10
c
c This is main program to generate climate anomaly forecasts.             
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
c      iv    -- 19 variables
c
c   Fortran 77 on IBMSP 
c
C--------+---------+---------+---------+---------+----------+---------+--
      program ANOMALY
      parameter (ix=360,iy=181,ixy=ix*iy,iv=19)            
c     dimension fcst(ixy),cavg(ixy),stdv(ixy),bias(ixy),anom(ixy)
      dimension fcst(ix,iy)
      dimension cavg(ix,iy)
      dimension cstd(ix,iy)
      dimension bias(ix,iy)
      dimension anom(ix,iy)
      dimension ipds(200),igds(200)
      dimension jpds(200),jgds(200)
      dimension kpds(200),kgds(200)
      dimension ifld(iv),ityp(iv),ilev(iv)
      dimension fmon(2),opara(2)
      logical*1 lb(ixy)
      character*80 cfcst,cmean,cstdv,cbias,canom
      namelist /namin/ cfcst,cmean,cstdv,cbias,canom,idate,ifh
      data ifld/   7,   7,   7,   7,  11,  11,  11,  33,  34,  33,  34,
     &            33,  34,   2,  11,  15,  16,  33,  34/
      data ityp/ 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 102, 105, 105, 105, 105, 105/
      data ilev/1000, 700, 500, 250, 850, 500, 250, 850, 850, 500, 500,
     &           250, 250,   0,   2,   2,   2,  10,  10/

      read (5,namin,end=100)
      write(6,namin)

 100  continue

      lfcst = len_trim(cfcst)
      lmean = len_trim(cmean)
      lstdv = len_trim(cstdv)
      lbias = len_trim(cbias)
      lanom = len_trim(canom)
      print *, 'Forecast      file is ',cfcst(1:lfcst)
      print *, 'Climate  mean file is ',cmean(1:lmean)
      print *, 'Climate  stdv file is ',cstdv(1:lstdv)
      print *, 'Analysis bias file is ',cbias(1:lbias)
      print *, 'Anomaly  fcst file is ',canom(1:lanom)
      
      icnt = 0
c     do ii = 1, iv
      do ii = 1, 1  
c      call baopenr(11,cfcst(1:lfcst),irfcst)
c      call baopenr(12,cmean(1:lmean),irmean)
c      call baopenr(13,cstdv(1:lstdv),irstdv)
c      call baopenr(14,cbias(1:lbias),irbias)
c      call baopenr(15,canom(1:lanom),iranom)
c      if (irfcst.ne.0) goto 882
c      if (irmean.ne.0) goto 882
c      if (irstdv.ne.0) goto 882
c      if (irbias.ne.0) goto 882
c      if (iranom.ne.0) goto 882
c
c     get forecast
c
       jj      = 0
       jpds    = -1
       jgds    = -1
       jpds(5) = ifld(ii)
       jpds(6) = ityp(ii)
       jpds(7) = ilev(ii)
c--------+---------+---------+---------+---------+---------+---------+--
       call getgrb(fcst,ix,iy,cfcst,ifld,ityp,ilev,idate,ifh,11,
     *             kpds,kgds)
       kdate=2000000000+idate
       print *, 'kdate=',kdate
       call iaddate(kdate,ifh,jdate)
       kdate=jdate-2006000000 +59000000
       print *, 'kdate=',kdate
       call getgrb(cavg,ix,iy,cmean,ifld,ityp,ilev,kdate,00,12,
     *             kpds,kgds)
       call getgrb(anom,ix,iy,canom,ifld,ityp,ilev,idate,ifh,15,
     *             kpds,kgds)

c      call baclose(11,iret)
c      call baclose(12,iret)
c      call baclose(13,iret)
c      call baclose(14,iret)
c      call baclose(15,iret)
      enddo

  881 continue
  991 continue
  883 format('ij=',i5,'  m1=',e10.4,'  m2=',e10.4,'  fc=',e10.4,
     *       '  an=',e10.4)
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       '  ndata  Maximun  Minimum')
  888 format (i4,2x,8i5,i8,2f9.2)

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

