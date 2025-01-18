# Shell
alias vim='nvim'
alias ls='ls --color=auto'
alias ll='ls -laFh --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias igrep='/home/salaam/mydotfiles/scripts/igrep.sh'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
#alias getclip='xclip -selection clipboard -o'
alias clip='xclip -selection clipboard'
alias i3conf='vim ${HOME}/.config/i3/config'
alias aliases='vim ${HOME}/.bash_aliases'
alias functions='vim ${HOME}/.bash_functions'

# Networking
alias wlan0='wlp0s20f3'
alias morpheusssh='ssh -p 10024 modengo@192.168.2.185'
alias bladessh='ssh -p 10025 blade@192.168.2.186'
alias notes='/home/salaam/mydotfiles/scripts/syncobsidian.sh'

# Gitclones/Projetos
alias qrshell='~/bin/qrshell'
alias pressao='bash /gitclones/pressao/pressao'
alias pomodoro='/gitclones/pomodoro/pomodoro.sh'
alias yourl='~/bin/yourl'
alias passgen='/bin/shellPass'
alias shellPass='~/bin/shellPass'
alias diffdate='~/bin/diffdate'
alias timershell='~/bin/timershell'

# Git commands
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gl='git pull'
alias glg='git log --graph --oneline --decorate --all'
alias gb='git branch'
alias gco='git checkout'
alias gm='git merge'
alias gdd='git diff'

# Kubernetes
alias k='kubectl'
