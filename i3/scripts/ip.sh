#!/usr/bin/env bash
#/scripts/ip.sh
#Escrever o ip em um arquivo

#sleep 20

[ ! -d "/$HOME/scripts/Output" ] && mkdir -p "$HOME/scripts/Output"
[ ! -f "$HOME/scritps/Output/meuip" ] && touch "$HOME/scripts/Output/meuip"

caminho="$HOME/scripts/Output/meuip"
ping -c 1 8.8.8.8 > /dev/null
if [ "$?" -ne "0" ]; then
	echo 0.0.0.0 > $caminho
else
	echo $(curl -s ipinfo.io/ip) > $caminho 
fi
exit 0
