      program pgrads                                            
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   This program aasume to convert ensemble precipitation records CCCC
CCC   to the Grads indentified format.                              CCCC
CCC                                                                 CCCC
CCC        Updated:  09/04/96 By Yuejian Zhu                        CCCC
CCC        Updated:  05/12/00 By Yuejian Zhu                        CCCC
CCC        Updated:  05/30/06 By Yuejian Zhu                        CCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     parameter(jf=20000,len=20)
      parameter(jf=10512,len=32,mem=16)
      dimension f(jf),ff(10512,mem),pp(10512,mem),aa(10512)
      dimension ik(10),rk(10)
      dimension ipds(25),igds(22),iens(5)             
      dimension jpds(25),jgds(22),jens(5)             
      dimension kpds(25),kgds(22),kens(5)
      dimension kens2(mem),kens3(mem),iflds(mem)
      logical*1 lb(jf)
      character*255 cpgb,cpgi,cpge
      namelist /namin/ cpgb,cpgi,cpge
      data kens2/1,1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3/
      data kens3/1,2,1,2,3,4,5,6,7,8,9,10,11,12,13,14/
      data iflds/1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16/
      data ik/30,31,32,33,34,35,36,37,38,39/
      data rk/0.254,2.54,6.35,12.7,25.4,50.8,1.00,5.00,10.00,25.00/  
c
      read (5,namin)
      lpgb=len_trim(cpgb)
      lpgi=len_trim(cpgi)
      lpge=len_trim(cpge)
      print *, cpgb(1:lpgb)
      print *, cpgi(1:lpgi)
      print *, cpge(1:lpge)
      call baopenr(11,cpgb(1:lpgb),iretb)
      call baopenr(21,cpgi(1:lpgi),ireti)
      call baopen (51,cpge(1:lpge),irete)
c
      ncnt=0
      ff=0.0

      do n=1,len  

       icnt=0

       do m=1, mem
        j=n-1
        jpds=-1
        jgds=-1
        jens=-1
        jpds(23)=2
        jpds(11)=00
        jpds(14)=n-1
        jens(2)=kens2(m)
        jens(3)=kens3(m)
        call getgbe(11,21,jf,j,jpds,jgds,jens,
     &                         kf,k,kpds,kgds,kens,lb,f,iret)
        if(iret.eq.0) then
         icnt=icnt+1
         call grange(kf,lb,f,dmin,dmax)
         print '(i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &    n,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
         kpds(5)=iflds(m)
         kpds(13)=1
         kpds(14)=kpds(14)*3
         kpds(15)=kpds(15)*3
         do ii=1,10512
          ff(ii,m)=f(ii)
         enddo
         call putgbe(51,kf,kpds,kgds,kens,lb,f,iret)
ccc
         do ii = 1, 25
          ipds(ii)=kpds(ii)
         enddo
         do ii = 1, 22
          igds(ii)=kgds(ii)
         enddo
         do ii = 1, 5 
          iens(ii)=kens(ii)
         enddo 
        else
         ncnt=ncnt+1
         if ( ncnt.le.1 ) then
          print *,' n=',n,' iret=',iret
         endif
        endif
       enddo   ! do m=1, mem
c
       aa=0.0
       do ii = 1, 10512
        do m = 1, mem
         aa(ii) = aa(ii) + ff(ii,m)/float(icnt)
        enddo
       enddo
       ipds(5)=mem+1
       ipds(14)=(n-1)*3
       ipds(15)=n*3
       iens(2)=1
       iens(3)=1
       call putgbe(51,10512,ipds,igds,iens,lb,aa,iret)
ccc
       if (n.ge.2) then
        do k = 1,10 
         aa=0.0
         do ii = 1, 10512
          do m = 1, mem
           bb=(ff(ii,m)+pp(ii,m))
           if (bb.ge.rk(k)) then
            aa(ii) = aa(ii) + 1.0
           endif
          enddo
         enddo
         ipds(5)=ik(k)
         ipds(14)=(n-2)*3
         ipds(15)=(n+0)*3
         iens(2)=1
         iens(3)=1
         do ii = 1, 10512
          aa(ii) = aa(ii)*100.0/float(icnt)
          if (aa(ii).ge.99.0) then
           aa(ii) = 100.0
          endif
         enddo
         call putgbe(51,10512,ipds,igds,iens,lb,aa,iret)
        enddo
       endif

       do ii = 1, 10512
        do jj = 1, mem
         pp(ii,jj)=ff(ii,jj)
        enddo
       enddo

      enddo  ! do n=1,len

      call baclose(11,iretb)
      call baclose(21,ireti)
      call baclose(51,irete)
 
      stop    
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
