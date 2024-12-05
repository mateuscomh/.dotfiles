#!/usr/bin/env bash

###############################
# Script de notificação com detecção de movimento do mouse
# Descrição:
# - Exibe notificação com barra de progresso antes de bloquear a tela.
# - Cancela o bloqueio se houver movimento do mouse ou pressionamento de teclas.
#
# Requisitos:
# - xrandr, xdotool, dunst, i3lock-color
###############################

set -e

if pgrep -x "i3lock" > /dev/null; then
    exit 0
fi

# Função: Obter saídas ativas
get_active_outputs() {
    xrandr --query | awk '/ connected / {print $1}'
}

outputs=($(get_active_outputs))
start_brightness=$(xrandr --verbose | grep -i brightness | awk '{print $2}')
end_brightness=0.1
steps=40
TEMP_BG="/tmp/lockscreen.png"

# Função: Restaurar brilho original e sair
restore_brightness() {
    for output in "${outputs[@]}"; do
        xrandr --output "$output" --brightness "$start_brightness"
    done
    cleanup
    exit 0
}

# Função: Limpar recursos temporários
cleanup() {
    [[ -f "$TEMP_BG" ]] && rm -f "$TEMP_BG"
    pkill -P $$
}

# Função: Detectar movimento do mouse
check_mouse_movement() {
    current_pos=$(xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d '=' -f2)
    if [[ "$current_pos" != "$initial_pos" ]]; then
        restore_brightness
    fi
}

# Função: Detectar pressionamento de teclas
monitor_key_presses() {
    local device_id
    device_id=$(xinput list | awk -F'id=' '/AT Translated Set 2 keyboard/{print $2}' | awk '{print $1}')
    while :; do
        xinput test "$device_id" | grep -q "key press" && restore_brightness
    done
}

# Captura inicial do mouse
initial_pos=$(xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d '=' -f2)

# Iniciar monitor de teclas em background
monitor_key_presses &
key_monitor_pid=$!

trap restore_brightness EXIT SIGINT SIGTERM

# Notificação de bloqueio
current=0
while [[ $current -le 100 ]]; do
    dunstify --icon preferences-desktop-screensaver \
        -h int:value:"$current" \
        -h 'string:hlcolor:#ff4444' \
        -h string:x-dunst-stack-tag:progress-lock \
        --timeout=500 "Bloqueio de Tela ..." "$(date '+%Y-%m-%d %H:%M:%S')"
    current=$((current + 1))
    sleep 0.05
    check_mouse_movement
done

# Gradual ajuste do brilho
brightness_step=$(echo "($start_brightness - $end_brightness) / $steps" | bc -l)
current_brightness=$start_brightness
while (( $(echo "$current_brightness > $end_brightness" | bc -l) )); do
    for output in "${outputs[@]}"; do
        xrandr --output "$output" --brightness "$current_brightness"
    done
    current_brightness=$(echo "$current_brightness - $brightness_step" | bc -l)
    sleep 0.2
    check_mouse_movement
done

check_mouse_movement
kill $key_monitor_pid 2>/dev/null

# Captura e desfoque da tela
scrot "$TEMP_BG"
convert "$TEMP_BG" -filter Gaussian -blur 0x55 "$TEMP_BG"

# Bloqueio da tela com i3lock
i3lock -i "$TEMP_BG" \
    --clock \
    --indicator \
    --line-uses-ring \
    --time-color="#A659DE" \
    --date-color="#B077D9" \
    --ring-color="#000000" \
    --ring-width=2 \
    --verif-text="and..."

# Restaurar brilho original ao desbloquear
restore_brightness
