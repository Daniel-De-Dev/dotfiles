#!/usr/bin/env bash

DIR="$HOME/Videos"
LOCK="$HOME/.cache/screenrecording.lock"
INFO="$HOME/.cache/screenrecording.info"

mkdir -p "$DIR"

notify() {
    notify-send -t 2000 "Screen Recording" "$1"
}

get_active_monitor() {
    # Try to get the focused monitor
    MON=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name; exit}')

    # Fallback: If no focused monitor found, pick the first one available
    if [[ -z "$MON" ]]; then
        MON=$(hyprctl monitors | awk '/^Monitor/{print $2; exit}')
    fi

    echo "$MON"
}

# check: If lock file exists, stop
if [[ -f "$LOCK" ]]; then
    PID=$(cat "$LOCK")

    # Kill the recording process gracefully
    if kill -0 "$PID" 2>/dev/null; then
        kill -SIGINT "$PID"
    fi
    rm "$LOCK"

    # Handle the file copy
    if [[ -f "$INFO" ]]; then
        FILE=$(cat "$INFO")
        # Copy as file URI
        if command -v wl-copy &> /dev/null; then
            echo "file://$FILE" | wl-copy -t text/uri-list
        fi
        notify "Saved & Copied to clipboard:\n$(basename "$FILE")"
        rm "$INFO"
    else
        notify "Stopped (No file info found)."
    fi
    exit 0
fi

# start: New Recording
FILE="$DIR/Recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"

# Handle Area & Full
if [[ "$1" == "--area" ]]; then
    AREA=$(slurp)
    # Exit if selection cancelled
    [[ -z "$AREA" ]] && exit 0

    wf-recorder -x yuv420p -g "$AREA" -f "$FILE" & 
else
    # Auto-detect monitor
    MONITOR=$(get_active_monitor)

    if [[ -n "$MONITOR" ]]; then
        wf-recorder -x yuv420p -o "$MONITOR" -f "$FILE" &
    else
        # fallback: let wf-recorder decide (might default to first output)
        wf-recorder -x yuv420p -f "$FILE" &
    fi
fi

# Save PID and Filename for the stop phase
PID=$!
echo "$PID" > "$LOCK"
echo "$FILE" > "$INFO"

notify "Recording started..."
