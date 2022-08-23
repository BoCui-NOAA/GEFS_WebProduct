      subroutine cvntoc(num,chr)
      character*10 chr
     
      if (num.le.9) then
       write (chr,701) num
      elseif (num.le.99) then
       write (chr,702) num
      elseif (num.le.999) then
       write (chr,703) num
      elseif (num.le.9999) then
       write (chr,704) num
      elseif (num.le.99999) then
       write (chr,705) num
      elseif (num.le.999999) then
       write (chr,706) num
      elseif (num.le.9999999) then
       write (chr,707) num
      elseif (num.le.99999999) then
       write (chr,708) num
      elseif (num.le.999999999) then
       write (chr,709) num
      elseif (num.gt.999999999) then
       write (chr,710) num
      else
       print *, ' problem with cvntoc, verifying please '
      endif

 701  format(i1)
 702  format(i2)
 703  format(i3)
 704  format(i4)
 705  format(i5)
 706  format(i6)
 707  format(i7)
 708  format(i8)
 709  format(i9)
 710  format(i10)
      return
      end
