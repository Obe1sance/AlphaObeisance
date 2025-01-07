#!/bin/bash

# Function for input validation
validate_input() {
    if [[ -z $1 ]]; then
        echo "Error: Input cannot be empty. Please try again."
        return 1
    fi
}

# Function for error handling
handle_error() {
    local exit_code=$1
    local error_message=$2
    if [[ $exit_code -ne 0 ]]; then
        echo "Error: $error_message"
        exit $exit_code
    fi
}

# Function to install firewalld on Fedora
install_firewalld() {
    sudo dnf update -y
    handle_error $? "Failed to update package lists."
    sudo dnf install -y firewalld
    handle_error $? "Failed to install firewalld."
    sudo systemctl start firewalld
    handle_error $? "Failed to start firewalld."
    sudo systemctl enable firewalld
    handle_error $? "Failed to enable firewalld."
    echo "firewalld installed and enabled."
}

# Detect installed firewall utility
if command -v firewall-cmd &> /dev/null; then
    firewall_choice="firewalld"
    echo "firewalld detected."
else
    echo "Firewalld is not installed."
    read -p "Would you like to install firewalld? (yes/no): " install_firewall
    if [[ $install_firewall =~ ^[Yy](es)?$ ]]; then
        firewall_choice="firewalld"
        install_firewalld
    else
        echo "No firewall installed. Exiting."
        exit 0
    fi
fi

# Function to allow or deny ports
allow_deny_ports() {
    local action=$1
    local port=$2
    validate_input "$action"
    validate_input "$port"
    if [[ $firewall_choice == "firewalld" ]]; then
        if [[ $action == "allow" ]]; then
            sudo firewall-cmd --zone=public --add-port=$port/tcp --permanent
            handle_error $? "Failed to allow port $port with firewalld."
        elif [[ $action == "deny" ]]; then
            sudo firewall-cmd --zone=public --remove-port=$port/tcp --permanent
            handle_error $? "Failed to deny port $port with firewalld."
        fi
        sudo firewall-cmd --reload
        handle_error $? "Failed to reload firewalld configuration."
    fi
}

# Main menu
while true; do
    read -p "Would you like to open or close ports? (open/close/quit): " choice
    validate_input "$choice"
    case $choice in
        open)
            read -p "Enter the port number to allow: " port
            allow_deny_ports "allow" "$port"
            ;;
        close)
            read -p "Enter the port number to deny: " port
            allow_deny_ports "deny" "$port"
            ;;
        quit)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
done
