      program fstprt
      dimension fcst(10512,14)
      dimension fmrf(10512),ft62(10512),favn(10512)
      character*80 cpgb,cpgi

c     cpgb='/ptmp/wx20yz/xxx/z500.99012900'
c     cpgi='/ptmp/wx20yz/xxx/z500i.99012900'
c     
c     call getgrb(fcst,fmrf,ft62,favn,cpgb,cpgi,7,500,    
c    *            1999012900,1999012812,0,10)
c     ipoint=2969
c     write(6,999) ipoint,(fcst(ipoint,i),i=1,7)
c     write(6,999) ipoint,(fcst(ipoint,i),i=8,14)

c     call getgrb(fcst,fmrf,ft62,favn,cpgb,cpgi,7,500,    
c    *            1999012900,1999012812,12,10)
c     ipoint=2969
c     write(6,999) ipoint,(fcst(ipoint,i),i=1,7)
c     write(6,999) ipoint,(fcst(ipoint,i),i=8,14)

c     call getgrb(fcst,fmrf,ft62,favn,cpgb,cpgi,7,500,    
c    *            1999012900,1999012812,204,10)
c     ipoint=1814
c     write(6,999) ipoint,(fcst(ipoint,i),i=1,7)
c     write(6,999) ipoint,(fcst(ipoint,i),i=8,14)

      cpgb='/ptmp/wx20yz/xxx/z500.99020612'
      cpgi='/ptmp/wx20yz/xxx/z500i.99020612'

      call getgrb(fcst,fmrf,ft62,favn,cpgb,cpgi,7,500,    
     *            1999020612,1999020600,0,10)
      ipoint=1814
      write(6,999) ipoint,(fcst(ipoint,i),i=1,7)
      write(6,999) ipoint,(fcst(ipoint,i),i=8,14)
      
      
 999  format(i5,1x,7f8.1)
      stop
      end
