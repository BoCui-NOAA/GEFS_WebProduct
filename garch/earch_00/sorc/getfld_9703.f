      program getfld                                            
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   This program will get pre-decided fields from daily ensemble  CCCC
CCC   forecasts.                                                    CCCC
CCC                                                                 CCCC
CCC   Programer: Yuejian Zhu (wd20yz)                               CCCC
CCC                                                                 CCCC
CCC   Updated:  03/17/97 By Yuejian Zhu                             CCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC
CCC order jpds(5) jpds(6) jpds(7)
CCC   1     7      100    1000    1000 mb geopotential height
CCC   2     7      100     700     700 mb geopotential height
CCC   3     7      100     500     500 mb geopotential height
CCC   4     7      100     250     250 mb geopotential height
CCC   5    33      105      10      10 meter u field
CCC   6    33      100     850     850 mb u field
CCC   7    33      100     500     500 mb u field
CCC   8    33      100     250     250 mb u field
CCC   9    34      105      10      10 meter v field
CCC  10    34      100     850     850 mb v field
CCC  11    34      100     500     500 mb v field
CCC  12    34      100     250     250 mb v field
CCC  13    11      105       2       2 meter temperature
CCC  14    11      100     850     850 mb temperature
CCC  15    52      100     700     700 mb relative humidity 
CCC  16    61(59)    1       0     sfc acumulation precipitation
CCC  17    59(61)    1       0     sfc precipitation rate
CCC  18     2      102       0     PRMSL-pressure reduced mean sea level
CCC  19    15      105       2       2 meter Maximum Temperature
CCC  20    16      105       2       2 meter Minimum Temperature
CCC
      parameter(jf=66000)
      dimension f(jf),fout(144,73)
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      dimension jpds5(100),jpds6(100),jpds7(100),iout(100)
      logical lb(jf)
      data jpds5/   7,  7,  7,  7, 33, 33, 33, 33, 34, 34,
     &             34, 34, 11, 11, 52, 61, 59,  2, 15, 16/
      data jpds6/ 100,100,100,100,105,100,100,100,105,100,
     &            100,100,105,100,100,  1,  1,102,105,105/
      data jpds7/1000,700,500,250, 10,850,500,250, 10,850,
     &            500,250,  2,850,700,  0,  0,  0,  2,  2/
      data iout /  51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
     &             61, 62, 63, 64, 65, 66, 66, 67, 68, 69/
c
      ncnt=0
      do n=1,20   
      j=0   
      jpds=-1
      jgds=-1
      jens=-1
ccc ....
ccc   We need to set jpds(23)=2 for extended message
ccc ....
      jpds(23)=2
      jpds(5)=jpds5(n)
      jpds(6)=jpds6(n)
      jpds(7)=jpds7(n)
      call getgbe(11,21,jf,j,jpds,jgds,jens,
     &                        kf,k,kpds,kgds,kens,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
        print '(2i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &   n,k,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
ccc ...
ccc   condition show here
ccc    1. every 12 hours for all fields
ccc    2. accumulation precipitation for each step ( 6 hours for AVN )
ccc    3. max and mim temperature for each step ( 6 hours for AVN )
ccc ...
       if (mod(kpds(14),12).eq.0.or.kpds(5).eq.61
     .                          .or.kpds(5).eq.15
     .                          .or.kpds(5).eq.16) then
ccc ....
ccc   check if it is high resolution ( 360*181 )
ccc ....
       if(kpds(3).eq.3.and.kf.eq.65160) then
        print *,'This is high resolution grid data, need intepolation'
        call i1d25d (f,fout)
         iijj=1
         do jj=1,73
          do ii=1,144
           f(iijj)=fout(ii,jj)
           iijj=iijj + 1
          enddo
         enddo
        kf      = 10512
        kpds(3) = 2         ! Grid Identification, 2=10512(144*73) points
        kpds(4) = 128       ! Flag for GDS or BMS, 128=10000000
        kgds(2) = 144
        kgds(3) = 73
        kgds(4) = 90000
        kgds(5) = 0
        kgds(6) = 128
        kgds(7) = -90000
        kgds(8) = -2500
        kgds(9) = 2500
        kgds(10)= 2500
       endif
        call putgbe(iout(n),kf,kpds,kgds,kens,lb,f,iret)
       endif                         
ccc
      else
        ncnt=ncnt+1
        if ( ncnt.le.1 ) then
        print *,' n=',n,' iret=',iret
        endif
      endif
      enddo
      stop    
      end
CCC
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
      subroutine i1d25d(glob,rout)
c       this subroutine will interpolate pressure grib[file
c       from 1 degree resolution to 2.5 degree resolution
c       which is using bilinear interpolation scheme.
c
c       Coded by Yuejian Zhu   05/04/93
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
c two dimensional linear interpolation.
c mflg(1,0) --- integer flag of (use,not.use) mask.
c  setup mask in caller and put into common block /comask/deflt,mask
c  mask(i,j) = (1,0) --- (use, void) data point (i,j)
c  use incl. lib. routine setmsk to setup /comask/
c  set default value for masked out points in deflt (r*4)
c  ierr,jerr --- no. of xb,yb points outside domain of xa and ya.
c
      subroutine intp2d(a,imx,imy,xa,ya,b,jmx,jmy,xb,yb,mflg)
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
        if (dd.eq.0.0) goto 20
c       print *, a(im,jm),a(im,jp),a(ip,jm),a(jp,jp)
        b(i,j) = (d4*a(im,jm)+d3*a(im,jp)+d2*a(ip,jm)+d1*a(ip,jp))/dd
   20 continue
   10 continue
      return
      end
c
      subroutine mskwgt(mask,imx,imy,im,ip,jm,jp,wgt)
      integer*2 mask(imx,imy)
      dimension wgt(4)
      wgt(1) = mask(ip,jp)
      wgt(2) = mask(ip,jm)
      wgt(3) = mask(im,jp)
      wgt(4) = mask(im,jm)
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

