#!/bin/bash
set -e

# Função para obter a lista de saídas conectadas e ativas
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
end_brightness=0.3

# Quantidade de passos para o fade
steps=15

# Tempo entre cada passo (em segundos)
delay=0.05

# Função para restaurar o brilho original
restore_brightness() {
    for output in "${outputs[@]}"; do
        xrandr --output "$output" --brightness $start_brightness
    done
    exit 0
}

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
done

# Mantém o brilho no valor final
for output in "${outputs[@]}"; do
    xrandr --output "$output" --brightness $end_brightness
done

# Aguarda um pouco antes de restaurar o brilho (opcional)
sleep 1.0

# Restaura o brilho original
restore_brightness

