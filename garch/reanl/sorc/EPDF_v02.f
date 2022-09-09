c
c  FUNCTION EPDF(EF,EW,N,Q,ICTL)
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2007-0801
c
c   function epdf to build up Probability Density Function by using picewise
c     linear approximation.
c
c   parameters:
c     input:
c     ef   -- forecasts for n ensemble members
c     ew   -- forecast weights for n ensemble members
c     n    -- ensemble members
c     qq   -- forecast value (specified) when ictl = 1
c          -- probability value (0-1.0, specified) when ictl = -1
c     ictl -- 1 to calculate probability from forecast value 
c            -1 to calculate forecast value from giving probability
c
c   Fortran 77 on IBMSP
c
      function epdf(ef,ew,n,qq,ictl)
      dimension ef(n),ew(n)
      dimension q(n),u(n),w(n),qa(n+1),d(n,3)
C--------+---------+---------+---------+---------+---------+---------+---------+
      do i = 1, n
       d(i,1) = ef(i)
      enddo
c
c     This sorting program will:
c      keep original data order
c      get new order (low to high)
c      new order data with original index
c
      call sortmm(d,n,3,1)
      write (*,'("ORG DATA SET",13f5.1)') (d(i,1),i=1,n)
      write (*,'("NEW DATA SET",13f5.1)') (d(i,2),i=1,n)
      write (*,'("N DATA INDEX",13f5.1)') (d(i,3),i=1,n)

      do i = 1, n
       ef(i) = d(i,2)
      enddo
c
c     to eliminate the duplication, give extra weight
c     m will be new dimension after this process (m<=n)
c
      m = 1
      q(1) = ef(1)
      u(1) = ew(int(d(1,3)))
      do i = 2, n  
       if (ef(i-1).ne.ef(i)) then
        m = m + 1
        q(m) = ef(i)
        u(m) = ew(int(d(i,3)))                 
       else
        u(m) = u(m) + ew(int(d(i,3)))
       endif
      enddo

      write (*,'("ENS WEIGHTS:",13f5.3)') (u(i),i=1,m)
c
c     to calculate ensemble segment weights
c
      w(1) = u(1) / (q(2) - q(1))
      w(m) = u(m) / (q(m) - q(m-1))
      do i = 2, m-1
ccc    find a bug to to calculate segment weight (08/07/2007)
c      w(i) = (u(i+1) + u(i)) / (q(i+1) - q(i-1))
ccc    Yuejian suggested weight
c      w(i) = (u(i+1) + 2.0*u(i) + u(i-1)) / (q(i+1) - q(i-1)) / 2.0
ccc    Keith suggested weight
       w(i) = 2.0*u(i) / (q(i+1) - q(i-1))
      enddo
      wsum=0.0
      do i = 1, m
       wsum = wsum + w(i)
      enddo
c
c     normalized PDF weights for each value
c
      do i = 1, m
       w(i) = w(i)/wsum
      enddo
      write (*,'("PDF WEIGHTS:",13f5.3)') (w(i),i=1,m)
c
c     calculate left and right bounds by approximation (considering tails)
c
      qlt=q(1) - 2.0/(w(1)*float(n+1))
      qrt=q(m) + 2.0/(w(m)*float(n+1))
c
c     normalized area of each trapezoidal
c
      qa(1) = (q(1) - qlt)*w(1)/2.0
      qun = qa(1)
      do i = 2, m
       qa(i) = (w(i-1)+w(i))*(q(i)-q(i-1))/2.0
       qun = qun + qa(i)                               
      enddo
      qa(m+1) = (qrt - q(m))*w(m)/2.0
      qun = qun + qa(m+1)                     
      qa(1) = qa(1)/qun
      do i = 2, m+1
       qa(i) = qa(i-1) + qa(i)/qun
      enddo

      write (*,'("CDF  AREAS :",14f5.3)') (qa(i),i=1,m+1)
      print *, "left bound is ",qlt,": right bound is ",qrt

      if (ictl.eq.1) then
c
c     to find out the position of give value qq
c
      if (qq.le.qlt) then
       epdf=0.0
       return
      endif
      if (qq.gt.qrt) then
       epdf=1.0
       return
      endif

      k=m
      do i = 1, m
       if (qq.lt.q(i)) then
        k=i-1
        goto 101
       endif
      enddo
 101  continue

      if (k.eq.0) then
       ww = w(1)*(qq - qlt)/(q(1)-qlt)
       fta = ww*(qq - qlt)/(2.0*qun)
       epdf = fta
      else if (k.eq.m) then
c
c     cumulative trapezoid area (CTA)
c
       cta = qa(m)
c
c     fractional trapezoid area
c
       ww = w(m)*(qrt - qq)/(qrt-q(m))
       fta = ww*(qrt - qq)/(2.0*qun)
c
c     the area is the probability (0.0-1.0) of given value qq 
c
       epdf = cta + fta
      else
c
c     cumulative trapezoid area (CTA)
c
       cta = qa(k)
c
c     fractional trapezoid area
c
       ww = w(k) + (w(k+1)-w(k))*(qq - q(k))/(q(k+1) - q(k))
       fta = (ww + w(k))*(qq - q(k))/(2.0*qun)
c
c     the area is the probability (0.0-1.0) of given value qq 
c
       epdf = cta + fta

      endif

      elseif (ictl.eq.-1) then

       if (qq.le.0.0.or.qq.gt.1.0) then
        epdf=-9999.99
        return 
       endif

       if (qq.eq.0.0) then
        epdf=qlt
        return
       endif
       if (qq.eq.1.0) then
        epdf=qrt
        return
       endif

       k = m
       do i = 1, m
        if (qq.lt.qa(i)) then
         k=i-1
         goto 102
        endif
       enddo
  102  continue

c
c      to solve the quadratic equation ( ax2 + bx + c = 0 )
c
       if (k.eq.0) then
        fta = qq*qun
        a = w(1)/(q(1)-qlt)
        b = 0.0
        c = -2.0*fta
        if (a.eq.0.0) then
         epdf=-9999.99
        else
         epdf = qlt + sqrt(-c/a) 
        endif
       else if (k.eq.m) then
        fta = (qq - qa(m))*qun
        a = -w(m)/(qrt-q(m))
        b = 2.0*w(m)
        c = -2.0*fta
        b2m4ac = b*b - 4.0*a*c
        if ( b2m4ac.lt.0.0) then
         print *, "There is no real solution for this problem"
         epdf=-9999.99
         return
        endif
        if (a.eq.0.0) then
         epdf = q(m) - c/b
        else
         epdf = q(m) + (sqrt(b2m4ac) - b)/(2.0*a)
        endif
       else
        fta = (qq - qa(k))*qun
        a = (w(k+1)-w(k))/(q(k+1)-q(k))
        b = 2.0*w(k)
        c = -2.0*fta
        b2m4ac = b*b - 4.0*a*c
        if ( b2m4ac.lt.0.0) then
         print *, "There is no real solution for this problem"
         epdf=-9999.99
         return
        endif
        if (a.eq.0.0) then
         epdf = q(k) - c/b
        else
         epdf = q(k) + (sqrt(b2m4ac) - b)/(2.0*a)
        endif
       endif
      else
       epdf=-9999.99
       return
      endif

      return
      end

