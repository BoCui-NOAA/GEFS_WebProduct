      program TEST
      dimension en(17)        
      data en/10.1, 5.6,18.5,99.3, 0.2,12.7,47.5,44.3,50.5, 0.9,
     &        11.8,19.3,31.6,89.1,55.0,10.9,12.0/
      call spread(17,en,ave,spr,1)
      print *, 'ave=',ave,' spr=',spr
      call spread(17,en,ave,spr,2)
      print *, 'ave=',ave,' spr=',spr
      call spread(17,en,ave,spr,3)
      print *, 'ave=',ave,' spr=',spr
      call spread(17,en,ave,spr,4)
      print *, 'ave=',ave,' spr=',spr
      stop
      end
