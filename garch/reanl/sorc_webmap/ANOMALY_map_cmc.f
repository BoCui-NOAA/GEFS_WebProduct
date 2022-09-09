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
      dimension cavg(ixy),cstd(ixy),bias(ixy),temp(ixy)
      dimension favg(ixy),fspr(ixy),fp10(ixy),fp90(ixy)
      dimension aavg(ixy),ap10(ixy),ap90(ixy)
      dimension ipds(200),igds(200),iens(5)
      dimension jpds(200),jgds(200),jens(5)
      dimension kpds(200),kgds(200),kens(5)
      dimension ifld(iv),ityp(iv),ilev(iv)
      dimension fmon(2),cmon(2),opara(2)
      logical*1 lb(ixy)
      character*80 cfavg,cfspr,ccavg,ccstd,cbias,caavg,cap10,cap90,
     &             cfp10,cfp90
      namelist /namin/ cfavg,cfspr,ccavg,ccstd,cbias,caavg,cap10,cap90,
     &                 cfp10,cfp90,ibias,nmemb
      data ifld/   7,   7,   7,   7,  11,  11,  11,  33,  34,  33,  34,
     &            33,  34,   2,  11,  15,  16,  33,  34/
      data ityp/ 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 102, 105, 105, 105, 105, 105/
      data ilev/1000, 700, 500, 250, 850, 500, 250, 850, 850, 500, 500,
     &           250, 250,   0,   2,   2,   2,  10,  10/

      read (5,namin,end=100)
      write(6,namin)

 100  continue

      lfavg = len_trim(cfavg)
      lfspr = len_trim(cfspr)
      lcavg = len_trim(ccavg)
      lcstd = len_trim(ccstd)
      lbias = len_trim(cbias)
      laavg = len_trim(caavg)
      lap10 = len_trim(cap10)
      lap90 = len_trim(cap90)
      lfp10 = len_trim(cfp10)
      lfp90 = len_trim(cfp90)
      print *, 'Forecast mean file is ',cfavg(1:lfavg)
      print *, 'Forecast sprd file is ',cfspr(1:lfspr)
      print *, 'Climate  mean file is ',ccavg(1:lcavg)
      print *, 'Climate  stdv file is ',ccstd(1:lcstd)
      print *, 'Analysis bias file is ',cbias(1:lbias)
      print *, 'Anomaly  avg  file is ',caavg(1:laavg)
      print *, 'Anomaly  p10  file is ',cap10(1:lap10)
      print *, 'Anomaly  p90  file is ',cap90(1:lap90)
      print *, 'Forecast 10%  file is ',cfp10(1:lfp10)
      print *, 'Forecast 90%  file is ',cfp90(1:lfp90)
      call baopen (81,caavg(1:laavg),iraavg)
      call baopen (82,cap10(1:lap10),irap10)
      call baopen (83,cap90(1:lap90),irap90)
      call baopen (84,cfp10(1:lfp10),irfp10)
      call baopen (85,cfp90(1:lfp90),irfp90)
      
      icnt = 0
c     do ii = 1, iv
      do ii = 15, 15 ! t2m only
       call baopenr(11,cfavg(1:lfavg),irfavg)
       call baopenr(12,cfspr(1:lfspr),irfspr)
       call baopenr(13,ccavg(1:lcavg),ircavg)
       call baopenr(14,ccstd(1:lcstd),ircstd)
       call baopenr(15,cbias(1:lbias),irbias)
       if (irfavg.ne.0) goto 882
       if (irfspr.ne.0) goto 882
       if (ircavg.ne.0) goto 882
       if (ircstd.ne.0) goto 882
       if (irbias.ne.0) goto 882
