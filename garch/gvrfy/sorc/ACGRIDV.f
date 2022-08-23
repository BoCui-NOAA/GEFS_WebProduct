      subroutine acgridv(yu,yv,xu,xv,cu,cv,
     *                  weight,lamin,lamax,lomin,lomax,qx4)   
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: CALCULATE AREA-WEIGHTED ANOMALLY CORRELATIONS           C
C            FOR FIELDS WIND VECTOR X and Y                          C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                             Yuejian Zhu (06/19/00)                 C
C                                                                    C
C     INPUT: XU(145,73) -- U forecast                                C
C            XV(145,73) -- V forecast                                C
C            YU(145,73) -- U analysis                                C
C            YV(145,73) -- V analysis                                C
C            CU(145,73) -- U climate                                 C
C            CV(145,73) -- V climate                                 C
C            W(73)      -- Weighting function                        C
C                                                                    C
C     OUTPUT:QX4 -- ANOMALY CORRELATIONS                             C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c ---------------------------------------------------------------
c   calculate anomaly correlation on the 2.5-degree grid over a
c   limited area - y=anl,x=fcst,c=climatology
c   using ed epstein's formulas
c   special global version for basu (73 lats) - member acbasu
c ---------------------------------------------------------------
      dimension yu(144,73),xu(144,73),cu(144,73),weight(73),qx4(4)
      dimension yv(144,73),xv(144,73),cv(144,73)
      sumwt  = 0.
      sumcov = 0.
      sumvrx = 0.
      sumvry = 0.
      sumxbu = 0.
      sumxbv = 0.
      sumybu = 0.
      sumybv = 0.
      smxbyb = 0.
      sumxbs = 0.
      sumybs = 0.
      cntla  = 0.
      do 37 la=lamin, lamax
       cntla = 0.
       sumxu = 0.
       sumxv = 0.
       sumyu = 0.
       sumyv = 0.
       sumxy = 0.
       sumxx = 0.
       sumyy = 0.
       do 73 lo=lomin,lomax
        xau = xu(lo,la) - cu(lo,la)
        xav = xv(lo,la) - cv(lo,la)
        yau = yu(lo,la) - cu(lo,la)
        yav = yv(lo,la) - cv(lo,la)
        cntla = cntla + 1.
        sumxu = sumxu + xau
        sumxv = sumxv + xav
        sumyu = sumyu + yau
        sumyv = sumyv + yav
        sumxy = sumxy + xau*yau + xav*yav
        sumxx = sumxx + xau*xau + xav*xav
        sumyy = sumyy + yau*yau + yav*yav
   73  continue
c
       xbaru = sumxu/cntla
       xbarv = sumxv/cntla
       ybaru = sumyu/cntla
       ybarv = sumyv/cntla
       xybar = sumxy/cntla
       xxbar = sumxx/cntla
       yybar = sumyy/cntla
c - - - - get averages over the current latitude belt
       covla = xybar - (xbaru*ybaru + xbarv*ybarv)
       varxla= xxbar - (xbaru*xbaru + xbarv*xbarv)
       varyla= yybar - (ybaru*ybaru + ybarv*ybarv)
c - - - - increment weighted sums over all latitudes
       w      = weight(la)
       sumwt  = sumwt  + w
       sumcov = sumcov + w*covla
       sumvrx = sumvrx + w*varxla
       sumvry = sumvry + w*varyla
       sumxbu = sumxbu + w*xbaru
       sumxbv = sumxbv + w*xbarv
       sumybu = sumybu + w*ybaru
       sumybv = sumybv + w*ybarv
       smxbyb = smxbyb + w*(xbaru*ybaru + xbarv*ybarv)
       sumxbs = sumxbs + w*(xbaru*xbaru + xbarv*xbarv)
       sumybs = sumybs + w*(ybaru*ybaru + ybarv*ybarv)
   37 continue
c--------+---------+---------+---------+---------+---------+---------+---------+
      cov  = (sumcov+smxbyb-(sumxbu*sumybu+sumxbv*sumybv)/sumwt)/sumwt
      varx = (sumvrx+sumxbs-(sumxbu*sumxbu+sumxbv*sumxbv)/sumwt)/sumwt
      vary = (sumvry+sumybs-(sumybu*sumybu+sumybv*sumybv)/sumwt)/sumwt
      if(varx.gt.0..or.vary.gt.0.) goto 12
      write(6,101)
      correl=99.
      goto 13
   12 correl = cov/sqrt(varx*vary)
   13 do 10 j = 1,4
   10 qx4(j)=correl
  101 format ( '%%%% trouble in acgridv %%%%')

      return
      end

