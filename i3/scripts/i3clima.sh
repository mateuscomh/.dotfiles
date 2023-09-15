#!/usr/bin/env bash

get_weather_info() {
    local result=$(curl -s wttr.in\?format=1 | sed 's/ //g')
    if [[ $result =~ [Uu]nknown || $result != *C ]]; then
	      sed -i 's/$/./' "$FILE"
    else
        echo "$result" > "$FILE"
    fi
}

# Main function
main() {
    FILE="/home/salaam/scripts/Output/i3clima"

    # Fetch weather information and write to file
    get_weather_info
}

# Call the main function
main
