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
c     q    -- forecast value (specified) when ictl = 1
c          -- probability value (0-1.0, specified) when ictl = -1
c     ictl -- 1 to calculate probability from forecast value 
c            -1 to calculate forecast value from giving probability
c
c   Fortran 77 on IBMSP
c
      function epdf(ef,ew,n,qq,ictl)
      dimension ef(n),ew(n)
      dimension q(n),u(n),w(n),z(n),qa(n+1),d(n,3)
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
      write (*,'("ORG DATA SET",10f5.1)') (d(i,1),i=1,n)
      write (*,'("NEW DATA SET",10f5.1)') (d(i,2),i=1,n)
      write (*,'("N DATA INDEX",10f5.1)') (d(i,3),i=1,n)

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

      write (*,'("ENS WEIGHTS:",10f5.3)') (u(i),i=1,m)
c
c     to calculate ensemble segment weights
c
c     z(1) = 1.0 / (q(2) - q(1))
c     z(m) = 1.0 / (q(m) - q(m-1))
c     do i = 2, m-1
c      z(i) = 2.0 / (q(i+1) - q(i-1))
c     enddo
c     z(1) = (u(2) + u(1)) / (q(2) - q(1))*2.0
c     z(m) = (u(m) + u(m-1)) / (q(m) - q(m-1))*2.0
      z(1) = u(1) / (q(2) - q(1))
      z(m) = u(m) / (q(m) - q(m-1))
      do i = 2, m-1
       z(i) = (u(i+1) + u(i)) / (q(i+1) - q(i-1))
      enddo
      zsum=0.0
      do i = 1, m
       zsum = zsum + z(i)
      enddo
c
c     normalized PDF weights for each value
c
      do i = 1, m
       w(i) = z(i)/zsum
      enddo
      write (*,'("PDF WEIGHTS:",10f5.3)') (w(i),i=1,m)
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

      write (*,'("CDF  AREAS :",11f5.3)') (qa(i),i=1,m+1)
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
c
c     cumulative trapezoid area (CTA)
c
      cta = 0.0
      do i = 1, k
       cta = cta + qa(i)                               
      enddo
      cta = qa(k)
c
c     fractional trapezoid area
c
      ww = w(k) + (w(k+1)-w(k))*(qq - q(k))/(q(k+1) - q(k))
      fta = (ww + w(k))*(qq - q(k))/(2.0*qun)
c
c     the area is the probability of given value qq (0.0-1.0)
c
      epdf = cta + fta

      elseif (ictl.eq.-1) then

       if (qq.le.0.0.or.qq.gt.1.0) then
        epdf=-9999.99
        return 
       endif

       if (qq.eq.0.0) epdf=qlt
       if (qq.eq.1.0) epdf=qrt

       do i = 1, m
        if (qq.lt.qa(i)) then
         k=i-1
         goto 102
        endif
       enddo
  102  continue

c
c      to solve the quadratic formula ( ax2 + bx + c = 0 )
c
       fta = (qq - qa(k))*qun
       a = (w(k+1)-w(k))/(q(k+1)-q(k))
       b = 2.0*w(k)
       c = -2.0*fta
       b2m4ac = b*b - 4.0*a*c
c      print *, "qa=",qa(k)," qq=",qq,"a,b,c=",a,b,c
       if ( b2m4ac.lt.0.0) then
        print *, "There is no real solution for this problem"
        epdf=-9999.99
        return
       endif
c      print *, "k=",k," q=",q(k)
       if (a.eq.0.0) then
        epdf = q(k) - c/b
       else
        epdf = q(k) + (sqrt(b2m4ac) - b)/(2.0*a)
       endif
      else
       epdf=-9999.99
       return
      endif

      return
      end

