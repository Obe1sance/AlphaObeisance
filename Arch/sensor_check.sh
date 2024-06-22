#!/bin/bash
#
# AlphaArch System Setup Script
# This script sets up an Arch Linux-based system with required packages and configurations.
# Make sure to review and customize this script to suit your needs before running it.
#
# Author: AlphaObeisance
# Version: 1.0
# Date: October 18, 2023

# Define colors for notifications
SUCCESS_COLOR="\033[32m"
ERROR_COLOR="\033[31m"
WARNING_COLOR="\033[1;33m"
GREEN_COLOR="\033[32m" # Added green color
RESET_COLOR="\033[0m"

# Function to notify success
function notify_success {
    echo -e "${SUCCESS_COLOR}$1${RESET_COLOR}"
}

# Function to notify errors
function notify_error {
    echo -e "${ERROR_COLOR}$1${RESET_COLOR}"
}

# Function to notify warnings
function notify_warning {
    echo -e "${WARNING_COLOR}$1${RESET_COLOR}"
}

# Function to set text to green
function set_text_green {
    echo -e "${GREEN_COLOR}$1${RESET_COLOR}"
}

# Function to wait for 2 seconds
function wait_2_seconds {
    sleep 2
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to get CPU temperature and frequency
get_cpu_data() {
  local cpu_temp=$(sensors -u | awk '/temp1_input/ {print $2}')
  local cpu_freq=$(cat /proc/cpuinfo | grep 'cpu MHz' | head -n 1 | awk '{print $4}')
  set_text_green "CPU Temperature: $cpu_temp °C"
  set_text_green "CPU Frequency: $cpu_freq MHz"
}

# Function to get GPU temperature and frequency
get_gpu_data() {
  if command_exists "nvidia-smi"; then
    local gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    local gpu_freq=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits)
    set_text_green "GPU Temperature: $gpu_temp °C"
    set_text_green "GPU Frequency: $gpu_freq MHz"
  else
    echo "NVIDIA GPU not found or nvidia-smi command not installed."
  fi
}

# Main function
main() {
  echo -e "${GREEN_COLOR}===== CPU and GPU Sensor Summary =====${RESET_COLOR}"
  get_cpu_data
  echo
  get_gpu_data
  echo -e "${GREEN_COLOR}=====================================${RESET_COLOR}"
}

main
