      subroutine acgrid(y,x,c,weight,lamin,lamax,lomin,lomax,qx4)   
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: CALCULATE AREA-WEIGHTED ANOMALLY CORRELATIONS           C
C            FOR FIELDS X and Y                                      C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: X(145,73)                                               C
C            Y(145,73)                                               C
C            W(73)                                                   C
C                                                                    C
C     OUTPUT:QX4 -- ANOMALY CORREALTIONS                             C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c ---------------------------------------------------------------
c  calculate anomaly correlation on the 2.5-degree grid over a
c  limited area - y=anl,x=fcst,c=climatology
c  using ed epstein's formulas
c  special global version for basu (73 lats) - member acbasu
c ---------------------------------------------------------------
      dimension y(144,73),x(144,73),c(144,73),weight(73),qx4(4)
      sumwt = 0.
      sumcov= 0.
      sumvrx= 0.
      sumvry= 0.
      sumxb = 0.
      sumyb = 0.
      smxbyb= 0.
      sumxbs= 0.
      sumybs= 0.
      cntla=0.
      sumx=0.
      sumy=0.
      do 37 la=lamin, lamax
        cntla=0.
        sumx =0.
        sumy =0.
        sumxy=0.
        sumxx=0.
        sumyy=0.
        do 73 lo=lomin,lomax
          xa=x(lo,la)-c(lo,la)
          ya=y(lo,la)-c(lo,la)
          cntla=cntla + 1.
          sumx = sumx + xa
          sumy = sumy + ya
          sumxy= sumxy+ xa*ya
          sumxx= sumxx+ xa*xa
          sumyy= sumyy+ ya*ya
   73   continue
c       if (la.eq.20) then
c        write(*,'(3f14.7)') x(1,20),sumx/144.0,sumy/144.0
c       endif
c
        xbar = sumx /cntla
        ybar = sumy /cntla
        xybar= sumxy/cntla
        xxbar= sumxx/cntla
        yybar= sumyy/cntla
c - - - - get averages over the current latitude belt
        covla = xybar - xbar*ybar
        varxla= xxbar - xbar*xbar
        varyla= yybar - ybar*ybar
c       covla = xybar                   
c       varxla= xxbar               
c       varyla= yybar               
c - - - - increment weighted sums over all latitudes
        w=weight(la)
        sumwt=sumwt + w
        sumcov = sumcov + w*covla
        sumvrx = sumvrx + w*varxla
        sumvry = sumvry + w*varyla
        sumxb  = sumxb  + w*xbar
        sumyb  = sumyb  + w*ybar
        smxbyb = smxbyb + w*xbar*ybar
        sumxbs = sumxbs + w*xbar*xbar
        sumybs = sumybs + w*ybar*ybar
   37 continue
      cov  = (sumcov + smxbyb- sumxb*sumyb/sumwt)/sumwt
      varx = (sumvrx + sumxbs- sumxb*sumxb/sumwt)/sumwt
      vary = (sumvry + sumybs- sumyb*sumyb/sumwt)/sumwt
c     cov  = (sumcov + smxbyb)/sumwt
c     varx = (sumvrx + sumxbs)/sumwt
c     vary = (sumvry + sumybs)/sumwt
      if( (varx.gt.0.).or.(vary.gt.0.))go to 12
        write(6,101)
        correl=99.
        go to 13
   12 correl = cov/sqrt(varx*vary)
   13 do 10 j = 1,4
   10 qx4(j)=correl
  101 format ( '%%%% trouble in angrid  %%%%')
      return
      end

