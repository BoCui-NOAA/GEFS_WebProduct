      program test
      dimension a(73),b(73)
      acnt=0.0
      bcnt=0.0
      pi=3.1415926
      do lat = 1, 73
       xlat   = (90.0-(lat-1)*2.5)*pi/180.0
       a(lat) = cos(xlat)
       a1     = cos(xlat-1.25*pi/180.0)
       a2     = cos(xlat+1.25*pi/180.0)
       b(lat) = (a1+a2)/2.0
       acnt=acnt+a(lat)
       bcnt=bcnt+b(lat)
       write (*,999) lat,a(lat),b(lat),a(lat)-b(lat)
      enddo
      print *, ' '
      write(*,998) acnt,bcnt,acnt-bcnt
 998  format ('Total  ',3f20.15)
 999  format ('lat=',i3,3f20.15)
      stop
      end

