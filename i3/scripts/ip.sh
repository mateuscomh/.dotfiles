#!/usr/bin/env bash
#/scripts/ip.sh
#Escrever o ip em um arquivo

#sleep 20

[ ! -d "/scripts/Output" ] && mkdir -p /scripts/Output
[ ! -f "/scritps/Output/meuip" ] && touch /scripts/Output/meuip

caminho="/scripts/Output/meuip"
ping -c 1 8.8.8.8 > /dev/null
if [ "$?" -ne "0" ]; then
	echo 0.0.0.0 > $caminho
else
	echo $(curl -s ipinfo.io/ip) > $caminho 
fi
exit 0
