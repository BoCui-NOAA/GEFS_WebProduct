      program PQPF                                              
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   PQPF - Probabilitistic Quatitative Precipitation Forecast     CCCC
CCC                                                                 CCCC
CCC   This program will calculate the probability distribution for  CCCC
CCC   ensemble precipitation forecast based on the assumation of    CCCC
CCC   Gamma 3-parameter distribution.                               CCCC
CCC                                                                 CCCC
CCC        Updated:  01/25/98 By Yuejian Zhu                        CCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
ccc
ccc   Parameters:
ccc     1. jf--->    model resolution or total grid points ( default 10512 )
ccc     2. istd->    numbers of criterian of probability
ccc     3. iem-->    numbers of ensember members
ccc     4. idays     the days of forecasts ( end of every 12 hours )
ccc
C--------+---------+---------+---------+---------+---------+---------+---------+
c     parameter(jf=10512,istd=6,iem=17,idays=15)
c     parameter(jf=10512,istd=1,iem=17,idays=32)
      parameter(jf=10512,istd=10,iem=17,idays=32)
      dimension f(jf),ff(jf,iem),pp(jf,iem),fin(iem)
      dimension ik(istd),rk(istd),fp(jf,istd)
      dimension ipds(25),igds(22),iens(5)             
      dimension jpds(25),jgds(22),jens(5)             
      dimension Kpds(25),kgds(22),kens(5)
      dimension kens2(iem),kens3(iem),iflds(iem)
      dimension iprob(2),xprob(2),iclust(16),imembr(80)
      external  gamdf
      logical lb(jf)
      data kens2/1,1,2,3,2,3,2,3,2,3,2,3,1,2,3,2,3/
      data kens3/1,2,1,1,2,2,3,3,4,4,5,5,1,1,1,2,2/
      data iflds/1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17/
      data ik/19,20,21,22,23,24,25,26,27,28/
      data rk/0.254,1.00,2.54,5.00,6.35,10.00,12.7,25.4,50.8/
c     data rk/0.254,2.54,6.35,12.7,25.4,50.8,1.00,5.00,10.00,25.00/
c
      ncnt   = 0
      iprob  = 0
      xprob  = 0.0
      iclust = 0
      imembr = 0
ccc
      do n = 1, idays
c
       do m = 1, iem
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
        jens(2)   = kens2(m)
        jens(3)   = kens3(m)
        call getgbe(11,21,jf,j,jpds,jgds,jens,
     &                kf,k,kpds,kgds,kens,lb,f,iret)
        if (iret.eq.0) then
         call grange(kf,lb,f,dmin,dmax)
         print '(i4,i3,2i5,4i3,i4,4i2,i4,i7,2g12.4)',
     &    n,(kpds(i),i=5,11),kpds(14),kens,kf,dmin,dmax
         kpds(5)  = iflds(m)
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
c
       if (n.ge.2) then
        izero= 0
        isame= 0
c
        do ii = 1, jf    
         jcnt = 0
         kcnt = 0
c
         do jj = 1, iem
          fin(jj)=ff(ii,jj)+pp(ii,jj)
          if (fin(jj).eq.0.0) then
           jcnt = jcnt + 1
          elseif (jj.ge.2) then
           if (fin(jj).eq.fin(jj-1)) then
            kcnt = kcnt + 1
           endif
          endif
         enddo    ! for jj loop
c
         rlam = 0.0
         falph= 0.0
         beta = 0.0
         gamma= 0.0
         rmu  = 0.0
         std  = 0.0
C--------+---------+---------+---------+---------+---------+---------+---------+
ccc    There are two special situations:
ccc      1. all values are zero, probability = 0%
ccc      2. all values are the same ( none zero ) probability 0% or 100%
ccc
         if (jcnt.eq.iem) then
c         print *, ii,' all value are zero, fp = 0.0'
          izero = izero + 1
c         do kk = 1, istd
          do kk = 1, 9    
           fp(ii,kk) = 0.0
          enddo
         elseif (kcnt.eq.iem-1) then
c         print *, 'ii=',ii,' all value are same = ',fin(1)
          isame = isame + 1
          do kk = 1, istd
           if (fin(1).ge.rk(kk)) then
            fp(ii,kk) = 1.00
           else
            fp(ii,kk) = 0.00
           endif
          enddo
         else
