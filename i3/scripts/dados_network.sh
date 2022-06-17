#!/usr/bin/env bash
#/scripts/dados_network.sh
# --------------------------------------------------------------------------------
# Copyright (C) 2020 Matheus Martins <3mhenrique@gmail.com>
# License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law
# --------------------------------------------------------------------------------

n=1
while [ $n -le 20 ] 
do
  downtotal=$(ifconfig $interface | grep -i -m1 "rx packets" | awk '{print $6 $7}')
  uptotal=$(ifconfig $interface | grep -i -m1 "tx packets" | awk '{print $6 $7}')

  echo $uptotal > /scripts/Output/uploadtotal
  echo $downtotal > /scripts/Output/downloadtotal
  sleep 3
  n=$(( n+1 ))
done
exit 0
