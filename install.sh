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
 ln -svf "${dir}/bash/.bash_aliases" "${HOME}/.bash_aliases"
fi

if ask "Install symlink for tmux" Y; then
  ln -svf "${dir}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
fi

if ask "Install symlink for I3WM?:" Y; then
  ln -svf "${dir}/i3/config/i3_gaps_config" "${HOME}/.config/i3/i3_gaps_config"
  ln -svf "${dir}/i3/config/i3_media_config" "${HOME}/.config/i3/i3_media_config"
fi

if ask "Install symlink for I3status?:" Y; then
  ln -svf "${dir}/i3/i3status/config" "${HOME}/.config/i3status/config"
  ln -svf "${dir}/i3/i3status/i3status_custom.sh" "${HOME}/.config/i3status/i3statusi3status_custom.sh"
fi

if ask "Install symlink for urxvt?" Y; then
  ln -svf "${dir}/urxvt/.Xresources" "${HOME}/.Xresources"
  ln -svf "${dir}/urxvt/.Xdefaults" "${HOME}/.Xdefaults"
  ln -svf "${dir}/urxvt/.urxvt" "${HOME}/.urxvt"
fi

if ask "Install symlink for vim" Y; then
  ln -svf "${dir}/vim/.vimrc" "${HOME}/.vimrc"
  mkdir "~/.vim/autoload/"
  echo "PlugInstall: curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

