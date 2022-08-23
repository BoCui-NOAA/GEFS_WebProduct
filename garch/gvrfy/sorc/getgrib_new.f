      subroutine getanl(field,nd,ilv,iday,idate,cfile,ifh,icon)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: READ PRESSURE FILE ON GRIB FORMAT WITH GRID POINT VALUE C
C     CODE : FROTRAN 77 ON CRAY                                      C
C                                                                    C
C     INPUT: NEW unblocked GRIB I FORMAT PRESSURE FILE               C
C                                                                    C
C     OUTPUT:2.5*2.5 degree grid resolution                          C
C                                                                    C
C     LIB. : W3AI08                                                  C
C                                                                    C
C     assign -a filename -s unblocked         fort.11                C
C     generate grib index file:                                      C
C     /wd2/wd20/wd20mi/bin/windex gribfile indexfile                 C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
CCC-- FOR 2.5*2.5 DEGREE RESOLUTION idim = 144,jdim=73
ccc-- for 1.0*1.0 degree resolution idim = 360,jdim=181
c
      parameter(mdata=100000)
      dimension    kpds(25),kgds(22),jpds(25),jgds(22)
      dimension    data(mdata),field(145,73),fld(144,73)
      dimension    idate(4)
      logical      lb(mdata)
      character*80 cfile(2)
      character*28 asunitg,asuniti
      data         lupgb/11/,lupgi/12/
      nd=0
c
      write (asuniti,'(22Hassign -s unblocked u:i2)') lupgi
      call assign(asuniti,ier)
      write (asunitg,'(22Hassign -s unblocked u:i2)') lupgb
      call assign(asunitg,ier)
c
      open(unit=lupgb,file=cfile(1),form='UNFORMATTED',
     1     status='OLD',err=999)
      open(unit=lupgi,file=cfile(2),form='UNFORMATTED',
     1     status='OLD',err=999)
      if (ilv.eq.1) ilevel=1000
      if (ilv.eq.2) ilevel=850 
      if (ilv.eq.3) ilevel=700
      if (ilv.eq.4) ilevel=500
      if (ilv.eq.5) ilevel=400
      if (ilv.eq.6) ilevel=300
      if (ilv.eq.7) ilevel=250
      if (ilv.eq.8) ilevel=200
      if (ilv.eq.9) ilevel=150
      if (ilv.eq.10) ilevel=100
      if (ilv.eq.11) ilevel=70
      if (ilv.eq.12) ilevel=50 
      if (ilv.eq.1.and.icon.eq.-1) ilevel=500
      if (iday.eq.1) ifh=0
c     ifh=(iday - 1)*ih
c
      print *, 'ifh = ',ifh
      print *, 'lupgb=',cfile(1)                     
      print *, 'lupgi=',cfile(2)                     
c
      do n=1,100
      j=n-1
      jpds=-1
      jgds=-1
      jpds(5)=7
      jpds(6)=100
      jpds(7)=ilevel
      jpds(14)=ifh  
      if (n.eq.1) then
         j=-1
         print *, 'j = ',j
      endif
      call getgb(lupgb,lupgi,mdata,j,jpds,jgds,
     *           kf,k,kpds,kgds,lb,data,iret)
      if(iret.eq.0) then
            if (icon.eq.-1) then
               call fitdat(data,field,kgds(4),kgds(7),
     &                                kgds(5),kgds(8))
            endif
        nd = kpds(8)*10000+kpds(9)*100+kpds(10)
        idate(1) = kpds(11)
        idate(2) = kpds(9)
        idate(3) = kpds(10)
        idate(4) = kpds(8)
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
ccc
ccc   if icon = 1, ===> operational T126 or 1X1 resolution grib
ccc   if icon = 3, ===> parallel x  T126 or 1X1 resolution grib
ccc
      if ( icon.eq.1.or.icon.eq.3 ) then
       call i1d25d(data,fld)
       do i = 1, 73
         do j = 1, 144
            field(j,i) = fld(j,i)
         enddo
       enddo
       do i = 1, 73
             field(145,i) = field(1,i)
       enddo
      endif
ccc
ccc   if icon = 2. ===> operational T62 or 2.5X2.5 resolution grib
ccc   if icon = 4. ===> parallel w  T62 or 2.5X2.5 resolution grib
ccc
      if ( icon.eq.2.or.icon.eq.4 ) then
       icnt = 0
       do i = 1, 73
        do j = 1, 144
           icnt = icnt + 1
            field(j,i) = data(icnt)
        enddo
       enddo    
       do i = 1, 73
            field(145,i) = field(1,i)
       enddo
      endif
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     &       ' ndata  Maximun    Minimum')
  888 format (i4,2x,8i5,i8,2g12.4)
      return
  999 print *, ' we have a problem to open pgb file '
      close (lupgb)
      close (lupgi)
      return
      end
c
      subroutine grange(n,ld,d,dmin,dmax)
      logical ld
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
c
      subroutine i1d25d(glob,rout)
