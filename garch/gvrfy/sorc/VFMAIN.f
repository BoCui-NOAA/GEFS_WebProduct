c
c This is main program of MRF model forecast verification on IBM-SP
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
c              GRANGE ---> to calculate max. and min value of array
c   
c   available climatology:
c      levels--1000,925,850,700,600,500,400,300,250,200,150,100,70,50,30,20,10
c      fields--z,u,v,t and etc.
c
c   special namelist parameter:
c      ic    --icoeff ( 1=grid to wave, 0=grid only )
c
c   parameter  idmax  ---> maximum days to verification
c
c   Fortran 77 on IBMSP ====== coded by Yuejian Zhu 07/01/99
c
C--------+---------+---------+---------+---------+----------+---------+--
      program VFMAIN
      parameter (idmax=25)
      dimension fcst(144,73),fanl(144,73),clim(144,73)
      dimension ufst(144,73),uanl(144,73),uclm(144,73)
      dimension vfst(144,73),vanl(144,73),vclm(144,73)
      dimension fstt(144,73),fant(144,73),clit(144,73)
      dimension clim1(144,73),clim2(144,73)
      dimension clit1(144,73),clit2(144,73)
      dimension af(20,73),ao(20,73),ac(20,73)
      dimension bf(21,73),bo(21,73),bc(21,73)
      dimension fnum(20,73),dnm1(20,73),dnm2(20,73)
      dimension q1(4,73),q2(4,73),q3(4,73)
      dimension w1(73),w2(73),w3(73)
      dimension qx1(4),qx2(4),qx3(4),qx4(4),weight(73)
      dimension ac1(idmax),ac2(idmax),ac3(idmax),ac4(idmax)
      dimension rms(idmax),erm(idmax),rmc(idmax),erc(idmax)
      dimension iymdh(idmax,5)
      character*5 chem(4)
      character*7 lhem(4)
      character*1 cfld(200)
      character*80 cfilea(2,100),cfilef(2,100),ca1,ca2,cf1,cf2 
      namelist/files/ cfilea,cfilef
      namelist/namin/ ihem,la1,la2,lo1,lo2,l1,l2,nhrs,ifd,ilv,iclim,ic
      data chem /'N Hem','S Hem','Trop.','N Amr'/
      data lhem /'20N-80N','20S-80S','20N-20S','20N-80N'/
      cfld     = ' '
      cfld(7)  = 'Z'
      cfld(11) = 'T'
      cfld(33) = 'U'
      cfld(34) = 'V'
      cfld(101)= 'S'
      cfld(102)= 'V'
      open(unit=51,file='scores.out',err=1020)
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
c     job will be controled by read card
c
      read  (5,files,end=1000)
      write (6,files)
 1000 continue
      read  (5,namin,end=1020)
      write (6,namin)
c
      len = nhrs/24 + 1
c
      ac1 = 9.9999
      ac2 = 9.9999
      ac3 = 9.9999
      ac4 = 9.9999
      rms = 99.99
      erm = 99.99
      rmc = 99.99
      erc = 99.99
c
      do iday = 1,len
       ca1 = cfilea(1,iday)
       ca2 = cfilea(2,iday)
       cf1 = cfilef(1,iday)
       cf2 = cfilef(2,iday)
c      read (ca1,'(9x,i8)') ndatea
       read (ca1,'(7x,i10)') ndatea
       lpgb=len_trim(cf1)  
       if (lpgb.eq.17) then
c       read (cf1,'(9x,i8)') ndatef
        read (cf1,'(7x,i10)') ndatef
        read (cf2,'(4x,i2)') ifh   
       else
