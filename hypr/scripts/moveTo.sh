#!/usr/bin/env bash

target_workspace=$1

if [ -z "$target_workspace" ]; then
    exit 1
fi

# Get the ID of the currently active workspace (more robust than activewindow)
current_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.id')

# Find all windows on the current workspace and move them silently to the target
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $current_workspace) | .address" | xargs -I {} hyprctl dispatch movetoworkspacesilent $target_workspace,address:{}

# Switch to the target workspace
hyprctl dispatch workspace $target_workspace
