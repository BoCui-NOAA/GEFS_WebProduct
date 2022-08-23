      subroutine grd2wv(f,a,b)
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
      dimension f(144),a(20),b(21),w(200)
      complex   w,c
      nn  = 145
      n2  = 20
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
            a(k) = f(j)*sa + a(k)
            b(k) = f(j)*ca + b(k)
         enddo   
         a(k) = a(k)/an
         b(k) = b(k)/an
      enddo    
      xbar=0.0
      do i=1,nn2
         xbar=xbar+f(i)/nn2
      enddo    
      b(n2+1)=xbar
      return
      end

