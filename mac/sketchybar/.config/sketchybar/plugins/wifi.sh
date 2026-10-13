#!/usr/bin/env bash

# Wi-Fi status: icon shows signal strength / state, label shows the SSID.
# The actual lookup lives in wifi_info.js (see there for why).

NAME="${NAME:-wifi}"
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

{
  read -r DEVICE
  read -r POWER
  read -r ACTIVE
  read -r RSSI
  read -r IP
  read -r SSID
} < <(osascript -l JavaScript "$CONFIG_DIR/plugins/wifi_info.js" 2>/dev/null)

# No Wi-Fi hardware (or the lookup failed): hide the item.
if [ -z "$DEVICE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

COLOR=0xffffffff
DIM=0x80ffffff

if [ "$POWER" != "1" ]; then
  ICON="󰤮" # wifi_strength_off_outline
  LABEL="Off"
  COLOR=$DIM
elif [ "$ACTIVE" != "1" ]; then
  ICON="󰤯" # wifi_strength_outline
  LABEL="Disconnected"
  COLOR=$DIM
elif [ -z "$IP" ]; then
  ICON="󰤫" # wifi_strength_alert_outline (associated, but no IP yet / DHCP failed)
  LABEL="${SSID:-No IP}"
else
  RSSI="${RSSI:-0}"
  if [ "$RSSI" -eq 0 ] || [ "$RSSI" -ge -60 ]; then
    ICON="󰤨" # wifi_strength_4
  elif [ "$RSSI" -ge -70 ]; then
    ICON="󰤥" # wifi_strength_3
  elif [ "$RSSI" -ge -80 ]; then
    ICON="󰤢" # wifi_strength_2
  else
    ICON="󰤟" # wifi_strength_1
  fi
  LABEL="${SSID:-Connected}"
fi

sketchybar --set "$NAME" \
  drawing=on \
  icon="$ICON" \
  icon.color="$COLOR" \
  label="$LABEL" \
  label.color="$COLOR"
