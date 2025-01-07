#!/bin/bash

# Copyright (c) 2021 AlphaObeisance
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR
# A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
{ sudo apt-get update && sudo apt-get upgrade -y; } >> "$LOG_DIR" 2>&1

# 2. Removing orphaned dependencies
log "Removing orphaned packages..."
echo "Removing orphaned packages..."
sudo apt-get autoremove -y >> "$LOG_DIR" 2>&1

# 3. Cleaning up unnecessary files
log "Cleaning up unnecessary files..."
echo "Cleaning up unnecessary files..."
sudo apt-get autoclean -y >> "$LOG_DIR" 2>&1

# 4. Checking disk space usage of each mounted file system
log "Checking disk space usage..."
echo "Checking disk space usage..."
df -h >> "$LOG_DIR" 2>&1

# 5. Listing all installed packages in alphabetical order
log "Listing all installed packages..."
echo "Listing installed packages..."
dpkg --get-selections | awk '{print $1}' | sort >> "$LOG_DIR" 2>&1

log "System Maintenance Completed..."
echo "System Maintenance Completed..."