c
c     get bias corrrrected forecast mean (14 members since May 30 2006 )
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
     *             lb,favg,iret)
       if(iret.eq.0) then
        ipds = kpds
        igds = kgds
        iens = kens
        call grange(kf,lb,favg,dmin,dmax)
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
c     get ensemble spread (14 members since May 30 2006 )
c
       jj      = 0
       jpds    = -1
       jgds    = -1
       jens    = -1
       jpds(5) = ifld(ii)
       jpds(6) = ityp(ii)
       jpds(7) = ilev(ii)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgbe(12,0,ixy,jj,jpds,jgds,jens,kf,k,kpds,kgds,kens,
     *             lb,fspr,iret)
       if(iret.eq.0) then
        ipds = kpds
        igds = kgds
        iens = kens
        call grange(kf,lb,fspr,dmin,dmax)
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
       call getgbe(13,0,ixy,jj,jpds,jgds,jens,kf,k,kpds,kgds,kens,
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
       call getgbe(14,0,ixy,jj,jpds,jgds,jens,kf,k,kpds,kgds,kens,
     *             lb,cstd,iret)
       if(iret.eq.0) then
        call grange(kf,lb,cstd,dmin,dmax)
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
c     convert climate mean and standard deviation to CMC's data order
c
      do ij = 1, ixy
       j = (180 - ij/360)*360 + (ij - ij/360*360) 
       temp(j) = cavg(ij)
       if ( ij.le.362) then
       endif
      enddo
c     print *, "cavg(1)=", cavg(1), " cavg(64801)=", cavg(64801)
      cavg=temp
c     print *, "cavg(1)=", cavg(1), " cavg(64801)=", cavg(64801)
      do ij = 1, ixy
       j = (180 - ij/360)*360 + (ij - ij/360*360) 
       temp(j) = cstd(ij)
      enddo
      cstd=temp
c
c     get bias (diff. between analysis and cdas)
c

       if ( ibias.ne.1) then
 
       jj      = 0
       jpds    = -1
       jgds    = -1
       jpds(5) = ipds(5)
       jpds(6) = ipds(6)
       jpds(7) = ipds(7)
c      jpds(8) = ipds(8)
c      jpds(9) = ipds(9)
c      jpds(10)= ipds(10)
c      jpds(11)= ipds(11)
c      jpds(14)= ipds(14)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgb(15,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,bias,iret)
       if(iret.eq.0) then
        call grange(kf,lb,bias,dmin,dmax)
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
       else
        bias=0.0
       endif

c
c     to calculate anomaly forecast
c
       n=14
       n=nmemb
       do ij = 1, ixy
        fmon(1) = favg(ij)
        fmon(2) = sqrt(fspr(ij)*fspr(ij)*float(n-1)/float(n))
c       fmon(2) = fspr(ij)
        if (fmon(2).le.0.0) fmon(2) = 0.01
        opara(1) = fmon(1)
        opara(2) = fmon(2)
        fp90(ij) = quanor(0.9,opara)
        fp10(ij) = quanor(0.1,opara)
c       if (ij.ge.10001.and.ij.le.10020) then
c        print *, 'ij=',ij,' avg=',favg(ij),' f10=',fp10(ij),
c    *            ' f90=',fp90(ij),' std=',fmon(2)
c       endif
ccc     notes to use climate bias
ccc     if bias = gdas - cdas, then fmon = cavg + bias
ccc     if bias = cdas - gdas, then fmon = cavg - bias
CCCCCC  Notes: 09/06/2006 by Yuejian Zhu: bias is incorrect.
c       cmon(1) = cavg(ij) - bias(ij)
        cmon(1) = cavg(ij) 
        cmon(2) = cstd(ij)
ccc     protect when stdv = 0.0
        if (cmon(2).eq.0.0) cmon(2) = 0.01
ccc     cdfnor accept two parameters directly (mean and std deviation)
        opara(1) = cmon(1)
        opara(2) = cmon(2)
        aavg(ij)=cdfnor(favg(ij),opara)*100.0
        ap10(ij)=cdfnor(fp10(ij),opara)*100.0
        ap90(ij)=cdfnor(fp90(ij),opara)*100.0
c  print out for 44N, 260-269E (16460-16469)
        if (ij.ge.16460.and.ij.le.16469) then
         write (*,883) ij,cmon(1),cmon(2),fp10(ij),ap10(ij)
         write (*,883) ij,cmon(1),cmon(2),favg(ij),aavg(ij)
         write (*,883) ij,cmon(1),cmon(2),fp90(ij),ap90(ij)
         print *, 'ij=',ij,' m1=',fmon(1),' m2=',fmon(2),
     *            ' bi=',bias(ij)
        endif
       enddo
       iens(4)=6
       call putgbe(81,ixy,ipds,igds,iens,lb,aavg,iret)
       call putgbe(82,ixy,ipds,igds,iens,lb,ap10,iret)
       call putgbe(83,ixy,ipds,igds,iens,lb,ap90,iret)
       call putgbe(84,ixy,ipds,igds,iens,lb,fp10,iret)
       call putgbe(85,ixy,ipds,igds,iens,lb,fp90,iret)

       call baclose(11,iret)
       call baclose(12,iret)
       call baclose(13,iret)
       call baclose(14,iret)
       call baclose(15,iret)
      enddo

      call baclose(81,iret)
      call baclose(82,iret)
      call baclose(83,iret)
      call baclose(84,iret)
      call baclose(85,iret)
  881 continue
  991 continue
  883 format('ij=',i5,'  cm=',e10.4,'  cs=',e10.4,'  fc=',e10.4,
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
      dmin=  1.e30
      dmax= -1.e30
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

