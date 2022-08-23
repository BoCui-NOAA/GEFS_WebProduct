CCC
CCC   This program will convert GRIB file to fit the ECMWF layer
CCC      for wind field only:
CCC      at:    850 mb   
CCC             200 mb 
CCC      for:   ECMWF file only
CCC
CCC      Yuejian Zhu converted from Cray-5    01/27/2000
CCC        
      Program ecmcvt
      dimension f1(10512),f2(10512)
      dimension kpds(25),kgds(22),jpds(25),jgds(22)
      logical*1 lb(10512),ld(10512)
      character*80 cpgb,cpgi,pgbo
      namelist /namin/ cpgb,cpgi,pgbo

      read (5,namin)
      lpgb=len_trim(cpgb)
      lpgi=len_trim(cpgi)
      lpgo=len_trim(pgbo)
      print *, cpgb(1:lpgb)
      print *, cpgi(1:lpgi)
      print *, pgbo(1:lpgo)
      call baopenr(11,cpgb(1:lpgb),iretb)
      call baopenr(21,cpgi(1:lpgi),ireti)
      call baopen (51,pgbo(1:lpgo),ireto)

      do n = 1, 300
       j   =n-1
       jpds=-1
       jgds=-1
       ndata=10512
       call getgb(11,21,10512,j,jpds,jgds,
     .            kf,k,kpds,kgds,lb,f2,iret)
       if (iret.eq.0) then
        call grange(kf,lb,f2,dmin,dmax)
C       print '(i4,2x,7i5,i8,2g12.4)',
C    &         k,(kpds(i),i=5,11),kf,dmin,dmax
        if (kpds(5).eq.33.or.kpds(5).eq.34) then
         do m = 1, 10512
          f1(m) = 10.00
          ld(m) = .FALSE.
         enddo
         do m=1, 4176
          f1(3168+m) = f2(m)
          ld(3168+m) = lb(m)
         enddo
         do m = 1, 10512
          f2(m) = f1(m)
          lb(m) = ld(m) 
         enddo
         ibmap = 0
         ibds  = 0
         kpds(3) = 2     ! Grid Identification, 2=10512(144*73) points
         kpds(4) = 128   ! Flag for GDS or BMS, 128=10000000
         kgds(2) = 144
         kgds(3) = 73
         kgds(4) = 90000
         kgds(5) = 0
         kgds(6) = 128
         kgds(7) = -90000
         kgds(8) = -2500
         kgds(9) = 2500
         kgds(10)= 2500
         kf      = 10512
c        call putgb(51,ndata,kpds,kgds,lb,f2,iret)
        endif
        call putgb(51,ndata,kpds,kgds,lb,f2,iret)
        call grange(kf,lb,f2,dmin,dmax)
C       print '(i4,2x,7i5,i8,2g12.4)',
C    &         k,(kpds(i),i=5,11),kf,dmin,dmax
       endif

      enddo
      stop
      end

      subroutine grange(n,ld,d,dmin,dmax)
      logical*1 ld
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

