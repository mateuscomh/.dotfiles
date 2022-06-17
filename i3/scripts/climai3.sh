#!/usr/bin/env bash
# --------------------------------------------------------------------------------
# Copyright (C) 2020 Matheus Martins <3mhenrique@gmail.com>
# License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law
# --------------------------------------------------------------------------------

#sleep 15 && 
curl -s wttr.in\?format=1 | sed 's/ //g' > /scripts/Output/i3clima

FILE="/scripts/Output/i3clima"
MAXSIZE="17"
FILESIZE=$(stat -c%s "$FILE")
if [ "$FILESIZE" -le "$MAXSIZE" ]; then
  exit 0
else
  echo "" > /scripts/Output/i3clima
  exit 1
fi

