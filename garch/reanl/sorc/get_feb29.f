c
c  Main program    get_feb29
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
c     parameter (ix=360,iy=181,ixy=ix*iy,iv=19)            
      parameter (ix=144,iy=73,ixy=ix*iy,iv=19)            
      dimension cavg1(ixy),cavg2(ixy),cavg3(ixy)
      dimension stdv1(ixy),stdv2(ixy),stdv3(ixy)
      dimension ipds(200),igds(200)
      dimension jpds(200),jgds(200)
      dimension kpds(200),kgds(200)
      dimension ifld(iv),ityp(iv),ilev(iv)
      logical*1 lb(ixy)
      character*80 cmean1,cmean2,cmean3,cstdv1,cstdv2,cstdv3
      namelist /namin/ cmean1,cmean2,cmean3,cstdv1,cstdv2,cstdv3
      data ifld/   7,   7,   7,   7,  11,  11,  11,  33,  34,  33,  34,
     &            33,  34,   2,  11,  15,  16,  33,  34/
      data ityp/ 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 102, 105, 105, 105, 105, 105/
      data ilev/1000, 700, 500, 250, 850, 500, 250, 850, 850, 500, 500,
     &           250, 250,   0,   2,   2,   2,  10,  10/

      read (5,namin,end=100)
      write(6,namin)

 100  continue

      lmean1 = len_trim(cmean1)
      lmean2 = len_trim(cmean2)
      lmean3 = len_trim(cmean3)
      lstdv1 = len_trim(cstdv1)
      lstdv2 = len_trim(cstdv2)
      lstdv3 = len_trim(cstdv3)
      print *, 'Climate  mean file is ',cmean1(1:lmean1)
      print *, 'Climate  mean file is ',cmean2(1:lmean2)
      print *, 'Climate  mean file is ',cmean3(1:lmean3)
      print *, 'Climate  stdv file is ',cstdv1(1:lstdv1)
      print *, 'Climate  stdv file is ',cstdv2(1:lstdv2)
      print *, 'Climate  stdv file is ',cstdv3(1:lstdv3)
      
      icnt = 0
      call baopen(51,cmean3(1:lmean3),irmean3)
      call baopen(52,cstdv3(1:lstdv3),irstdv3)
      do ii = 1, iv
       call baopenr(11,cmean1(1:lmean1),irmean1)
       call baopenr(12,cmean2(1:lmean2),irmean2)
       call baopenr(13,cstdv1(1:lstdv1),irstdv1)
       call baopenr(14,cstdv2(1:lstdv2),irstdv2)
       if (irmean1.ne.0) goto 882
       if (irmean2.ne.0) goto 882
       if (irstdv1.ne.0) goto 882
       if (irstdv2.ne.0) goto 882
c--------+----------+----------+----------+----------+----------+----------+--
c
c     get climate mean
c
       jj      = 0
       jpds    = -1
       jgds    = -1
       jpds(5) = ifld(ii)
       jpds(6) = ityp(ii)
       jpds(7) = ilev(ii)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgb(11,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,cavg1,iret)
       if(iret.eq.0) then
        ipds = kpds
        igds = kgds
        call grange(kf,lb,cavg1,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
        icnt = 1
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
c
       call getgb(12,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,cavg2,iret)
       if(iret.eq.0) then
        call grange(kf,lb,cavg2,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
       do ij = 1, ixy   
        cavg3(ij) = (cavg1(ij) + cavg2(ij))/2.0
       enddo
c
       if (ii.le.14) then
       ipds(10)= 29     
       else
       ipds(10)= ipds(10) + 1
       endif
       call putgb(51,ixy,ipds,igds,lb,cavg3,iret)
       if(iret.eq.0) then
        call grange(kf,lb,cavg3,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
        endif
        write(*,888) k,(ipds(i),i=5,11),ipds(14),kf,dmax,dmin
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
       jpds(5) = ifld(ii)
       jpds(6) = ityp(ii)
       jpds(7) = ilev(ii)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgb(13,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,stdv1,iret)
       if(iret.eq.0) then
        ipds = kpds
        igds = kgds
        call grange(kf,lb,stdv1,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
c
       call getgb(14,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,stdv2,iret)
       if(iret.eq.0) then
        call grange(kf,lb,stdv2,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
c
       do ij = 1, ixy   
        stdv3(ij) = (stdv1(ij) + stdv2(ij))/2.0
       enddo
c
       if (ii.le.14) then
       ipds(10)= 29     
       else
       ipds(10)= ipds(10) + 1
       endif
       call putgb(52,ixy,ipds,igds,lb,stdv3,iret)
       if(iret.eq.0) then
        call grange(kf,lb,stdv3,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
        endif
        write(*,888) k,(ipds(i),i=5,11),ipds(14),kf,dmax,dmin
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif

c
       call baclose(11,iret)
       call baclose(12,iret)
       call baclose(13,iret)
c      call baclose(14,iret)
      enddo

      call baclose(51,iret)
      call baclose(52,iret)
  881 continue
  991 continue
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

