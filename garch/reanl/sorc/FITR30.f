      subroutine fitr30(field)
      dimension field(144,73),wave(2,32,32)
      dimension fieldt(144,73)
C     dimension fac(64)

      pi=3.1415926

       do 80 j = 1,73
       coslat = sin(pi*2.5*(j-1)/180.0)
       do 80 i = 1,144
  80   fieldt(i,j) = field(i,j) *  coslat
c
c      using sptez instead of sphert in splib
c
       call sptez(1,31,0,144,73,wave,fieldt,-1)      
c      CALL SPHERT ( 101,fieldt,WAVE,0,FAC,144,73,31,1)
       do 85 i = 1,32
       wave(1,i,32) = 0.0
  85   wave(2,i,32) = 0.0
       call sptez(1,31,0,144,73,wave,fieldt,1)      
c      CALL SPHERT (-101,fieldt,WAVE,0,FAC,144,73,31,1)
       do 90 j = 2,72
       coslat = sin(pi*2.5*(j-1)/180.0)
       do 90 i = 1,144
  90   field(i,j) = fieldt(i,j) /  coslat

      return
      end

