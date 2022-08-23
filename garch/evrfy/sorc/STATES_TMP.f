c
c This is main program of MRF ensemble model forecast verification on IBM-SP
c
c  main program    VFMAIN
c
c   subroutine                                                    
c              RMSAWT ---> to get mean error and RMS error
c              LATWMN ---> to get latitude mean values
c              SUMWAV ---> to sum the wave groups
c              ACGRID ---> to calaulate AC using grid values
c              GRD2WV ---> transfor latitude data from grid to wave
c              GET23Y ---> read 23 years Reanalysis data ( GRIB )
c              GETANL ---> read analysis and forecast files ( GRIB )
c              GETGBE ---> read forecast files ( GRIB ) with extension
c              GRANGE ---> to calculate max. and min value of array
c   
c   available climatology:
c      levels--1000,925,850,700,600,500,400,300,250,200,150,100,70,50,30,20,10
c      fields--z,u,v,t and etc.
c
c   special namelist parameter:
c      ic    --icoeff ( 1=grid to wave, 0=grid only )
c
c   Fortran 77 on IBMSP ====== coded by Yuejian Zhu 07/01/99
c
C--------+---------+---------+---------+---------+----------+---------+--
      subroutine states(fanl,fcst,ifd,ilv,ndate,acc,rms,ic,iclim)
      dimension fcst(144,73),fanl(144,73),clim(144,73)
      dimension clim1(144,73),clim2(144,73)
      dimension af(20,73),ao(20,73),ac(20,73)
      dimension bf(21,73),bo(21,73),bc(21,73)
      dimension fnum(20,73),dnm1(20,73),dnm2(20,73)
      dimension q1(4,73),q2(4,73),q3(4,73)
      dimension w1(73),w2(73),w3(73)
      dimension qx1(4),qx2(4),qx3(4),qx4(4),weight(73)
      dimension acc(3,4),rms(3,4)
      dimension lats(3),late(3),lat1(3),lat2(3),lon1(3),lon2(3)
      character*5 chem(3)
      character*7 lhem(3)
      character*1 cfld(200)
      data chem /'N Hem','S Hem','Trop.'/
      data lhem /'20N-80N','20S-80S','20N-20S'/
      data lats / 5,45,29/
      data late /28,68,44/
      data lat1 / 6,45,29/
      data lat2 /29,68,44/
      data lon1 /  1,  1,  1/
      data lon2 /144,144,144/
      cfld     = ' '
      cfld(7)  = 'Z'
      cfld(11) = 'T'
      cfld(33) = 'U'
      cfld(34) = 'V'
c     ifd      = 7
c
c --- calculate the weight ( latitude dependence )
c
      do lat = 37, 73
        j  = lat - 36
        xlat = (2.5*j - 2.5 )/57.296
        weight(j)   = sin(xlat)
        weight(lat) = sin(1.571-xlat)
      enddo    
c
      ac1 = 9.9999
      ac2 = 9.9999
      ac3 = 9.9999
      ac4 = 9.9999
      acc = 9.9999
      rms = 9999.99
      erm = 9999.99
      rmc = 9999.99
      erc = 9999.99
c
c --- check the analysis grid data ( 144*73 = 10512 )
c
       if(fanl(1,1).eq.-9999.99) goto 998
c
c --- check the forecast grid data ( 144*73 = 10512 )
c
       if(fcst(1,1).eq.-9999.99) goto 998
c
c --- get the climatology
c
c     ndate=ndate/100
      print *, 'ndate=',ndate
      jyy = ndate/1000000
      jmm = (ndate-jyy*1000000)/10000
      jdd = (ndate - jyy*1000000 - jmm*10000)/100
      im1 = jmm
      if (jdd.le.15) im2=jmm - 1
      if (im2.lt.1)  im2=im2 + 12
      if (jdd.gt.15) im2=jmm + 1
      if (im2.gt.12) im2=im2 - 12
      percnt = 1.00-abs(temp)
      if (iclim.eq.0) then
