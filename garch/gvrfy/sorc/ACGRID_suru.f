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
      dimension coslat(74),covla(74),varxla(74),varyla(74)
c
        nlat=lamax-lamin+1
        pi=3.14159265358
c
        lt = 0
        sumlat = 0.0
        do la=lamin-1, lamax-1
        lt = lt + 1
        coslat(lt) = 0.0
        alatx = 91.25 - float(la)*2.5
        alat = alatx * pi/180.0
        clat = cos(alat)
        coslat(lt) = clat * 0.5
        sumlat = sumlat + clat
        enddo
c
c       latex=lamax+1
        latex=lamax
c       if(lamax.eq.73) latex=73
        if(lamax.eq.73) latex=72
        lt = 0
      do 37 la=lamin-1, latex
        lt = lt + 1
        cntla=0.
        sumxy=0.
        sumxx=0.
        sumyy=0.

        do 73 lo=lomin,lomax
          xa=x(lo,la)-c(lo,la)
          ya=y(lo,la)-c(lo,la)
          cntla=cntla + 1.
          sumxy= sumxy+ xa*ya
          sumxx= sumxx+ xa*xa
          sumyy= sumyy+ ya*ya
   73   continue
c
        covla(lt)= sumxy/cntla
        varxla(lt)= sumxx/cntla
        varyla(lt)= sumyy/cntla
c
   37   continue
c
c - - - - increment weighted sums over all latitudes
        sumcov= 0.
        sumvrx= 0.
        sumvry= 0.
        latex=nlat+1
        if(nlat.eq.73) latex=73
c     do 38 lt=2, latex
c       sumcov = sumcov + coslat(lt-1) * (covla(lt)+covla(lt-1))
c       sumvrx = sumvrx + coslat(lt-1) * (varxla(lt)+varxla(lt-1))
c       sumvry = sumvry + coslat(lt-1) * (varyla(lt)+varyla(lt-1))
c  38 continue
      do 38 lt=1, nlat    
        sumcov = sumcov + coslat(lt) * (covla(lt+1)+covla(lt))
        sumvrx = sumvrx + coslat(lt) * (varxla(lt+1)+varxla(lt))
        sumvry = sumvry + coslat(lt) * (varyla(lt+1)+varyla(lt))
   38 continue
      cov  = sumcov/sumlat
      varx = sumvrx/sumlat
      vary = sumvry/sumlat
c
      if( (varx.gt.0.).or.(vary.gt.0.))go to 12
        write(6,101)
        correl=99.
        go to 13
   12 correl = cov/sqrt(varx*vary)
   13 do 10 j = 1,4
   10 qx4(j)=correl
  101 format ( '%%%% trouble in angrid  %%%%')
c
      return
      end
