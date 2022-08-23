      subroutine getcac (cnh,csh,ifld,imon,ilev,iunit)
      dimension cnh(145,37),csh(145,37)
c
      jlev = ilev
      if (ilev.eq.4) jlev=2
      icnt = imon  + (jlev - 1)*12
      if (icnt.eq.1) goto 101
      do 100 i = 1, icnt - 1
      read (iunit)
 100  continue
 101  continue
      read (iunit) im,il,cnh
      write (6,991) im,il
      write (6,991) imon,ilev
 991  format ('===  month is ',i4,' ====',' level is ',i4,' ====')
      do 200 i = 1, 37
       do 200 j = 1, 145
      csh(j,i) = cnh(j,i)
 200  continue
      close(iunit)
      return
      end