ccc
ccc   jjj=1 to calculate the simplified probability
ccc   jjj=0 to calculate the 3-parameter probability
ccc
          icnt = 0
          jjj  = 0
          if ( jjj.eq.1 ) then
           do kk = 1, istd
            rstd = rk(kk)
            do jj=1,iem
             if (fin(jj).ge.rstd) then
              icnt = icnt + 1
             endif
            enddo
            fp(ii,kk) = float(icnt)/float(iem)
           enddo
          else
           call mlpert(fin,iem,falph,beta,gamma,rlam,rmu,rnu,stde)
           if (beta.eq.0.0) then
            beta = 0.00001
           endif
c
           do kk = 1, istd
            rstd = rk(kk)
            if (rmu.ge.0.0) then
             gab = ( rstd - gamma)/beta
            else
             gab = (-rstd - gamma)/beta
            endif
ccc
ccc    case 1   beta >0 mu >0    probability exceeding = 1.0 - p
ccc    case 2   beta >0 mu <0    probability exceeding = p
ccc    case 3   beta <0 mu >0    probability exceeding = p
ccc    case 4   beta <0 mu <0    probability exceeding = 1.0 - p
ccc
            if (rmu.lt.0.0) then
             fp(ii,kk) = gamdf(gab,falph)
             if (beta.lt.0.0) then
              fp(ii,kk) = 1.0 - gamdf(gab,falph)
             endif
            else  
             fp(ii,kk) = 1.0 - gamdf(gab,falph)
             if (beta.lt.0.0) then
              fp(ii,kk) = gamdf(gab,falph)
             endif
            endif
c           print '(i5,17f4.1)',ii,(fin(iii),iii=1,17)
c           print '(i5,6f8.2,3x,f4.2)',ii,
c    &            rlam,falph,beta,gamma,rmu,stde,fp(ii,kk)
            if (fp(ii,kk).gt.1.0) then
             print '(i5,17f4.1)',ii,(fin(iii),iii=1,17)
             print '(i5,6f8.2,3x,f4.2)',ii,
     &             rlam,falph,beta,gamma,rmu,stde,fp(ii,kk)
C--------+---------+---------+---------+---------+---------+---------+---------+
             print *, 'fp=',fp(ii,kk),' is incorrect, please check!!!'
            endif      
            fp(ii,kk) = fp(ii,kk)*100.00
           enddo     ! for kk loop
          endif      ! if ( jjj.eq.1) then
         endif       ! if (jcnt.eq.iem) then
        enddo       ! for ii loop
ccc
        do kk = 1, istd
         ipds(5)  = 191        !: OCT 9
         ipds(14) = (n-2)*12
         ipds(15) = (n+0)*12
         iens(2)  = 5          !: OCT 42
         iens(3)  = 0          !: OCT 43
         iens(4)  = 0          !: OCT 44
         iprob(1) = 61         !: OCT 46
         iprob(2) = 2          !: OCT 47
         xprob(1) = 0.0        !: OCT 48-51
         xprob(2) = rk(k)      !: OCT 52-55
         iclust(1)= iem        !: OCT 61
         call putgbex(51,10512,ipds,igds,iens,iprob,xprob
     &               iclust,imembr,lb,fp,iret)
