#!/bin/bash

# Set wallpaper using feh or any other wallpaper setter tool
if command -v feh &> /dev/null; then
    feh --bg-scale $HOME/.config/hypr/images/wallpapers/horizontal/animegirls/cyberpunk/marble-grace.png
else
    echo "feh is not installed, please install feh to set the wallpaper."
fi
