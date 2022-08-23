#!/bin/sh
# pry.truncate.linkpgb.sh CDATE
# makes symbolic links in the current directory to pry forecast files
# from the current date.  Files before forecast hour 96 are from the prx.
set -x
 echo $0 DEACTIVATED;exit
CDATE=${1:-${CDATE:?}}
h=00

while [[ $h -le 84 ]];do
p=prx
if [ -s /global/pry/pgbf$h.$CDATE ]; then
 echo "OK, the file is there"
else
 ln -s /global/$p/pgbf$h.$CDATE .
fi
((h+=12))
done

if [ -s /global/pry/pgbanl.$CDATE ]; then
 echo "OK, the file is there"
else
 ln -s /global/$p/pgbf00.$CDATE pgbanl.$CDATE
fi