ccc
         print *, 'all zero values for kk=',kk,' n=',n,' is ',izero
         print *, 'all same values for kk=',kk,' n=',n,' is ',isame
        enddo    ! for kk loop 
       endif    ! if (n.ge.2)
       pp = ff
      enddo     ! for n loop
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
CCC   subroutine mlpert(ff,nmem,alpha,beta,gamma,rlam,rmu,rnu,stdd)
CCC   This program is transformed and modified from MLPERTX.BAS 
CCC   (quick Basic version) to fortran version mlpert.f
CCC      --- Quick Basic by Dick Lehman ( CPC )
CCC      --- Transfored and modified to Fortran by Yuejian Zhu (12/05/96)
CCC
CCC   INPUT:       
CCC                ff ----- real array with dimension nmem
CCC                nmem --- the length of data samples
CCC
CCC   OUTPUT:
CCC                alpha --- shape parameter of 3-parameters GAMMA function
CCC                beta  --- scale parameter of 3-parameters GAMMA function
CCC                gamma --- location parameter of 3-parameters GAMMA function
CCC                rlam  --- processing parameter after transform           
CCC                rmu   --- mean value of statistic from data              
CCC                rnu   --- mean value of GAMMA function                   
CCC                stdd  --- standard deviation from statistics
CCC           
CCC   SUBROUTINE:
CCC                subroutine lmr3(x,el2,tau3)              
CCC                subroutine piksrt (r0)
CCC                subroutine zbrakv (r0,zum,rmin,x1,x2,xb1,xb2,nb)
CCC   FUNCTION:
CCC                function algams (x1)
CCC                function digamds (x)
CCC                function pe3ml(r0,anu,ala,g)
CCC                function rtbis(r0,rmin,X1,X2,xacc,ala,ell)
C--------+---------+---------+---------+---------+---------+---------+---------+
      subroutine mlpert(ff,nmem,alpha,beta,gamma,rlam,rmu,rnu,stdd)
      parameter (nn=1,nnbmax=2,nn1=1000)                   
      dimension ff(nmem)
      dimension x0(nn),ami(nn),amx(nn),bet(nn),ex2(nn),avg(nn)
      dimension skw(nn),ga(nn),al1(nn),v(nn),stde(nn)
      dimension rt(nn,nnbmax+1),alph(nn,nnbmax+1)
      dimension xb1(nnbmax),xb2(nnbmax),el(nnbmax),al(nnbmax)
      dimension dz(34),zum(34),r0(nn1),out(nn1)
      common /shared/ n1,nbmax,nin,av
c     zum() ARE VALUES OF THE SUM FROM 1 TO NIN OF DZ(J),WHERE DZ(J)=Z^J/J!,
c     AND Z=EXP[log(COF*NIN!)/NIN].
c      FOR NIN=1,Z=DZ(1)=COF,THE FIRST EXPONENTIAL INCREMENT
      data zum/    0.000,    0.000,    0.043,    0.132,    0.297,
     .             0.550,    0.920,    1.440,    2.170,    3.180,
     .             4.600,    6.580,    9.350,   13.200,   18.700,
     .            26.400,   37.300,   52.700,   74.600,  106.000,
     .           150.000,  213.000,  303.000,  431.000,  614.000,
     .           876.000, 1250.000, 1790.000, 2560.000, 3660.000,
     .          5250.000, 7520.000,10800.000,15500.000/
      sqalp = 1.0        ! added
      nskip = 0
      nbmax = 2
      neg   = 0          ! added
c     neg   = 1          ! added
ccc
c     print '(5x,17f4.1)',ff
      n1    = nmem 
      do i = 1, n1
         r0(i) = ff(i)
      enddo
      do j = 1, nn
         av  = 0.0
         var = 0.0
         sks = 0.0
         nb  = 0
         do i = 1, n1
c  IF R <= 0 THEN R = -.01 'DIAGNOSTIC FOR PRCP DATA
c  IF R <= .02 THEN R = -.01 'DIAGNOSTIC FOR PRCP DATA
          r0(i) = r0(i)/sqalp
          av    = av + r0(i)/float(n1)
         enddo
         rmin =  10000.0
         rmax = -10000.0
         do i = 1, n1
          if (r0(i).gt.rmax) rmax=r0(i)
          if (r0(i).lt.rmin) rmin=r0(i)
          s = r0(i) - av
          p = s*s  
          var = var + p
          p = p*s
          sks = sks + p
         enddo
         if (sks.lt.0.0) then
          neg = neg + 1
          do i = 1, n1
           r0(i) = -r0(i)
          enddo
          rmin0 = -rmax
          rmax  = -rmin
          rmin  = rmin0
          av    = -av
         endif   
         avg(j) = av
         ami(j) = rmin
         amx(j) = rmax
c	VAR is ML estimate of variance in Gaussian model
         var = var / float(n1) 
        if (var.eq.0.0) then
         print *, "ERROR in input: ALL VALUES ARE THE SAME!"
         stop 1000            
        endif 
         sd      = sqrt(var)
         stde(j) = sd
         sk      = sks/(float(n1)*sd**3.0)
