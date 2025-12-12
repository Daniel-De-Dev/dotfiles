#!/usr/bin/env bash

# Path to keybindings
CONFIG="$HOME/.config/hypr/conf/keybinding.conf"

# Parse the config and pipe to Rofi
awk '/^bind/ && /#/ {
    # Remove "bind =" and replace $mainMod with Super
    sub(/^bind\s*=\s*/, "");
    gsub(/\$mainMod/, "Super");

    # Split the line into [Command Part] and [Comment Part]
    split($0, parts, "#");
    desc = parts[2];

    # Clean up whitespace in description
    gsub(/^\s+|\s+$/, "", desc);

    # Split the keys (e.g., "Super, Return, ...")
    split(parts[1], keys, ",");
    key_combo = keys[1] " + " keys[2];

    # Output format for Rofi
    printf "<b>%-20s</b>  %s\n", key_combo, desc
}' "$CONFIG" | rofi -dmenu -i -markup-rows -p "Keybinds" -config ~/.config/rofi/config-compact.rasi
