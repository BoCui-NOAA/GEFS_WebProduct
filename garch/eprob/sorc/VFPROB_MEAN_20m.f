      PROGRAM AVERAGE
C
C     nm=# of ensemble, nr=# of regions, nb=# of bin + 1
C
      parameter (nm=21,istep=30,nr=6,nb=11)
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
      dimension hr(nm), fa(nm)
      dimension fv(18)

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
       ifh = 12*nfcst
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

c       print *,' day  = ', nd
cccc    changed status to unknown since 2003/03/12 -- Yuejian Zhu
c       open(unit=nunit,file=cfile(nd),form='FORMATTED',status='OLD')
C--------+---------+---------+---------+---------+---------+---------+---------+
       open(unit=nunit,file=cfile(nd),form='FORMATTED',status='UNKNOWN')

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
c        print *,ndate,jdate
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
C
C  Temperally for Toth Zoltan ( 03/14/2002 )
C
         cprob = 0.0
         tfst  = 0.0
         do ii = 1, nm
          tfst = tfst + fcp(ii)
         enddo
         do ii = 1, nm
          cprob = cprob + anp(ii)/tfst
         enddo

         creso = 0.0
         do ii = 1, nm
          if (fcp(ii).ne.0.0) then
          ctmp =float((ii-1)*(nm-1))/100.0-anp(ii)/fcp(ii)
          creli = creli + fcp(ii)*ctmp*ctmp/tfst
          ctmp  = anp(ii)/fcp(ii) - cprob
c         write(*,'(f20.8)') ctmp
          creso = creso + fcp(ii)*ctmp*ctmp/tfst
          endif
         enddo
         if (ndom.eq.1.and.nfcst.eq.10) then
          write(*,'("xxxx ",i4,f10.5)') nd,creso
         endif

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

c
c      calculate sample climatology probability
c
         cprob = 0.0
         tfst  = 0.0
         do ii = 1, nm
          tfst = tfst + fcp0(ii,ndom)
         enddo
         do ii = 1, nm
          cprob = cprob + anp0(ii,ndom)/tfst
         enddo

       write(*,'(2f20.8)') tfst,cprob

c
c      calculate the BS = reliability + resolution + uncertainty
c
         creli = 0.0
         creso = 0.0
         cunce = 0.0

         do ii = 1, nm
          if (fcp0(ii,ndom).ne.0.0) then
cccc notes from Yuejian Zhu (05/11/2005) 
c         ctmp =float((ii-1)*(nm-1))/100.0-anp0(ii,ndom)/fcp0(ii,ndom)
          ctmp =float(ii-1)/float(nm-1)-anp0(ii,ndom)/fcp0(ii,ndom)
c         write(*,'(3f20.8)') ctmp,anp0(ii,ndom),fcp0(ii,ndom)         
          creli = creli + fcp0(ii,ndom)*ctmp*ctmp/tfst
          ctmp  = anp0(ii,ndom)/fcp0(ii,ndom) - cprob
c         write(*,'(f20.8)') ctmp         
          creso = creso + fcp0(ii,ndom)*ctmp*ctmp/tfst
          endif
         enddo

         cunce = cprob*(1.0 - cprob)
         cssco = (creso - creli)/cunce

         write(*,'(i2,5x,4f10.3)') nfcst,creli,creso,cunce,cssco
c        print *,                  nfcst,creli,creso,cunce,cssco

c
c      calculate the economic value by calling subroutine EVALUE.f
c

         do i = 1, nm
          hr(i) = hre0(i,ndom)
          fa(i) = fae0(i,ndom)
         enddo

         write (*,'(20f4.2)') (hr(i),i=1,nm-1)
         write (*,'(20f4.2)') (fa(i),i=1,nm-1)
         call evalue(hr,fa,nm,fv)

         evaln9 = fv(9)
         write (*,'(10f7.4)') (fv(i),i=4,13)

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
     .             fprob0(1,ndom),nm,nb,
     .             creli,creso,cunce,cssco,evaln9)

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
c     read(nunit,1001)(fprob(i),i=1,nm)
c     read(nunit,1001)(fp(i),i=1,nm)
      read(nunit,1003)(fprob(i),i=1,nm)
      read(nunit,1003)(fp(i),i=1,nm)
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
 1003 format(11f6.1)
c1003 format(11i6)
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
     .                 hre,fae,hrc,fac,hrl,fal,fprob,nm,nb,
     .                 creli,creso,cunce,cssco,evaln9)
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
      write(51,1009)trpfs,trpfc,creli,creso,cunce,cssco
      write(51,1010)rpss,evaln9
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
 1009 format(' RANKED PROBABILITY SCORES = ',6F6.3)
 1010 format(' RANKED PROBABILITY SKILL SCORE = ',2E15.8)
 1024 format(' FORECAST PROBABILITY ')
      return
      end

       subroutine evalue(hr,far,im1,fv)
c
c      This program will calculate the economic value of forecasts
c      copied from ~wd20zt/value/value.f of sgi machine
c      modified by Yuejian Zhu    (02/09/2001)
c

c      xml    - mitigrated loss
c      xc     - cost
c      xl     - loss
c      clfr   - climate frequency of forecast
c

       parameter (clfr=0.1,im=100,icl=18)
