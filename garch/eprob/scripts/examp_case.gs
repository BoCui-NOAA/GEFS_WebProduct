*  Script to draw an XY plot.  
*
function main(args)

#'set display color white'
#'clear'

if (args='') 
  say 'Enter Record Number'
  pull lrec 
else
  lrec = args
endif

fname = "/nfstmp/wx20yz/vfprob/tmp_new.dat"                     

*  Read record: 

irec=1
while (irec<=lrec)
ret = read(fname)
rc = sublin(ret,1)
if (rc>0) 
  say 'File Error'
  return
endif
rec = sublin(ret,2)
p1 = subwrd(rec,1)
p2 = subwrd(rec,2)
p3 = subwrd(rec,3)
p4 = subwrd(rec,4)
p5 = subwrd(rec,5)
p6 = subwrd(rec,6)
p7 = subwrd(rec,7)
p8 = subwrd(rec,8)
p9 = subwrd(rec,9)
p0 = subwrd(rec,10)
px = subwrd(rec,11)

irec = irec + 1
endwhile

'draw string 3.35 0.95 'p2
'draw string 4.05 0.95 'p3
'draw string 4.75 0.95 'p4
'draw string 5.45 0.95 'p5
'draw string 6.15 0.95 'p6
'draw string 6.85 0.95 'p7
'draw string 7.55 0.95 'p8
'draw string 8.25 0.95 'p9
'draw string 8.95 0.95 'p0
'draw string 9.65 0.95 'px
