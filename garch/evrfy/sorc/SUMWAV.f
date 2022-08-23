      subroutine sumwav(w,y)   
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: SUM 20 WAVES TO 4 GROUPS                                C
C            group 1: wave 1-3                                       C
C            group 2: wave 4-9                                       C
C            group 3: wave 10-20                                     C
C            group 4: wave 1-20                                      C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: w(20)                                                   C
C                                                                    C
C     OUTPUT: y(4)                                                   C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension w(20),y(4)
      do 100 k=1,4
      y(k)=0.0
  100 continue
      do 200 k=1,3
      y(1)=y(1)+w(k)
  200 continue
      do 300 k=4,9
      y(2)=y(2)+w(k)
  300 continue
      do 400 k=10,20
      y(3)=y(3)+w(k)
  400 continue
      do 500 k=1,20
      y(4)=y(4)+w(k)
  500 continue
      return
      end

