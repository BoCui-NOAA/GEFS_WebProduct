      program random
c     IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      real*8 x(16),seed            
      dimension indx(16)
      seed=33331         
      call DURAND(seed,16,x)
      call isortx(x,1,16,indx)
      write(*,'(16i4)') (indx(i),i=1,16)
      seed=33332         
      call DURAND(seed,16,x)
      call isortx(x,1,16,indx)
      write(*,'(16i4)') (indx(i),i=1,16)
      seed=33333         
      call DURAND(seed,16,x)
      call isortx(x,1,16,indx)
      write(*,'(16i4)') (indx(i),i=1,16)
      stop
      end

