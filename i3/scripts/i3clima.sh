#!/usr/bin/env bash

# Function to fetch weather information using curl
get_weather_info() {
    curl -s wttr.in\?format=1 | sed 's/ //g' > "$FILE"
}

# Function to check if weather information is unknown
is_unknown_weather() {
    head -n 1 "$FILE" | grep -q "^Unknown" || return 1
    return 0
}

# Main function
main() {
    FILE="/scripts/Output/i3clima"
    MAX_TRIES=5
    INTERVAL=360 # 6 minutes in seconds

    # Fetch weather information and write to file
    get_weather_info

    # Check if weather information is unknown
    if is_unknown_weather; then
        echo "--" > "$FILE"
        for ((try=1; try<=MAX_TRIES; try++)); do
            # Repeat curl command with a 6-minute interval, up to 5 tries
            sleep "$INTERVAL"
            get_weather_info
            if ! is_unknown_weather; then
                break
            fi
        done
    fi

    # Check if the file is empty and write '---' if needed
    if [ ! -s "$FILE" ]; then
        echo "---" > "$FILE"
    fi
}

# Call the main function
main

