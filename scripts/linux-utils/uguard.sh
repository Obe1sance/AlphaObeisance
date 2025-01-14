#!/bin/bash

                        #\\\\\\\\\\\\\\\/////////////////#
                        ###          UGUARD            ###
                        #\\\\\\\\\\\\\\\/////////////////#
# The purpose of this script is to configure the Uncomplicated Firewall (UFW)
# on a Linux system. It sets up a secure default rule for blocking all incoming
# and outgoing traffic, then selectively allows essential traffic for web access
# and user-defined traffic through specified ports. This script is helpful for
# system administrators or users who want to configure firewall rules to protect
# their system from unauthorized access while allowing necessary communication.

# Define some color variables to make messages more readable and visually appealing
GREEN='\033[0;32m'    # Green for success messages
TEAL='\033[0;36m'     # Teal for informational messages
RESET='\033[0m'       # Reset color back to default

# Step 1: Disable UFW if it's already enabled (optional step)
echo -e "${TEAL}Disabling UFW if it is already enabled...${RESET}"
# This is to ensure we're starting with a clean slate
sudo ufw disable

# Step 2: Set default policies to deny all incoming and outgoing traffic
echo -e "${TEAL}Setting default rules to deny all incoming and outgoing traffic...${RESET}"
# This means that by default, no traffic will be allowed in or out.
sudo ufw default deny incoming
sudo ufw default deny outgoing

# Step 3: Allow outgoing traffic on essential ports for web access
echo -e "${TEAL}Allowing outgoing traffic on essential ports (DNS, HTTP, HTTPS)...${RESET}"
# These ports are required for the system to access the internet (DNS for domain lookups, HTTP for web browsing, HTTPS for secure browsing)
sudo ufw allow out 53   # Allow DNS traffic (used for domain name resolution)
sudo ufw allow out 80   # Allow HTTP traffic (used for web pages)
sudo ufw allow out 443  # Allow HTTPS traffic (secure web pages)

# Step 4: Enable the UFW firewall
echo -e "${TEAL}Enabling UFW firewall...${RESET}"
# This activates the firewall with the settings configured so far.
sudo ufw enable

# Step 5: Ask the user if they want to permit access to ports via specific IPs
echo -e "${TEAL}Would you like to permit access to specific ports via specific IPs? (y/n)${RESET}"
read -p "Please enter your choice: " permit_access

if [[ "$permit_access" == "y" || "$permit_access" == "Y" ]]; then
  while true; do
    # If the user answers "yes", prompt them to specify the IP addresses
    echo -e "${TEAL}Please enter the IP addresses you want to permit (comma-separated, e.g., 192.168.0.10, 10.0.0.5):${RESET}"
    read -p "IPs: " permit_from
    echo -e "${TEAL}Please enter the ports you would like to allow (comma-separated, e.g., 22, 8080):${RESET}"
    read -p "Ports: " ports

    # Process the input to split the comma-separated lists into individual IPs and ports
    IFS=',' read -ra IP_ARRAY <<< "$permit_from"
    IFS=',' read -ra PORT_ARRAY <<< "$ports"

    # Loop through the IPs and ports and apply the UFW rules for both incoming and outgoing traffic
    for ip in "${IP_ARRAY[@]}"; do
      for port in "${PORT_ARRAY[@]}"; do
        ip=$(echo $ip | xargs)  # Trim any spaces around the IP address
        port=$(echo $port | xargs)  # Trim any spaces around the port number
        echo -e "${TEAL}Allowing incoming and outgoing traffic for ${ip} on port ${port}...${RESET}"
        sudo ufw allow from $ip to any port $port
        sudo ufw allow out to $ip port $port
      done
    done

    echo -e "${GREEN}Traffic has been successfully allowed for the specified IPs on the specified ports.${RESET}"

    # Ask if the user wants to add more traffic rules
    echo -e "${TEAL}Would you like to allow more traffic for other IPs?${RESET} (y/n)"
    read -p "Enter your choice: " another_traffic
    if [[ "$another_traffic" != "y" && "$another_traffic" != "Y" ]]; then
      break
    fi
  done
fi

# Step 6: Reload UFW to apply all the changes
echo -e "${TEAL}Reloading UFW to apply changes...${RESET}"
sudo ufw reload

# Step 7: Show the current UFW status to confirm the changes
echo -e "${GREEN}UFW configuration completed. Here's the current UFW status:${RESET}"
# Display the full list of firewall rules and their statuses
sudo ufw status verbose