c       read (cf1,'(10x,i8)') ndatef
        read (cf1,'(8x,i10)') ndatef
        read (cf2,'(4x,i3)') ifh   
       endif
       ihr  = ndatef - ndatef/100*100
       ndate=ndatef/100
       jyy = ndate/10000
       jy2 = jyy - (jyy/100)*100
       jmm = (ndate-jyy*10000)/100
       jdd = ndate - jyy*10000 - jmm*100
       iymdh(iday,5) = jy2
       iymdh(iday,3) = jmm
       iymdh(iday,4) = jdd
       iymdh(iday,2) = ihr
       iymdh(iday,1) = ifh
c
c --- get the forecast grid data ( 144*73 = 10512 )
c
       print *, '=== Read forecast field ==='
       if (ifd.gt.100) then
        call getanl(ufst,cf1,cf2,33,ilv,ndatef,ifh)
        call getanl(vfst,cf1,cf2,34,ilv,ndatef,ifh)
        if(ufst(1,1).eq.-9999.99) goto 998
        if(vfst(1,1).eq.-9999.99) goto 998
       else
        call getanl(fcst,cf1,cf2,ifd,ilv,ndatef,ifh)
        if(fcst(1,1).eq.-9999.99) goto 998
       endif
c
c --- get the analysis grid data ( 144*73 = 10512 )
c
       print *, '=== Read analysis field ==='
       if (ifd.gt.100) then
        call getanl(uanl,ca1,ca2,33,ilv,ndatea,0)
        call getanl(vanl,ca1,ca2,34,ilv,ndatea,0)
        if(uanl(1,1).eq.-9999.99) goto 998
        if(vanl(1,1).eq.-9999.99) goto 998
       else
        call getanl(fanl,ca1,ca2,ifd,ilv,ndatea,0)
        if(fanl(1,1).eq.-9999.99) goto 998
       endif
c
c --- get the climatology
c
      ndate=ndatea/100
      jyy = ndate/10000
      jmm = (ndate-jyy*10000)/100
      jdd = ndate - jyy*10000 - jmm*100
      im1 = jmm
      if (jdd.le.15) im2=jmm - 1
      if (im2.lt.1)  im2=im2 + 12
      if (jdd.gt.15) im2=jmm + 1
      if (im2.gt.12) im2=im2 - 12
      percnt = 1.00-abs(temp)
      if (iclim.eq.0.and.ifd.lt.100) then
c...  Using CPC/Climatology ( if iclim=0 )
       print *, '=== Read climates field ==='
       call getcac(clim1,ifd,ilv,im1)
       call getcac(clim2,ifd,ilv,im2)
      else
c...  Using CDAS/Reanl 17 years climatology ( grib file )
       print *, '=== Read climates field ==='
       if (ifd.gt.100) then
        call get23y(clim1,33,ilv,im1,ihr,ifh) 
        call get23y(clim2,33,ilv,im2,ihr,ifh) 
        call get23y(clit1,34,ilv,im1,ihr,ifh) 
        call get23y(clit2,34,ilv,im2,ihr,ifh) 
       else
        call get23y(clim1,ifd,ilv,im1,ihr,ifh) 
        call get23y(clim2,ifd,ilv,im2,ihr,ifh) 
       endif
      endif
      temp=(float(jdd)-15.)/30.
      percnt = 1.00-abs(temp)
      do i = 1,144
       do j = 1,73
        clim(i,j)= clim1(i,j)*percnt+(1.0-percnt)*clim2(i,j)
        clit(i,j)= clit1(i,j)*percnt+(1.0-percnt)*clit2(i,j)
       enddo
      enddo
