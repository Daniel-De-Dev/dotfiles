#!/usr/bin/env bash

DIR="$HOME/Screenshots"
FILE="Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
EDITOR="gimp"

mkdir -p "$DIR"

# Notify with Thumbnail & Click-to-Open
notify_view() {
    local fpath="$1"
    ACTION=$(notify-send \
        -i "$fpath" \
        "Screenshot Saved" \
        "Click to open in GIMP" \
        --action="open=Open in GIMP" \
        --wait)

    # If the user clicked the action, open the editor
    if [[ "$ACTION" == "open" ]]; then
        $EDITOR "$fpath" &
    fi
}

# Instant Capture
take_instant() {
    if [[ "$1" == "area" ]]; then
        # Freeze screen for selection
        hyprpicker -r -z & PID=$!
        sleep 0.1
        # Select region
        REGION=$(slurp -b "#00000080" -c "#888888ff" -w 1)
        kill "$PID" 2>/dev/null
        [[ -z "$REGION" ]] && exit 0
        grim -g "$REGION" "$DIR/$FILE"
    else
        grim "$DIR/$FILE"
    fi

    # Copy to clipboard
    wl-copy < "$DIR/$FILE"

    notify_view "$DIR/$FILE"
}

if [[ "$1" == "--instant" ]]; then take_instant "full"; exit 0; fi
if [[ "$1" == "--instant-area" ]]; then take_instant "area"; exit 0; fi

DELAY=$(echo -e "Immediate\n5s\n10s\n30s" | rofi -dmenu -p "Timer")
[[ -z "$DELAY" ]] && exit 0

TYPE_LABEL=$(echo -e "Screen\nArea\nOutput" | rofi -dmenu -p "Capture")
[[ -z "$TYPE_LABEL" ]] && exit 0
case "$TYPE_LABEL" in
    "Screen") TYPE="screen" ;;
    "Area")   TYPE="area" ;;
    "Output") TYPE="output" ;;
esac

# Select Action
ACT_LABEL=$(echo -e "Copy\nSave\nCopy & Save\nEdit" | rofi -dmenu -p "Action")
[[ -z "$ACT_LABEL" ]] && exit 0
case "$ACT_LABEL" in
    "Copy")        ACTION="copy" ;;
    "Save")        ACTION="save" ;;
    "Copy & Save") ACTION="copysave" ;;
    "Edit")        ACTION="edit" ;;
esac

# Handle Countdown
if [[ "$DELAY" != "Immediate" ]]; then
    SEC="${DELAY%s}"
    for i in $(seq $SEC -1 1); do
        notify-send -t 500 "Screenshot" "Taking shot in $i..."
        sleep 1
    done
fi

export GRIMBLAST_EDITOR="$EDITOR"

if [[ "$ACTION" == "edit" ]]; then
    grimblast edit "$TYPE"
else
    # Run grimblast and capture output filename
    # Grimblast prints the filename to stdout on success
    OUT_FILE=$(grimblast "$ACTION" "$TYPE" "$DIR/$FILE")

    # If a file was created/saved, show our custom notification
    if [[ -f "$OUT_FILE" ]]; then
        notify_view "$OUT_FILE"
    elif [[ "$ACTION" == "copy" ]]; then
         notify-send "Screenshot" "Copied to clipboard"
    fi
fi
