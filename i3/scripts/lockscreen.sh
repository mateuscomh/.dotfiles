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
TEMP_BG='/tmp/lockscreen.png'

# Tira uma captura de tela
scrot $TEMP_BG

# Aplica o desfoque na captura de tela
convert $TEMP_BG -filter Gaussian -blur 0x55 $TEMP_BG

cleanup() {
    if [ -n "$TEMP_BG" ] && [ -f "$TEMP_BG" ]; then
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
