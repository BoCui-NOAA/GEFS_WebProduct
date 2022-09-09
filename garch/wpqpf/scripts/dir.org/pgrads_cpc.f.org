      program pgrads                                            
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   This program aasume to convert ensemble precipitation records CCCC
CCC   to the Grads indentified format.                              CCCC
CCC                                                                 CCCC
CCC   FOR CPC only:                                                 CCCC
CCC   1. Calculate EPPF for 1-5 days                                CCCC
CCC   2. Calculate EPPF for 6-10 days                               CCCC
CCC   3. Calculate EPPF for 8-14 days ( week two )                  CCCC
CCC                                                                 CCCC
CCC        Updated:  11/17/97 By Yuejian Zhu                        CCCC
CCC        Updated:  05/11/00 By Yuejian Zhu                        CCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(jf=10512,len=28)
      dimension f(jf),ff(10512,17),aa(10512)
      dimension f1(10512,17),f2(10512,17),f3(10512,17)
      dimension ik(4),rk(4)
      dimension ipds(25),igds(22),iens(5)             
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      dimension kens2(17),kens3(17)
      logical*1 lb(jf)
      character*80 cpgb,cpgi,cpge
      namelist /namin/ cpgb,cpgi,cpge
      data kens2/1,1,2,3,2,3,2,3,2,3,2,3,1,2,3,2,3/
      data kens3/1,2,1,1,2,2,3,3,4,4,5,5,1,1,1,2,2/
      data ik/19,20,21,22/
      data rk/12.7,25.4,50.8,101.6/ 
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

      ncnt   = 0
      f1 = 0.0
      f2 = 0.0
      f3 = 0.0
      do n   = 1,len  
       do m  = 1,17
        j    = n-1
        jpds = -1
        jgds = -1
        jens = -1
        jpds(23) = 2
        if (m.le.12) then
         jpds(11) = 00
         jpds(14) = n-1
        else
         jpds(11) = 12
         jpds(14) = n
        endif
        jens(2) = kens2(m)
        jens(3) = kens3(m)
        call getgbe(11,21,jf,j,jpds,jgds,jens,
     &                         kf,k,kpds,kgds,kens,lb,f,iret)
        if(iret.eq.0) then
         call grange(kf,lb,f,dmin,dmax)
         print '(i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &    n,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
c
         do ii=1,10512
          if (n.gt.2.and.n.le.12) then
           f1(ii,m) = f1(ii,m) + f(ii)
          endif
          if (n.gt.12.and.n.le.22) then
           f2(ii,m) = f2(ii,m) + f(ii)
          endif
          if (n.gt.16.and.n.le.30) then
           f3(ii,m) = f3(ii,m) + f(ii)
          endif
         enddo
         if (m.le.12) then
          do ii = 1, 25
           ipds(ii)=kpds(ii)
          enddo
          do ii = 1, 22
           igds(ii)=kgds(ii)
          enddo
          do ii = 1, 5 
           iens(ii)=kens(ii)
          enddo 
         endif
        else
         ncnt=ncnt+1
         if ( ncnt.le.1 ) then
         print *,' n=',n,' iret=',iret
         endif
        endif
       enddo ! m=1,17
      enddo  ! n=1,len 
ccc
ccc   kpds(5) is not real to the actual field
ccc   kpds(14) is not real to the actual field
ccc   kpds(15) is not real to the actual field
ccc   only for grads purpose
ccc
      aa=0.0
      do k = 1, 4
       do ii = 1, 10512
        do m = 1, 17
         bb=f1(ii,m)
         if (bb.ge.rk(k)) then
          aa(ii) = aa(ii) + 100.0/17.0
         endif
        enddo
       enddo
       ipds(5)  = ik(k)
       ipds(13) = 1
       ipds(14) = 6
       ipds(15) = 36
       iens(2)  = 1
       iens(3)  = 1
       call putgbe(51,10512,ipds,igds,iens,lb,aa,iret)
       aa = 0.0
       do ii = 1, 10512
        do m = 1, 17
         bb=f2(ii,m)
         if (bb.ge.rk(k)) then
          aa(ii) = aa(ii) + 100.0/17.0
         endif
        enddo
       enddo
       ipds(5)  = ik(k)
       ipds(13) = 1
       ipds(14) = 36 
       ipds(15) = 66 
       iens(2)  = 1
       iens(3)  = 1
       call putgbe(51,10512,ipds,igds,iens,lb,aa,iret)
       aa = 0.0
       do ii = 1, 10512
        do m = 1, 17
         bb=f3(ii,m)
         if (bb.ge.rk(k)) then
          aa(ii) = aa(ii) + 100.0/17.0
         endif
        enddo
       enddo
       ipds(5)  = ik(k)
       ipds(13) = 1
       ipds(14) = 48 
       ipds(15) = 90  
       iens(2)  = 1
       iens(3)  = 1
       call putgbe(51,10512,ipds,igds,iens,lb,aa,iret)
       aa = 0.0
      enddo ! k = 1, 4
c
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
