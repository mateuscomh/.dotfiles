#!/usr/bin/env bash
#/$HOME/scripts/i3custom.sh

#Requisitos
# vnstat / curl / neofetch 
# Don't run as root or sudo
if (( $(id -u) == 0 )); then
    echo "You should not run this script as root"
    echo "Exiting..."
    exit;
fi
# Auto detect interfaces
ifaces=$(ls /sys/class/net | grep -E '(eth|wlan|enp|wlp|eno|net)')
#ifaces="eno1"
last_time=0
last_rx=0
last_tx=0
rate=""

readable() {
  local bytes=$1
  local kib=$(( bytes >> 10 ))
  if [ $kib -lt 0 ]; then
    echo "? K"
  elif [ $kib -gt 1024 ]; then
    local mib_int=$(( kib >> 10 ))
    local mib_dec=$(( kib % 1024 * 976 / 10000 ))
    if [ "$mib_dec" -lt 10 ]; then
      mib_dec="0${mib_dec}"
    fi
    echo "${mib_int}.${mib_dec} M"
  else
    echo "${kib} K"
  fi
}

update_rate() {
  local time=$(date +%s)
  local rx=0 tx=0 tmp_rx tmp_tx

  for iface in $ifaces; do
    read tmp_rx < "/sys/class/net/${iface}/statistics/rx_bytes"
    read tmp_tx < "/sys/class/net/${iface}/statistics/tx_bytes"
    rx=$(( rx + tmp_rx ))
    tx=$(( tx + tmp_tx ))
  done

  local interval=$(( $time - $last_time ))
  if [ $interval -gt 0 ]; then
    rate="$(readable $(( (rx - last_rx) / interval )))↓ $(readable $(( (tx - last_tx) / interval )))↑"
  else
    rate=""
  fi

  last_time=$time
  last_rx=$rx
  last_tx=$tx
}

function network(){
  downtotal=$(/usr/bin/vnstat -s | grep today | awk {'print $2$3'})
  uptotal=$(/usr/bin/vnstat -s | grep today | awk {'print $5$6'})
#  ipext=$(cat /scripts/Output/meuip)
}

function weather(){
  clima=$(cat /$HOME/scripts/Output/i3clima)
}
function timeup(){
  minuto=$(awk -F "." '{print $1}'  /proc/uptime)  
#minuto=$(awk '{print $0/60}' /proc/uptime | sed 's/\.[^.]*//')
    if [ $minuto -le "3599" ]; then
        utime=$(uptime | awk '{printf $3$4}' | sed 's/,//')
      else if [ $minuto -le "86390" ]; then
        utime=$(uptime | awk '{printf $3}' | sed 's/:/h:/' | sed 's/,/m'/)
    else 
      utime=$(uptime | awk '{printf $3$4$5}' | sed 's/,/ /' | sed 's/,//')
      fi
    fi
}

function ram() {
  used=$(free -gh | grep "Mem" | awk {'print $3'})
}

i3status | while :
do
  read line
    timeup
    update_rate
    network
    weather
    ram
#printf "%s\n" "$clima | ${rate} | DT:($downtotal) UT:($uptotal) | $ipext $used | U:$utime | $line" || exit 1
printf "%s\n" "$clima | ${rate} | DT:($downtotal) UT:($uptotal) | $used | U:$utime | $line" || exit 1
done
