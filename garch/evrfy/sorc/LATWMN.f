      subroutine latwmn(w,l1,l2,wmean)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: LATITUDE WEIGHT MEAN OVER l1 and l2                     C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: w(73), L1 and L2                                        C
C            ihem = 1 Northern Hemisphere                            C
C            ihem = 2 Northern Hemisphere                            C
C                                                                    C
C     OUTPUT: wmean over L1 and L2                                   C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension w(73)
      data pi/3.14159/
c
c 
      rad = 180.0/pi
      wmean = 0.0
      dl    = 0.0
      dlat  = pi*2.5/180.
      do 100 l=l1,l2
      alat=(float(l)-.5)*2.5*pi/180.
c     if(ihem.eq.2) alat=alat-(90.0/rad)
      wmean=wmean+sin(alat)*dlat*.5*(w(l)+w(l+1))
      dl=dl+sin(alat)*dlat
  100 continue
      wmean=wmean/dl
      return
      end

