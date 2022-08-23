      subroutine getfst(fgrid,ndate,ifh,ilv,cfile,icon)
      parameter(jf=10512)
      dimension fgrid(10512,52),f(jf)
      integer jpds(25),jgds(22),kpds(25),kgds(22)
      integer jens(5),kens(5)
      integer iens2(52),iens3(52)
      logical lb(jf)
      character*80 cfile(2)
      character*28 asunitg,asuniti
      data iens2/ 1, 1, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2,
     *      3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2,
     *      3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2/
      data iens3/ 1, 2, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7,
     *      8, 8, 9, 9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,
     *     17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25/
      data lupgb/11/,lupgi/21/
c
      write (asuniti,'(22Hassign -s unblocked u:i2)') lupgi
      call assign(asuniti,ier)
      write (asunitg,'(22Hassign -s unblocked u:i2)') lupgb
      call assign(asunitg,ier)
c
      open(unit=lupgb,file=cfile(1),form='UNFORMATTED',
     1     status='OLD')
      open(unit=lupgi,file=cfile(2),form='UNFORMATTED',
     1     status='OLD')
c
      fgrid=999999.0
c
      call nd2ymd(ndate,iyr,imo,idy,ihr)
c
      do n=1,1716
      j=n-1
      jpds=-1
      if (n.eq.1) then
c     jpds(23)=3  
      j=-1
      endif
c     jpds(7)=ilv
c     jpds(8)=iyr
c     jpds(9)=imo
c     jpds(10)=idy
c     jpds(11)=ihr
c     jpds(14)=ifh
      jgds=-1
      jens=-1
      call getgbe(lupgb,lupgi,jf,j,jpds,jgds,jens,
     &                        kf,k,kpds,kgds,kens,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
c       print '(i4,2x,7i5,5i5,i8,2g12.4)',
c    &   k,(kpds(i),i=5,11),kens,kf,dmin,dmax
c     else
c       print *,' n=',n,' iret=',iret
      endif
c
      if (kpds(8).eq.iyr.and.
     1    kpds(9).eq.imo.and.
     2    kpds(10).eq.idy.and.
     3    kpds(11).eq.ihr.and.
     4    kpds(14).eq.ifh) then
      do m=1,52
       if (kens(2).eq.iens2(m).and.kens(3).eq.iens3(m)) then
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
          do i = 1, 10512
             fgrid(i,m) = f(i)
          enddo
       endif
      enddo
      endif
      enddo
 888  format (i4,2x,8i5,3i5,i8,2g12.4)
      return
      end
