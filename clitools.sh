#!/bin/bash

# Lista de repositórios GitHub
repos=(
	"mateuscomh/shellpass"
	"mateuscomh/pomodoro"
	"mateuscomh/diffdate.sh"
	"mateuscomh/yoURL"
	"mateuscomh/pressao"
	"mateuscomh/qrshell"
	"mateuscomh/timer"
	"mateuscomh/debfetch"
)

# Diretório onde os repositórios serão clonados
clone_dir="$HOME/cli-tools"
# Diretório onde os scripts .sh serão armazenados
bin_dir="$HOME/bin/gitclones"

# Cria os diretórios necessários, se não existirem
mkdir -p "$clone_dir"
mkdir -p "$bin_dir"

# Função para clonar um repositório e copiar scripts .sh
clone_and_copy_scripts() {
	repo=$1
	repo_name=$(basename "$repo")
	repo_dir="$clone_dir/$repo_name"

	# Clona ou atualiza o repositório
	if [ -d "$repo_dir" ]; then
		echo "Repositório $repo já existe em $repo_dir. Atualizando..."
		cd "$repo_dir" && git pull
	else
		echo "Clonando repositório $repo em $repo_dir..."
		git clone "https://github.com/$repo.git" "$repo_dir"
	fi

	# Cria links simbólicos para todos os scripts .sh no diretório bin
	echo "Criando links simbólicos para scripts .sh de $repo_name em $bin_dir..."
	find "$repo_dir" -name "*.sh" | while read script; do
		script_name=$(basename "$script" .sh)
		ln -sf "$script" "$bin_dir/$script_name"
	done

	if [ $? -eq 0 ]; then
		echo "Links simbólicos de $repo_name criados com sucesso!"
	else
		echo "Erro ao criar links simbólicos de $repo_name."
	fi
}

# Itera sobre a lista de repositórios e executa a função clone_and_link_scripts para cada um
for repo in "${repos[@]}"; do
	clone_and_link_scripts "$repo"
done

echo "Processo concluído!"
