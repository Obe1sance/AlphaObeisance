#!/bin/bash

# Check if battery is present and get the status
if command -v upower &> /dev/null; then
    # Using upower to fetch battery status
    upower -i $(upower -e | grep battery) | grep -E "state|percentage" | awk '{print $2}'
else
    echo "Battery status unavailable"
fi
