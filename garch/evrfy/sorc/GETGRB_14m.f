      subroutine getgrb(glb,cpgb,ifd,ilev,idate,ifh,iunit)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                            C
C     USAGE: READ FORECAST PRESSURE FILE ON GRIB FORMAT EXTENSION            C
C            WITH GRID POINT VALUE                                           C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                         C
C                                                                            C
C     INPUT: unblocked GRIB FORMAT PRESSURE FILE                             C
C                                                                            C
C     OUTPUT:2.5*2.5 degree grid resolution cover global ( 144*73 )          C
C                                                                            C
C     Arguments:                                                             C
C               1. glb(144,73)                                               C
C               2. cpgb ( pgb file input )                                   C
C               3. ifd ( field ID input )                                    C
C               4. ilev ( level input )                                      C
C               5. idate ( YYMMDDHH input with Y2K option )                  C
C               6. ifh  ( forecast hours at idate )                          C
C                                                                            C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+----------+----------+----------+----------+----------+----------+--
      parameter(mdata=10512,mem=16)
      dimension kpds(200),kgds(200),kens(200)
      dimension jpds(200),jgds(200),jens(200)
      dimension glb(144,73,mem),data(mdata)               
      dimension jlev(17)                 
      dimension iens2(mem),iens3(mem)
      character*2  cim(12)
      character*80 cpgb,cdate    
      logical   lb(mdata)
      data      jlev/1000, 925, 850, 700, 500, 400, 300, 250, 
     .                200, 150, 150, 100,  75,  50,  30,  20,  10/
      data      cim /'01','02','03','04','05','06',
     .               '07','08','09','10','11','12'/
      data iens2/1,1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3/
      data iens3/1,2,1,2,3,4,5,6,7,8,9,10,11,12,13,14/
c
      glb=-9999.99
      if (idate.gt.999999999.and.idate.lt.2100000000) then
       kdate  = idate
       idate  = idate - (idate/100000000)*100000000
       iyear  = idate/1000000             
       imonth = idate/10000 - iyear*100
       iday   = idate/100 - iyear*10000 - imonth*100
       ihour  = idate - iyear*1000000 - imonth*10000 - iday*100
       idate  = kdate
      else if (idate.gt.9999999.and.idate.lt.100000000) then
       iyear  = idate/1000000
       imonth = idate/10000 - iyear*100
       iday   = idate/100 - iyear*10000 - imonth*100
       ihour  = idate - iyear*1000000 - imonth*10000 - iday*100
      else
       goto 992
      endif
c
      do j = 1, 12
      if (jlev(j).eq.ilev) goto 100
      enddo
      if (ilev.eq.2) goto 100

      goto 993
  100 continue
      lpgb=len_trim(cpgb)
      print *, 'PGB=',cpgb(1:lpgb)   
      call baopenr(iunit,cpgb(1:lpgb),iretb)
c
      icnt    = 0
      do imem = 1, mem
      jj      = 0
      jpds    = -1
      jgds    = -1
      jens    = -1
      jpds(5) = ifd
      jpds(6) = 100
      jpds(7) = ilev
      if (ilev.eq.2) then
      jpds(6) = 105
      endif
      if (iyear.eq.0) then
       jpds(8) = 100
      else
       jpds(8) = iyear
      endif
      jpds(9) = imonth
      jpds(10)= iday 
      jpds(11)= ihour
      jpds(14)= ifh
c
      jpds(23)= 2              ! set up wild card for extension search
      jens(2) = iens2(imem)
      jens(3) = iens3(imem)
c--------+----------+----------+----------+----------+----------+----------+--
c     print *, jpds,jens
      call getgbe(iunit,0,mdata,jj,jpds,jgds,jens,
     .           kf,k,kpds,kgds,kens,lb,data,iret)
c     print *, kpds,kens,iret
      if(iret.eq.0) then
       call grange(kf,lb,data,dmin,dmax)
       if (icnt.eq.0) then
        write(*,886)
        icnt=1
       endif
c--------+----------+----------+----------+----------+----------+----------+--
       write(*,888) k,(kpds(i),i=5,11),kpds(14),(kens(i),i=2,3),kf,
     .              dmax,dmin
       do i = 1, 144
        do j = 1, 73
         ij=(j-1)*144 + i
         glb(i,j,imem)=data(ij)
        enddo
       enddo
      else if (iret.eq.99) then
       goto 881
      else
       goto 991
      endif
  881 continue
      enddo
      call baclose(iunit,iret)
      return
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       ' ens2 ens3  ndata  Maximun  Minimum')
  888 format (i4,2x,8i5,2i5,i8,2f9.2)
  991 print *, ' there is a problem to open pgb file !!! '
      call baclose(iunit,iret)
      return
  992 print *, ' idate =',idate,' is not acceptable, please check!!!'
      call baclose(iunit,iret)
      return
  993 print *, ' level =',ilev,' is not acceptable, please check!!!'
      call baclose(iunit,iret)
      return
      end
