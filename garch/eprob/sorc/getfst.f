      subroutine getfst(nfcst,fgrid,fmrf,flrf,ndate,mdate,ifh,
     &cfile,icon)
CCC for NCEP after Feb. 23rd 1996     
      parameter(jf=144*73)
      dimension fgrid(10512,14),f(jf)
      dimension fmrf(10512),flrf(10512)
      integer jpds(25),jgds(22),kpds(25),kgds(22)
      integer jens(5),kens(5),kfhens(14)
      integer iens2(14),iens3(14)
      logical lb(jf)
      character*80 cfile(2)
      data iens2/ 2, 3, 2, 3, 2, 3, 2, 3, 2, 3,
     *            2, 3, 2, 3/
      data iens3/ 1, 1, 2, 2, 3, 3, 4, 4, 5, 5,
     *            1, 1, 2, 2/        
      data lupgb/11/,lupgi/21/
c
      open(unit=lupgb,file=cfile(1),form='UNFORMATTED',
     1     status='OLD')
      open(unit=lupgi,file=cfile(2),form='UNFORMATTED',
     1     status='OLD')
c
      fgrid=0.0
c
	  jpds=-1
	  jgds=-1
	  jens=-1
c
ccc   For operational MRF ( T126 resolution )
       call conens(ifh,1,1,1,1,ifhens,0)
       kfhmrf=ifhens
ccc   For control run MRF ( T62 resolution )
       call conens(ifh,1,1,2,1,ifhens,0)
       kfht62=ifhens
ccc   For 5 pairs 00Z run ( t62 resolution )
      do m=1,10
       call conens(ifh,1,iens2(m),iens3(m),1,ifhens,0)
       kfhens(m)=ifhens
      enddo
c
c     READING OTHER ENSEMBLE MEMBERS 
c
CCC 473 records for NCEP before, 562 records after
      do n=1,561
      j=n-1
      jpds(23)=2
      call nd2ymd(ndate,iyr,imo,idy,ihr)
      call getgbe(lupgb,lupgi,jf,j,jpds,jgds,jens,
     &                        kf,k,kpds,kgds,kens,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
        call conens(kpds(14),kens(1),kens(2),kens(3),kens(4),jfhens,0)
      else
        print *,' n=',n,' iret=',iret
      endif
c
      if (kpds(9)  .eq. imo .and.
     &    kpds(10) .eq. idy .and.
     &    kpds(11) .eq. ihr .and. 
     &    kpds(14) .eq. ifh ) then
c
       if (jfhens.eq.kfhmrf) then
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
          do i = 1, 10512
             fmrf(i) = f(i)
          enddo
       endif
       if (jfhens.eq.kfht62) then
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
          do i = 1, 10512
             flrf(i) = f(i)
          enddo
       endif
      do m=1,10
       if (jfhens.eq.kfhens(m)) then                          
        write(*,888)
     &  k,(kpds(i),i=5,11),kpds(14),(kens(i),i=1,3),kf,dmin,dmax
          do i = 1, 10512
             fgrid(i,m) = f(i)
          enddo
       endif
      enddo
      endif
      enddo
c
ccc   get 12Z forecast data
c
      do n=1, 561   
      j=n-1
          jpds=-1
          jgds=-1
          jens=-1
      jpds(23)=2
      jfh=ifh+12
      call nd2ymd(mdate,jyr,jmo,jdy,jhr)
      call getgbe(lupgb,lupgi,jf,j,jpds,jgds,jens,
     &                        kf,k,kpds,kgds,kens,lb,f,iret)
      if(iret.eq.0) then
        call grange(kf,lb,f,dmin,dmax)
      else
        print *,' n=',n,' iret=',iret
      endif
      if (kpds(9)  .eq. jmo .and.
     &    kpds(10) .eq. jdy .and.
     &    kpds(11) .eq. jhr .and. 
     &    kpds(14) .eq. jfh ) then
c
      do m=11,14
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
 887  format (i4,2x,8i5,i8,2g12.4)
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

