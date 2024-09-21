#!/bin/bash
stty -icanon -echo

# Nome: i3lock-blur-screen
# Descrição: Script para bloquear a tela usando i3lock com uma imagem de fundo desfocada.

# Caminho para a imagem de fundo temporária
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
end_brightness=0.3

# Etapas de Fade
steps=40
delay=0.1

# Restaurar o brilho original e encerrar o script
restore_brightness() {
    for output in "${outputs[@]}"; do
        xrandr --output "$output" --brightness $start_brightness
    done
    # Matar o processo de monitoramento de teclado se ele estiver em execução
    if [ -n "$keyboard_pid" ] && ps -p "$keyboard_pid" > /dev/null; then
        kill "$keyboard_pid"
    fi
    exit 0
}

# Função para capturar eventos de movimentação do mouse
check_mouse_movement() {
    current_x=$(get_mouse_position)
    current_y=$(get_mouse_position)

    if [ "$initial_x" != "$current_x" ] || [ "$initial_y" != "$current_y" ]; then
        restore_brightness
    fi
}

# Função para obter a posição inicial do mouse
get_mouse_position() {
    xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d '=' -f 2
}

# Pega a posição inicial do mouse
initial_x=$(get_mouse_position)
initial_y=$(get_mouse_position)

get_key_press() {
    # Get list of keyboard
    #local device_id=$(xinput list | grep -i 'keyboard' | grep -o 'id=[0-9]*' | cut -d= -f2 | head -n 1)
    
    local device_id="9"
    local key_press=""
    key_press=$(timeout 0.05s xinput test $device_id | awk '/key press/ { print $3 }') 
    if [[ "$key_press" =~ ^[0-9]+$ ]]; then
        restore_brightness
    fi
}

# Captura interrupções e restaura o brilho original
trap restore_brightness SIGINT SIGTERM SIGHUP SIGABRT SIGUSR1

# Calcula a diferença de brilho por passo
brightness_step=$(echo "($start_brightness - $end_brightness) / $steps" | bc -l)

# Define o brilho atual como o inicial
current_brightness=$start_brightness

# Inicia monitoramento de eventos de teclado em segundo plano

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

# Tira uma captura de tela
scrot $TEMP_BG

# Aplica o desfoque na captura de tela
convert $TEMP_BG -filter Gaussian -blur 0x55 $TEMP_BG

# Remove print criado após desbloqueio
cleanup(){
  if [ -f "$TEMP_BG" ]; then
    rm -f "$TEMP_BG"
  fi
}
trap cleanup EXIT

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
exit 0

