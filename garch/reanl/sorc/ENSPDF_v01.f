c
c  Main program    ENS_CDF
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2007-08010
c
c   Fortran 77 on IBMSP
c
      program ENDCDF     
      parameter (n=10)
      dimension b(n),q(n),u(n)
C--------+---------+---------+---------+---------+---------+---------+---------+
      data b/11.0, 1.0, 5.0,13.0,17.0,10.0, 8.0,23.0,31.0,12.0/
      data u/ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1/
c     data b/11.0, 5.5, 1.0, 5.0,13.0,17.0,19.5,10.0, 8.0,24.0,23.0,
c    *       31.0,12.0/
c     data u/ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
c    *        0.1, 0.1/
      
      print *, "============= EXAMPLE ==============="
      d=10.5
      q=b
      prob=epdf(q,u,n,d,1)
      print *, "PROB=",prob*100.0," for VALUE=",d

      print *, "============= EXAMPLE ==============="
      d=0.402338
      q=b
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE ==============="
      d=1.5
      q=b
      prob=epdf(q,u,n,d,1)
      print *, "PROB=",prob*100.0," for VALUE=",d

      print *, "============= EXAMPLE =============="
      d=28.0
      q=b
      prob=epdf(q,u,n,d,1)
      print *, "PROB=",prob*100.0," for VALUE=",d

      print *, "============= EXAMPLE ==============="
      d=10.5
      q=b
      q(7)=5.0
      prob=epdf(q,u,n,d,1)
      print *, "PROB=",prob*100.0," for VALUE=",d

      print *, "============= EXAMPLE ==============="
      d=10.5
      q=b
      q(6)=5.0
      q(7)=5.0
      prob=epdf(q,u,n,d,1)
      print *, "PROB=",prob*100.0," for VALUE=",d

      print *, "============= EXAMPLE ==============="
      d=0.1  
      q=b
      value=epdf(q,u,n,d,-1)
      print *, "VALUE=",value," for PROB=",d*100.0

      print *, "============= EXAMPLE =============="
      d=0.5  
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

