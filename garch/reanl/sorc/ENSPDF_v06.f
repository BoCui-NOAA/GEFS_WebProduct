c
c  Main program    ENS_CDF
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2007-08010
c
c   Fortran 77 on IBMSP
c
      program ENDCDF     
      parameter (n=20)
      dimension b(n),q(n),u(n)
C--------+---------+---------+---------+---------+---------+---------+---------+
c     data b/11.0, 1.0, 5.0,13.0,17.0,10.0, 8.0,23.0,31.0,12.0/
c     data u/ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1/
      data b/5844.7,5848.9,5849.4,5852.4,5853.8,5854.7,5854.9,5855.2
     *      ,5855.4,5855.7,5856.2,5856.9,5857.4,5858.1,5858.9,5859.6
     *      ,5860.4,5861.0,5862.0,5863.0/
c     data b/5848.4,5850.4,5851.3,5855.2,5855.5,5856.1,5856.4,5857.2
c    *      ,5857.8,5858.0,5858.0,5859.2,5859.8,5860.5,5861.7,5862.6
c    *      ,5863.6,5863.9,5864.0,5866.1/
c     data b/5845.6,5850.5,5851.4,5853.0,5853.2,5854.5,5855.4,5856.4
c    *      ,5856.7,5856.7,5857.5,5857.7,5857.7,5858.4,5858.4,5858.8
c    *      ,5860.0,5862.6,5862.8,5862.9/
c     data b/301.7,301.9,301.9,301.6,301.6,301.4,301.4,301.6,301.7,301.7
c    *     ,301.6,301.6,301.6,301.5,301.8,301.8,301.7,301.6,301.8,301.8/
c     data b/301.6,301.2,301.6,301.7,301.5,301.4,301.0,301.3,301.6,301.6 
c    *     ,301.4,301.2,301.7,301.2,301.6,301.5,301.8,301.7,301.2,301.7/
c     data b/11.0, 5.5, 1.0, 5.0,13.0,17.0,19.5,10.0, 8.0,24.0,23.0,
c    *       31.0,12.0/
c     data u/ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
c    *        0.1, 0.1/
      u=0.05
      
      print *, "============= EXAMPLE =============="
      d=0.5  
      q=b*1.0
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE =============="
      d=0.1  
      q=b*1.0
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE =============="
      d=0.9  
      q=b*1.0
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE =============="
      d=1.0  
      q=b*1.0
      value=epdf(q,u,n,d,0)
      print *, "VALUE=",value," for PROB=",d*100.0

      stop
      end

