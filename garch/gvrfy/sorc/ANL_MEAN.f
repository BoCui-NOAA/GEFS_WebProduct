c
c  Main program    ANL_MEAN
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
      program ANL_MEAN
      parameter (ix=360,iy=181,ixy=ix*iy,iv=45)            
c     parameter (ix=144,iy=73,ixy=ix*iy,iv=19)            
      dimension fnmc(ixy),fecm(ixy),fukm(ixy),fmen(ixy)
      dimension ipds(200),igds(200),iens(5)
      dimension jpds(200),jgds(200),jens(5)
      dimension kpds(200),kgds(200),kens(5)
      dimension ifld(iv),ityp(iv),ilev(iv)
      logical*1 lb(ixy)
      character*4  lab(4)
      character*80 cnmc,cecm,cukm,cmen
      namelist /namin/ cnmc,cecm,cukm,cmen
      data ifld/   7,   7,   7,   7,   7,   7,   7,   7,   7,   7,     
     &            11,  11,  11,  11,  11,  11,  11,  11,  11,  11,
     &            52,  52,  52,  52,  33,  33,  33,  33,  33,  33,
     &            33,  33,  33,  33,  34,  34,  34,  34,  34,  34,
     &            34,  34,  34,  34,   2/
      data ityp/ 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 100, 100, 102/                          
      data ilev/1000, 850, 700, 500, 400, 300, 250, 200, 150, 100,
     &          1000, 850, 700, 500, 400, 300, 250, 200, 150, 100,
     &          1000, 850, 700, 500,1000, 850, 700, 500, 400, 300, 
     &           250, 200, 150, 100,1000, 850, 700, 500, 400, 300,
     &           250, 200, 150, 100,   0/
      data lab/'NCEP','ECM ','UKM ','MEAN'/

      read (5,namin,end=100)
      write(6,namin)

  100 continue

      lnmc = len_trim(cnmc)
      lecm = len_trim(cecm)
      lukm = len_trim(cukm)
      lmen = len_trim(cmen)
      print *, 'NCEP analysis file is ',cnmc(1:lnmc)
      print *, 'ECM  analysis file is ',cecm(1:lecm)
      print *, 'UKM  analysis file is ',cukm(1:lukm)
      print *, 'MEAN analysis file is ',cmen(1:lmen)
      call baopen (81,cmen(1:lmen),irmen)
      call baopenr(11,cnmc(1:lnmc),irnmc)
      call baopenr(12,cecm(1:lecm),irecm)
      call baopenr(13,cukm(1:lukm),irukm)
c     if (irnmc.ne.0) goto 882
c     if (irecm.ne.0) goto 882
c     if (irukm.ne.0) goto 882
      
      jj   = -1
      jcnt = 0
  200 continue
      do ii = 1, iv
      icnt = 0
      incep = 0
      iecm  = 0
      iukm  = 0
      
c
c     get NCEP analysis
c
c      jj      = jj + 1
       jj      = -1      
       jpds    = -1
       jgds    = -1
       jpds(5) = ifld(ii)
       jpds(6) = ityp(ii)
       jpds(7) = ilev(ii)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgb(11,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,fnmc,iret)
       if(iret.eq.0) then
        ipds = kpds
        igds = kgds
        icnt = icnt + 1
        incep = 1
        call grange(kf,lb,fnmc,dmin,dmax)
        k_nmc = k
        kf_nmc = kf
        dmax_nmc = dmax
        dmin_nmc = dmin
c       write(*,888) lab(1),k_nmc,(kpds(i),i=5,11),kpds(14),kf_nmc,
c    *               dmax_nmc,dmin_nmc
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
c
c     get ECM analysis
c
       jjj     = -1
       jpds    = -1
       jgds    = -1
       jens    = -1
       jpds(5) = ipds(5)
       jpds(6) = ipds(6)
       jpds(7) = ipds(7)
       jpds(9) = ipds(9)
       jpds(10)= ipds(10)
       jpds(11)= ipds(11)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgb(12,0,ixy,jjj,jpds,jgds,kf,k,kpds,kgds,lb,fecm,iret)
       if(iret.eq.0) then
        icnt = icnt + 1
        iecm = 1
        call grange(kf,lb,fecm,dmin,dmax)
        k_ecm = k
        kf_ecm = kf
        dmax_ecm = dmax
        dmin_ecm = dmin
c       write(*,888) lab(2),k_ecm,(kpds(i),i=5,11),kpds(14),kf_ecm,
c    *               dmax_ecm,dmin_ecm
       endif
c
c     get UKM analysis
c
       jjj     = -1
       jpds    = -1
       jgds    = -1
       jens    = -1
       jpds(5) = ipds(5)
       jpds(6) = ipds(6)
       jpds(7) = ipds(7)
       jpds(9) = ipds(9)
       jpds(10)= ipds(10)
       jpds(11)= ipds(11)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgb(13,0,ixy,jjj,jpds,jgds,kf,k,kpds,kgds,lb,fukm,iret)
       if(iret.eq.0) then
        icnt = icnt + 1
        iukm = 1
        call grange(kf,lb,fukm,dmin,dmax)
        k_ukm = k
        kf_ukm = kf
        dmax_ukm = dmax
        dmin_ukm = dmin
c       write(*,888) lab(3),k_ukm,(kpds(i),i=5,11),kpds(14),kf_ukm,
c    *               dmax_ukm,dmin_ukm
       endif
c
c     to calculate mean analysis    
c
       if (icnt.gt.0) then
        write(*,886)
        if (incep.eq.1) then
        write(*,888) lab(1),k_nmc,(kpds(i),i=5,11),kpds(14),kf_nmc,
     *               dmax_nmc,dmin_nmc
        endif
        if (iecm.eq.1) then
        write(*,888) lab(2),k_ecm,(kpds(i),i=5,11),kpds(14),kf_ecm,
     *               dmax_ecm,dmin_ecm
        endif
        if (iukm.eq.1) then
        write(*,888) lab(3),k_ukm,(kpds(i),i=5,11),kpds(14),kf_ukm,
     *               dmax_ukm,dmin_ukm
        endif
        jcnt = jcnt + 1
        do ij = 1, ixy
         fmen(ij) = (fnmc(ij)+fecm(ij)+fukm(ij))/float(icnt)
        enddo
        call grange(kf,lb,fmen,dmin,dmax)
        write(*,888) lab(4),jcnt,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
        if (kpds(5).eq.7.and.kpds(6).eq.100.and.kpds(7).eq.500) then
        write(60,889) (kpds(i),i=5,11),incep,iecm,iukm
        endif
c       write(61,890) kpds(5),kpds(6),kpds(7)
        print *, "               ***************"
        call putgbe(81,ixy,ipds,igds,iens,lb,fmen,iret)
       endif

      enddo
c     goto 200

  881 continue
  991 continue

      print *, " **** Total ", jcnt, " variables are processed ****"
      call baclose(11,iret)
      call baclose(12,iret)
      call baclose(13,iret)
      call baclose(81,iret)
  886 format('     Irec   pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       '  ndata  Maximun  Minimum')
  888 format (a4,1x,i4,1x,8i5,i8,2f9.2)
  889 format (1x,7i5,' NCEP=',i1,' ECM=',i1,' UKM=',i1)
  890 format (1x,3i5)

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

