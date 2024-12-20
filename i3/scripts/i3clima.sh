#!/usr/bin/env bash

get_weather_info() {
    local result
    result=$(curl -s wttr.in\?format=1 | sed 's/ //g')
    if [[ $result =~ [Uu]nknown || ! $result =~ [0-9]+.*C$ ]]; then
        result=$(curl -s -X GET "https://api.wsclima.com.br/v1/stations/143/detail" \
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
    fi
    echo "$result"
}

get_day_of_week() {
    local day
    day=$(date +%a)
    echo "$day"
}

# Main function
main() {
    FILE="${HOME}/scripts/Output/i3clima"

    # Fetch weather information and day of the week
    local weather_info
    weather_info=$(get_weather_info)
    local day_of_week
    day_of_week=$(get_day_of_week)

    echo "$day_of_week.$weather_info" > "$FILE"
}
main

