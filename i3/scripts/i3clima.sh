#!/usr/bin/env bash

get_weather_info() {
    local result
    result=$(curl -s wttr.in\?format=1 | sed 's/ //g')
    if [[ $result =~ [Uu]nknown || ! $result =~ [0-9]+.*C$ ]]; then
        result="."
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
    FILE="/home/salaam/scripts/Output/i3clima"

    # Fetch weather information and day of the week
    local weather_info
    weather_info=$(get_weather_info)
    local day_of_week
    day_of_week=$(get_day_of_week)

    echo "$day_of_week.$weather_info" > "$FILE"
}
main

