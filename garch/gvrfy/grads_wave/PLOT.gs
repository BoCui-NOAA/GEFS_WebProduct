
'open pgbf120_s0.2005110900.ctl'
'open pgbf120_u0.2005110900.ctl'
'open pgbf120_s1.2005110900.ctl'
'open pgbf120_u1.2005110900.ctl'
'open pgbf120_s2.2005110900.ctl'
'open pgbf120_u2.2005110900.ctl'
'open pgbf120_s3.2005110900.ctl'
'open pgbf120_u3.2005110900.ctl'

'set display color white'
'clear'
'set t 6'
'set lev 500'

'enable print f120.2005110900'
'set gxout shaded'
'set vpage 0.0 5.6 4.0 8.5'
'set grads off'
'd HGTprs.1'
'cbar.gs'
'draw title 500hPa height f120 (ini:2005110900)'

'set vpage 5.4 11.0 4.0 8.5'
'set grads off'
'd HGTprs.3 - HGTprs.4'
'cbar.gs'
'draw title f120 diff (0-3) (ini:2005110900)'

'set vpage 0.0 5.6 0.0 4.5'
'set grads off'
'd HGTprs.5 - HGTprs.6'
'cbar.gs'
'draw title f120 diff (4-9) (ini:2005110900)'

'set vpage 5.4 11.0 0.0 4.5'
'set grads off'
'd HGTprs.7 - HGTprs.8'
'cbar.gs'
'draw title f120 diff (10-20) (ini:2005110900)'

'print'


