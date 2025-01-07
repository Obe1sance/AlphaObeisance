#!/bin/bash

set -e

LOG_FILE="/var/log/arch_update.log"

# Function to update the system
update_system() {
    echo -e "\e[92mUpdating the system...\e[0m"
    sudo pacman -Sy archlinux-keyring && sudo pacman -Syu --noconfirm >> "$LOG_FILE" 2>&1
    echo "System update completed at $(date)" >> "$LOG_FILE"
    sleep 2
}

# Function to check package integrity
check_package_integrity() {
    echo -e "\e[92mVerifying installed package integrity...\e[0m"
    set +e  # Disable set -e temporarily
    sudo pacman -Qk >> "$LOG_FILE" 2>&1
    set -e  # Re-enable set -e
    echo "Package integrity check completed at $(date)" >> "$LOG_FILE"
    sleep 2
}

# Function to remove orphaned packages
remove_orphaned_packages() {
    echo -e "\e[92mRemoving orphaned packages...\e[0m"
    
    # Capture orphaned packages in an array
    mapfile -t orphans < <(sudo pacman -Qtdq)
    
    # Check if there are orphaned packages
    if [ ${#orphans[@]} -gt 0 ]; then
        # Remove orphaned packages one by one
        for pkg in "${orphans[@]}"; do
            sudo pacman -Rns "$pkg" --noconfirm >> "$LOG_FILE" 2>&1
        done
        echo "Removed ${#orphans[@]} orphaned packages at $(date)" >> "$LOG_FILE"
    else
        # Log if no orphaned packages found
        echo "No orphaned packages to remove." >> "$LOG_FILE"
    fi
    
    sleep 2
}


# Function to clear Pacman cache
clear_pacman_cache() {
    echo -e "\e[92mClearing Caches...\e[0m"
    sudo rm -rf /var/cache/pacman/pkg/* >> "$LOG_FILE" 2>&1
    echo "Caches cleared at $(date)" >> "$LOG_FILE"
    sleep 2
}

# Function to check for security updates
check_security_updates() {
    echo -e "\e[92mChecking for security updates...\e[0m"
    security_updates=$(pacman -Qlq | grep '/usr/share/doc/security' | uniq)
    if [ -n "$security_updates" ]; then
        echo "Security updates available:" >> "$LOG_FILE"
        echo "$security_updates" >> "$LOG_FILE"
        # Handle security updates here (e.g., notify user, take action)
    else
        echo "No security updates available." >> "$LOG_FILE"
    fi
    sleep 2
}

# Function to prompt user for reboot
prompt_for_reboot() {
    echo -n "Updates have been completed. Do you want to reboot now? (y/n): "
    read choice
    case "$choice" in
        y|Y ) sudo reboot ;;
        n|N ) echo "You chose not to reboot."; exit 0 ;;
        * ) echo "Invalid response. Please enter 'y' or 'n'."; prompt_for_reboot ;;
    esac
}

# Main function to execute all defined functions
main() {
    update_system
    check_package_integrity
    remove_orphaned_packages
    clear_pacman_cache
    check_security_updates

    echo -e "\e[92mSystem Maintenance completed...\e[0m"

    # Prompt user for reboot
    prompt_for_reboot
}

# Execute the main function
main
