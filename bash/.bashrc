#!/bin/bash

# Configurações iniciais
########################

# TMUX (desativado)
 if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
     exec tmux
 fi

# Configurações do BASH
########################

# Configuração do teclado e idioma
# Seta repeticao de teclado
xset r rate 325 15
#xset r rate 225 15 #Define velocidade de repeticao dos caracteres
export LANG=C.UTF-8 #Variavel LANG UTF8
setxkbmap -layout us -variant intl #Layout teclado US-Internacional

# Opções do shell (shopt)
shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize

# Valida se é um shell interativo
[[ "$-" != *i* ]] && return

# Opções do histórico
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTCONTROL='ignoreboth:erasedups:ignorespace:ignoredups'
export HISTIGNORE='ll:cd ..:cd -:ls:ls -lah:history:pwd:bg:fg:clear'
export PROMPT_COMMAND='history -a'
export HISTSIZE=
export HISTFILESIZE=

# Configurações de aparência e prompt
######################################

# Detecta se suporta cores
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Função para extrair o nome do branch do Git
parse_git_branch() {
    local branch
    if git rev-parse --is-inside-work-tree &>/dev/null && branch=$(git branch 2>/dev/null | sed -n '/\* /s///p'); then
        if [ -n "$(git status --porcelain)" ]; then
            echo -e "($branch*)"
        else
            echo -e "($branch)"
        fi
    fi
}

# Configura o PS1 (prompt)
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi

# Configura o título da janela
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
    printf "\033]0;%s\007" "$1"
    ;;
*)
    ;;
esac

# Cores e aliases do ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    LS_COLORS=$LS_COLORS:'ow=40;97' ; export LS_COLORS
fi

# Carrega aliases personalizados
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Completar comandos no Bash
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Funções e comandos adicionais
################################

# Header bash debfetch
/gitclones/debfetch/debfetch -p -d

# Configuração do FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Funções para lista de tarefas (ToDo)
export TODO="${HOME}/.todo.txt"
[ ! -f "$TODO" ] && touch "$TODO"
tla() { [ $# -eq 0 ] && echo "------" || echo "$(echo $* | md5sum | cut -c 1-3) → $*" >> $TODO && cat $TODO;}
tlr() { [ $# -eq 0 ] && echo "------" || sed -i "/^$*/d" $TODO && cat $TODO;}

# Função 'gd' para navegação rápida entre diretórios
# gd em https://codeberg.org/blau_araujo/gd-function
gd() {
    local sel dir dirs dirs_hist dirs_home IFS fzf
    fzf=(
        fzf
        --reverse -e -i -1
        --prompt=': '
        --height=15%
        --border=horizontal
    )

    [[ $# -le 1 ]] || { echo 'gd: Excesso de argumentos!' 1>&2; return 1; }
    dir="${1:-$HOME}"
    case "$dir" in
        -)  # Muda para o último diretório visitado...
            dir=
            ;;
        --) # Abre a busca para todos os diretórios em $HOME (até 4 níveis)...
            dir=$(find $HOME -maxdepth 4 -type d | ${fzf[@]} || return 0)
            ;;
    esac

    pushd ${dir:+"$dir"} &> /dev/null && return
    dirs_hist=$(dirs -l -p | grep "$dir")
    dirs_home=$(find ~ -maxdepth 4 -type d -wholename "*$dir*")
    IFS=$'\n'
    dirs=(
        ${dirs_hist:+"$dirs_hist"}
        ${dirs_home:+"$dirs_home"}
    )
    ((${#dirs[@]})) || {
        echo "gd: $dir: Diretório não encontrado" 1>&2
        return 2
    }

    sel=$(printf '%s\n' "${dirs[@]}" | awk '!i[$0]++' | ${fzf[@]} || return 0)
    pushd "$sel" > /dev/null
}

complete -F _cd gd

# Adiciona diretório local ao PATH
PATH="$HOME/.local/bin:$PATH"

# Inicializa Atuin (se disponível)
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash --disable-up-arrow)"

