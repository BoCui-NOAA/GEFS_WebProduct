      subroutine fitr20(field)
      dimension field(144,73),wave(2,22,22)
      dimension fieldt(144,73)

ccc
ccc   final smooth program without colat weighting by using sptez transform
ccc   program. It's OK for low-mid latitude, but a problem for high latitude
ccc   when using colat weighting -- Yuejian Zhu (06/07/2005)

      pi=3.1415926

       do 80 j = 1,73
c      coslat = sin(pi*2.5*(j-1)/180.0)
       coslat = 1.0                        
       do 80 i = 1,144
  80   fieldt(i,j) = field(i,j) *  coslat
c
c      using sptez instead of sphert in splib
c
       call sptez(1,21,0,144,73,wave,fieldt,-1)      
       do 85 i = 1,22
       wave(1,i,22) = 0.0
  85   wave(2,i,22) = 0.0
       call sptez(1,21,0,144,73,wave,fieldt,1)      
       do 90 j = 2,72
c      coslat = sin(pi*2.5*(j-1)/180.0)
       coslat = 1.0                       
       do 90 i = 1,144
  90   field(i,j) = fieldt(i,j) /  coslat

      return
      end

