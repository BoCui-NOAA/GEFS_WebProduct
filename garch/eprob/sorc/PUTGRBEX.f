C$$$  DOCUMENTATION BLOCK
C
C SUBROUTINE:   PUTGRB        WRITE PRESSURE GRIB FILE  
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 00-09-08
C
C PROGRAM HISTORY LOG:
C   00-09-08   YUEJIAN ZHU (WX20YZ) 
C
C USAGE:
C
C   OUTPUT FILES:
C     UNIT  51  PRECIPITATION GRIB FILE ( 144*73 )
C
C   SUBPROGRAMS CALLED:
C     PUTGB -- W3LIB ROUTINE
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      subroutine putgrbex(ogrid,ilev,ifld,idate,ifhour)                            
      parameter(jf=10512)
      dimension ogrid(144,73),f(jf)
      dimension kpds(25),kgds(22),kens(5),kprob(2),kclust(16)
      dimension kmembr(80),xprob(2)
      character*80 cpge
      logical*1 lb(jf)
c
c     cpge='outline.dat'
c     lpge=len_trim(cpge)
c     call baopenw(61,cpge(1:lpge),irete)

      do i = 1, 144
       do j = 1, 73
        ij=(j-1)*144 + i
        f(ij) = ogrid(i,j)
        if (ogrid(i,j).eq.-999.99) then
         lb(ij)=.false.
        else
         lb(ij)=.true.
        endif
       enddo
      enddo

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

      if (iyear.eq.0) then
       iyear=100
      endif
     
      if (iyear.gt.50) then
       icentury=20
      else
       icentury=21
      endif

      kpds(1)  = 7
      kpds(2)  = 82
      kpds(3)  = 2
      kpds(4)  = 128
      kpds(5)  = ifld    ! Using standard deviation of heigh instead of
      kpds(6)  = 100
      kpds(7)  = ilev    ! level
      kpds(8)  = iyear   ! year
      kpds(9)  = imonth  ! month
      kpds(10) = iday    ! day     
      kpds(11) = ihour   ! hour 
      kpds(12) = 0       ! minute of hour
      kpds(13) = 1       ! forecast time unit
      kpds(14) = ifhour  ! Forecast hours
      kpds(15) = 0
      kpds(16) = 10
      kpds(17) = 0
      kpds(18) = 1
      kpds(19) = 2
      kpds(20) = 0
      kpds(21) = icentury
      kpds(22) = 1
      kpds(23) = 2
      kpds(24) = 0
      kpds(25) = 0
      kgds(1)  = 0
      kgds(2)  = 144
      kgds(3)  = 73
      kgds(4)  = 90000
      kgds(5)  = 0
      kgds(6)  = 128
      kgds(7)  = -90000
      kgds(8)  = -2500
      kgds(9)  = 2500
      kgds(10) = 2500
      kgds(11) = 0
      kgds(12) = 0
      kgds(13) = 0
      kgds(14) = 0
      kgds(15) = 0
      kgds(16) = 0
      kgds(17) = 0
      kgds(18) = 0
      kgds(19) = 0
      kgds(20) = 255
      kgds(21) = 0  
      kgds(22) = 0  
      kens(1)  = 0
      kens(2)  = 5
      kens(3)  = 0
      kens(4)  = 1
      kens(5)  = 0
      kprob(1) = 0
      kprob(2) = 0
      xprob(1) = 0.0
      xprob(2) = 0.0
      kclust   = 0
      kmembr   = 0
      if (kpds(5).eq.191) then
       kens(4) = 0
       kprob(1)= 7
       kprob(2)= 11
      endif

      call putgbex(61,10512,kpds,kgds,kens,kprob,xprob,
     *             kclust,kmembr(80),lb,f,iret)
c     call baclose(61,irete)

      return
 992  print *, ' idate =',idate,' is not acceptable, please check!!!'
      return
 1000 continue

      return
      end
