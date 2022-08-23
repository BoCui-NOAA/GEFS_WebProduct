      program EQPF                                              
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   EQPF - Ensemble Based  Quatitative Precipitation Forecast     CCCC
CCC                                                                 CCCC
CCC   This program will calculate the probability distribution for  CCCC
CCC   ensemble precipitation forecast based on the assumation of    CCCC
CCC                                                                 CCCC
CCC      1. GEV 3-parameter distribution                            CCCC
CCC      2. PE3 3-parameter distribution                            CCCC
CCC                                                                 CCCC
CCC    By using:                                                    CCCC
CCC      L-Moments method estimation.                               CCCC
CCC                                                                 CCCC
CCC                                                                 CCCC
CCC                                                                 CCCC
CCC    Proggram: Yuejian Zhu 02/26/1999                             CCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
ccc
ccc   Parameters:
ccc     1. jf--->    model resolution or total grid points ( default 10512 )
ccc     2. istd->    numbers of criterian of probability
ccc     3. iem-->    numbers of ensember members
ccc     4. idays     the days of forecasts ( end of every 12 hours )
ccc
C--------+---------+---------+---------+---------+---------+---------+--
      parameter(jf=10512,iem=17,ihdays=33)
      double precision fin(iem)
      double precision fmom(3),opara(3)
      dimension fr(jf),fm(jf)
      dimension f(jf),ff(jf,iem),pp(jf,iem)
      dimension ipds(25),igds(22),iens(5)             
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      dimension kens2(iem),kens3(iem)
      character*80 gbf,gbi,gbo,gbm
      logical lb(jf)
      namelist /namin/ iask
      data kens2/1,1,2,3,2,3,2,3,2,3,2,3,1,2,3,2,3/
      data kens3/1,2,1,1,2,2,3,3,4,4,5,5,1,1,1,2,2/
c
      read (5,namin)
      write(6,namin)
      ncnt   = 0
      gbf='/ptmp/wx20yz/eqpf/precip.dat'
      gbi='/ptmp/wx20yz/eqpf/precip.ind'
      gbo='/ptmp/wx20yz/eqpf/precip.out'
      lgbf=len_trim(gbf)
      lgbi=len_trim(gbi)
      lgbo=len_trim(gbo)
      call baopenr(11,gbf(1:lgbf),iretba)
      call baopenr(21,gbi(1:lgbi),iretba)
      call baopen(51,gbo(1:lgbo),iretba)
ccc
ccc   Step 1: read in the data on GRIB 2 ( 144*73 ) globally
ccc
      do n = 1, ihdays       ! ihdays = # of half days - 1
       do m = 1, iem         ! iem = # of ensemble ( default = 17 )
        j    = n-1
        jpds = -1
        jgds = -1
        jens = -1
        jpds(23) = 2
ccc
ccc     first 12 members are T00Z forecast, next 5 member are T12Z
ccc
        if (m.le.12) then
         jpds(11) = 00
         jpds(14) = n-1
        else
         jpds(11) = 12
         jpds(14) = n
        endif
        jens(2)   = kens2(m)
        jens(3)   = kens3(m)
        call getgbe(11,21,jf,j,jpds,jgds,jens,
     &                kf,k,kpds,kgds,kens,lb,f,iret)
        if (iret.eq.0) then
         call grange(kf,lb,f,dmin,dmax)
         print '(i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &    n,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
         kpds(13) = 1
         kpds(14) = kpds(14)*12
         kpds(15) = kpds(15)*12
         do ii = 1, 10512
          ff(ii,m) = f(ii)
         enddo
ccc
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
        endif  ! if (iret.eq.0)
       enddo   ! for m loop
ccc
ccc    Step 2: to calculate the probability of inverse of probability
ccc    
ccc    n=1,  0-12 hours period
ccc    n=2, 12-24 hours period
ccc    n=3, 24-36 hours period
ccc    ......
ccc
ccc    when applied if (n.ge.3.and.mod(n-1,2).eq.0)
ccc     means we start to culculate 12-36 hours period probability.
ccc
       if (n.ge.3.and.mod(n-1,2).eq.0) then
c      if (n.eq.iask) then
c
        izero= 0
        isame= 0
c
        do ii = 1, jf    
ccc
ccc      jcnt --- acount # of zero values
ccc      kcnt --- acount # of same values
ccc
         jcnt = 0
         kcnt = 0
c
         do jj = 1, iem
          fin(jj) = ff(ii,jj) + pp(ii,jj)
          if (fin(jj).eq.0.0) then
           jcnt = jcnt + 1
          elseif (jj.ge.2) then
           if (fin(jj).eq.fin(jj-1)) then
            kcnt = kcnt + 1
           endif
          endif
         enddo    ! for jj loop
c
C--------+---------+---------+---------+---------+---------+---------+---------+
ccc    There are two special situations:
ccc      1. all values are zero, probability = 0%
ccc      2. all values are the same ( none zero ) probability 0% or 100%
ccc
         if (ii.eq.5000) write (*,991) ii,fin
         amt = 1.0
         if (jcnt.eq.iem) then
          print *, ii,' all value are zero, fp = 0.0'
          izero = izero + 1
          fr(ii) = 0.0
          fm(ii) = 0.0
         elseif (kcnt.eq.iem-1) then
          print *, 'ii=',ii,' all value are same = ',fin(1)
          isame = isame + 1
          fr(ii) = fin(1)
          fm(ii) = fin(1)
         else