c	table of cf values for correcting sk for sampling bias.
c	assume sk=1 (alpha=4) to get cf1 for PE3 then later find cf2,
c	corr for sample sk assuming n=45
c	cf1 data from JR Wallis, NC Matalas, JR Slack, 1974, Just a Moment!,
c	water Resources Research 10, 211-219.
c	 n=20    30    40    50    60    90
c	 1.430 1.279 1.207 1.165 1.138 1.093
c	note cf1 gives correct values for N1, assuming sk=1
c       cf1 = 1.00678 + 7.565*float(n1**(-1)) + 18.0*float(n1**(-2))
        cf1 = 1.00678 + 7.565/float(n1) + 18.0/float(n1)/float(n1)
        skl = log(abs(sk))
c	note cf2 corrects for sk assuming N1=45
        cf2 = .00534 + .0581*skl + .0213*skl**2.0
c	note added 07-08-96: cf below reproduces reasonably well the Pearson cf's
c	in Just A Moment! Table 4 for N1 from 20 to 90 and skew from .25 to 4, i.e.
c	alpha 64 to 1.
       cf  = cf1 + cf2
       skc = cf*sk
c  LOCATE 1, 10: PRINT "SD="; : PRINT USING "##.###"; sd;
c  LOCATE 1, 22: PRINT "SKC="; : PRINT USING "##.###"; skc
       skw(j) = skc
c  minimum possible ML estimate of nu in PE3 model
       x0(j)  = av - rmin 
       x1     = x0(j)
       x2     = 15.0*sd
c  X2 = 20! * sd 'DIAGNOSTIC
       if ( x2.lt.x1 ) then
          print *, "x2<x1 error"
       endif
        ex2(j) = x2
c************* GET PE3ML(ANU) VALUE *******************
c  PRINT "X1,X2="; x1; x2
c  I$ = INPUT$(1): END
      call zbrakv(r0,zum,rmin,x1,x2,xb1,xb2,nb)
      do i = 1, nb
       xacc = .00001*(xb1(i) + xb2(i))/2.0
c      print *, "xacc= ", xacc   
       rt(j, i) = rtbis(r0,rmin,xb1(i),xb2(i),xacc,ala,ell)
c      print *, "  DX= ", xb1(i)
       el(i) = ell
       al(i) = ala
       if (ala.eq.999.0) then
c       print *, "skew=",skc
        ala = 0.0
       endif
       alph(j,i) = rt(j,i)*ala
      enddo
      if (nb.eq.0) then
c  NOTE: these X1 & X2 values are Log likelihoods
       if (x1.gt.x2) then
        nz1 = nz1 + 1
c  no sol'n case when abs(skew) is large
        call piksrt(r0)
        call lmr3(r0,el2,tau3)
        gamest = -.01
        fal = (av - gamest) / el2
c   alest is rational estimate of alpha by power series expansion of fal
        alest = -0.3443+0.0532*fal+0.30791*fal*fal+0.0006682*fal*fal*fal
c   sest is estimate of sigma consistent with fal and alest in PE3 model.
        sest  = el2 * fal/sqrt(alest)
        one   = 1.0
        third = 1.0/3.0
        c1    = 0.2906
        c2    = 0.1882
        c3    = 0.0442
        d1    = 0.36067
        d2    =-0.59567
        d3    = 0.25361
        d4    =-2.78861
        d5    = 2.56096
        d6    =-0.77045
        pI3   = 9.424778
        rootpi= 1.7724539
       if (tau3.ge.third) then
        t = one - tau3
        alp3 = t*(d1 + t*(d2 + t*d3))/(one + t*(d4 + t*(d5 + t*d6)))
       else
        t    = pi3*tau3*tau3
        alp3 = (one + c1*t)/(t*(one + t*(c2 + t*c3)))
       endif
        alph(j,nbmax+1) = alest
        rt(j,nbmax+1)   = av - gamest
        ga(j)           = gamest
        v(j)            = sest
        al1(j)          = alest/(av - gamest)
        bet(j)          = 1.0/al1(j)
       endif 
       if (x2.gt.x1) then
