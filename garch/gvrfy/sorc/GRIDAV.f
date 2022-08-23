      SUBROUTINE gridav(z,lon,lat,deg,gridv)
      dimension z(lon,lat),deg(lat)
c
c       grid averaging algorithm: spherical integration
c       not fancy but has a pole correction
c
c       algorithm:
c
c       dtheta = (deg(i+1)-deg(i)/2 + (deg(i) - deg(i-1))/2
c               = (deg(i+1) - deg(i-1))/2
c
c       integral = sum for all point: point_value * dtheta * cos(theta)
c               / sum for all points: dtheta * cos(theta)
c
c       however there is a problem with the poles,
c       point_value*dos(theta) goes to zero
c
c       one solution:
c       let dtheta = (90 degrees - (deg(1)+deg(2))/2)
c       and assume that f*cos(theta) is linear
c
c       and then integrate the over the interval
c       this yields an effective dtheta of
c
c       dth = 0.5 * (90.- (deg(1)+deg(2))/2)**2 / (90.- deg(1))
c       note:
c       grids must from north and work down
c
      gridv=0.
      PI=4.*ATAN(1.)
      X=0.
      W=0.
      DO 11 J=1,LAT
      COSL=COS(DEG(J)*PI/180.)
c       wne: pole problem fix
        if (j.eq.1) then
           dth = 0.5*(90.- (deg(1)+deg(2))/2.)**2 * PI/180.
        else if (j.eq.lat) then
           dth = 0.5*((deg(lat)+deg(lat-1))/2.+90.)**2 * PI/180.
        else
           dth = 0.5 * (deg(j-1) - deg(j+1)) * COSL
        endif
      DO 10 I=1,LON
      X=X+Z(I,J)*DTH
      W=W+DTH
10    CONTINUE
11    CONTINUE
      GRIDV=X/W
      RETURN
      END

