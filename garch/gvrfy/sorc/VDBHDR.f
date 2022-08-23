      subroutine vdbhdr(vdbhdr132,len,chd)                             
c
c     chd(1): header field 1: verification database version
c     chd(2): header field 2: forecast model verified
c     chd(3): header field 3: forecast hours
c     chd(4): header field 4: verifying date
c     chd(5): header field 5: verifying data source or analysis
c     chd(6): verifying grid or region
c     chd(7): statistic type
c     chd(8): parameter identifier
c     chd(9): level identifier
c
      character*132 vdbhdr132
      character*10 chd(9)

      led=0
      do ii = 1, 9
       len=len_trim(chd(ii))
       lst=led+1
       led=led+len
       vdbhdr132(lst:led) = chd(ii)(1:len)
       lst=led+1
       led=led+1
       vdbhdr132(lst:led) = " "    
      enddo
c     len=len_trim(vdbhdr132)
      len=led-1                      
      return
      end
