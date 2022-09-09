c
c  Main program    ENS_CDF
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2007-08010
c
c   Fortran 77 on IBMSP
c
      program ENDCDF     
      parameter (n=40)
      dimension b(n),q(n),u(n)
C--------+---------+---------+---------+---------+---------+---------+---------+
c     data b/11.0, 1.0, 5.0,13.0,17.0,10.0, 8.0,23.0,31.0,12.0/
c     data u/ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1/
c     data b/11.0, 5.5, 4.5, 5.0,13.0,17.0,19.5, 6.2, 5.8,24.0,23.0,
c    *       31.0,12.0/
c     data u/ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
c    *        0.1, 0.1/
      data b/51.10,62.20,53.20,50.20,54.10,56.10,58.00,52.20,53.30,54.80
     *      ,51.30,62.10,58.20,54.90,55.20,56.80,54.60,57.50,60.10,59.60
     *      ,87.00,80.00,88.00,88.00,74.00,85.00,87.00,85.00,90.00,87.00
     *      ,85.00,90.00,77.00,85.00,86.00,84.00,90.00,79.00,88.00,81.00
     *      /

      u=1.0
      
      print *, "============= EXAMPLE ==============="
      d=0.1  
      q=b
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE ==============="
      d=0.5  
      q=b
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE ==============="
      d=0.51 
      q=b
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE ==============="
      d=0.512 
      q=b
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE =============="
      d=0.9     
      q=b
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      stop
      end

