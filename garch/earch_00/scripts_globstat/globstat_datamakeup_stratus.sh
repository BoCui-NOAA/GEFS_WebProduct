set -x 

for dir in ENS ENS_bc cmc_ens cmc_ens_bc fno_ens fno_ens_bc ecm_ens
do 

cd /global/shared/stat/${dir}

  for file in `cat /global/save/wx22lu/naefs/scripts/cirrus_${dir}_list.txt`
   do
  if [ ! -s $file ]; then 
  scp -p globstat@cirrus.ncep.noaa.gov:/global/shared/stat/${dir}/$file  . 
  fi
  done

done
