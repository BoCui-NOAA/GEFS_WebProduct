      dimension fcpd(9),fcpm(10) 
      dimension fcpm2(3,2),fcpm3(5,2),fcpm4(7,2),fcpm5(9,2)
      dimension fcpm33(5,2)
      dimension fcpm22(3,2),bimodg(144,73)
      dimension fm(10,3), fmo(10,3), fm2(3,2)
      dimension fcpv(10,2)
c	remove this dimension when added into whole program
c	remove print statements
c	remove comment "c" from weight line
      dimension fcp(3,10), anp(3,10)
        lats=1
        late=1
        lons=1
        lone=3
c	fcpd	: derivative of fcp
c	fcpm	: min place marked by -1, max place by +1
c	fcpm2	: bimod distribution of fcst, verif. anal.
c	fcpm22	: bimod subset, more stringent
c	fcpm3	: trimod
c	fcpm4	: quad-mod
c	fcpm5	: quint-mod
c	fcpv	: value for max-min locations
c	nmax2, nmax3,etc:	number of bimod, trimod, etc cases
c	bimodg	: 2for bi, 3for tri etc modality
c
c--------+---------+---------+---------+---------+---------+---------+---------+
c     ASSESSING BIMODALITY
c--------+---------+---------+---------+---------+---------+---------+---------+
c
           bimodg=0.0
c	place this within lead-time and region loops
         data fcp /1,3,0,
     *             0,1,0,
     *             0,1,0,
     *             1,1,1,
     *             2,2,0,
     *             2,3,1,
     *             1,2,0,
     *             1,1,1,
     *             1,1,0,
     *             0,2,0/
         data anp /1,0,0,
     *             0,0,0,
     *             0,0,0,
     *             0,1,0,
     *             0,0,1,
     *             0,0,0,
     *             0,0,1,
     *             0,0,0,
     *             0,0,0,
     *             0,1,0/
          print *, '++++++++++++++++++++++++++++++++++++'
          print *, '  ASSESSING BIMODALITY '
          print *, '++++++++++++++++++++++++++++++++++++'
          ngp    =  0
          indom  =  0
          nmax1=0
          nmax2=0
          nmax22=0
          nmax3=0
          nmax33=0
          nmax4=0
          nmax5=0
          fcpm2=.0
          fcpm22=.0
          fcpm3=.0
          fcpm33=.0
          fcpm4=.0
          fcpm5=.0
 301  continue
          do nlat = lats, late
           ngl = (nlat-1)*144
           do nlon = lons, lone
            ng   = ngl+nlon
            ngp  = ngp+1
c           wfac = weight(nlat)*wdom(ndom)
c**************************************************
	  fcpd	=  .0
	  fcpm	=  .0
          fcpmt=.0
          fcpv=.0
          fm=.0
          fmo=.0
          fm2=.0
          fm22=.0
          nmax=0
          nmin=0
          print *,(fcp(ngp,j), j=1,10)
          print *,(anp(ngp,j), j=1,10)
c	compute derivative
            do nb = 1 , 9
              fcpd(nb)=fcp(ng,nb+1)-fcp(ng,nb)
            enddo
          print *,(fcpd(j), j=1,9)
c	check for maximum at extreme bins
c	first bin
             if (fcpd(1).le.-1.0) then 
              fcpm(1)=1
	      nmax=nmax+1
	     endif
             if (fcpd(1).eq.0) then
              do nb=2,9
               if (fcpd(nb).ne.0) then
                if (fcpd(nb).le.-1.0) then
                 fcpm(1)=1
	         nmax=nmax+1
                endif
                go to 190
               endif
              enddo
             endif
  190         continue
c	last bin
             if (fcpd(9).ge.1.0) then 
              fcpm(10)=1
	      nmax=nmax+1
             endif
             if (fcpd(9).eq.0) then
              do nb=1,8
               if (fcpd(9-nb).ne.0) then
                if (fcpd(9-nb).ge.1.0) then
                 fcpm(10)=1
	         nmax=nmax+1
                endif
                go to 191
               endif
              enddo
             endif
  191        continue
c	check for min/max at other bins
            nbtest=1
           do nb = 1 , 9
  180       continue
	    if (nbtest.gt.nb) go to 181
            do nb2 = nb , 9
             if (fcpd(nb).gt..0.and.fcpd(nb2).lt..0) then
              nbm=1+(1+nb+nb2)/2
              if (((nb2-nb)/2).eq.0) nbm=(1+nb+nb2)/2
              fcpm(nbm)=1
	      nmax=nmax+1
	      nbtest=nb2
              go to 180
	     endif
             if (fcpd(nb).lt..0.and.fcpd(nb2).gt..0) then
              nbm=1+(1+nb+nb2)/2
              if (((nb2-nb)/2).eq.0) nbm=(1+nb+nb2)/2
              fcpm(nbm)=-1
	      nbtest=nb2
              go to 180
             endif
	    enddo
  181       continue
	   enddo
          print *,(fcpm(j), j=1,10)
          print *,nmax
c	add current gridpoint statistics to overall stat
c	unimodal cases
            if(nmax.eq.1) then
             nmax1=nmax1+1
             bimodg(nlat,nlon)=1
            endif
            if (nmax.lt.2) go to 182