c      dimension hr(*),   far(*),     v(11,2), xmefc(im)
       dimension hr(*),   far(*),     v(im1,2), xmefc(im)
       dimension xml(icl), xc(icl), xl(icl),     fv(icl)

ccc... data for assume xml, xc and xl for totally 18 levels
       data xml/1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,
     *          1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00/
       data xc /1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,
     *          1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00/
       data xl /1.05,1.10,1.25,1.50,2.00,3.00,5.00,8.00,10.0,
     *          18.0,27.0,40.0,60.0,90.0,140.,210.,350.,500./

ccc... loop over cost/loss ratios

        do j = 1, 18

         do i = 1, im1
          v(i,1) = i
         enddo 

c
c              |       Yes           |        No
c       ----------------------------------------------------
c         YES  |  h(its)             |   m(isses)
c              |  M(itigated) L(oss) |   L(oss)
c       ----------------------------------------------------
c         NO   |  f(alse alarms)     |   c(orrect rejections)
c              |  C(ost)             |   N(o cost)
c       ----------------------------------------------------
c
c       Mean Expense (general forecast) = h*ML + m*L + f*C
c       Mean Expense (perfect forecast) = o*ML
c       Mean Expense (climate forecast) = min[o*L,o*ML + (1-o)*C]
c        o     - climatological frequency
c        ML    - Mitigated Loss
c        C     - Cost
c        L     - Loss
c        h     - hites
c        m     - misses
c        f     - false alarms
c
c      Value = (ME(cl) - ME(fc))/(ME(cl) - ME(perf))

c      xmecl   - mean expense for climate forecast
c      xmeperf - mean expense for perfect forecast
c      xmehr   - mean expense for high resolution forecast 
c
c      xme1    - loss from climatological frequency  [ o*L ]
c      xme2    - loss from cost and mitigated loss [ o*ML + (1-o)*C ]
c       if xme2.lt.xme1    means need protect ( always )
c       if xme2.ge.xme1    means need giveup  ( never  )
c
         xme1 = clfr*xl(j)
         xme2 = clfr*xml(j)+(1-clfr)*xc(j)
         xme  = xme1
         if(xme2.lt.xme1) xme=xme2

c        if(xme2.lt.xme1) print *,'always protect'
         if(xme2.lt.xme1) np=1

c        if(xme2.ge.xme1) print *,'never  protect'
         if(xme2.ge.xme1) np=0

         xmecl  = xme
         xmeperf= clfr*xml(j)
c        print *, 'ens'
c  loop over ens probabilities
         do i = 1, im1
          xmefc(i) = clfr*hr(i)*xml(j) 
     *             + clfr*(1-hr(i))*xl(j)
     *             + (1-clfr)*far(i)*xc(j)
          v(i,2)   = (xmecl-xmefc(i))/(xmecl-xmeperf)
c         print *,v(i,2)
         enddo     

         call sortm(v,im1,2,2)

         fv(j) = v(im1,2)
         write(6,66)  kd,1./xl(j),np,v(im1,2),v(im1,1)
        enddo               ! do j = 1, 18

        write(6,67)
 66    format(1x,i2,f7.4,i2,2f8.3)
 67    format(1x)

       return
       end
C   generalized version of sort subroutine for multidim. arrays
C
C   a(n,nc) array of n rows, nc columns to be sorted by column k
C
C
      SUBROUTINE SORTm(A, N,nc,k)
      PARAMETER (M=50)
      INTEGER N, I, J, L, R, S, STACK(M, 2)
      REAL A(n,nc), X, W
C
      S = 1
      STACK(1, 1) = 1
      STACK(1, 2) = N
  100 CONTINUE
C  SIMULATE OUTER REPEAT LOOP ...
          L = STACK(S, 1)
          R = STACK(S, 2)
          S = S - 1
  200     CONTINUE
C  SIMULATE MIDDLE REPEAT LOOP ...
              I = L
              J = R
c   change last # for column to be sorted *********
              X = A ((L+R)/2, k)
  300         CONTINUE
C  SIMULATE INNER REPEAT LOOP
  400             CONTINUE
C  SIMULATE WHILE LOOP
c   change #  **************************************
                  IF (A(I, k).LT.X) THEN
                      I = I + 1
                      GOTO 400
                  ENDIF
  500             CONTINUE
C  SIMULATE WHILE LOOP
c   change #  **************************************
                  IF (X.LT.A(J, k)) THEN
                      J = J -1
                      GOTO 500
                  ENDIF
                  IF (I.LE.J) THEN
c  2nd # is total # of columns **********************
                      do 1000 icol = 1, nc, 1
                          W    = A(I, icol)

                          A(I, icol) = A(J, icol)
                          A(J, icol) = W
 1000                 continue
                      I = I + 1
                      J = J - 1
                  ENDIF
C  END OF INNER REPEAT LOOP
              IF (I.LE.J) GOTO 300
              IF (I.LT.R) THEN
                  S = S + 1
                  IF (S.GT.M) THEN
                      PRINT *, 'STACK OVERFLOW IN QSORT'
                      STOP 'STACK OVF'
                  ENDIF
                  STACK(S, 1) = I
                  STACK(S, 2) = R
              ENDIF
              R = J
C  END OF MIDDLE REPEAT LOOP
          IF (L.LT.R) GOTO 200
C  END OF OUTER REPEAT LOOP
      IF (S.GT.0) GOTO 100
      RETURN
      END

