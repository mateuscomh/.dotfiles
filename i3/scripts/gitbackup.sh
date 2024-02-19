#!/bin/bash

# Diretório onde os repositórios serão clonados
REPO_DIR="/home/salaam/giclones"

# Obter lista de repositórios do GitHub (substitua 'SEU_USUARIO' pelo seu nome de usuário do GitHub)
curl -s "https://api.github.com/users/mateuscomh/repos?per_page=1000" |
    grep -o 'git@github.com:[^"]*' |
    while read REPO_URL; do
        # Extrair o nome do repositório
        REPO_NAME=$(basename "${REPO_URL}" .git)
        # Clonar o repositório
        git clone --mirror "${REPO_URL}" "${REPO_DIR}/${REPO_NAME}.git"
    done

