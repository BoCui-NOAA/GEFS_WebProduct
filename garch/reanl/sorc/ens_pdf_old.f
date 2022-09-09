c
c  Main program    ENS_CDF
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2007-08010
c
c   Fortran 77 on IBMSP
c
      program END_CDF     
      parameter (n=10)
      dimension q(n),u(n),w(n)
C--------+---------+---------+---------+---------+---------+---------+---------+
      q(1)  = 11.0
      q(2)  =  1.0
      q(3)  =  5.0
      q(4)  = 13.0
      q(5)  = 17.0
      q(6)  = 10.0
      q(7)  =  8.0
      q(8)  = 23.0
      q(9)  = 31.0
      q(10) = 12.0

      u = 1.0/float(n)
      call sort(q,10)
      print *, q
      
      m = n
      qun = 0.0
      do i = 2, m
       qun = qun + (u(i-1)+u(i))*(q(i)-q(i-1))/2.0
      enddo

      vn=qun/(1.0-2.0/float(n+1))
      print *, "qun=",qun,"vn=",vn
      do i = 1, n
       w(i) = u(i)/vn
      enddo

      qlt=q(1) - 2.0/(w(1)*float(n+1))
      qrt=q(m) + 2.0/(w(m)*float(n+1))

      print *, "qlt=",qlt," qrt=",qrt
      qq = 10.5
      qq = 30.0
      do i = 1, n
       if (qq.lt.q(i)) then
        k=i-1
        goto 101
       endif
      enddo

 101  continue
      print *, "k=",k

      cta = 0.0
      do i = 2, k
       cta = cta + (w(i-1)+w(i))*(q(i)-q(i-1))/2.0
      enddo

      ww = w(k) + (w(k+1)-w(k))*(qq - q(k))/(q(k+1) - q(k))
      fta = (ww + w(k))*(qq - q(k))/2.0
      print *, "cta=",cta," fta=",fta
    
      prob = cta + fta

      print *, "prob=",prob," for value=",qq

      stop
      end

