#!/usr/bin/env bash

if [ -f "/opt/homebrew/bin/macism" ]; then
  MACISM="/opt/homebrew/bin/macism"
elif [ -f "/usr/local/bin/macism" ]; then
  MACISM="/usr/local/bin/macism"
else
  MACISM="macism"
fi

NAME="${NAME:-keyboard}"

US_LAYOUT="com.apple.keylayout.US"
SE_LAYOUT="com.apple.keylayout.Swedish-Pro"

CURRENT_LAYOUT=$(macism)

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$CURRENT_LAYOUT" = "$US_LAYOUT" ]; then
    $MACISM "$SE_LAYOUT"
  else
    $MACISM "$US_LAYOUT"
  fi

  CURRENT_LAYOUT=$(macism)
fi

# labels
if [ "$CURRENT_LAYOUT" = "$US_LAYOUT" ]; then
  SHORT_NAME="US"
elif [ "$CURRENT_LAYOUT" = "$SE_LAYOUT" ]; then
  SHORT_NAME="SE"
else
  SHORT_NAME="??"
fi

sketchybar --set $NAME label="$SHORT_NAME"
