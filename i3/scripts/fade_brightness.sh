#!/bin/bash

set -e
# Função para obter a lista de saídas conectadas e ativas
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

# Quantidade de passos para o fade
steps=15

# Tempo entre cada passo (em segundos)
delay=0.08

restore_brightness() {
    local active_outputs=($(get_active_outputs))
    
    for output in "${active_outputs[@]}"; do
        echo "Restaurando brilho para $output"
        xrandr --output "$output" --brightness $start_brightness
    done
    exit 0
}

trap restore_brightness SIGINT SIGTERM SIGHUP SIGABRT
sleep 1

for p in $(seq 0 2 100); do
    dunstify --icon preferences-desktop-screensaver \
        -h int:value:"$p" \
        -h 'string:hlcolor:#ff4444' \
        -h string:x-dunst-stack-tag:progress-lock \
        --timeout=500 "Bloqueio de Tela ..." $echo "$(date '+%Y-%m-%d %H:%M:%S')"
    sleep 0.05
done

# Calcula a diferença de brilho por passo
brightness_step=$(echo "($start_brightness - $end_brightness) / $steps" | bc -l)

# Loop para diminuir o brilho gradualmente
current_brightness=$start_brightness
while (( $(echo "$current_brightness > $end_brightness" | bc -l) )); do
    echo "Ajustando brilho para $current_brightness"
    for output in "${outputs[@]}"; do
        echo "Ajustando brilho para $output"
        xrandr --output "$output" --brightness "$current_brightness"
    done
    current_brightness=$(echo "$current_brightness - $brightness_step" | bc -l)
    sleep $delay
done

# Mantém o brilho no valor final
echo "Mantendo brilho final $end_brightness"
for output in "${outputs[@]}"; do
    xrandr --output "$output" --brightness $end_brightness
done

# Aguarda um pouco antes de restaurar o brilho (opcional)
sleep 1.5

# Restaura o brilho original
restore_brightness

