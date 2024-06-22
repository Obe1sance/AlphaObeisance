#!/bin/bash

#An Arch Linux maintanence script.

# Set log filename
LOG_FILE="maintenance.log"
LOG_DIR="/var/log"

# Full path to the log file
LOG_PATH="$LOG_DIR/$LOG_FILE"

# Ensure the script is run with sufficient privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[32mError: This script must be run as root.\033[0m"
    exit 1
fi

# Create a new log file if it doesn't exist
if [ ! -f "$LOG_PATH" ]; then
    touch "$LOG_PATH"
    chmod 644 "$LOG_PATH"  # Ensure the log file has appropriate permissions
fi

# Add timestamp to each log entry
function log() {
    echo -e "\033[32m[$(date '+%Y-%m-%d %H:%M:%S')]\033[0m $*" | tee -a "$LOG_PATH"
}

# 1. Updating System Packages
log "Updating system..."
sudo pacman -Sy --noconfirm && sudo pacman-key --init --keyserver hkp://keys.gnupg.net >> "$LOG_PATH" 2>&1

# 2. Refresh the package database to ensure the latest signatures are used
log "Refreshing package databases..."
sudo pacman -Syy --noconfirm >> "$LOG_PATH" 2>&1

# 3. Updating the archlinux-keyring package to ensure that all packages are verified correctly
log "Updating archlinux-keyring..."
sudo pacman -S --noconfirm archlinux-keyring >> "$LOG_PATH" 2>&1

# 4. Updating installed packages
log "Updating installed packages..."
sudo pacman -Syu >> "$LOG_PATH" 2>&1

# 5. Removing orphaned dependencies
log "Removing orphaned packages..."
sudo pacman -Rns $(pacman -Qdtq) --noconfirm >> "$LOG_PATH" 2>&1

# 6. Removing all unnecessary files, such as cache and log files
log "Cleaning up unnecessary files..."
sudo pacman -Scc --noconfirm >> "$LOG_PATH" 2>&1

# 7. Checking disk space usage of each mounted file system
log "Checking disk space usage..."
df -hT >> "$LOG_PATH" 2>&1

# 8. Listing all installed packages in alphabetical order
log "Listing all installed packages..."
pacman -Qe >> "$LOG_PATH" 2>&1

log "System Maintenance Completed."

# Announce log location to the user
echo -e "\033[32mSystem maintenance completed. Log file can be found at: $LOG_PATH\033[0m"
