
'open pgbf_FHR_s0._YMDH.ctl'
'open pgbf00_s0._YMDH.ctl'
'open pgbf_FHR_s1._YMDH.ctl'
'open pgbf00_s1._YMDH.ctl'
'open pgbf_FHR_s2._YMDH.ctl'
'open pgbf00_s2._YMDH.ctl'
'open pgbf_FHR_s3._YMDH.ctl'
'open pgbf00_s3._YMDH.ctl'

'set display color white'
'clear'
'set t 6'
'set lev 500'

'enable print f_FHR._YMDH.gr'
'set gxout shaded'
'set vpage 0.0 5.6 4.0 8.5'
'set grads off'
'd HGTprs.2 - HGTprs.1 '
'cbar.gs'
'draw title 500hPa height f00-f_FHR (ini:_YMDH)'
*'draw title 500hPa height f_FHR (ini:_YMDH)'

'set vpage 5.4 11.0 4.0 8.5'
'set grads off'
'd HGTprs.3 - HGTprs.4'
'cbar.gs'
'draw title f_FHR diff (0-3) (ini:_YMDH)'

'set vpage 0.0 5.6 0.0 4.5'
'set grads off'
'd HGTprs.5 - HGTprs.6'
'cbar.gs'
'draw title f_FHR diff (4-9) (ini:_YMDH)'

'set vpage 5.4 11.0 0.0 4.5'
'set grads off'
'd HGTprs.7 - HGTprs.8'
'cbar.gs'
'draw title f_FHR diff (10-20) (ini:_YMDH)'

'print'


