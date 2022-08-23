      subroutine rmsawt(rmsx,ermx,y,x,weight,lamin,lamax,lomin,lomax)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: CALCULATE AREA-WEIGHTED RMS and MEAN ERROR              C
C            FOR FIELDS X and Y                                      C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: X(145,37)                                               C
C            Y(145,37)                                               C
C            W(37)                                                   C
C                                                                    C
C     OUTPUT:RMS                                                     C
C            ERM                                                     C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c--------+----------+----------+----------+----------+----------+----------+--
c ---------------------------------------------------------------
c  calculate area-weighted rms and mean error between fields y and x
c  return single values of rms,erm
c  rms=rms error     erm=mean error
c ---------------------------------------------------------------
      dimension y(144,37),x(144,37),weight(37)
      flodif = lomax-lomin+1
      sumsq  = 0.
      sumerr = 0.
      sumwgt = 0.
      do lat = lamin,lamax
        tlatm  = 0.
        tlatms = 0.
        do lon = lomin,lomax
          error  = x(lon,lat) - y(lon,lat)
          tlatm  = tlatm  + error
          tlatms = tlatms + error*error
        enddo    
        sumsq  = sumsq  + tlatms*weight(lat)
        sumerr = sumerr + tlatm *weight(lat)
        sumwgt = sumwgt + weight(lat)
      enddo    
      rmsx = sqrt((sumsq/sumwgt)/flodif)
      ermx =     (sumerr/sumwgt)/flodif
      return
      end

