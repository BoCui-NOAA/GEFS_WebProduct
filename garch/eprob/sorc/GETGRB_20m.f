      subroutine getgrb(fp,ne,fm,ft,fa,cpgb,cpgi,ifd,ilev,idate,jdate,
     *                  ifh,iunit)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                      C
C     USAGE: READ FORECAST PRESSURE FILE ON GRIB FORMAT EXTENSION      C
C            WITH GRID POINT VALUE                                     C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                   C
C                                                                      C
C     INPUT: unblocked GRIB FORMAT PRESSURE FILE                       C
C                                                                      C
C     OUTPUT:2.5*2.5 degree grid resolution cover global ( 144*73 )    C
C                                                                      C
C     Arguments:                                                       C
C               1. glb(144,73)                                         C
C               2. cpgb ( pgb file input )                             C
C               3. cpgi ( pgb index file input )                       C
C               4. ifd ( field ID input )                              C
C               5. ilev ( level input )                                C
C               6. idate ( YYMMDDHH input with Y2K option )            C
C               6. ifh  ( forecast hours at idate )                    C
C                                                                      C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c--------+---------+---------+---------+---------+---------+---------+---------+
      parameter(mdata=20000)
      dimension kpds(25),kgds(22),kens(5),jpds(25),jgds(22),jens(5)
      dimension data(mdata)               
      dimension fp(10512,ne)               
      dimension fm(10512)
      dimension ft(10512)
      dimension fa(10512)
      dimension jlev(17)                 
      dimension iens2(22),iens3(22)
      character*2  cim(12)
      character*80 cpgb,cpgi    
      logical   lb(mdata)
      data      jlev/1000, 925, 850, 700, 500, 400, 300, 250, 
     .                200, 150, 150, 100,  75,  50,  30,  20,  10/
      data      cim /'01','02','03','04','05','06',
     .               '07','08','09','10','11','12'/
      data iens2/1,1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3/
      data iens3/1,2,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20/
c     data iens2/1,1,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3/
c     data iens3/1,2,2,2,3,3,4,4,5,5,6,6,5,5,6,6,8,8,9,9,10,10/
 
      fp=-9999.99
      fm=-9999.99
      ft=-9999.99
      fa=-9999.99
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
 
      if (jdate.gt.999999999.and.jdate.lt.2100000000) then
       kdate  = jdate
       jdate  = jdate - (jdate/100000000)*100000000
       jyear  = jdate/1000000              
       jmonth = jdate/10000 - jyear*100
       jday   = jdate/100 - jyear*10000 - jmonth*100
       jhour  = jdate - jyear*1000000 - jmonth*10000 - jday*100
       jdate  = kdate
      else if (jdate.gt.9999999.and.jdate.lt.100000000) then
       jyear  = jdate/1000000
       jmonth = jdate/10000 - jyear*100
       jday   = jdate/100 - jyear*10000 - jmonth*100
       jhour  = jdate - jyear*1000000 - jmonth*10000 - jday*100
      else
       goto 992
      endif

      do j = 1, 12
       if (jlev(j).eq.ilev) goto 100
      enddo
      goto 993
  100 continue

      lpgb=len_trim(cpgb)
      lpgi=len_trim(cpgi)
      print *, 'PGB=',cpgb(1:lpgb),' INDEX=',cpgi(1:lpgi)   
      call baopenr(iunit,cpgb(1:lpgb),iretb)
      call baopenr(iunit+10,cpgi(1:lpgi),ireti)
c
      icnt    = 0
      jcnt    = 0
      do imem = 1, ne+2
       jj      = 0
       jpds    = -1
       jgds    = -1
       jens    = -1
       jpds(5) = ifd
       jpds(6) = 100
       jpds(7) = ilev
       if (iyear.eq.0) then
        iyear=100
       endif
       jpds(8) = iyear
       jpds(9) = imonth
       jpds(10)= iday 
       jpds(11)= ihour
       jpds(14)= ifh
c
       jpds(23)= 2              ! set up wild card for extension search
       jens(2) = iens2(imem)
       jens(3) = iens3(imem)
c--------+---------+---------+---------+---------+---------+---------+---------+
c      print *, jpds,jens
      print *, 'JPDS=',(jpds(kkk),kkk=5,14)
      print *, 'jj=', jj
       call getgbe(iunit,iunit+10,mdata,jj,jpds,jgds,jens,
     .             kf,k,kpds,kgds,kens,lb,data,iret)
c      print *, kpds,kens,iret
      print *, 'iret=', iret
      print *, 'JPDS=',(jpds(kkk),kkk=5,14)
      print *, 'JGDS=',(jgds(kkk),kkk=5,14)
      print *, 'KPDS=',(kpds(kkk),kkk=5,14)
      print *, 'KGDS=',(kgds(kkk),kkk=5,14)
      print *, 'Kf=', kf,'k=',k
       if(iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
         icnt=1
        endif
c--------+---------+---------+---------+---------+---------+---------+---------+
        write(*,888) k,(kpds(i),i=5,11),kpds(14),(kens(i),i=2,3),kf,
     .                  dmax,dmin
        if (imem.eq.1) then
         do i = 1, 10512
          fm(i) = data(i)
         enddo
        elseif (imem.eq.2) then
         do i = 1, 10512
          ft(i) = data(i)
         enddo
c       elseif (imem.eq.13) then
c        do i = 1, 10512
c         fa(i) = data(i)
c        enddo
        else
         jcnt=jcnt+1
         do i = 1, 10512
          fp(i,jcnt) = data(i)
         enddo
        endif
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif
  881 continue
      enddo

      call baclose(iunit,iret)
      call baclose(iunit+10,iret)
      return
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       ' ens2 ens3  ndata  Maximun  Minimum')
  888 format (i4,2x,8i5,2i5,i8,2f9.2)
  991 print *, ' there is a problem to open pgb file !!! '
      return
  992 print *, ' idate =',idate,' is not acceptable, please check!!!'
      return
  993 print *, ' level =',ilev,' is not acceptable, please check!!!'
      return
      end
