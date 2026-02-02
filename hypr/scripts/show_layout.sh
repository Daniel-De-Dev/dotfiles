#!/usr/bin/env bash

IMG1="$HOME/.config/hypr/keyboard-layout-split.png"
IMG2="$HOME/.config/hypr/keyboard-layout-dactyl.png"
TEMP_IMG="/tmp/hypr-layout-combined.png"

magick "$IMG1" "$IMG2" +append "$TEMP_IMG"

kitten icat --hold "$TEMP_IMG"
