      subroutine getanl(agrid,mdate,cfile,kp5,kp6,kp7,icon)
      parameter(jf=512*256,len=144*73)
      dimension agrid(len),f(jf)
      integer jpds(25),jgds(22),kpds(25),kgds(22)
      integer jens(5),kens(5)
      logical lb(jf)
      character*28 asunitg,asuniti
      character*80 cfile(2)
      data lupgb/12/,lupgi/22/
c
      write (asuniti,'(22Hassign -s unblocked u:i2)') lupgi
      call assign(asuniti,ier)
      write (asunitg,'(22Hassign -s unblocked u:i2)') lupgb
      call assign(asunitg,ier)
c
      agrid=999999.0
      open(unit=lupgb,file=cfile(1),form='UNFORMATTED',
     1     status='OLD',err=999)
      open(unit=lupgi,file=cfile(2),form='UNFORMATTED',
     1     status='OLD',err=999)
c
      call nd2ymd(mdate,iyr,imo,idy,ihr)
c
      do n=1,1000
      j=n-1
      jpds=-1
      jgds=-1
      jens=-1
      jpds(5)=kp5
      jpds(6)=kp6
      jpds(7)=kp7    
      jpds(8)=iyr    
      jpds(9)=imo
      jpds(10)=idy
      jpds(11)=ihr
      jpds(14)=0   
c
c     call getgb(lupgb,lupgi,jf,j,jpds,jgds,
c    *           kf,k,kpds,kgds,lb,f,iret)
      call getgbe(lupgb,lupgi,jf,j,jpds,jgds,jens,
     &                        kf,k,kpds,kgds,kens,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
c       print '(i4,2x,7i5,5i5,i8,2g12.4)',
c    &   k,(kpds(i),i=5,11),kens,kf,dmin,dmax
        write(*,886)
        write(*,887)
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
          do i = 1, 10512
             agrid(i) = f(i)
          enddo
        goto 998
c     else
c       print *,' n=',n,' iret=',iret
      endif
c
c     print *, kpds(9),kpds(10),kpds(11),kpds(14),kpds(5),
c    &         kpds(6),kpds(7)
c     print *, imo,idy,ihr,ilevel
c     if (kpds(9)  .eq. imo .and.
c    &    kpds(10) .eq. idy .and.
c    &    kpds(11) .eq. ihr .and. 
c    &    kpds(14) .eq. 0   .and. 
c    &    kpds(5)  .eq. 7   .and. 
c    &    kpds(6)  .eq. 100 .and. 
c    &    kpds(7)  .eq. ilevel ) then
c
c       write(*,886)
c       write(*,887)
c       write(*,888)
c    &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
c         do i = 1, 10512
c            agrid(i) = f(i)
c         enddo
c      endif
      enddo
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14 ens1',
     &       ' ens2 ens3  ndata  Maximun    Minimum')
  887 format('  --------------------------------------------------',
     &       '-------------------------------------')
  888 format (i4,2x,8i5,3i5,i8,2g12.4)
      goto 998
  999 print *, 'There is a problem to open grib file '
  998 continue
      close (lupgb)
      close (lupgi)
      return
      end
