      subroutine nd2ymd(ndate,iyr,imo,idy,ihr)
c
c     calculate year, month and day
c
      iyr  = ndate/1000000
      jyr  = iyr*1000000
      imo  = (ndate-jyr)/10000
      jmo  = imo*10000
      idy  = (ndate-jyr-jmo)/100
      jdy  = idy*100
      ihr  = ndate-jyr-jmo-jdy
      iyr  = iyr - (iyr/100)*100
      return
      end

