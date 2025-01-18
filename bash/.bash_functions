#!/usr/bin/env bash

# functions for colorized output
# Inspiration:
#https://meleu.sh
# ANSI escape color codes
if [[ -z "${ansiRed}" ]]; then
	readonly ansiRed='\e[1;31m'
	readonly ansiGreen='\e[1;32m'
	readonly ansiYellow='\e[1;33m'
	readonly ansiNoColor='\e[0m'
fi

echoRed() {
	echo -e "${ansiRed}$*${ansiNoColor}"
}

echoGreen() {
	echo -e "${ansiGreen}$*${ansiNoColor}"
}

echoYellow() {
	echo -e "${ansiYellow}$*${ansiNoColor}"
}

err() {
	echoRed "$*" >&2
}

warn() {
	echoYellow "$*" >&2
}
#---

# termcp(): get stdin text and sent to clipboard
termcp() {
  xclip -selection clipboard < "$1"
}
#---

# dud(): get the disk usage of a directory and its subdirs
dud() {
    du --max-depth=1 --human-readable "${@:-.}" | sort --human-numeric-sort
}
#---

# getclip: spits the clipboard on stdout
getclip() {
  xclip -selection clipboard <<< "$*"
}

# lauch(): launch a aplication from terminal
launch() {
  case "$OSTYPE" in
    "cygwin"*)
      cygstart "$@"
      ;;
    "darwin"*) # MacOS
      open "$@"
      ;;
    *)
      xdg-open "$@"
      ;;
  esac
}
#---
# urlencode
###########
# URL encode using pure bash.
#
# Inspiration:
#https://meleu.sh
# https://github.com/dylanaraps/pure-bash-bible#percent-encode-a-string

urlencode() {
  local LC_ALL=C
  local string="${*:-$(cat)}"
  local length="${#string}"
  local char

  for (( i = 0; i < length; i++ )); do
    char="${string:i:1}"
    if [[ "$char" == [a-zA-Z0-9.~_-] ]]; then
      printf "$char"
    else
      printf '%%%02X' "'$char"
    fi
  done
  printf '\n'
}

#urlencode "$@"
#---

# urldecode
###########
# URL decode using pure bash.
#
# TODO: make it accept input from stdin
#
# inspiration:
# https://github.com/dylanaraps/pure-bash-bible#decode-a-percent-encoded-string

urldecode() {
  local encoded="${*:-$(cat)}"
  encoded="${encoded//+/ }"
  printf '%b' "${encoded//%/\\x}"
  printf '\n'
}

#urldecode "$@"
#----

# google(): Open google.com in the default browser, arguments are used as search terms.
google() {
	local terms
	terms="$(urlencode "$@")"
	launch "https://www.google.com/search?q=${terms}"
}
