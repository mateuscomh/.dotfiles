#!/bin/bash

############################### 
# Script de controle de brilho da tela com detecção de movimento do mouse
# 
# Descrição:
# Este script reduz gradualmente o brilho da tela, restaurando-o ao valor original
# se detectar movimento do mouse durante a execução. Ele foi projetado para ambientes
# Linux com suporte a xrandr e xdotool.
#
# Requisitos:
# - xrandr, xdotool, dunst
############################### 

set -e

if pgrep -x "i3lock" > /dev/null; then
    exit 0
fi

# Obter a lista de saídas conectadas e ativas
get_active_outputs() {
    xrandr --query | awk '/ connected / { 
        if ($0 ~ /[0-9]+mm x [0-9]+mm$/) 
            print $1 
    }'
}

# Obtenha a lista de saídas ativas
outputs=($(get_active_outputs))

# Brilho inicial e final
start_brightness=1.0
end_brightness=0.1

# Etapas de Fade
steps=15
delay=0.07

# Restaurar o brilho original e encerrar o script
restore_brightness() {
    for output in "${outputs[@]}"; do
        xrandr --output "$output" --brightness $start_brightness
    done
    exit 0
}

# Função para obter a posição atual do mouse
get_mouse_position() {
    xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d '=' -f 2
}

check_mouse_movement() {
    current_x=$(get_mouse_position)
    current_y=$(get_mouse_position)

    if [ "$initial_x" != "$current_x" ] || [ "$initial_y" != "$current_y" ]; then
        restore_brightness
    fi
}

# Pega a posição inicial do mouse
initial_x=$(get_mouse_position)
initial_y=$(get_mouse_position)

# Captura interrupções e restaura o brilho original
trap restore_brightness SIGINT SIGTERM SIGHUP SIGABRT SIGUSR1

# Notificação de progresso
current=0
while [ "$current" -le 100 ]; do
    dunstify --icon preferences-desktop-screensaver \
        -h int:value:"$current" \
        -h 'string:hlcolor:#ff4444' \
        -h string:x-dunst-stack-tag:progress-lock \
        --timeout=500 "Bloqueio de Tela ..." "$(date '+%Y-%m-%d %H:%M:%S')"
    sleep 0.05
    current=$((current + 2))
    
    check_mouse_movement
done

# Calcula a diferença de brilho por passo
brightness_step=$(echo "($start_brightness - $end_brightness) / $steps" | bc -l)

# Define o brilho atual como o inicial
current_brightness=$start_brightness

# Loop para diminuir o brilho gradualmente
while (( $(echo "$current_brightness > $end_brightness" | bc -l) )); do
    for output in "${outputs[@]}"; do
        xrandr --output "$output" --brightness "$current_brightness"
    done
    current_brightness=$(echo "$current_brightness - $brightness_step" | bc -l)
    sleep $delay

    check_mouse_movement
done

# Mantém o brilho no valor final
for output in "${outputs[@]}"; do
    xrandr --output "$output" --brightness $end_brightness
done

sleep 1.0

# Restaura o brilho original
restore_brightness

