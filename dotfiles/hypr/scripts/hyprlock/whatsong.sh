#!/bin/bash

# If using playerctl (Spotify, etc.)
if command -v playerctl &> /dev/null; then
    playerctl metadata title
# Alternatively, if using mpd (Music Player Daemon)
elif command -v mpc &> /dev/null; then
    mpc current
else
    echo "No song playing"
fi
