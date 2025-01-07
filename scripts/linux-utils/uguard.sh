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

# Use Case:
# - When you want to secure your Linux system by blocking all unnecessary incoming
#   and outgoing traffic, but still need access to essential services like web browsing.
# - When you need to configure firewall rules for specific incoming and outgoing
#   traffic based on IP addresses and ports, such as for a web server, database, or
#   other network services.
# - This script allows you to quickly configure your firewall settings by interacting
#   with the user and asking which ports and IPs should be allowed through.

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

# Step 5: Ask the user if they want to allow any additional outgoing ports
echo -e "${TEAL}Would you like to allow any additional outgoing ports?${RESET} (y/n)"
read -p "Please enter your choice: " allow_outgoing

if [[ "$allow_outgoing" == "y" || "$allow_outgoing" == "Y" ]]; then
  while true; do
    # If the user answers "yes", prompt them to specify additional outgoing ports
    echo -e "${TEAL}Please enter the outgoing ports you would like to allow (comma-separated, e.g., 3306, 8080):${RESET}"
    read -p "Ports: " ports

    # Process the input to split the comma-separated list into individual ports
    IFS=',' read -ra PORT_ARRAY <<< "$ports"
    for port in "${PORT_ARRAY[@]}"; do
      port=$(echo $port | xargs)  # Trim any spaces around the port number
      echo -e "${TEAL}Allowing outgoing traffic on port ${port}...${RESET}"
      sudo ufw allow out $port
    done
    echo -e "${GREEN}Outgoing ports have been successfully allowed.${RESET}"

    # Ask if the user wants to add more outgoing rules
    echo -e "${TEAL}Would you like to allow more outgoing ports?${RESET} (y/n)"
    read -p "Enter your choice: " another_outgoing
    if [[ "$another_outgoing" != "y" && "$another_outgoing" != "Y" ]]; then
      break
    fi
  done
fi

# Step 6: Ask the user if they want to allow any incoming ports
echo -e "${TEAL}Would you like to allow any incoming ports?${RESET} (y/n)"
read -p "Please enter your choice: " allow_incoming

if [[ "$allow_incoming" == "y" || "$allow_incoming" == "Y" ]]; then
  while true; do
    # If the user answers "yes", prompt them to specify which IP addresses and ports to allow incoming traffic from
    echo -e "${TEAL}Please enter the IP address you want to allow access from (e.g., 192.168.0.10):${RESET}"
    read -p "Example: 192.168.0.10: " permit_from
    echo -e "${TEAL}Please enter the incoming ports you would like to allow (comma-separated, e.g., 22, 8080):${RESET}"
    read -p "Ports: " ports

    # Process the input to split the comma-separated list into individual ports
    IFS=',' read -ra PORT_ARRAY <<< "$ports"
    for port in "${PORT_ARRAY[@]}"; do
      port=$(echo $port | xargs)  # Trim any spaces around the port number
      echo -e "${TEAL}Allowing incoming traffic from ${permit_from} on port ${port}...${RESET}"
      sudo ufw allow from $permit_from to any port $port
    done
    echo -e "${GREEN}Incoming traffic has been successfully allowed from ${permit_from} on the specified ports.${RESET}"

    # Ask if the user wants to add more incoming rules from other devices
    echo -e "${TEAL}Would you like to allow incoming traffic from another device?${RESET} (y/n)"
    read -p "Enter your choice: " another_device
    if [[ "$another_device" != "y" && "$another_device" != "Y" ]]; then
      break
    fi
  done

  # Ask if the user wants to add more incoming rules for other devices
  echo -e "${TEAL}Would you like to allow additional incoming ports for other devices?${RESET} (y/n)"
  read -p "Enter your choice: " another_incoming
  if [[ "$another_incoming" != "y" && "$another_incoming" != "Y" ]]; then
    break
  fi
fi

# Step 7: Show the current UFW status to confirm the changes
echo -e "${GREEN}UFW configuration completed. Here's the current UFW status:${RESET}"
# Display the full list of firewall rules and their statuses
sudo ufw status verbose
