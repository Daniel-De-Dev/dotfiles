#!/usr/bin/env bash

# Get windows list: "Title (Class) :::: Address"
WINDOWS=$(hyprctl clients -j | jq -r '.[] | select(.mapped and .hidden==false) | "\(.title)  <span weight=\"light\" color=\"gray\">(\(.class))</span> :::: \(.address)"')

# Select Window
CHOICE=$(echo -e "$WINDOWS" | rofi -dmenu -i -markup-rows -p "Window" -config ~/.config/rofi/config-compact.rasi)

# Extract Address (Everything after the separator)
ADDR=$(echo "$CHOICE" | awk -F " :::: " '{print $2}')

# Focus
if [[ -n "$ADDR" ]]; then
    hyprctl dispatch focuswindow address:"$ADDR"
fi
