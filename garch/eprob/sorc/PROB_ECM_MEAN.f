      PROGRAM AVERAGE
C
C     nm=# of ensemble, nr=# of regions, nb=# of bin + 1
C
      parameter (nm=11,istep=10,nr=6,nb=11)
      dimension anp(nm),anp0(nm,nr)
      dimension fcp(nm),fcp0(nm,nr)
      dimension fp(nm), fp0(nm,nr)
      dimension bsf(nb),bsf0(nb,nr)
      dimension bsc(nb),bsc0(nb,nr)
      dimension bs(nb), bs0(nb,nr)
      dimension hre(nm),hre0(nm,nr)
      dimension fae(nm),fae0(nm,nr)
      dimension hrc(nb),hrc0(nb,nr)
      dimension fac(nb),fac0(nb,nr)
      dimension hrl(nb),hrl0(nb,nr)
      dimension fal(nb),fal0(nb,nr)
      dimension fprob(nm),fprob0(nm,nr)
      dimension trpfs0(nr),trpfc0(nr)
      dimension rpss0(nr)
      dimension ifile(200)

      character*80 cfile(200)
      character*80 ofile

      namelist/filec/ cfile,ofile
      namelist/filei/ ifile
      namelist/namin/ ilen,istymd,iedymd

      data nunit/11/
C--------+---------+---------+---------+---------+---------+---------+---------+
   
      read  (5,filec,end=2000)
 2000 continue
      write (6,filec)

      read  (5,filei,end=2010)
 2010 continue
      write (6,filei)

      read  (5,namin,end=2020)
 2020 continue
      write (6,namin)

      if (nm.eq.11) then
       lskip=138
      else
       lskip=174
      endif
 
      open(unit=51,file=ofile,form='FORMATTED',status='NEW')

      fdays = float(ilen)
 
      do nfcst = 1, istep
       print *, 'nfcst = ',nfcst
       ifh = 24*nfcst
       write(51,1021)ifh
       anp0 = 0.0
       fcp0 = 0.0
       fp0  = 0.0
       hre0 = 0.0
       fae0 = 0.0
       bsf0 = 0.0
       bsc0 = 0.0
       bs0  = 0.0
       hrc0 = 0.0
       hrl0 = 0.0
       fac0 = 0.0
       fal0 = 0.0
       fprob0 = 0.0
       trpfs0 = 0.0
       trpfc0 = 0.0
       rpss0  = 0.0
 
       do nd = 1, ilen   

        print *,' day  = ', nd
        open(unit=nunit,file=cfile(nd),form='FORMATTED',status='OLD')

c       nrec=(nfcst-1)*174
        nrec=(nfcst-1)*lskip
        if ( nrec.gt.0 ) then
         do iii = 1, nrec
          read(nunit,*)
         enddo
        endif
 
        do ndom = 1, nr
         read(nunit,*)
	 read(nunit,1000) ndate,jdate
         print *,ndate,jdate
         call daily(nunit,anp,fcp,fp,bsf,bsc,bs,trpfs,trpfc,rpss,
     .              hre,fae,hrc,fac,hrl,fal,fprob,nd,nm,nb)

         do i = 1, nm
	  anp0(i,ndom) = anp0(i,ndom) + anp(i)/fdays
	  fcp0(i,ndom) = fcp0(i,ndom) + fcp(i)/fdays
	  fp0(i,ndom)  = fp0(i,ndom)  + fp(i)/fdays
	  hre0(i,ndom) = hre0(i,ndom) + hre(i)/fdays
	  fae0(i,ndom) = fae0(i,ndom) + fae(i)/fdays
          fprob0(i,ndom) = fprob0(i,ndom) + fprob(i)/fdays
         enddo

         do i = 1, nb
	  bsf0(i,ndom) = bsf0(i,ndom) + bsf(i)/fdays
	  bsc0(i,ndom) = bsc0(i,ndom) + bsc(i)/fdays
	  bs0(i,ndom)  = bs0(i,ndom)  + bs(i)/fdays
	  hrc0(i,ndom) = hrc0(i,ndom) + hrc(i)/fdays
	  fac0(i,ndom) = fac0(i,ndom) + fac(i)/fdays
	  hrl0(i,ndom) = hrl0(i,ndom) + hrl(i)/fdays
	  fal0(i,ndom) = fal0(i,ndom) + fal(i)/fdays
	 enddo

	 trpfs0(ndom) = trpfs0(ndom) + trpfs/fdays
	 trpfc0(ndom) = trpfc0(ndom) + trpfc/fdays
	 rpss0(ndom)  = rpss0(ndom)  + rpss/fdays

        enddo

        close(nunit)

       enddo        ! do nd = 1, ilen
 
       do ndom = 1, nr
        if (ndom.eq.1) write(51,1011)
        if (ndom.eq.2) write(51,1012)
        if (ndom.eq.3) write(51,1013)
        if (ndom.eq.4) write(51,1014)
        if (ndom.eq.5) write(51,1015)
        if (ndom.eq.6) write(51,1016)
        call wrout(anp0(1,ndom),fcp0(1,ndom),fp0(1,ndom),bsf0(1,ndom),
     .             bsc0(1,ndom),bs0(1,ndom),trpfs0(ndom),trpfc0(ndom),
     .             rpss0(ndom),hre0(1,ndom),fae0(1,ndom),hrc0(1,ndom),
     .             fac0(1,ndom),hrl0(1,ndom),fal0(1,ndom),
     .             fprob0(1,ndom),nm,nb)

        write(52,1031) (fp0(i,ndom),i=1,nm)
       enddo
      enddo         ! do nfcst = 1, 30/32
 
 1000 format(22x,i10,7x,i10)
 1001 format(11f6.0)
