#!/bin/bash

#This is a basic Fedora (and derivative) system maintenance script that effectively updates the system and cleans up irrelevant packages.

# Set log filename
LOG_FILE="maintenance.log"
LOG_DIR="$HOME/Downloads/$LOG_FILE"

# Check if the user has write permissions to ~/Downloads
if [ ! -w "$HOME/Downloads" ]; then
    echo "Error: You don't have write permissions for $HOME/Downloads. Please check your permissions."
    exit 1
fi

# Create a new log file if it doesn't exist, or append to an existing one
if [ ! -f "$LOG_DIR" ]; then
    touch "$LOG_DIR"
else
    tail -n +2 "$LOG_DIR" > temp && mv temp "$LOG_DIR"  # Remove the last line from the log file (header)
fi

# Add timestamp to each log entry
function log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_DIR"
}

# 1. Updating System Packages
log "Updating system..."
echo "Updating the system..."
{ sudo dnf update -y && sudo dnf upgrade -y; } >> "$LOG_DIR" 2>&1

# 2. Removing orphaned dependencies
log "Removing orphaned packages..."
echo "Removing orphaned packages..."
sudo dnf autoremove -y >> "$LOG_DIR" 2>&1

# 3. Cleaning up unnecessary files
log "Cleaning up unnecessary files..."
echo "Cleaning up unnecessary files..."
sudo dnf clean all >> "$LOG_DIR" 2>&1

# 4. Checking disk space usage of each mounted file system
log "Checking disk space usage..."
echo "Checking disk space usage..."
df -h >> "$LOG_DIR" 2>&1

# 5. Listing all installed packages in alphabetical order
log "Listing all installed packages..."
echo "Listing installed packages..."
rpm -qa | sort >> "$LOG_DIR" 2>&1

log "System Maintenance Completed..."
echo "System Maintenance Completed..."
