#!/usr/bin/env bash

set -e
ask() {
  while true; do
    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi
    read -r -p "$1 [$prompt] " REPLY </dev/tty
    if [ -z "$REPLY" ]; then
      REPLY=$default
    fi
    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
      q*|Q*) exit 0 ;;
    esac
  done
}
dir=$(pwd)

if ask "Install symlink for bash" Y; then
 ln -svf "${dir}/bash/.bashrc" "${HOME}/.bashrc"
 ln -svf "${dir}/bash/.bash_logout" "${HOME}/.bash_logout"
 ln -svf "${dir}/bash/.bash_functions" "${HOME}/.bash_functions"
fi

if ask "Install symlink for tmux" Y; then
  ln -svf "${dir}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
fi

if ask "Install symlink for htop?:" Y; then
  if [ ! -d "$HOME/.config/htop/" ]; then
    mkdir -p "$HOME/.config/htop/"
  fi

  ln -svf "${dir}/htop/.config/htop/htoprc" "${HOME}/.config/htop/htoprc"
fi

if ask "Install symlink for atuin?:" Y; then
  if [ ! -d "$HOME/.config/atuin/" ]; then
    mkdir -p "$HOME/.config/atuin/"
  fi

  ln -svf "${dir}/atuin/config.toml" "${HOME}/.config/atuin/config.toml"
fi

if ask "Install symlink for solaar?:" Y; then
  if [ ! -d "$HOME/.config/solaar/" ]; then
    mkdir -p "$HOME/.config/solaar/"
  fi

  ln -svf "${dir}/solaar/config.yaml" "${HOME}/.config/solaar/config.yaml"
fi

if ask "Install symlink for I3WM?:" Y; then
  mkdir -p "$HOME/.config/systemd/user/"
  ln -svf "${dir}/i3/config/scripts/systemd/xautolock.service" "${HOME}/.config/systemd/user/xautolock.service"
  ln -svf "${dir}/i3/config/config" "${HOME}/.config/i3/config"
  ln -svf "${dir}/i3/config/i3_gaps_config" "${HOME}/.config/i3/i3_gaps_config"
  ln -svf "${dir}/i3/config/i3_media_config" "${HOME}/.config/i3/i3_media_config"
  ln -svf "${dir}/i3/scripts" "${HOME}/scripts"
fi

if ask "Install symlink for I3status?:" Y; then
  if [ ! -d "$HOME/.config/i3status/" ]; then
    mkdir -p "$HOME/.config/i3status/"
  fi

  ln -svf "${dir}/i3/i3status/i3status_custom.sh" "${HOME}/.config/i3status/i3status_custom.sh"
  ln -svf "${dir}/i3/i3status/config" "${HOME}/.config/i3status/config"
fi

if ask "Install symlink for urxvt?" Y; then
  ln -svf "${dir}/urxvt/.Xresources" "${HOME}/.Xresources"
  ln -svf "${dir}/urxvt/.Xdefaults" "${HOME}/.Xdefaults"
  ln -svf "${dir}/urxvt/.urxvt" "${HOME}/.urxvt"
fi

if ask "Install ranger configs" Y; then
  if [ ! -d "$HOME/.config/ranger/" ]; then
    mkdir -p "$HOME/.config/ranger/"
  fi

  ln -svf "${dir}/ranger" "${HOME}/.config/ranger"
fi

if ask "Install vim configs?" Y; then
  if [ ! -d "$HOME/.vim" ]; then
    mkdir -p "$HOME/.vim"
  fi

  ln -svf "${dir}/vim/vimrc" "${HOME}/.vim/vimrc"
  if [ ! -d "$HOME/.vim/autoload/" ]; then
    mkdir -p "$HOME/.vim/autoload/"
  fi
  
  ln -svf "${dir}/vim/autoload/autoload" "${HOME}/.vim/autoload/autoload"
  ln -svf "${dir}/vim/autoload/plug.vim" "${HOME}/.vim/autoload/plug.vim" 

  if [ ! -f "$HOME/.vim/autoload/plug.vim" ] || [ ! -s "$HOME/.vim/autoload/plug.vim" ]; then
    echo "PlugInstall: curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/mateuscomh/dotfiles/main/vim/autoload/autoload"
  fi
fi

if ask "Install alacritty configs" Y; then
  if [ ! -d "$HOME/.config/alacritty/" ]; then
    mkdir -p "$HOME/.config/alacritty/"
  fi

  ln -svf "${dir}/alacritty" "${HOME}/.config/alacritty"
fi

