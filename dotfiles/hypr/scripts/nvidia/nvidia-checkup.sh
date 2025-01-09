#!/bin/bash

#The purpose of this script is to ensure your rig is set up for optimal Nvidia compatability. Executing it simply runs checks to ensure appropriate packages and modules are installed and enabled, and reports NVIDIA
#compatability status to terminal.

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Color definitions for green/teal theme
GREEN='\033[0;32m'
TEAL='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'

# Check NVIDIA driver installation and version
echo -e "${BOLD}${TEAL}Checking NVIDIA driver...${RESET}"
if command_exists nvidia-smi; then
    nvidia_version=$(nvidia-smi | grep 'Driver Version' | awk '{print $3}')
    echo -e "${GREEN}NVIDIA driver is installed and active. Driver Version: $nvidia_version${RESET}"
else
    echo -e "${RED}nvidia-smi command not found. NVIDIA driver might not be installed or configured correctly.${RESET}"
    exit 1
fi

# Check NVIDIA kernel modules
echo -e "\n${BOLD}${TEAL}Checking NVIDIA kernel modules...${RESET}"
modules=(nvidia_drm nvidia_modeset nvidia_uvm nvidia)
missing_modules=()

for module in "${modules[@]}"; do
    if ! lsmod | grep -q "$module"; then
        missing_modules+=("$module")
    fi
done

if [ ${#missing_modules[@]} -eq 0 ]; then
    echo -e "${GREEN}All required NVIDIA modules are loaded: ${modules[*]}${RESET}"
else
    echo -e "${RED}The following NVIDIA modules are missing: ${missing_modules[*]}${RESET}"
    echo -e "${RED}Ensure that the NVIDIA driver is properly installed and configured.${RESET}"
    exit 1
fi

# Check OpenGL rendering
echo -e "\n${BOLD}${TEAL}Checking OpenGL rendering...${RESET}"
if command_exists glxinfo; then
    if glxinfo | grep -q 'NVIDIA'; then
        echo -e "${GREEN}OpenGL rendering is being handled by the NVIDIA GPU.${RESET}"
    else
        echo -e "${RED}OpenGL rendering is not being handled by the NVIDIA GPU. Check your graphics configuration.${RESET}"
    fi
else
    echo -e "${RED}glxinfo command not found. Please install the 'mesa-utils' package to check OpenGL rendering.${RESET}"
    exit 1
fi

echo -e "\n${GREEN}All checks passed. Your Linux system is properly utilizing the NVIDIA GPU.${RESET}"
