#!/usr/bin/env bash

# LOG OUTPUT TO A FILE
LOG_FILE="/tmp/sketchybar_keyboard.log"
exec >> "$LOG_FILE" 2>&1

echo "--- $(date) ---"
echo "Sender: $SENDER"

# 1. FIND MACISM
if [ -f "/opt/homebrew/bin/macism" ]; then
  MACISM="/opt/homebrew/bin/macism"
elif [ -f "/usr/local/bin/macism" ]; then
  MACISM="/usr/local/bin/macism"
else
  MACISM="macism"
fi
echo "Using Macism at: $MACISM"

NAME="${NAME:-keyboard}"

US_LAYOUT="com.apple.keylayout.US"
SE_LAYOUT="com.apple.keylayout.Swedish-Pro"

# 2. GET CURRENT LAYOUT
CURRENT_LAYOUT=$($MACISM)
echo "Current Layout: '$CURRENT_LAYOUT'"

if [ "$SENDER" = "mouse.clicked" ]; then
  echo "Click detected. Attempting switch..."
  
  if [ "$CURRENT_LAYOUT" = "$US_LAYOUT" ]; then
    echo "Switching to SE ($SE_LAYOUT)"
    $MACISM "$SE_LAYOUT"
  else
    echo "Switching to US ($US_LAYOUT)"
    $MACISM "$US_LAYOUT"
  fi

  # Update variable
  CURRENT_LAYOUT=$($MACISM)
  echo "New Layout: '$CURRENT_LAYOUT'"
fi

# 3. UPDATE LABEL
if [ "$CURRENT_LAYOUT" = "$US_LAYOUT" ]; then
  SHORT_NAME="US"
elif [ "$CURRENT_LAYOUT" = "$SE_LAYOUT" ]; then
  SHORT_NAME="SE"
else
  SHORT_NAME="??"
fi

echo "Setting label to: $SHORT_NAME"
sketchybar --set $NAME label="$SHORT_NAME"