c...  Using CPC/Climatology ( if iclim=0 )
       print *, '=== Read climates field ==='
       call getcac(clim1,ifd,ilv,im1)
       call getcac(clim2,ifd,ilv,im2)
      elseif (iclim.eq.1) then
c...  Using CDAS/Reanl 17 years climatology ( grib file )
       print *, '=== Read climates field ==='
       call get23y(clim1,ifd,ilv,im1,ihr,ifh) 
       call get23y(clim2,ifd,ilv,im2,ihr,ifh) 
      else
c...  No climatology data
       print *, '=== No climates field ==='
       clim1=0.0
       clim2=0.0
      endif
      temp=(float(jdd)-15.)/30.
      percnt = 1.00-abs(temp)
      do i = 1,144
       do j = 1,73
        clim(i,j)= clim1(i,j)*percnt+(1.0-percnt)*clim2(i,j)
       enddo
      enddo
c....
      if (ic.eq.1) then      
       do lat = 1, 73
        call grd2wv(fcst(1,lat),af(1,lat),bf(1,lat))
        call grd2wv(fanl(1,lat),ao(1,lat),bo(1,lat))
        call grd2wv(clim(1,lat),ac(1,lat),bc(1,lat))
       enddo    
       do i = 1, 20
        do l = 1, 73
         fnum(i,l)  =(af(i,l)-ac(i,l))*(ao(i,l)-ac(i,l))+
     .               (bf(i,l)-bc(i,l))*(bo(i,l)-bc(i,l))
         dnm1(i,l)  =(af(i,l)-ac(i,l))**2+(bf(i,l)-bc(i,l))**2
         dnm2(i,l)  =(ao(i,l)-ac(i,l))**2+(bo(i,l)-bc(i,l))**2
        enddo
       enddo    
       do l = 1, 73
        call sumwav(fnum(1,l),q1(1,l))
        call sumwav(dnm1(1,l),q2(1,l))
        call sumwav(dnm2(1,l),q3(1,l))
       enddo    
      endif
c....
      do ihem = 1,3
       l1  = lats(ihem)
       l2  = late(ihem)
       la1 = lat1(ihem)
       la2 = lat2(ihem)
       lo1 = lon1(ihem)
       lo2 = lon2(ihem)
       if (ic.eq.1) then
c.....avg over lat band l1-l2, from north pole to south pole 
        do j = 1, 4
         do l = 1, 73
          w1(l)=q1(j,l)
          w2(l)=q2(j,l)
          w3(l)=q3(j,l)
         enddo    
         call latwmn(w1,l1,l2,qx1(j))
         call latwmn(w2,l1,l2,qx2(j))
         call latwmn(w3,l1,l2,qx3(j))
        enddo    
c.....combine terms to get anom corr for this day
        do j = 1, 4
         qx4(j)=qx1(j)/(sqrt(qx2(j))*sqrt(qx3(j)))
        enddo    
       else
        call acgrid(fanl,fcst,clim,weight,la1,la2,lo1,lo2,qx4)
       endif
       call rmsawt(rmsf,ermf,fanl,fcst,weight,la1,la2,lo1,lo2)
       call rmsawt(rmsc,ermc,clim,fanl,weight,la1,la2,lo1,lo2)
c      call rmsawt(rmsc,ermc,clim,fcst,weight,la1,la2,lo1,lo2)
       acc (ihem,1) = qx4(1)
       acc (ihem,2) = qx4(2)
       acc (ihem,3) = qx4(3)
       acc (ihem,4) = qx4(4)
       rms (ihem,1) = rmsf*100.00
       rms (ihem,2) = ermf*100.00
       rms (ihem,3) = rmsc
       rms (ihem,4) = ermc
cc     write (*,999) (qx4(iii),iii=1,4)
      enddo
 998  continue
c999  format (4(f10.4))
      return  
      end
