#!/bin/bash

# Dispositivo de saída de vídeo (ajuste conforme necessário)
output="DP-4"

# Brilho inicial e final
start_brightness=1.0
end_brightness=0.3

# Quantidade de passos para o fade
steps=15

# Tempo entre cada passo (em segundos)
delay=0.08

# Função para restaurar o brilho original
restore_brightness() {
    xrandr --output $output --brightness $start_brightness
    exit 0
}

trap restore_brightness SIGINT SIGTERM SIGHUP SIGABRT
# Captura interrupções e restaura o brilho original
# Envia uma notificação antes de começar a escurecer a tela
sleep 1
notify-send -u critical -t 7000 'Bloqueio de tela...' && sleep 1

# Calcula a diferença de brilho por passo
brightness_step=$(echo "($start_brightness - $end_brightness) / $steps" | bc -l)

# Loop para diminuir o brilho gradualmente
current_brightness=$start_brightness
while (( $(echo "$current_brightness > $end_brightness" | bc -l) )); do
    xrandr --output "$output" --brightness "$current_brightness"
    current_brightness=$(echo "$current_brightness - $brightness_step" | bc -l)
    sleep $delay
done

# Mantém o brilho no valor final
xrandr --output $output --brightness $end_brightness

# Aguarda um pouco antes de restaurar o brilho (opcional)
sleep 1.5

# Restaura o brilho original
restore_brightness

