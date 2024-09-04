#!/bin/bash

# Nome: i3lock-blur-screen
# Descrição: Script para bloquear a tela usando i3lock com uma imagem de fundo desfocada.
# 
# Funcionalidade:
# - Captura uma imagem da tela atual.
# - Aplica um efeito de desfoque Gaussian na imagem capturada.
# - Bloqueia a tela usando i3lock, exibindo a imagem desfocada como fundo.
# - Remove a imagem temporária após o desbloqueio.
#
# Dependências:
# - scrot: Utilitário para captura de tela.
# - ImageMagick: Ferramenta para editar e converter imagens (usada para aplicar desfoque).
# - i3lock-color: Versão customizada do i3lock com suporte para mais opções de personalização.
#
# Autor: Matheus Martins
# Data: 07 de agosto de 2024
# Versão: 1.0
#
# Licença: MIT
#
# Uso: 
# Execute o script diretamente a partir da linha de comando ou configure um atalho no i3wm.
# Exemplo: ./i3lock-blur-screen.sh
# Ou configure no i3wm: bindsym $mod+Shift+L exec ~/scripts/i3lock-blur-screen.sh

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
end_brightness=0.1

# Etapas de Fade
steps=40
delay=0.1

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

TEMP_BG='/tmp/lockscreen.png'

echo "$(date): Executando lockscreen.sh" >> /tmp/lockscreen.log

# Tira uma captura de tela
scrot $TEMP_BG

# Aplica o desfoque na captura de tela
convert $TEMP_BG -filter Gaussian -blur 0x55 $TEMP_BG

# Remove print criado após desbloqueio
cleanup(){
  if [ -f "$TEMP_BG" ]; then
    echo "$(date): Removendo $TEMP_BG" >> /tmp/lockscreen.log
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