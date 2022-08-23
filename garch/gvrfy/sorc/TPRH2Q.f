  subroutine rhtp2q(levs,rh,t,p,q,iret)
		use funcphys
		use physcons
		implicit none
		integer,intent(in)  :: levs
	 	real,   intent(in)  :: rh(levs), t(levs), p(levs)
	 	real,   intent(out) :: q(levs)
		integer,intent(inout) :: iret
		integer i,k,iprint
		real shs,xinc,relh
		real(krealfp) pr,tr,es

                print*, "rh,t,p", rh,t,p
		iprint=0
		if (iret.eq.-1) iprint=1
	    iret=0
		do k=1,levs
		  relh=1.e-2*max(min(rh(k),100.),0.)
		  pr=p(k)
		  tr=t(k)
		  es=fpvs(tr)
		  es=min(es,pr)
		  shs=con_eps*es/(pr+con_epsm1*es)
		  if(iprint.eq.1) print*,'tr,es,shs',tr,es,shs,fpvs(tr)
		  q(k)=relh*shs
	    enddo
	  return
  end subroutine rhtp2q
