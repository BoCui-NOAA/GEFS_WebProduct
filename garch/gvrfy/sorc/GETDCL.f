      subroutine getdcl(glb,ifd,ilev,idate)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: READ CLIMATE PRESSURE FILE ON GRIB FORMAT               C
C            WITH GRID POINT VALUE                                   C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: unblocked GRIB FORMAT PRESSURE FILE                     C
C                                                                    C
C     OUTPUT:2.5*2.5 degree grid resolution cover global ( 144*73 )  C
C                                                                    C
C     Arguments:                                                     C
C               1. glb(144,73)                                       C
C               2. ifd ( field ID input )                            C
C               3. ilev ( level input )                              C
C               4. imon ( month input )                              C
C               5. ihr  ( hour of date input )                       C
C               6. ifh  ( forecast hours at ihr )                    C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c--------+----------+----------+----------+----------+----------+----------+--
      parameter(mdata=20000)
      dimension kpds(25),kgds(22),jpds(25),jgds(22)
      dimension glb(144,73),data(mdata)               
      dimension jlev(12)                 
      character*2  cim(12)
      character*80 cpgb,cpgi    
      logical*1   lb(mdata)
      data      jlev/1000, 850, 700, 500, 400, 300, 
     .                250, 200, 150, 100,  75,  50/
      data      cim /'01','02','03','04','05','06',
     .               '07','08','09','10','11','12'/
      data      cpgb/'/global/cdas/z500.daily0z.harmc4.b7995.grb'/
      data      cpgi/'/global/cdas/z500.daily0z.harmc4.b7995.grbi'/
c
      glb=-9999.99
      if (idate.gt.999999999.and.idate.lt.2100000000) then
       idate  = idate - (idate/100000000)*100000000
       iyear  = idate/1000000
       imonth = idate/10000 - iyear*100
       iday   = idate/100 - iyear*10000 - imonth*100
       ihour  = idate - iyear*1000000 - imonth*10000 - iday*100
      else if (idate.gt.9999999.and.idate.lt.100000000) then
       iyear  = idate/1000000
       imonth = idate/10000 - iyear*100
       iday   = idate/100 - iyear*10000 - imonth*100
       ihour  = idate - iyear*1000000 - imonth*10000 - iday*100
      else
       goto 992
      endif

      do j = 1, 12
       if (jlev(j).eq.ilev) goto 100
      enddo
      goto 993
  100 continue

      print *, cpgb(1:43)   
      print *, cpgi(1:44)   
      call baopenr(11,cpgb(1:42),iretb)
      call baopenr(21,cpgi(1:43),ireti)
c     print *, '=== Read 23 years CDAS/Reanl Climatology data ==='
c     print *, ' Month =',imon,' fld =',ifd,' level =',ilev,
c    .         ' itime =',itime    
      j       = -1
      jpds    = -1
      jgds    = -1
      jpds(5) = ifd
      jpds(6) = 100
      jpds(7) = ilev
      jpds(9) = imonth
      jpds(10)= iday
      call getgb(11,21,mdata,j,jpds,jgds,
     .           kf,k,kpds,kgds,lb,data,iret)
      if(iret.eq.0) then
        call baclose(11,iret)
        call baclose(21,iret)
        call grange(kf,lb,data,dmin,dmax)
        write(*,886)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmin,dmax
        do i = 1, 144
         do j = 1, 73
          ij=(j-1)*144 + i
          glb(i,j)=data(ij)
         enddo
        enddo
      else
       goto 991
      endif
      return
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       '  ndata  Maximun    Minimum')
  888 format (i4,2x,8i5,i8,2g12.4)
  991 print *, ' there is a problem to open pgb file !!! '
      call baclose(11,iret)
      call baclose(21,iret)
      return
  992 print *, ' idate =',idate,' is not acceptable, please check!!!'
      return
  993 print *, ' level =',ilev,' is not acceptable, please check!!!'
      return
      end
