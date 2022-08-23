      subroutine getfst(fgrid,ndate,mdate,ifh,ilv,cfile,icon)
CCC
CCC   SUBROUTINE GETFST ---> named getfst_nmc.f
CCC   good for NCEP-ENSEMBLE after Feb. 23rd 1996 implememtation
CCC   ----- Yuejian Zhu (04/12/96)
CCC
c     parameter(jf=512*256)
      parameter(jf=20000)
      dimension fgrid(10512,17),f(jf)
      integer jpds(25),jgds(22),kpds(25),kgds(22)
      integer jens(5),kens(5)
      integer iens2(17),iens3(17),kfhens(17)
      logical lb(jf)
      character*80 cfile(2)
      character*28 asunitg,asuniti
      data iens2/ 1, 1, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3,
     *            1, 2, 3, 2, 3/
      data iens3/ 1, 2, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5,
     *            1, 1, 1, 2, 2/        
      data lupgb/11/,lupgi/21/
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
c
      fgrid=999999.0
      jfh=ifh+12
c
ccc   For operational MRF ( T126 resolution )
      m=1
c      if (ifh.le.168) then
       call conens(ifh,1,iens2(m),iens3(m),1,ifhens,0)
c      else
c      call conens(ifh,0,0,0,0,ifhens,0)
c      endif
      kfhens(m)=ifhens
ccc   For control run MRF ( T62 resolution )
      m=2
c      if (ifh.eq.0) then
c      call conens(ifh,0,0,0,0,ifhens,0)
c      else
       call conens(ifh,1,iens2(m),iens3(m),1,ifhens,0)
c      endif
      kfhens(m)=ifhens
ccc   For 5 pairs 00Z run ( t62 resolution )
      do m=3,12
       call conens(ifh,1,iens2(m),iens3(m),1,ifhens,0)
      kfhens(m)=ifhens
      enddo
ccc   For Avn run and 2 pairs T12Z run
      do m=13,17
       call conens(jfh,1,iens2(m),iens3(m),1,ifhens,0)
      kfhens(m)=ifhens
      enddo
c
      do n=1,652
      j=n-1
      jpds=-1
      jgds=-1
      jens=-1
      if (n.eq.1) then
      jpds(23)=2
      j=-1
      endif
      call nd2ymd(ndate,iyr,imo,idy,ihr)
      call nd2ymd(mdate,jyr,jmo,jdy,jhr)
      call getgbens(lupgb,lupgi,jf,j,jpds,jgds,jens,
     &                        kf,k,kpds,kgds,kens,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
        call conens(kpds(14),kens(1),kens(2),kens(3),kens(4),jfhens,0)
c       print '(i4,2x,7i5,5i5,i8,2g12.4)',
c    &   k,(kpds(i),i=5,11),kens,kf,dmin,dmax
c
      if (kpds(9)  .eq. imo .and.
     &    kpds(10) .eq. idy .and.
     &    kpds(11) .eq. ihr .and. 
     &    kpds(14) .eq. ifh ) then
c
      do m=1,12
       if (jfhens.eq.kfhens(m)) then
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
          do i = 1, 10512
             fgrid(i,m) = f(i)
          enddo
       endif
      enddo
      endif
c
      if (kpds(9)  .eq. jmo .and.
     &    kpds(10) .eq. jdy .and.
     &    kpds(11) .eq. jhr .and. 
     &    kpds(14) .eq. jfh ) then
c
      do m=13,17
       if (jfhens.eq.kfhens(m)) then
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
          do i = 1, 10512
             fgrid(i,m) = f(i)
          enddo
       endif
      enddo
      endif
c     else
c       print *,' n=',n,' iret=',iret
      endif                             ! if (iret.eq.0) then
      enddo                             ! do n=1,652
  888 format (i4,2x,8i5,3i5,i8,2g12.4)
      goto 998
  999 print *, 'There is problem to open grib file'
  998 continue
      close (lupgb)
      close (lupgi)
      return
      end
      subroutine conens(kfh,jen1,jen2,jen3,jen4,kfhens,jcon)
      if (jcon.eq.0) then
        kfhens=kfh*10000+jen1*1000+jen2*100+jen3*10+jen4
      else
        kfh=kfhens/10000
        jen1=(kfhens-kfh*10000)/1000
        jen2=(kfhens-kfh*10000-jen1*1000)/100
        jen3=(kfhens-kfh*10000-jen1*1000-jen2*100)/10
        jen4=(kfhens-kfh*10000-jen1*1000-jen2*100-jen3*10)
      endif
      return
      end
