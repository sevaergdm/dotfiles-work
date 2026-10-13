#!/bin/sh

# Refreshes on network changes and wake, plus every 30s so the signal
# strength icon stays current. Click opens Wi-Fi settings.
wifi=(
  icon="󰤯"
  label="…"
  update_freq=30
  script="$PLUGIN_DIR/wifi.sh"
  click_script="open 'x-apple.systempreferences:com.apple.wifi-settings-extension'"
)
sketchybar --add item wifi right \
           --set wifi "${wifi[@]}" \
           --subscribe wifi wifi_change system_woke
