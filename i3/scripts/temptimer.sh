#!/bin/bash

# Solicita o tempo do temporizador com um valor padrão de 10 segundos
read -p "Defina o tempo do temporizador (ex: 10s, 5m, 1h) [10s]: " tempo
tempo=${tempo:-10s}  # Define 10 segundos como padrão se não for especificado

# Converte o tempo para segundos
if [[ "$tempo" =~ ^[0-9]+[smh]$ ]]; then
    case ${tempo: -1} in
        s) segundos_total=${tempo%?} ;;
        m) segundos_total=$((${tempo%?} * 60)) ;;
        h) segundos_total=$((${tempo%?} * 3600)) ;;
        *) echo "Formato de tempo inválido."; exit 1 ;;
    esac
else
    echo "Formato de tempo inválido. Use o formato 10s, 5m ou 1h."
    exit 1
fi

# Solicita a mensagem de notificação
read -p "Digite a mensagem para exibir ao final do temporizador: " mensagem
mensagem=${mensagem:-"Tempo Encerrado!"}

echo "Iniciando temporizador por $tempo..."

bash -c "timer $tempo" &

# Variáveis de controle
intervalo=1  # Intervalo em segundos para atualizar a barra de progresso
total_passos=$((segundos_total / intervalo))
current=0

# Loop para atualizar a barra de progresso
while [ "$current" -le "$total_passos" ]; do
    progresso=$((current * 100 / total_passos))
    tempo_restante=$((segundos_total - current * intervalo))
    dunstify --icon preferences-desktop-screensaver \
        -h int:value:"$progresso" \
        -h 'string:hlcolor:#ff4444' \
        -h string:x-dunst-stack-tag:temporizador \
        --timeout=1010 "Temporizador em execução..." "Faltam $tempo_restante segundos"
    sleep "$intervalo"
    current=$((current + 1))
done

# Notificação e som final
dunstify -u critical "Temporizador" "$mensagem $(date '+%Y-%m-%d %H:%M:%S')"
paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga

