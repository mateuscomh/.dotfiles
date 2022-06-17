#!/usr/bin/env bash
# --------------------------------------------------------------------------------
# Copyright (C) 2021 Blau Araujo <blau@debxp.org>
# License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law
# --------------------------------------------------------------------------------
increase() {
    for d in $(get_status); do
       b=$(awk 'BEGIN {printf "%.1f", '${d#*:}' + 0.1}')
       [[ $(awk 'BEGIN {printf "%d", '$b'*100}') -gt 999  ]] && b=9.99
       xrandr --output ${d%:*} --brightness $b
    done
}
decrease() {
    for d in $(get_status); do
       b=$(awk 'BEGIN {printf "%.1f", '${d#*:}' - 0.1}')
       [[ $(awk 'BEGIN {printf "%d", '$b'*100}') -lt 0  ]] && b=0
       xrandr --output ${d%:*} --brightness $b
    done
}
restore() {
    for d in $(heads); do
       xrandr --output $d --brightness 1.0
    done
}
set_brightness() {
    b=$1
    [[ $(awk 'BEGIN {printf "%d", '$b'*100}') -gt 999  ]] && b=9.99
    [[ $(awk 'BEGIN {printf "%d", '$b'*100}') -lt 0  ]] && b=0
    for d in $(heads); do
       xrandr --output $d --brightness $b
    done
}
heads() {
    xrandr -q | grep '\bconnected' | cut -d' ' -f1
}
get_status() {
    for d in $(heads); do
        echo $d:$(xrandr --verbose --current | grep -A5 ^"$d" | tail -1 | awk '{print $NF}')
    done
}
case $1 in
    '+') increase; get_status;;
    '-') decrease; get_status;;
    'r') restore; get_status;;
    [0-9].[0-9]) set_brightness $1; get_status;;
    'c') get_status;;
    *) get_status
esac
¿
