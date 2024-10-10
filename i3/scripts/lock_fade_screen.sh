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
#stty -icanon -echo

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

outputs=($(get_active_outputs))

# Brilho inicial e final
start_brightness=1.0
end_brightness=0.2

# Etapas de Fade
steps=35
delay=0.08

# Restaurar o brilho original e encerrar o script
restore_brightness() {
    for output in "${outputs[@]}"; do
        xrandr --output "$output" --brightness $start_brightness
    done
    exit 0
}

# Função capturar eventos de movimentação do mouse
check_mouse_movement() {
    current_x=$(get_mouse_position)
    current_y=$(get_mouse_position)

    if [ "$initial_x" != "$current_x" ] || [ "$initial_y" != "$current_y" ]; then
        restore_brightness
    fi
}

# Função obter a posição inicial do mouse
get_mouse_position() {
    xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d '=' -f 2
}

initial_x=$(get_mouse_position)
initial_y=$(get_mouse_position)

# Função obter interrupcao por teclado
get_key_press() {
    device_id=$(xinput list | awk -F 'id=' '/liliums Lily58/ && !/Consumer Control|Mouse|System Control/ {print $2}' | awk '{print $1}')
 
    key_press=$(timeout 0.05s xinput test "$device_id" | awk '/key press/ { print $3 }') 
    if [[ "$key_press" =~ ^[0-9]+$ ]]; then
        restore_brightness
    fi
}

trap restore_brightness SIGINT SIGTERM SIGHUP SIGABRT SIGUSR1

# Notifica bloqueio de tela
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
    get_key_press
done

# Mantém o brilho no valor final
for output in "${outputs[@]}"; do
    xrandr --output "$output" --brightness $end_brightness
done

sleep 1.0

TEMP_BG='/tmp/lockscreen.png'
scrot $TEMP_BG

# Aplica o desfoque na captura de tela
convert $TEMP_BG -filter Gaussian -blur 0x55 $TEMP_BG

# Remove print criado após desbloqueio
cleanup() {
    if [ -n "$TEMP_BG" ] && [ -f "$TEMP_BG" ]; then
      rm -f "$TEMP_BG"
    fi
}
trap cleanup EXIT SIGINT SIGTERM SIGHUP SIGABRT SIGUSR1

# Bloqueia a tela com i3lock-color
i3lock -i $TEMP_BG \
    --clock \
    --indicator \
    --line-uses-ring \
    --time-color=#A659DE \
    --date-color=#B077D9 \
    --ring-color=#000000 \
    --ring-width=2 \
    --verif-text="and..."

# Restaura o brilho original
restore_brightness
