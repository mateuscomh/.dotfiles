#!/usr/bin/env bash

############################### 
# Script de notificação com detecção de movimento do mouse
# 
# Descrição:
# Este script exibe notificação com progress bar se detectar e interrompe se
# detectar movimento do mouse durante a execução.
#
# Requisitos:
# - xrandr, xdotool, dunst
############################### 

set -e

if pgrep -x "i3lock" > /dev/null; then
    exit 0
fi

get_mouse_position() {
    xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d '=' -f 2
}

get_key_press() {
    device_id=$(xinput list | awk -F 'id=' '/liliums Lily58/ && !/Consumer Control|Mouse|System Control/ {print $2}' | awk '{print $1}')
    key_press=$(timeout 0.05s xinput test "$device_id" | awk '/key press/ { print $3 }') 
    if [[ "$key_press" =~ ^[0-9]+$ ]]; then
        exit 0
    fi
}

check_mouse_movement() {
    current_x=$(get_mouse_position)
    current_y=$(get_mouse_position)

    if [ "$initial_x" != "$current_x" ] || [ "$initial_y" != "$current_y" ]; then
       exit 0 
    fi
}

# Pega a posição inicial do mouse
initial_x=$(get_mouse_position)
initial_y=$(get_mouse_position)

trap SIGINT SIGTERM SIGHUP SIGABRT SIGUSR1

# Notificação de progresso
current=0
while [ "$current" -le 100 ]; do
    dunstify --icon preferences-desktop-screensaver \
        -h int:value:"$current" \
        -h 'string:hlcolor:#ff4444' \
        -h string:x-dunst-stack-tag:progress-lock \
        --timeout=500 "Bloqueio de Tela ..." "$(date '+%Y-%m-%d %H:%M:%S')"
    sleep 0.05
    current=$((current + 1))
    
    check_mouse_movement
    get_key_press
done
