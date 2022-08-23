       program XYZ              
       use funcphys
       use physcons
c
c      call qpvs
       call gfuncphys
       rh=90.
       t=300.
       p=1000.
       q=0.
       print *, ' rh=',rh,' t=',t,' p=',p,' q=',q
       p=p*100.
       es=fpvs(t)
       es=min(es,p)
       shs=con_eps*es/(p+con_epsm1*es)
       q=rh*shs*0.01
       print*,'tr,es,shs',t,es,shs,fpvs(t),q
c
       stop
       end
