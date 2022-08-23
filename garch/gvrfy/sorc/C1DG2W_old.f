      subroutine c1dg2w(f,iw1,iw2)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: TRANSFER GRID TO WAVE COEFF.                            C
C            HERE TRUNCATE TO FIRST 20 WAVES                         C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: f(144)                                                  C
C                                                                    C
C     OUTPUT: a(20) real part                                        C
C             b(21) image part                                       C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter (nw=60)
      dimension f(144),a(nw),b(nw),w(200)
      complex   w,c
      nn  = 145
      n2  = nw 
      an  = nn/2
      nn2 = nn-1
      pi  = 3.14159265897932
      cnst= 1./an
      ang = cnst * pi
      ca  = cos(ang)
      sa  = sin(ang)
      c   = cmplx(ca,sa)
      w(1)= (1.0,0.0)
      do j = 2,nn
       w(j) = c*w(j-1)
      enddo     
      do k = 1,n2
       a(k) = 0.0
       b(k) = 0.0
       do j = 1,nn2
        i  = mod(k*(j-1),nn2) + 1
        ca = real(w(i))
        sa = aimag(w(i))
        if (k.eq.10.and.j.eq.10) then
         print *, 'j=',j,' sa=',sa,' ca=',ca
        endif
        a(k) = f(j)*sa + a(k)
        b(k) = f(j)*ca + b(k)
       enddo   
       a(k) = a(k)/an
       b(k) = b(k)/an
      enddo    

      write (*,888) (a(k),k=1,10)
      write (*,888) (b(k),k=1,10)
 888  format (10f7.1)

      do j = 1,nn2
       f(j) = 0.0
       do k = 1,n2
        i  = mod(k*(j-1),nn2) + 1
        ca = real(w(i))
        sa = aimag(w(i))
        if (k.eq.10.and.j.eq.10) then
         print *, 'j=',j,' sa=',sa,' ca=',ca
        endif
        if (k.eq.1) then
c        f(j) = f(j) + 0.5*b(k)*sa 
         f(j) = f(j) + 0.5*b(k) 
        else
         f(j) = f(j) + a(k)*sa + b(k)*ca 
        endif
       enddo
      enddo

c     do j = 1, nn2
c      f(j) = 0.0
c      do k = 1, n2
c       i  = mod(k*(j-1),nn2) + 1
c       ca = real(w(i))
c       sa = aimag(w(i))
c       if (sa.eq.0.0) then
c        f(j) = f(j) + an*b(k)/ca 
c       else
c        f(j) = f(j) + an*a(k)/sa + an*b(k)/ca 
c       endif
c      enddo 
c     enddo

      return
      end

