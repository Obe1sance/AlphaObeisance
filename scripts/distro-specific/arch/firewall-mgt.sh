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

# Function to install ufw
install_ufw() {
    sudo pacman -Syu --noconfirm ufw
    handle_error $? "Failed to install ufw."
    sudo ufw enable
    handle_error $? "Failed to enable ufw."
    echo "ufw installed and enabled."
}

# Function to install firewalld
install_firewalld() {
    sudo pacman -Syu --noconfirm firewalld
    handle_error $? "Failed to install firewalld."
    sudo systemctl start firewalld
    handle_error $? "Failed to start firewalld."
    sudo systemctl enable firewalld
    handle_error $? "Failed to enable firewalld."
    echo "firewalld installed and enabled."
}

# Detect installed firewall utility
if command -v ufw &> /dev/null; then
    firewall_choice="ufw"
    echo "ufw detected."
elif command -v firewall-cmd &> /dev/null; then
    firewall_choice="firewalld"
    echo "firewalld detected."
else
    echo "Neither ufw nor firewalld are installed."
    read -p "Would you like to install a firewall? (yes/no): " install_firewall
    if [[ $install_firewall =~ ^[Yy](es)?$ ]]; then
        read -p "Which firewall would you like to install? (ufw/firewalld): " firewall_choice
        validate_input "$firewall_choice"
        if [[ $firewall_choice == "ufw" ]]; then
            install_ufw
        elif [[ $firewall_choice == "firewalld" ]]; then
            install_firewalld
        else
            echo "Invalid choice. Exiting."
            exit 1
        fi
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
    if [[ $firewall_choice == "ufw" ]]; then
        if [[ $action == "allow" ]]; then
            sudo ufw allow $port
            handle_error $? "Failed to allow port $port with ufw."
        elif [[ $action == "deny" ]]; then
            sudo ufw deny $port
            handle_error $? "Failed to deny port $port with ufw."
        fi
    elif [[ $firewall_choice == "firewalld" ]]; then
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
