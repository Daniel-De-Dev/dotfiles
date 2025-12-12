#!/usr/bin/env bash

# Kill existing instances
killall waybar || pkill waybar
sleep 0.2

# Launch
waybar &