c....
      if (ifd.eq.101) then
       do i = 1, 144
        do j = 1, 73
         fcst(i,j)=sqrt(ufst(i,j)*ufst(i,j)+vfst(i,j)*vfst(i,j))
         fanl(i,j)=sqrt(uanl(i,j)*uanl(i,j)+vanl(i,j)*vanl(i,j))
         clim(i,j)=sqrt(clim(i,j)*clim(i,j)+clit(i,j)*clit(i,j))
        enddo
       enddo
      elseif (ifd.eq.102) then
       do i = 1, 144
        do j = 1, 73
         uerr      = uanl(i,j) - ufst(i,j)
         verr      = vanl(i,j) - vfst(i,j)
         fanl(i,j) = sqrt(uerr*uerr+verr*verr)
         uerr      = clim(i,j) - ufst(i,j)
         verr      = clit(i,j) - vfst(i,j)
         clim(i,j) = sqrt(uerr*uerr+verr*verr)
         fcst(i,j) = 0.0
        enddo
       enddo
      endif
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
     .              (bf(i,l)-bc(i,l))*(bo(i,l)-bc(i,l))
        dnm1(i,l)  =(af(i,l)-ac(i,l))**2+(bf(i,l)-bc(i,l))**2
        dnm2(i,l)  =(ao(i,l)-ac(i,l))**2+(bo(i,l)-bc(i,l))**2
       enddo
      enddo    
      do l = 1, 73
        call sumwav(fnum(1,l),q1(1,l))
        call sumwav(dnm1(1,l),q2(1,l))
        call sumwav(dnm2(1,l),q3(1,l))
      enddo    
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
      if (ifd.eq.102) then
       ac1 (iday) = 0.0
       ac2 (iday) = 0.0
       ac3 (iday) = 0.0
       ac4 (iday) = 0.0
      else
       ac1 (iday) = qx4(1)
       ac2 (iday) = qx4(2)
       ac3 (iday) = qx4(3)
       ac4 (iday) = qx4(4)
      endif
      call rmsawt(rmsf,ermf,fanl,fcst,weight,la1,la2,lo1,lo2)
      call rmsawt(rmsc,ermc,clim,fcst,weight,la1,la2,lo1,lo2)
      rms (iday) = rmsf
      erm (iday) = ermf
      rmc (iday) = rmsc
      erc (iday) = ermc
 998  continue
      enddo
c
c --- write out results
c
      write (51,901) chem(ihem),cfld(ifd),lhem(ihem)
      do i = 1, len
      write (51,902) (iymdh(i,j),j=1,5),ilv,                       
     &               ac1(i),ac2(i),ac3(i),ac4(i)
      enddo
      write (51,903) chem(ihem),cfld(ifd),lhem(ihem)
      do i = 1, len
      write (51,904) (iymdh(i,j),j=1,5),ilv,
     &               rms(i),erm(i),rmc(i),erc(i)
      enddo
      goto 1000
 901  format (/,a5,' AC by Waves (  ',a1,'  ',a7,' )  -       1-3',
     &              '     4-9    10-20    1-20 ')
 902  format (2x,i3,1x,'hrs after =',i2,'Z ',3i3,i5,'mb',3x,4(f7.4,1x))
C--------+---------+---------+---------+---------+----------+---------+--
 903  format (/,a5,' Differences (  ',a1,'  ',a7,' )  -   (F-A)',
     &              'RMS   Mean (F-C)RMS   Mean    ')
 904  format (2x,i3,1x,'hrs after =',i2,'Z ',3i3,i5,'mb',3x,4(f7.2,1x))
c901  format (//,a5,' AC by Waves (  ',a1,'  ',a7,' )  -      1-3',
c    &              '     4-9    10-20    1-20 ',/)
c902  format (2x,i3,1x,'hrs after =',i2,'Z ',3i3,i5,'mb',3x,4(f7.4,1x))
c--------+---------+---------+---------+---------+----------+---------+--
c903  format (//,a5,' Differences (  ',a1,'  ',a7,' )  -      ',
c    &              '(Fcst-Anl)        (Fcst-Clim)    ',/
c    &           5x,'                              -       RMS',
c    &              '     Mean    RMS     Mean '/)
c904  format (2x,i3,1x,'hrs after =',i2,'Z ',3i3,i5,'mb',3x,4(f7.2,1x))
c
 1020 continue
      stop    
      end
