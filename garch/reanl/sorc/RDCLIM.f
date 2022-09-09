      Program RDCLIM 
      dimension aa(10512,101)
      do ii = 1, 10512
       read(10) (aa(ii,jj),jj=1,101)
       if (ii.eq.3506) then
        write (*,'(10f7.1)') (aa(ii,jj),jj=1,101)
c       write (*,'(i5,10f7.1)') ii,aa(ii,1)
       endif
      enddo
      stop
      end
