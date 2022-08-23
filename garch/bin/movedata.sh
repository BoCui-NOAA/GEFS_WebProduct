

set -x

#cd /emc3/global

#cat > ingester.sh <<EOF
#
#mkdir -p /emc3/global/$1
#cd /emc3/global/$1
#tar -xvf -
#
#EOF

#chmod 755 /emc3/global/ingester.sh

for ddir in  pry prz vrfy
do

cd /global/$ddir
tar -cvf - . | /emc3/global/ingester.sh $ddir

done