c 1000 format('SCORES  AT VALID TIME ',i8,
c     &' (ic : ',i8,')')
 1011 format(' ---------- Northern Hemisphere --------------')
 1012 format(' ----------Southern Hemisphere --------------')
 1013 format(' ----------     Tropics   --------------')
 1014 format(' ---------- N. America   --------------')
 1015 format(' -------------Europe------------------')
 1016 format(' ----------     India   --------------')
 1021 format('Verification for ',i4,' hour forecasts')
 1031 format(21f6.1)
 
      stop
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine daily(nunit,anp,fcp,fp,bsf,bsc,bs,trpfs,trpfc,rpss,
     &                 hre,fae,hrc,fac,hrl,fal,fprob,nd,nm,nb)
      dimension anp(*),fcp(*),fp(*), bsf(*),bsc(*),bs(*)
      dimension hre(*),fae(*),hrc(*),fac(*),hrl(*),fal(*) 
      dimension fprob(*)
c
c     print *, 'start daily reading'
      read(nunit,*)
      read(nunit,1001)(anp(i),i=1,nm)
      read(nunit,1001)(fcp(i),i=1,nm)
      read(nunit,*)
      read(nunit,1001)(fprob(i),i=1,nm)
      read(nunit,1001)(fp(i),i=1,nm)
c
      read(nunit,*)
      read(nunit,1002)(bsf(i),i=1,nb)
      read(nunit,1002)(bsc(i),i=1,nb)
      read(nunit,1002)(bs(i),i=1,nb)
c
      read(nunit,1009)trpfs,trpfc
      read(nunit,1010)rpss
c
      read(nunit,*)
      read(nunit,1022)(hre(np),np=1,nm)
      read(nunit,1022)(fae(np),np=1,nm)
c
      read(nunit,*)
      read(nunit,1002)(hrc(np),np=1,nb)
      read(nunit,1002)(fac(np),np=1,nb)
c
      read(nunit,*)
      read(nunit,1002)(hrl(np),np=1,nb)
      read(nunit,1002)(fal(np),np=1,nb)
c
 1001 format(11f6.0)
 1002 format(11f6.3)
 1022 format(11f6.3)
 1003 format(11i6)
 1004 format(' RELIABILITY DIAGRAM  ')
 1005 format(' BRIER SCORES  ')
 1006 format(' HIT RATES AND FALSE ALARMS OF ENSEMBLE FORECASTS')
 1007 format(' HIT RATES AND FALSE ALARMS FOR MRF ')
 1008 format(' HIT RATES AND FALSE ALARMS FOR LOW RESOLUTION MODEL')
 1009 format(29x,2F6.3)
 1010 format(34x,E15.8)

      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine wrout(anp,fcp,fp,bsf,bsc,bs,trpfs,trpfc,rpss,
     .                 hre,fae,hrc,fac,hrl,fal,fprob,nm,nb)
      dimension anp(nm),fcp(nm),fp(nm), bsf(nb),bsc(nb),bs(nb)
      dimension hre(nm),fae(nm),hrc(nb),fac(nb),hrl(nb),fal(nb) 
      dimension fprob(nm)
 
      write(51,1004)
      write(51,1011)(anp(i),i=1,nm)
      write(51,1011)(fcp(i),i=1,nm)
      write(51,1024)
      write(51,1001)(fprob(i),i=1,nm)
CCCC----- Modefied by Yuejian Zhu (97/07/16)
      do ii=1,nm
       if (fcp(ii).eq.0.0) then
        print *, "fcp=",fcp(ii)
        fp(ii)=0.0
       else
        fp(ii)=anp(ii)/fcp(ii)*100.00
       endif
      enddo
CCCC----- End of modified
      write(51,1001)(fp(i),i=1,nm)
      write(51,1005)
      write(51,1002)(bsf(i),i=1,nb)
      write(51,1002)(bsc(i),i=1,nb)
      write(51,1002)(bs(i),i=1,nb)
      write(51,1009)trpfs,trpfc
      write(51,1010)rpss
      write(51,1006)
      write(51,1002)(hre(np),np=1,nm)
      write(51,1002)(fae(np),np=1,nm)
      write(51,1007)
      write(51,1002)(hrc(np),np=1,nb)
      write(51,1002)(fac(np),np=1,nb)
      write(51,1008)
      write(51,1002)(hrl(np),np=1,nb)
      write(51,1002)(fal(np),np=1,nb)

 1001 format(11f6.1)
 1011 format(11f6.0)
 1002 format(11f6.3)
 1003 format(11i6)
 1004 format(' RELIABILITY DIAGRAM  ')
 1005 format(' BRIER SCORES  ')
 1006 format(' HIT RATES AND FALSE ALARMS OF ENSEMBLE FORECASTS')
 1007 format(' HIT RATES AND FALSE ALARMS FOR MRF ')
 1008 format(' HIT RATES AND FALSE ALARMS FOR LOW RESOLUTION MODEL')
 1009 format(' RANKED PROBABILITY SCORES = ',2F6.3)
 1010 format(' RANKED PROBABILITY SKILL SCORE = ',E15.8)
 1024 format(' FORECAST PROBABILITY ')
      return
      end
