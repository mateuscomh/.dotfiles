#!/bin/bash

# Executa o comando 'sensors' e obtém a linha contendo a temperatura
temp_line=$(sensors | grep "Tctl:")

# Extrai o número da temperatura
temp_value=$(echo "$temp_line" | grep -oP '\+\K\d+\.\d+')

# Imprime a temperatura formatada
echo "$temp_value°C" 

