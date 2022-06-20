#!/bin/bash

[[ "$-" != *i* ]] && return

#History options

# https://meleu.sh/bash-history
export EDITOR='vim'
export VISUAL="$EDITOR"
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTCONTROL='ignoreboth:erasedups'
export HISTIGNORE='ll:cd ..:cd -:ls:ls -lah:history:pwd:bg:fg:clear'
export PROMPT_COMMAND='history -a'
export HISTSIZE=
export HISTFILESIZE=

# shopt options
shopt -s histappend
shopt -s cmdhist

# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# colored options 
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Validate if the git are installed on system and change color on PS1
git --version > /dev/null 
GIT_IS_AVAILABLE=$?

if [ "$GIT_IS_AVAILABLE" -eq 0 ]; then
  parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
  }
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '

elif [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '

fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    LS_COLORS=$LS_COLORS:'ow=40;97' ; export LS_COLORS
fi
/usr/bin/setxkbmap -layout us_intl

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# To-do function
export TODO="${HOME}/.todo.txt"

[ ! -f "$TODO" ] && touch "$TODO"

# Create item to-do list
tla() { [ $# -eq 0 ] && cat $TODO || echo "$(echo $* | md5sum | cut -c 1-3) → $*" >> $TODO ;}
# Remove item on to-do list
tlr() { [ $# -eq 0 ] && cat $TODO || sed -i "/^$*/d" $TODO ;}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Header bash debfetch
# https://git.blauaraujo.com/blau_araujo/debfetch
/gitclones/debfetch/debfetch -dp
