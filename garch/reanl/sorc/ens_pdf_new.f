c
c  Main program    ENS_CDF
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2007-08010
c
c   Fortran 77 on IBMSP
c
      program END_CDF     
      parameter (n=10)
      dimension ef(n),q(n),ew(n),u(n),uu(n),w(n),z(n),qa(n+1),a(n,3)
C--------+---------+---------+---------+---------+---------+---------+---------+
      ef(1)  = 11.0
      ef(2)  =  1.0
      ef(3)  =  5.0
      ef(4)  = 13.0
      ef(5)  = 17.0
      ef(6)  =  5.0
      ef(6)  = 10.0
      ef(7)  =  5.0
      ef(7)  =  8.0
      ef(8)  = 23.0
      ef(9)  = 31.0
      ef(10) = 12.0

      ew = 1.0/float(n)
      do i = 1, n
       a(i,1) = ef(i)
      enddo
      call sortmm(a,n,3,1)
      write (*,'(10f5.1)') (a(i,1),i=1,n)
      write (*,'(10f5.1)') (a(i,2),i=1,n)
      write (*,'(10f5.1)') (a(i,3),i=1,n)

      do i = 1, n
       ef(i) = a(i,2)
      enddo
 
      m = 1
      q(1) = ef(1)
      u(1) = ew(int(a(1,3)))
      do i = 2, n  
       if (ef(i-1).ne.ef(i)) then
        m = m + 1
        q(m) = ef(i)
        u(m) = ew(int(a(i,3)))                 
       else
        u(m) = u(m) + ew(int(a(i,3)))
       endif
      enddo

      write (*,'(10f5.3)') (u(i),i=1,m)
      
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

      do i = 1, m
       w(i) = z(i)/zsum
      enddo
      write (*,'(10f5.3)') (w(i),i=1,m)

      qlt=q(1) - 2.0/(w(1)*float(n+1))
      qrt=q(m) + 2.0/(w(m)*float(n+1))

      qa(1) = (q(1) - qlt)*w(1)/2.0
      qun = qa(1)
      do i = 2, m
       qa(i) = (w(i-1)+w(i))*(q(i)-q(i-1))/2.0
       qun = qun + qa(i)                               
      enddo
      qa(m+1) = (qrt - q(m))*w(m)/2.0
      qun = qun + qa(m+1)                     

      do i = 1, m+1
       qa(i) = qa(i)/qun
      enddo

      print *, "qlt=",qlt," qrt=",qrt," qun=",qun
      write (*,'(11f5.2)') (qa(i),i=1,m+1)

      qq = 11.5
      qq = 20.0
      k=m
      do i = 1, m
       if (qq.lt.q(i)) then
        k=i-1
        goto 101
       endif
      enddo

 101  continue
      print *, "k=",k

      cta = 0.0
      do i = 1, k
       cta = cta + qa(i)                               
      enddo

      ww = w(k) + (w(k+1)-w(k))*(qq - q(k))/(q(k+1) - q(k))
      fta = (ww + w(k))*(qq - q(k))/(2.0*qun)
      print *, "cta=",cta," fta=",fta
    
      prob = cta + fta

      print *, "prob=",prob," for value=",qq

      stop
      end