c	get max/min values
            nmaxt=0
            nmint=0
            nmm=0
            do nb=1,10
             if(fcpm(nb).eq.1) then
              nmaxt=nmaxt+1
              nmm=nmm+1
              fcpv(nmm,1)=fcp(ng,nb)
              fcpv(nmm,2)=anp(ng,nb)
             endif
             if(fcpm(nb).eq.-1) then
              nmint=nmint+1
              nmm=nmm+1
              fcpv(nmm,1)=fcp(ng,nb)
              fcpv(nmm,2)=anp(ng,nb)
             endif
            enddo
c	add up statistics
c	multimodal cases counted as bimodal
            if(nmaxt.ge.2) then
             bimodg(nlat,nlon)=2
             nmax2=nmax2+1
             do nb=1,10
              fm(nb,3)=nb
              fm(nb,1)=fcpv(nb,1)
              fm(nb,2)=fcpv(nb,2)
              fmo(nb,3)=nb
              fmo(nb,1)=fcpv(nb,1)
              fmo(nb,2)=fcpv(nb,2)
             enddo
             call sortm(fm,10,3,1)
              print *,(fm(j,1),j=1,10)
              print *,(fm(j,2),j=1,10)
              print *,(fm(j,3),j=1,10)
             fm2(1,1)=fm(10,1)
             fm2(3,1)=fm(9,1)
             fm2(1,2)=fm(10,2)
             fm2(3,2)=fm(9,2)
             kl=fm(10,3)
             ku=fm(9,3)
             if(fm(10,3).gt.fm(9,3)) then
              kl=fm(9,3)
              ku=fm(10,3)
             endif
             xmin=fm(8,1)
             do n=kl,ku
              if(fmo(n,1).le.xmin) then
               fm2(2,1)=fmo(n,1)
               fm2(2,2)=fmo(n,2)
               xmin=fmo(n,1)
              endif
             enddo
             do nb=1,3
	       fcpm2(nb,1)=fcpm2(nb,1)+fm2(nb,1)
	       fcpm2(nb,2)=fcpm2(nb,2)+fm2(nb,2)
             enddo
c	bimod, more stringent
             if((fm2(3,1)-fm2(2,1)).ge.2) then
              nmax22=nmax22+1
              do nb=1,3
	       fcpm22(nb,1)=fcpm22(nb,1)+fm2(nb,1)
	       fcpm22(nb,2)=fcpm22(nb,2)+fm2(nb,2)
              enddo
             endif
            endif	! bimod
c	trimodal
            if(nmaxt.eq.3) then
             bimodg(nlat,nlon)=3
             nmax3=nmax3+1 
             do nb=1,5
	       fcpm3(nb,1)=fcpm3(nb,1)+fcpv(nb,1)
	       fcpm3(nb,2)=fcpm3(nb,2)+fcpv(nb,2)
             enddo
c	trimodal, more stringent
             xmin3=fcpv(2,1)
             if(xmin3.gt.fcpv(4,1) xmin=fcpv(4,1)
             xmax3=fcpv(1,1)
             if(xmax.lt.fcpv(3,1) xmax=fcpv(3,1)
             if(xmax.lt.fcpv(5,1) xmax=fcpv(5,1)
             if(xmax-xmin.ge.2) then
              nmax33=nmax33+1 
              do nb=1,5
	       fcpm33(nb,1)=fcpm33(nb,1)+fcpv(nb,1)
	       fcpm33(nb,2)=fcpm33(nb,2)+fcpv(nb,2)
              enddo
             endif
            endif
c	4-modal
            if(nmaxt.eq.4) then
             bimodg(nlat,nlon)=4
             nmax4=nmax4+1 
             do nb=1,7
	       fcpm4(nb,1)=fcpm4(nb,1)+fcpv(nb,1)
	       fcpm4(nb,2)=fcpm4(nb,2)+fcpv(nb,2)
             enddo
            endif
c	5-modal
            if(nmaxt.eq.5) then
             bimodg(nlat,nlon)=5
             nmax5=nmax5+1 
             do nb=1,9
	       fcpm5(nb,1)=fcpm5(nb,1)+fcpv(nb,1)
	       fcpm5(nb,2)=fcpm5(nb,2)+fcpv(nb,2)
             enddo
            endif
c
c
  182	    continue
c
c	end multimodality check
c	write out fcpm2, fcpm22, fcpm3, fcpm4, fcpm5
c			nmax2, nmax22, nmax3, nmax4, nmax5
c
c
           enddo      ! nlon
          enddo       ! nlat
          print *,nmax1,nmax2, nmax22,nmax3,nmax33,nmax4,nmax5
          print *,(fcpm2(j,1),j=1,3)
          print *,(fcpm2(j,2),j=1,3)
          print *,(fcpm22(j,1),j=1,3)
          print *,(fcpm22(j,2),j=1,3)
          print *,(fcpm3(j,1),j=1,5)
          print *,(fcpm3(j,2),j=1,5)
          print *,(fcpm33(j,1),j=1,5)
          print *,(fcpm33(j,2),j=1,5)
          print *,(fcpm4(j,1),j=1,7)
          print *,(fcpm4(j,2),j=1,7)
          print *,(fcpm5(j,1),j=1,9)
          print *,(fcpm5(j,2),j=1,9)
          print *,(bimodg(1,j),j=1,3)
      stop
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
