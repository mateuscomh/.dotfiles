#!/usr/bin/env bash

# Configurações
CACHE_FILE="/tmp/weather_cache.txt"
CACHE_TIMEOUT=600  # Tempo de cache em segundos (10 minutos)
WEATHER_FORMAT="%c+%t"

# Função para obter informações do clima
get_weather_info() {
    local result

    # Tenta obter o clima do wttr.in com timeout de 5 segundos
    result=$(curl -s --max-time 5 "wttr.in?format=$WEATHER_FORMAT" | sed 's/ //g')

    # Verifica se a resposta é válida
    if [[ $result =~ [Uu]nknown || ! $result =~ [0-9]+.*C$ ]]; then
        echo "wttr.in indisponível ou resposta inválida. Usando API alternativa..." >&2

        # Tenta obter o clima da API alternativa
        result=$(curl -s --max-time 5 -X GET "https://api.wsclima.com.br/v1/stations/143/detail" \
            -H "Accept: application/json" \
            -H "Accept-Language: pt-BR,pt;q=0.7" \
            -H "Access-Control-Allow-Origin: *" \
            -H "Connection: keep-alive" \
            -H "Content-Type: application/json" \
            -H "DNT: 1" \
            -H "Origin: https://www.wsclima.com.br" \
            -H "Referer: https://www.wsclima.com.br/" \
            -H "Sec-Fetch-Dest: empty" \
            -H "Sec-Fetch-Mode: cors" \
            -H "Sec-Fetch-Site: same-site" \
            -H "Sec-GPC: 1" \
            -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36" \
            -H 'sec-ch-ua: "Brave";v="129", "Not=A?Brand";v="8", "Chromium";v="129"' \
            -H "sec-ch-ua-mobile: ?0" \
            -H "sec-ch-ua-platform: 'Linux'" | grep -oP '"temp":"\K[0-9]+\.[0-9]+' | head -n 1)

        # Adiciona o símbolo de grau Celsius à temperatura
        if [[ -n $result ]]; then
            result="${result}°C"
        else
            result="N/A"
        fi
    fi

    echo "$result"
}

# Função para obter o dia da semana
get_day_of_week() {
    local day
    day=$(LC_TIME=pt_BR.UTF-8 date +%a)
    echo "$day"
}

# Função principal
main() {
    local output_file="/home/salaam/scripts/Output/i3clima"
    local weather_info
    local day_of_week

    # Verifica se o cache é válido
    if [[ -f $CACHE_FILE ]]; then
        local cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
        if [[ $cache_age -lt $CACHE_TIMEOUT ]]; then
            # Usa o cache se ainda for válido
            weather_info=$(cat "$CACHE_FILE")
        else
            # Atualiza o cache
            weather_info=$(get_weather_info)
            echo "$weather_info" > "$CACHE_FILE"
        fi
    else
        # Cria o cache
        weather_info=$(get_weather_info)
        echo "$weather_info" > "$CACHE_FILE"
    fi

    # Obtém o dia da semana
    day_of_week=$(get_day_of_week)

    # Salva o resultado no arquivo de saída
    echo "$day_of_week.$weather_info" > "$output_file"
}

# Executa o script
main
