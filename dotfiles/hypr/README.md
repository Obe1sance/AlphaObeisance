Hyprland Desktop Configuration on Arch Linux
=========================================
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////////////////#
###                         NVIDIA CONFIGURATION                                    ###
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////////////////#
## NVIDIA compatability check script available in /hypr/scripts/nvidia. Execute with ' bash nvidia-checkup.sh  `

# - NVIDIA: https://wiki.hyprland.org/Nvidia/
# - For NVIDIA Stability it simply tells you this
# - A: Install nvidia-dkms and nvidia-utils | sudo pacman -Syu && sudo pacman -S nvidia-dkms nvidia-utils
# - B: Enable modules | sudo nano /etc/mkinitcpio.conf
# - C: Set "MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)" without quotations ofc.
# - D: sudo nano /etc/modprobe.d/nvidia.conf
# - E: Set "options nvidia_drm modeset=1 fbdev=1" without quotations ofc.
# - F: Enjoy Hyprland with Nvidia.
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////////////////#

## NOTE: I have included the script /hypr/scripts/1-install.deps.sh that should theoretically install the dependancies if you want to akin your build to mine.

## File Structure Overview
~/.config/hypr/
├── configs/                  # Supplemental configuration files
│   ├── aesthetics.conf      # Visual and UI aesthetics
│   ├── autostart.conf       # Startup rules and processes
│   ├── environment.conf     # Global environment variables
│   ├── input-rules.conf     # Input device configurations
│   ├── keybindings.conf     # Keybinding definitions
│   ├── monitors.conf        # Multi-monitor setup
│   ├── variables.conf       # Global variables for Hyprland
│   ├── window-rules.conf    # Rules for window behaviors
│   ├── workspaces.conf      # Workspace definitions
├── themes/                   # Theme files for various components
│   ├── hyprlock/
│   │   ├── ao-bright.conf   # Bright theme for Hyprlock
│   │   ├── ao-dark.conf     # Dark theme for Hyprlock
├── images/                   # Directory for wallpapers
│   │   ├── wallpapers       # for self contained wallpaper storage
│   │   ├── avatars          # For self contained avatar storage
│   │   ├── logos            # For self contained logo storage
├── hyprland.conf             # Core configuration for Hyprland
├── hypridle.conf             # Configuration for idle behavior
├── hyprlock.conf             # Lock screen configuration
├── hyprpaper.conf            # Wallpaper configuration
└── README.md                 # This file

## Detailed Breakdown
1. Supplemental Configuration Files (configs/ Directory)
This folder contains additional configuration files that let you tweak specific aspects of your Hyprland environment.
- `aesthetics.conf`: Adjust the visual appearance of your desktop, such as color schemes and fonts.
- `autostart.conf`: Define applications that start automatically when Hyprland is launched.
- `input-rules.conf`: Customize input device behavior, like mouse and keyboard settings.
- `keybindings.conf`: Create custom keybindings for faster workflow and navigation.
- `monitors.conf`: Configure multi-monitor setups.
- `paths.conf`: Set paths to system directories and applications.
- `variables.conf`: Define global variables for use in other configuration files.
- `window-rules.conf`: Customize window behavior, like transparency and placement rules.
- `workspaces.conf`: Manage workspaces and window placement across them.

2. Themes (themes/ Directory)
This folder contains theme files for different Hyprland components.
- `hyprlock/`: Contains themes for the Hyprlock lock screen, including dark and light modes:
  - `ao-bright.conf`: A bright theme for Hyprlock.
  - `ao-dark.conf`: A dark theme for Hyprland.

3. Wallpapers (wallpapers/ Directory)
This directory holds your wallpaper images. You can add any wallpaper files here, and they will be available for use in your Hyprland configuration.

4. Core Configuration Files
These files contain the essential settings that define how Hyprland operates.
- `hyprland.conf`: This is the main configuration file called by Hyprland. It includes global settings and general configuration options for your Hyprland environment.
- `hypridle.conf`: Contains settings for idle behavior, such as how the system handles idle states and whether or not it should lock or go to sleep.
- `hyprlock.conf`: Manages the lock screen settings, such as appearance and behavior when locking the system.
- `hyprpaper.conf`: Configures wallpaper settings, allowing you to set wallpapers for different workspaces or monitor layouts.

## Getting Started
To begin customizing your Hyprland desktop, start by editing the core configuration files (hyprland.conf, hypridle.conf, etc.) to match your preferences. Then, explore the configs/ directory to fine-tune specific aspects of your setup, such as keybindings, appearance, or workspace management.

Feel free to modify any of these files and restart Hyprland to apply your changes.

## Need Help?
If you're new to Hyprland or need further assistance, check out the docs/how-to-keybind.conf guide for keybinding customization or refer to the [Hyprland documentation](https://hyprland.org/) for more in-depth information.

This file structure ensures that your Hyprland desktop is highly modular, customizable, and easy to maintain. Enjoy building your ideal desktop experience!```markdown
