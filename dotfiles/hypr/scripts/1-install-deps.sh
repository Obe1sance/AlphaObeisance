#!/bin/bash

# This script automates the installation of a set of predefined software packages on an Arch-based Linux system.
# The script is organized into categories based on the type of functionality:
#
# - Music control packages (e.g., playerctl, mpc)
# - System utilities (e.g., upower, networkmanager)
# - Wallpaper setting tools (e.g., feh)
# - Performance monitoring tools (e.g., btop, fastfetch)
# - File management utilities (e.g., ranger)
# - Application launchers (e.g., rofi)
#
# Additionally, the script ensures that the AUR helper `yay` is installed, which is required to install packages
# from the Arch User Repository (AUR). It also installs specific AUR packages such as hypridle, hyprlock, hyprpaper,
# and waypaper for managing your desktop environment.
#
# The script checks if each package is already installed and installs any missing packages using `pacman`
# or `yay` (for AUR packages) without requiring user interaction.
#
# To use this script, simply run it in a terminal on an Arch-based system with `sudo` privileges.
#
# Note: This script assumes you have a working internet connection and that your package manager is correctly configured.


# Music control packages
media_packages=(
  "playerctl"   # Control music playback (e.g., Spotify)
  "mpc"         # Control MPD (Music Player Daemon)
  "swaync"      # Notification Daemon
  "steam"
  "nwg-look"
)

# System packages for battery, network, and related utilities
system_packages=(
  "upower"      # Battery status information
  "networkmanager" # Network management tools (e.g., nmcli)
  "zed"
)

# Wallpaper setting packages
wallpaper_packages=(
  "feh"         # Simple image viewer and wallpaper setter
  "shotwell"
)

# Performance monitoring and system utilities
performance_packages=(
  "btop"        # A resource monitor (CPU, memory, disk, etc.)
  "fastfetch"   # A system information fetcher (useful for prompt customization)
  "nvtop"
)

# File management and navigation utilities
file_management_packages=(
  "ranger"      # A terminal file manager
  "thunar"      # A gui based file manager
)

# Application launchers
launcher_packages=(
  "rofi"        # A window switcher, application launcher, and more
)

# Function to check if a package is installed
is_installed() {
  if pacman -Q "$1" &> /dev/null; then
    echo "$1 is already installed."
  else
    echo "$1 is not installed. Installing..."
    sudo pacman -S --noconfirm "$1"
  fi
}

# Function to install yay (AUR helper)
install_yay() {
  # Check if yay is already installed
  if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Installing yay..."

    # Install necessary dependencies for building yay
    sudo pacman -S --needed --noconfirm base-devel git

    # Clone the yay repository from AUR
    git clone https://aur.archlinux.org/yay.git

    # Enter the yay directory
    cd yay

    # Build and install yay
    makepkg -si --noconfirm

    # Go back to the previous directory
    cd ..

    echo "yay has been installed successfully."
  else
    echo "yay is already installed."
  fi
}

# Function to install AUR packages using yay
install_aur_packages() {
  echo "Installing AUR packages..."

  yay -S --noconfirm hypridle hyprlock hyprpaper waypaper hyprshot
}

# Install yay (AUR helper) first
install_yay

# Install AUR packages (hypridle, hyprlock, hyprpaper, waypaper)
install_aur_packages

# Install all packages in the defined groups

# Loop through media packages and install them if not installed
echo "Installing media control packages..."
for package in "${media_packages[@]}"; do
  is_installed "$package"
done

# Loop through system packages and install them if not installed
echo "Installing system packages..."
for package in "${system_packages[@]}"; do
  is_installed "$package"
done

# Loop through wallpaper packages and install them if not installed
echo "Installing wallpaper setting packages..."
for package in "${wallpaper_packages[@]}"; do
  is_installed "$package"
done

# Loop through performance packages and install them if not installed
echo "Installing performance monitoring packages..."
for package in "${performance_packages[@]}"; do
  is_installed "$package"
done

# Loop through file management packages and install them if not installed
echo "Installing file management packages..."
for package in "${file_management_packages[@]}"; do
  is_installed "$package"
done

# Loop through launcher packages and install them if not installed
echo "Installing launcher packages..."
for package in "${launcher_packages[@]}"; do
  is_installed "$package"
done

echo "All packages installation completed!"