c  no sol'n case when abs(skew) is small
        nz2    = nz2 + 1 
        ga(j)  = 0.0
        al1(j) = 0.0
        v(j)   = 0.0
        bet(j) = 0.0
       endif
      else
       ga(j)           = av - rt(j,nb)
       ng              = ng + 1
       al1(j)          = al(nb)
       bet(j)          = 1.0/al(nb)
       v(j)            = sqrt(rt(j,nb)/al(nb))
       rt(j,nbmax+1)   = rt(j,nb)
       alph(j,nbmax+1) = alph(j,nb)
      endif
      enddo
c  note nz2 failures are not included in ngz since the nz2 params are zeros
c  that should not be included in the RNGM data averages
      ngz = ng + nz1
c     do j = 1, nn
c      print *, '   rt1    rt2 '
c      print 1001, rt(j,1),rt(j,2)
c     enddo
c     print *,
c    .    'MLPERTX N=',n1,' trials=',nn,' ng=',ng,' z1=',nz1,' z2=',nz2
c     print *,
c    .    'ZBRAKV/RTBIS solutions for nu:New PE3 MaxLik Eqns nin=',nin
c     print *, 'nskip=',nskip,' -skew=',neg
      do j = 1, nn
       if (j.lt.21) then
        alpha=alph(j,3)
        beta=bet(j)
        gamma=ga(j)
        stdd=stde(j)
        rlam=al1(j)
        rmu=avg(j)
        rnu=rt(j,3)
c       print *, '  nu0    nux    nu1    lam1   alpha  beta'
c       print 1001, x0(j),ex2(j),rt(j,3),al1(j),alph(j,3),bet(j)
c       write(52,1001) x0(j),ex2(j),rt(j,3),al1(j),alph(j,3),bet(j)
c       print *, ' gamma   data  range    mu    sig1   stde   skew'
c       print 1001, ga(j),ami(j),amx(j),avg(j),v(j),stde(j),skw(j)
       endif
c      if (nn.eq.1.and.nb.eq.0) then
c       print *, '   el2  sest  gamest  alest  alp3'
c       print 1002,el2,sest,gamest,alest,alp3
c      endif
      enddo
 1001 format (10(f7.2))
 1002 format (10(f7.3))
c      print '(5x,17f4.1,4f6.2,1x,f3.2)',ff,
c    &        alpha,beta,gamma,stdd
c      write(52,'(5x,17f4.1,4f6.2,1x,f3.2)') ff,
c    &        alpha,beta,gamma,stdd

      return 
      end
c
      real function algams (x1)
c  LOGARITHM OF GAMMA FUNCTION
c  BASED ON ALGORITHM ACM291, COMMUN. ASSOC. COMPUT. MACH. (1966)
      small = 1.0E-7                  
      crit  = 13.0
      big   = 1.0E+9       
      toobig= 2.0E+36                                 
