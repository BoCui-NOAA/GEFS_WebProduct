      subroutine get17y(cnh,csh,ifd,imon,ilev,ifh)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: READ PRESSURE FILE ON GRIB FORMAT WITH GRID POINT VALUE C
C     CODE : FROTRAN 77 ON CRAY                                      C
C                                                                    C
C     INPUT: NEW unblocked GRIB I FORMAT PRESSURE FILE               C
C                                                                    C
C     OUTPUT:2.5*2.5 degree grid resolution                          C
C                                                                    C
C     assign -a filename -s unblocked         fort.11                C
C     generate grib index file:                                      C
C     /wd2/wd20/wd20mi/bin/windex gribfile indexfile                 C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
CCC-- FOR 2.5*2.5 DEGREE RESOLUTION idim = 144,jdim=73
c
      parameter(mdata=50000)
      dimension kpds(25),kgds(22),jpds(25),jgds(22)
      dimension cnh(145,37),csh(145,37)
      dimension data(mdata),il(12)
      character*2  cim(12)
      character*42 cfile1  
      character*48 cfile2  
      character*28 asunitg,asuniti
      logical   lb(mdata)
      data      il/1000,850,700,500,400,300,250,200,150,100,75,50/
      data      cim/'01','02','03','04','05','06',
     .              '07','08','09','10','11','12'/
      data      lupgb/11/,lupgi/21/
      data      cfile1/'/reanl3/monthly/pgb.f00/clim/pgb.f00'/
      data      cfile2/'/reanl3/monthly/pgb.f00/clim/pgb.f00'/
c
      write (asuniti,'(22Hassign -s unblocked u:i2)') lupgi
      call assign(asuniti,ier)
      write (asunitg,'(22Hassign -s unblocked u:i2)') lupgb
      call assign(asunitg,ier)
c
      cfile1(37:38)=cim(imon)
      cfile2(37:38)=cim(imon)
      if (mod(ifh,24).eq.0) then
      cfile1(39:42)='.00Z'
      cfile2(39:48)='.00Z.index'
      else if (mod(ifh,24).eq.12) then
      cfile1(39:42)='.12Z'
      cfile2(39:48)='.12Z.index'
      else
      print *, ' Please specify ifh=12 or ifh=24, exit '
      call abort
      endif
      print *,  cfile1
      print *,  cfile2
      open(unit=lupgb,file=cfile1,form='UNFORMATTED',
     1     status='OLD',err=999)
      open(unit=lupgi,file=cfile2,form='UNFORMATTED',
     1     status='OLD',err=999)
      ilevel = il(ilev)
      print *, 'Read 17 years CDAS/Reanl Climatology data  '
      print *, 'Month = ',imon,' lupgb = ',lupgb,' lupgi = ',lupgi
      do n=1,100
      j=n-1
      jpds=-1
      jgds=-1
      jpds(5)=ifd
      jpds(6)=100
      jpds(7)=ilevel
      jpds(9)=imon
      if (n.eq.1) then
      j=-1
      endif
      call getgb(lupgb,lupgi,mdata,j,jpds,jgds,
     *           kf,k,kpds,kgds,lb,data,iret)
      if(iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
        write(*,886)
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),kf,dmin,dmax
        goto 998
      endif
       goto 999
      enddo
c
  998 continue
       icnt = 0
       do i = 1, 37
        do j = 1, 144
           icnt = icnt + 1
           jcnt = icnt + 5184
           cnh(j,38-i) = data(icnt)
           csh(j,i)    = data(jcnt)
        enddo
       enddo    
       do i = 1, 37
           cnh(145,i) = cnh(1,i)      
           csh(145,i) = csh(1,i)      
       enddo
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     &       ' ndata  Maximun    Minimum')
  888 format (i4,2x,8i5,i8,2g12.4)
      return
  999 print *, ' we have a problem to open pgb file '
      close (lupgb)
      close (lupgi)
      return
      end
