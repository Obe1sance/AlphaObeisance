#!/usr/bin/env bash

#This is just a simple script for enabling/disabling vsync on NVIDIA GPU's. Just create an alias to execute this script to toggle the function on/off.
#The script effectively checks to ensure all nvidia related packages (proprietary) are installed and then toggles the vsync function.
#If using i3wm with multiple displays, you may need to refresh i3wm as sometimes wallpapers don't reload properly after the toggle.

#!/bin/bash

# Function to check if a package is installed
function package_installed {
    pacman -Qs "$1" >/dev/null 2>&1
}

# Function to install a package if it's not already installed
function install_package {
    if ! package_installed "$1"; then
        echo "$1 is missing, installing now..."
        sudo pacman -S --noconfirm "$1"
    fi
}

# Function to ensure all required NVIDIA packages are installed
function ensure_nvidia_packages {
    declare -a packages=("nvidia-utils" "nvidia-settings" "nvidia" "lib32-nvidia-utils" "lib32-nvidia-utils" "opencl-nvidia" "nvidia-dkms")

    for pkg in "${packages[@]}"; do
        install_package "$pkg"
    done
}

# Function to toggle vsync
function vsync {
    nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = $@ }"
}

# Check and install all required NVIDIA packages
echo "Ensuring appropriate NVIDIA packages are present..."
ensure_nvidia_packages

# Toggle vsync function
toggle_vsync() {
    if [[ $(nvidia-settings -tq CurrentMetaMode | grep ForceFullCompositionPipeline=On) ]]; then
        vsync Off
    else
        vsync On
    fi
}

# Main script logic
toggle_vsync
