      SUBROUTINE AVEF(x,ix,iy,ns,ne)
      parameter (nw=500)
      dimension x(ix,iy)
      dimension a(0:nw),b(0:nw)
      dimension xa(nw),xb(nw)
c
      x2pi = 2*3.1415926536
c     x2pi = 2.0*3.14159
      mnw=(nw+1)/2

      do j = 1, iy
      xa0 = 0.0
      do k = 1, ix
       xa0 = xa0 + x(k,j)
      enddo
      a0 = xa0/float(ix)
      do i = 1, mnw
       xa(i) = 0.
       xb(i) = 0.
       do k = 1, ix
        xa(i) = xa(i) + x(k,j)*cos(float(i*k)*x2pi/float(ix))
        xb(i) = xb(i) + x(k,j)*sin(float(i*k)*x2pi/float(ix))
       enddo
       a(i) = 2.0*xa(i)/float(ix)
       b(i) = 2.0*xb(i)/float(ix)
      enddo
      a(0) = a0
c
c     print *, 'a0=',a0
      do k = 1, ix
c      x(k,j) = a0    ! wave zero - zonal wave
       x(k,j) = 0.0
       do i = ns, ne
        x(k,j) = x(k,j) + a(i)*cos(float(i*k)*x2pi/float(ix)) 
     .                  + b(i)*sin(float(i*k)*x2pi/float(ix))
       enddo
      enddo    

      enddo
      return
      end