ccc
ccc       Using L-moment ratios and PE3 method
ccc
C--------+---------+---------+---------+---------+---------+---------+---------+
c         print *, 'Calculates the L-moment ratios, by prob. weighted'
c         call samlmr(fin,iem,fmom,3,-0.35D0,0.0D0)
c         print *, 'Calculates the L-moment ratios, by more directed method'
c         call samlmu(fin,iem,fmom,3)
          fmom = 0.0
          opara= 0.0
          call sort(fin,iem)
c         call samlmu(fin,iem,fmom,3)
          call samlmr(fin,iem,fmom,3,-0.35D0,0.0D0)
          call ecpqpf(fmom,prob,n)
          call pelpe3(fmom,opara)
          fr(ii)=quape3(1.0-prob,opara)
          fm(ii)=quape3(0.5,opara)
          if (ii.eq.5000) write(*,992) ii,fmom,fr(ii),fm(ii)
         endif 
        enddo       ! for ii = jf loop
        do ii = 1, 10512
         f(ii) = ff(ii,1)+pp(ii,1)
        enddo
ccc
ccc     Step 3: write the information
ccc
         ipds(5)  = 59         !: OCT 9
         ipds(14) = (n-2)*12
         ipds(15) = (n  )*12
         ipds(16) = 3          !: or 10
         ipds(22) = 6
c        call putgb(51,jf,ipds,igds,lb,f,iret)
c        ipds(5)  = 60         !: OCT 9
c        call putgb(51,jf,ipds,igds,lb,fm,iret)
c        ipds(5)  = 61         !: OCT 9
         call putgb(51,jf,ipds,igds,lb,fr,iret)
ccc
       endif    ! if (n.ge.3)
       pp = ff
      enddo     ! for n loop
 991  format (i5,2x,17(f4.1))
 992  format (i5,2x,5(f8.3))
      stop    
      end
C--------+---------+---------+---------+---------+---------+---------+---------+
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
C--------+---------+---------+---------+---------+---------+---------+---------+
      subroutine ecpqpf(fm,p,nt)
      dimension fm(3)
      dimension c(9,15),d(10)
      data d/ 0.0, 0.2, 2.0, 5.0,10.0,15.0,25.0,35.0,50.0,75.0/
CCC following data are based on 9798w
      data c/ 0.9, 0.8, 0.7, 0.7, 0.6, 0.5, 0.4, 0.2, 0.1,
     2        0.9, 0.8, 0.7, 0.6, 0.6, 0.4, 0.3, 0.2, 0.1,
     3        0.9, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.2, 0.1,
     4        0.9, 0.6, 0.5, 0.4, 0.4, 0.3, 0.2, 0.1, 0.1,
     5        0.8, 0.6, 0.5, 0.4, 0.3, 0.2, 0.2, 0.1, 0.1,
     6        0.8, 0.5, 0.4, 0.3, 0.3, 0.2, 0.2, 0.1, 0.1,
     7        0.8, 0.5, 0.5, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1,
     8        0.7, 0.5, 0.3, 0.3, 0.2, 0.1, 0.1, 0.1, 0.1,
     +        0.7, 0.5, 0.4, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1,
     +        0.7, 0.4, 0.3, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1,
     1        0.7, 0.4, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1,
     2        0.7, 0.4, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1,
     3        0.7, 0.4, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1,
     4        0.7, 0.4, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1,
     5        0.7, 0.4, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1/
c     data c/ 0.9, 0.7, 0.7, 0.7, 0.3, 0.3, 0.1, 0.1, 0.1,
c    2        0.9, 0.7, 0.7, 0.5, 0.5, 0.3, 0.1, 0.1, 0.1,
c    3        0.9, 0.7, 0.5, 0.5, 0.3, 0.1, 0.1, 0.1, 0.1,
c    4        0.7, 0.5, 0.5, 0.3, 0.3, 0.1, 0.1, 0.1, 0.1,
c    5        0.7, 0.7, 0.5, 0.3, 0.3, 0.1, 0.1, 0.1, 0.1,
c    6        0.7, 0.5, 0.3, 0.5, 0.3, 0.3, 0.1, 0.1, 0.1,
c    7        0.7, 0.5, 0.5, 0.3, 0.1, 0.1, 0.1, 0.1, 0.1,
c    8        0.7, 0.5, 0.5, 0.3, 0.1, 0.1, 0.1, 0.1, 0.1,
c    +        0.7, 0.7, 0.7, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3,
c    +        0.7, 0.7, 0.7, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3,
c    1        0.7, 0.7, 0.7, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3,
c    2        0.7, 0.7, 0.7, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3,
c    3        0.7, 0.7, 0.7, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3,
c    4        0.7, 0.7, 0.7, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3,
c    5        0.7, 0.7, 0.7, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3/
      ltime=(nt-1)/2
      do i = 1, 9
       if (fm(1).gt.d(i).and.fm(1).le.d(i+1)) p=c(i,ltime)
      enddo
      return
      end