c  C0 IS 0.5*LOG(2*PI)
c  C1...C7 ARE THE COEFFTS OF THE ASYMPTOTIC EXPANSION OF ALGAM
c  S1 IS -(EULER'S CONSTANT), S2 IS PI**2/12
      c0 =  0.9189385332046728
      c1 =  0.08333333333333333
      c2 = -0.002777777777777778
      c3 =  0.0007936507936507937
      c4 = -0.005952380952380953
      c5 =  0.008417508417508417
      c6 = -0.01917526917526918
      c7 =  0.0641025641025641
      s1 = -0.5772156649015329
      s2 =  0.8224670334241132
      zero = 0.0
      half = 0.5
      one  = 1.0
      two  = 2.0
      alga = zero
      if (x1.le.0.0.or.x1.gt.toobig) goto 100
c   USE SMALL-X1 APPROXIMATION IF X1 IS NEAR 0, 1 OR 2
      if (abs(x1-two).gt.small) goto 110
       alga = log(x1 - one)
       xx = x1 - two
       goto 120
  110 continue
      if (abs(x1-one).gt.small) goto 130
       xx = x1 - one
  120 continue
       alga = alga + xx * (s1 + xx * s2)
       algams = alga
       return
  130 continue
      if (x1.gt.small) goto 140
       algams = -log(x1) + S1 * X1
       return  
c  REDUCE TO ALGAM(X1+N) WHERE X1+N.GE.CRIT
  140 continue
      sum1 = zero
      y = x1
      if (y.ge.crit) goto 160
       z = one
  150 continue
       z = z * y
       y = y + one
      if (y.le.crit) goto 150
       sum1 = sum1 - log(z)
c  USE ASYMPTOTIC EXPANSION IF Y.GE.CRIT
  160 continue
      sum1 = sum1 + (y - half) * log(y) - y + c0
      sum2 = zero
      if (y.ge.big) goto 170
       z = one / (y * y)
       sum2 = ((((((c7*z + c6)*z + C5)*z + C4)*z + C3)*z + C2)*z + C1)/y
  170 algams = sum1 + sum2
      return   
  100 print *, "ALGAM ERROR: ARGUMENT OUT OF RANGE"
      return
      end
c
      real function digamds (x)
c     common /shared/ n1,nbmax,nin,av
c  DIGAMMA FUNCTION (EULER'S PSI FUNCTION) - THE FIRST DERIVATIVE OF
c  LOG(GAMMA(X))
c
c  BASED ON ALGORITHM AS103, APPL. STATIST. (1976) VOL.25 NO.3
c
c  DOUBLE PRECISION (A-H,O-Z)
      zero = 0.0
      half = 0.5
      one  = 1.0
      small= 0.000000001
      crit =13.0
c  C1...C7 ARE THE COEFFTS OF THE ASYMPTOTIC EXPANSION OF DIGAMD
c       D1 IS  -(EULER'S CONSTANT)
c       DATA C1,C2,C3,C4,C5,C6,C7,D1/
      c1 = 8.333333333333333D-02
      c2 = -8.333333333333333D-03
      c3 = 3.968253968253968D-03
      c4 = -4.166666666666667D-03
      c5 = 7.575757575757576D-03
      c6 = -2.109279609279609D-02
      c7 = 8.333333333333333D-02
      d1 = -.5772156649015329
      diga = zero
      if (x.le.zero) goto 200
c  USE SMALL-X APPROXIMATION IF X.LE.SMALL
      if (x.gt.small) goto 210
       digamds = D1 - one / x
       return
c  REDUCE TO DIGAMD(X+N) WHERE X+N.GE.CRIT
  210 continue
      y = x
  220 continue
      if (y.ge.crit) goto 230
      diga = diga - one / y
      y = y + one
      goto 220
c  USE ASYMPTOTIC EXPANSION IF Y.GE.CRIT
  230 continue
      diga = diga + log(y) - half / y
      y = one / (y * y)
      sum = ((((((c7*y + c6)*y + c5)*y + c4)*y + c3)*y + c2)*y + c1)*y
      digamds = diga - sum
      return
  200 print *, "ERROR *** ROUTINE DIGAMD: ARGUMENT OUT OF RANGE", x
      return
      end
c
      subroutine lmr3(x,el2,tau3)
c   RLL 12-12-95 MODIFIED FROM HOSKINGS LMR FORTRAN ROUTINE
c   SAMPLE L-MOMENTS OF A DATA ARRAY
c   PARAMETERS OF ROUTINE:
c   X         *INPUT* ARRAY OF LENGTH N1. CONTAINS THE DATA INCLUDING ZEROS
c                   IN ASCENDING ORDER.
c   N1        *INPUT* (COMMON SHARED INTEGER): NUMBER OF REAL DATA VALUES
c   EL2,TAU3  *OUTPUT* L-MOMENTS L2, L3/L2
c
c   NUMBER OF L-MOMENTS TO BE FOUND. AT MOST MAX(N,20).
      parameter (nmom=4)
      dimension sum(nmom),x(*)
      common /shared/ n1,nbmax,nin,av
      zero = 0.0
      one  = 1.0
c  SUMMING PRELIMINARY TO GETTING L-MOMENTS FOR SAMPLE
      do j = 1, nmom
         sum(J) = zero
      enddo
      do i = 1, n1
       z = float(i)
       term = x(i)
       sum(1) = sum(1) + term
       do j = 2, nmom
        z = z - one
        term = term * z
        sum(j) = sum(j) + term
       enddo
      enddo
      y = n1
      z = n1
      sum(1) = sum(1)/z
      do j = 2, nmom
       y = y - one
       z = z*y
       sum(j) = sum(j)/z
      enddo
c   L-MOMENTS ARE NOW CALCULATED FOR THE SAMPLE
      k = nmom
      p0 = one
      if (mod(nmom,2).eq.1) p0=-one
      do kk = 2, nmom
       ak = float(k)
       p0 = -p0
       p = p0
       temp = p*sum(1)
       do i = 1, k-1
        ai = float(i)
        p = -p*(ak + ai - one)*(ak - ai)/(ai * ai)
        temp = temp + p*sum(i+1)
       enddo
       sum(k) = temp
       k = k - 1
      enddo
      el1 = sum(1)
      el2 = sum(2)
      if (sum(2).eq.zero) then
       print *, "ERROR in LMR3: ALL THE DATA VALUES ARE THE SAME"
       return
      endif
      tau3 = sum(3) / el2
      return
      end
c
      real function pe3ml(r0,anu,ala,g)
      dimension r0(*)
      common /shared/ n1,nbmax,nin,av
c  MaxLik equation for Pearson III distribution, solved by varying ANU
c  When PE3ML=0, nuhat=ANU and lamhat=ala. sighat=SQR(nuhat/lamhat)
c  [alphahat=nuhat*lamhat, betahat=1/lamhat, gamhat=av-nuhat]
c  COMMON SHARED av=muhat, the mean of the input data, r0(i), i=1 to N1.
c  COMMON SHARED N1 AS INTEGER. N1 is the number of input data
c  Absolute requirement: rmin>av-ANU, where rmin is the smallest r0(i) datum
      g = 0.0
      h = 0.0
      do i = 1, n1
       r = r0(i) - av + anu
       g = g + log(r)
       h = h + (1.0/r)
      enddo
      g   = g/float(n1)
      h   = h/float(n1)
      ala = h/(anu*h - 1.0)
      alp = ala*anu
      pe3ml = log(ala) - digamds(alp) + g
      return
      end
c
      subroutine piksrt (r0)
      dimension r0(*)
      common /shared/ n1,nbmax,nin,av
c  Sorts an array of length N1 into ascending numerical order. r0() is
c  replaced on output by its sorted rearrangement.
c  r0() must be a single column array.
      do j = 2, n1
       a = r0(j)
      do i = j-1, 1, -1
       if (r0(i).le.a) goto 401
       r0(i+1) = r0(i)
      enddo
 401  continue
      if (r0(i).gt.a) i=0
      r0(i+1) = a
      enddo
      return
      end
c
      real function rtbis(r0,rmin,x1,x2,xacc,ala,ell)
      common /shared/ n1,nbmax,nin,av
c  COMMON SHARED av  NOTE: the x1, x2 here are xb1() & xb2() from ZBRAKV!!
      jmax = 40
c  LOCATE 2, 1: PRINT "x2="; x2
      arg = rmin - av + x2
      if (arg.le.0.0) then
      print *,"X2 ERROR IN RTBIS: av,rmin,x1,x2,arg=",av,rmin,x1,x2,arg
      ala = 999.0
      return  
      endif
      fmid = pe3ml(r0,x2,ala,g)
      arg = rmin - av + x1
      if (arg.le.0.0) then
        print *,"X1 ERROR IN RTBIS:av,rmin,x1,x2,arg=",av,rmin,x1,x2,arg
        ala = 999.0
        return
      endif
      f = pe3ml(r0,x1,ala,g)
      if (f*fmid.ge.0.0) then
       print *,"RTBIS ERROR: Root must be bracketed for bisection."
       return
      endif
      if (f.lt.0.0) then
       trtbis = x1
       dx = x2 - x1
      else
       trtbis = x2
       dx = x1 - x2
      endif  
      do j = 1, jmax
       dx = dx * .5
c  X1 redefined so DX may be passed back to MLPERTX and printed
       x1 = dx 
       xmid = trtbis + dx
       arg = rmin - av + xmid
       if ( arg.le.0.0) then
        print *,"XMID ERROR IN RTBIS j, XMID, arg, DX = ",j,xmid,arg,dx
        return  
       endif
       fmid = pe3ml(r0,xmid,ala,G)
       if (fmid.le.0.0) trtbis = xmid
       rtbis = trtbis
c      print *, "RTBIS nu1,j=  ", trtbis, J
c  The next statements terminate the repeated bisections when DX has
c  fallen to a value below the given accuracy cutoff(xacc)
       if (abs(dx).lt.xacc) then
        alp = trtbis * ala
        ell = alp*log(ala) - algams(alp) + (alp - 1)*g - alp
        return
       endif
       if (fmid.eq.0.0) return
      enddo
      print *,"RTBIS ERROR: TOO MANY BISECTIONS"
      return
      end
c
      subroutine zbrakv (r0,zum,rmin,x1,x2,xb1,xb2,nb)
      dimension r0(*),zum(*),dz(34),xb1(*),xb2(*)
      real nf,nfj
      common /shared/ n1,nbmax,nin,av
c  UR is the useful range of nu values.
      ur  = x2 - x1 
      j   = 4
      cof = .00001
  100 continue
      if ((ur-zum(j)).gt.0.0) then
         j = j + 1
         goto 100
      endif
      nin = j
      nf  = 1.0
      nfj = 1.0
c     print *,"UR=",ur," N=",nin
      do j = 1, nin
       nf = nf + float(j)*nf
      enddo
      z = exp(log(cof*nf)/float(nin))
      nfj = 1
      do j = 1, nin
       nfj = nfj + float(j)*nfj    
       dz(nin-j+1) = (z**float(j))/nfj
      enddo
c  DZ() ARE EXPONENTIALLY INCREASING INCREMENTS TO x1, THAT BEGIN WITH COF
c  AND SUM TO UR.
c  FOR I = 1 TO NIN: PRINT DZ(I); : NEXT
c  END
c  INITIALLY, X1 AND X2 ARE THE LOWER AND UPPER BOUNDS ON NU. UR=X2-X1. LATER,
c  X1 AND X2 ARE REDEFINED AND PASSED TO MLPERT AS ELL'S (LOG LIKELIHOODS)
c
c  note that DZ(1)=COF
      x = x1 + dz(1) 
      fp = pe3ml(r0,x,ala,g)
c     print *,'FP,X,DZ(1)=',fp,x,dz(1)
      i = 2
 300  continue
      if (i.le.nin) then
c     do i = 2, nin
       x = x + dz(i)
c      if ((x-av+rmin).le.0.0) then
c       print *, "ZBRAK NIN,X,DZ(I)=", nin, x, dz(i)
c      endif
       fc = pe3ml(r0,x,ala,g)
       if (i.eq.2) then
        alp = x*ala
        x1 = alp*log(ala) - algams(alp) + (alp - 1.0)*g - alp
       endif
c      print *,'FC,X,I=',fc,x,i
c  i$ = INPUT$(1) 'NOTE this is a useful diagnostic statement!!
       if ((fc*fp).lt.0.0) then
        nb = nb + 1
        xb1(nb) = x - dz(i)
        xb2(nb) = x
        alpx = x * ala
       endif
       fp = fc
       i  = i + 1
c  The next statement cuts out unneeded calculations.
       if (nb.eq.nbmax.and.i.le.nin) i=nin+1
c  The next statement allows one to display S solutions with alpha values
c  very close to 1. It assumes that if an S solution is found, it will have
c  an upper bracket with alpha value(alpx) below 1.5. HIROSE data has largest
c  S sol'n upper bracket alpha(1.48) found to date. So a solution bracket with
c  alpx >1.5 is taken to be a P solution.
c  NOTE: this statement will allow some P solutions to be displayed, when no
c  S solution is found and the P solution upper bracket has an alpha =<1.5
c  To eliminate the possibility of displaying (and for RNGM- data averaging in)
c  S solutions, then comment out this next statement!
c  IF alpx > 1! AND alpx < 1.5 THEN i = NIN
c  The next statement cuts out unneeded calculations.
CC-YZ  if (alpx.gt.1.5.and.i.le.nin) i=nin
c  PRINT "alpx="; alpx: i$ = INPUT$(1)
       if (nb.eq.0.and.i.eq.nin) then
        alp = x*ala
        x2 = alp*log(ala) - algams(alp) + (alp - 1.0)*g - alp
       endif
       goto 300
      endif
ccc
c     do i = 1, nb
c      print *, 'xb1=',xb1(i),' xb2=',xb2(i) 
c     enddo
c      print *, 'nb=',nb,' nbmax=',nbmax
ccc
      return
      end
