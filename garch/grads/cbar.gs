*
*  Script to plot a colorbar
*
function colorbar (args)
*
*  Check shading information
*
  'query shades'
  shdinfo = result
  if (subwrd(shdinfo,1)='None') 
    say 'Cannot plot color bar: No shading information'
    return
  endif
* 
*  Get plot size info
*
  'query gxinfo'
  rec2 = sublin(result,2)
  rec3 = sublin(result,3)
  rec4 = sublin(result,4)
  xsiz = subwrd(rec2,4)
  ysiz = subwrd(rec2,6)
  ylo = subwrd(rec4,4)
  xhi = subwrd(rec3,6)
  xd = xsiz - xhi
*
*  Decide if horizontal or vertical color bar
*  and set up constants.
*
  if (ylo<0.6 & xd<1.0) 
    say "Not enough room in plot for a colorbar"
    return
  endif
  cnum = subwrd(shdinfo,5)
  if (ylo<0.6 | xd>1.5)
    xl = xhi + xd/2 - 0.4
    xr = xl + 0.2
    xwid = 0.2
    ywid = 0.5
    if (ywid*cnum > ysiz*0.8) 
      ywid = ysiz*0.8/cnum
    endif
    ymid = ysiz/2
    yb = ymid - ywid*cnum/2
    'set string 1 l 6'
    vert = 1
  else
    ymid = ylo/2
    yt = ymid + 0.2
    yb = ymid
    xmid = xsiz/2
    xwid = 0.8
    if (xwid*cnum > xsiz*0.8)
      xwid = xsiz*0.8/cnum
    endif
    xl = xmid - xwid*cnum/2
    'set string 1 tc 6'
    vert = 0
  endif
*
*  Plot colorbar
*
  'set strsiz 0.14 0.15'
  num = 0
  while (num<cnum) 
    rec = sublin(shdinfo,num+2)
    col = subwrd(rec,1)
    hi = subwrd(rec,3)
    'set line 'col
    if (vert) 
      yt = yb + ywid
    else 
      xr = xl + xwid
    endif
    'draw recf 'xl' 'yb' 'xr' 'yt
    if (num<cnum-1)
      if (vert) 
        'draw string '%(xr+0.05)%' 'yt' 'hi
      else
        'draw string 'xr' '%(yb-0.05)%' 'hi
      endif
    endif
    num = num + 1
    if (vert); yb = yt;
    else; xl = xr; endif;
  endwhile
