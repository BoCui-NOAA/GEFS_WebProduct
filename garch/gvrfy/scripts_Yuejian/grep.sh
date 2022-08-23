
for mmdd in 0720 0721
do

grep "120 hrs " /global/vrfy/SCORESs.2000$mmdd | sed -n "3,5 p"

done
