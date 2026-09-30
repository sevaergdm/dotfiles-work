#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/plugins/icon_map_fn.sh"

AEROSPACE="/opt/homebrew/bin/aerospace"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=0x88FF00FF label.shadow.drawing=on icon.shadow.drawing=on background.border_width=2
else
  sketchybar --set $NAME background.color=0x44FFFFFF label.shadow.drawing=off icon.shadow.drawing=off background.border_width=0
fi

APPS=$($AEROSPACE list-windows --workspace "$1" | awk -F"|" '{gsub(/^ *| *$/, "", $2); print $2}')

ICON_STRIP=" "
if [ "${APPS}" != "" ]; then
  while read -r app; do
    ICON_STRIP+="$(icon_map "$app")"
  done <<<"${APPS}"
else
  ICON_STRIP=""
fi

sketchybar --set $NAME label="$ICON_STRIP"