c
c       this subroutine will interpolate pressure grib[file
c       from 1 degree resolution to 2.5 degree resolution
c       which is using bilinear interpolation scheme.
c
c       coded by yuejian zhu   05/04/93
c
c
      parameter (imax=360,jmax=181)
      parameter (idim=144,jdim=73)
      dimension glob(*),band(360,181),rout(144,73)
      dimension xa(700),xb(700),ya(700),yb(700)
c
c
      dlxa = 360./float(imax)
      dlxb = 360./float(idim)
      dlya = 180./float(jmax-1)
      dlyb = 180./float(jdim-1)
      call setxy(xa,imax,ya,jmax,0.0,dlxa,0.0,dlya)
      call setxy(xb,idim,yb,jdim,0.0,dlxb,0.0,dlyb)
c
        ij = 0
        do 70 j = 1,jmax
        do 70 i = 1,imax
        ij = ij + 1
   70   band(i,j) = glob(ij)
        call intp2d(band,imax,jmax,xa,ya,rout,idim,jdim,xb,yb,0)
      return
      end
c
      subroutine setxy(x,nx,y,ny,xmn,dlx,ymn,dly)                      
      dimension x(nx),y(ny)                                          
      do 10 i = 1,nx                                                 
   10   x(i) = xmn + dlx*float(i-1)                                   
      if (ny.eq.0) return                                             
      do 20 j = 1,ny                                                   
   20   y(j) = ymn + dly*float(j-1)                                    
      return                                                           
      end                                                              
c
      subroutine intp2d(a,imx,imy,xa,ya,b,jmx,jmy,xb,yb,mflg)
c
c two dimensional linear interpolation.
c
      parameter(max=721,maxp=384*190)
      integer*2 mask(maxp)
      common /comask/ deflt,mask
      common /comwrk/ ierr,jerr,dxp(max),dyp(max),dxm(max),dym(max),
     1                iptr(max),jptr(max),wgt(4)
      dimension a(imx,*),b(jmx,*),xa(*),ya(*),xb(*),yb(*)
      call setptr(xa,imx,xb,jmx,iptr,dxp,dxm,ierr)
      call setptr(ya,imy,yb,jmy,jptr,dyp,dym,jerr)
      do 1 i = 1,4
  1   wgt(i) = 1.0
      if (mflg.eq.0) deflt = 0.0
      if (mflg.ge.0) then
        do 2 j = 1,jmy
        do 2 i = 1,jmx
  2     b(i,j) = deflt
      endif
c
      do 10 j = 1,jmy
        jm = jptr(j)
        if (jm.lt.0) goto 10
        jp = jm + 1
      do 20 i = 1,jmx
        im = iptr(i)
        if (im.lt.0) goto 20
        ip = im + 1
c       if (mflg.eq.1) call mskwgt(mask,imx,imy,im,ip,jm,jp,wgt)
        d1 = dxm(i)*dym(j)*wgt(1)
        d2 = dxm(i)*dyp(j)*wgt(2)
        d3 = dxp(i)*dym(j)*wgt(3)
        d4 = dxp(i)*dyp(j)*wgt(4)
        dd = d1 + d2 +d3 + d4
        if (dd.eq.0.0) goto 10
c       print *, a(im,jm),a(im,jp),a(ip,jm),a(jp,jp)
        b(i,j) = (d4*a(im,jm)+d3*a(im,jp)+d2*a(ip,jm)+d1*a(ip,jp))/dd
   20 continue
   10 continue
      return
      end
c
      subroutine setptr(x,m,y,n,iptr,dp,dm,ierr)
      dimension x(*),y(*),iptr(*),dp(*),dm(*)
      ierr = 0
      do 10 j = 1,n
        yl = y(j)
        if (yl.lt.x(1)) then
          ierr = ierr + 1
          iptr(j) = -1
          goto 10
        elseif (yl.gt.x(m)) then
          ierr = ierr + 1
          iptr(j) = -1
          goto 10
        endif
        do 20 i = 1,m-1
          if (yl.gt.x(i+1)) goto 20
          dm(j) = yl-x(i)
          dp(j) = x(i+1)-yl
          iptr(j) = i
          goto 10
  20    continue
  10  continue
      return
      end
c 
      subroutine fitdat(data,field,lat1,lat2,lon1,lon2)
      dimension data(*),field(145,73)
c
      lat1 = lat1 + 90000
      lat2 = lat2 + 90000
      lat1 = lat1/2500 + 1
      lat2 = lat2/2500 + 1
c
      if ( lon2.lt.lon1 ) then
      lon2 = lon1 + abs(lon2)
      endif
c
      if ( lon2.gt.lon1.and.lon1.lt.0 ) then
      lon2 = 360000 + lon2
      lon1 = 360000 + lon1
      endif
c
      lon1 = lon1/2500 + 1
      lon2 = lon2/2500 + 1
c
      inc = 1 
      if ( lat2.lt.lat1) then
      inc = -1
      endif
c
      print *, 'lat1=',lat1,'lat2=',lat2,'lon1=',lon1,'lon2=',lon2
      icnt = 1
      do ii=lat1,lat2,inc
       do jj=lon1,lon2
c       field(jj,73 - ii + 1)=data(icnt)
        field(jj,ii)=data(icnt)
        icnt=icnt + 1
        enddo
      enddo
      return
      end
c
