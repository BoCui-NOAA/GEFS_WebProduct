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
c   note: 
c      if ibias = 1, no bias information available
c
c   Fortran 77 on IBMSP 
c
C--------+---------+---------+---------+---------+----------+---------+--
      program ANOMALY
      parameter (ix=360,iy=181,ixy=ix*iy,iv=19)            
      dimension fcst(ixy),cavg(ixy),stdv(ixy),bias(ixy),anom(ixy)
      dimension ipds(200),igds(200),iens(5)
      dimension jpds(200),jgds(200),jens(5)
      dimension kpds(200),kgds(200),kens(5)
      dimension ifld(iv),ityp(iv),ilev(iv)
      dimension fmon(2),opara(2)
      logical*1 lb(ixy)
      character*80 cfcst,cmean,cstdv,cbias,canom
      namelist /namin/ cfcst,cmean,cstdv,cbias,canom,ibias
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
c     lbias = len_trim(cbias)
      lanom = len_trim(canom)
      print *, 'Forecast      file is ',cfcst(1:lfcst)
      print *, 'Climate  mean file is ',cmean(1:lmean)
      print *, 'Climate  stdv file is ',cstdv(1:lstdv)
c     print *, 'Analysis bias file is ',cbias(1:lbias)
      print *, 'Anomaly outpu file is ',canom(1:lanom)
      call baopen (81,canom(1:lanom),iranom)
      
      icnt = 0
      do ii = 1, iv
       call baopenr(11,cfcst(1:lfcst),irfcst)
       call baopenr(12,cmean(1:lmean),irmean)
       call baopenr(13,cstdv(1:lstdv),irstdv)
c      call baopenr(14,cbias(1:lbias),irbias)
       if (irfcst.ne.0) goto 882
       if (irmean.ne.0) goto 882
       if (irstdv.ne.0) goto 882
c      if (irbias.ne.0) goto 882
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
c     get climate mean
c
       jj      = 0
       jpds    = -1
       jgds    = -1
       jens    = -1
       jpds(5) = ipds(5)
       jpds(6) = ipds(6)
       jpds(7) = ipds(7)
       jpds(8) = 59
       if (ii.le.14) then
       jpds(9) = jpds9  
       jpds(10)= jpds10 
       jpds(11)= jpds11 
       else
       jpds(9) = kpds9  
       jpds(10)= kpds10 
       jpds(11)= kpds11 
       endif
c      jpds(14)= ipds(14)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgbe(12,0,ixy,jj,jpds,jgds,jens,kf,k,kpds,kgds,kens,
     *             lb,cavg,iret)
       if(iret.eq.0) then
        call grange(kf,lb,cavg,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
         icnt=1
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
c
c     get climate standard deviation
c
       jj      = 0
       jpds    = -1
       jgds    = -1
       jens    = -1
       jpds(5) = ipds(5)
       jpds(6) = ipds(6)
       jpds(7) = ipds(7)
       jpds(8) = 59      
       if (ii.le.14) then
       jpds(9) = jpds9  
       jpds(10)= jpds10 
       jpds(11)= jpds11 
       else
       jpds(9) = kpds9  
       jpds(10)= kpds10 
       jpds(11)= kpds11 
       endif
c      jpds(14)= ipds(14)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgbe(13,0,ixy,jj,jpds,jgds,jens,kf,k,kpds,kgds,kens,
     *             lb,stdv,iret)
       if(iret.eq.0) then
        call grange(kf,lb,stdv,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
         icnt=1
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
c
c     get bias (diff. between analysis and cdas)
       if ( ibias.ne.1) then
c
c      jj      = 0
c      jpds    = -1
c      jgds    = -1
c      jpds(5) = ipds(5)
c      jpds(6) = ipds(6)
c      jpds(7) = ipds(7)
c      jpds(8) = ipds(8)
c      jpds(9) = ipds(9)
c      jpds(10)= ipds(10)
c      jpds(11)= ipds(11)
c      jpds(14)= ipds(14)
c--------+----------+----------+----------+----------+----------+----------+--
c      call getgb(14,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,bias,iret)
c      if(iret.eq.0) then
c       call grange(kf,lb,bias,dmin,dmax)
c       if (icnt.eq.0) then
c        write(*,886)
c        icnt=1
c       endif
c       write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
c      else if (iret.eq.99) then
c       goto 881
c      else
c       goto 991
c      endif
       else
        bias=0.0
       endif

c
c     to calculate anomaly forecast
c
       do ij = 1, ixy
ccc     notes to use climate bias
ccc     if bias = gdas - cdas, then fmon = cavg + bias
ccc     if bias = cdas - gdas, then fmon = cavg - bias
c       fmon(1) = cavg(ij) - bias(ij)
        fmon(1) = cavg(ij)
        fmon(2) = stdv(ij)
ccc     protect when stdv = 0.0
        if (fmon(2).eq.0.0) fmon(2) = 0.01
ccc     cdfnor accept two parameters directly (mean and std deviation)
        opara(1) = fmon(1)
        opara(2) = fmon(2)
        anom(ij)=cdfnor(fcst(ij),opara)*100.0
        if (ij.ge.10001.and.ij.le.10020) then
        write (*,883) ij,fmon(1),fmon(2),fcst(ij),anom(ij)
c       print *, 'ij=',ij,' m1=',fmon(1),' m2=',fmon(2),
c    *           ' fc=',fcst(ij),' an=',anom(ij)
        endif
       enddo
       iens(4)=6
       call putgbe(81,ixy,ipds,igds,iens,lb,anom,iret)

       call baclose(11,iret)
       call baclose(12,iret)
       call baclose(13,iret)
c      call baclose(14,iret)
      enddo

      call baclose(81,iret)
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

