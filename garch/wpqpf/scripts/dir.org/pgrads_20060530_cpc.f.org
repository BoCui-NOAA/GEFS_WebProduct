      program pgrads                                            
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   This program aasume to convert ensemble precipitation records CCCC
CCC   to the Grads indentified format.                              CCCC
CCC                                                                 CCCC
CCC   FOR CPC only:                                                 CCCC
CCC   1. Calculate PQPF for 1-5 days                                CCCC
CCC   2. Calculate PQPF for 6-10 days                               CCCC
CCC   3. Calculate PQPF for 8-14 days ( week two )                  CCCC
CCC                                                                 CCCC
CCC        Updated:  11/17/97 By Yuejian Zhu                        CCCC
CCC        Updated:  05/11/00 By Yuejian Zhu                        CCCC
CCC     adding 84-120 hrs forecast for HPC of medium forecast       CCCC
CCC        Updated:  01/23/01 By Yuejian Zhu                        CCCC
CCC    Corrected definition for forecast periods                    CCCC
CCC        Based on T00Z forecast:                                  CCCC
CCC         1 -   days forecast ( 12 - 36 hours, n = 2- 3 )         CCCC
CCC         2 -   days forecast ( 36 - 60 hours, n = 4- 5 )         CCCC
CCC         3 -   days forecast ( 60 - 84 hours, n = 6- 7 )         CCCC
CCC         4 -   days forecast ( 84 -108 hours, n = 8- 9 )         CCCC
CCC         5 -   days forecast (108 -132 hours, n =10-11 )         CCCC
CCC         1 - 5 days forecast ( 12 -132 hours, n = 2-11 )         CCCC
CCC         6 -10 days forecast (132 -252 hours, n =12-21 )         CCCC
CCC         8 -14 days forecast (180 -348 hours, n =16-29 )         CCCC
CCC         4 - 5 days forecast ( 84 -132 hours, n = 8-11 )         CCCC
CCC        therefore:                                               CCCC
CCC         n = 1   ---> 00-12 hours forecast of T00Z               CCCC
CCC         n = 2   ---> 12-24 hours forecast of T00Z               CCCC
CCC        Updated:  02/12/2001 by Yuejian Zhu                      CCCC
CCC        Updated:  05/30/2006 by Yuejian Zhu                      CCCC
CCC                                                                 CCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(jf=10512,len=28,mem=16)
      dimension f(jf),ff(10512,mem),aa(10512)
      dimension f1(10512,mem),f2(10512,mem),f3(10512,mem),f4(10512,mem)
      dimension ik(4),rk(4),rrk(4)
      dimension ipds(25),igds(22),iens(5)             
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      dimension kens2(mem),kens3(mem)
      logical*1 lb(jf)
      character*255 cpgb,cpgi,cpge
      namelist /namin/ cpgb,cpgi,cpge
      data kens2/1,1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3/
      data kens3/1,2,1,2,3,4,5,6,7,8,9,10,11,12,13,14/           
      data ik/19,20,21,22/
      data rk/12.7,25.4,50.8,101.6/ 
      data rrk/2.54,6.35,12.7,25.4/ 
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
       do m  = 1,mem
        j    = n-1
        jpds = -1
        jgds = -1
        jens = -1
        jpds(23) = 2
        jpds(11) = 00
        jpds(14) = n-1
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
ccc...     the n here represents T12Z not T00Z
ccc...     1- 5 days forecast (n =  2-11 for T00Z, 3-12 for T12Z) 
          if (n.gt.2.and.n.le.12) then
           f1(ii,m) = f1(ii,m) + f(ii)
          endif
ccc...     6-10 days forecast (n = 12-21 for T00Z,13-22 for T12Z) 
          if (n.gt.12.and.n.le.22) then
           f2(ii,m) = f2(ii,m) + f(ii)
          endif
ccc...     8-14 days forecast (n = 16-29 for T00Z,17-30 for T12Z) 
          if (n.gt.16.and.n.le.30) then
           f3(ii,m) = f3(ii,m) + f(ii)
          endif
ccc...     4- 5 days forecast (n =  8-11 for T00Z, 9-12 for T12Z) 
          if (n.gt.8.and.n.le.12) then
           f4(ii,m) = f4(ii,m) + f(ii)
          endif
         enddo
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
       enddo ! m=1,16
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
        do m = 1, mem
         bb=f1(ii,m)
         if (bb.ge.rk(k)) then
          aa(ii) = aa(ii) + 100.0/float(mem)
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
        do m = 1, mem
         bb=f2(ii,m)
         if (bb.ge.rk(k)) then
          aa(ii) = aa(ii) + 100.0/float(mem)
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
        do m = 1, mem
         bb=f3(ii,m)
         if (bb.ge.rk(k)) then
          aa(ii) = aa(ii) + 100.0/float(mem)
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
       do ii = 1, 10512
        do m = 1, mem
         bb=f4(ii,m)
         if (bb.ge.rrk(k)) then
          aa(ii) = aa(ii) + 100.0/float(mem)
         endif
        enddo
       enddo
Ccc...
Ccc... the corrected setting for ipds(14) is 24
Ccc... the corrected setting for ipds(15) is 36
Ccc...  but it will conflict with 1-5 days forecast
Ccc...  because GrADs only set the ending time
Ccc...  All the calculation is correctted,
Ccc...  but with personal setting ( need understood )
Ccc...   --- Yuejian Zhu (02/12/2001)
       ipds(5)  = ik(k)
       ipds(13) = 1
       ipds(14) = 21 
       ipds(15) = 33  
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
