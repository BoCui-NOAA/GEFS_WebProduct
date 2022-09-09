c
c  Main program    ENS_CDF
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2007-08010
c
c   Fortran 77 on IBMSP
c
      program END_CDF     
      parameter (n=10)
      dimension q(n),w(n+1)
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

      u = 1.0/float(n+1)
      call sort(q,10)
      write (*,'(10f5.1)') (q(i),i=1,10)
      m = n

      do i = 2, m
       w(i) = u/(q(i)-q(i-1))
      enddo
      w(1) = w(2)/2.0
      w(m+1) = w(m)/2.0

      ww=0.0
      do i = 1, m+1
       ww = ww + w(i)
      enddo
      print *, "ww=",ww
      
      write (*,'(11f5.3)') (w(i),i=1,11)
      qlt=q(1) - u/w(1)                  
      qrt=q(m) + u/w(m+1)                 

      print *, "qlt=",qlt," qrt=",qrt
c     qq = 30.0
      qq = 7.0
      qq = 9.0
      qq = 12.5
      qq = 27.0
      qq = 33.0
      qq = 30.0
      qq = 10.5
      qq = 11.5
      qq = 3.0
      qq = 31.1
      k=n
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
       cta = cta + w(i)*(q(i)-q(i-1))
      enddo

      fta = w(k+1)*(qq - q(k))
      print *, "cta=",cta," fta=",fta
    
      prob = 1.0/float(n+1) + cta + fta

      print *, "prob=",prob," for value=",qq

      stop
      end

