#!/bin/bash

#A simple NixOS cleanup script.

# Remove unused packages
echo "Removing unused packages..."
sudo nix-collect-garbage

# Clear the Nix store
echo "Clearing the Nix store..."
sudo nix-store --gc

# Delete old generations
echo "Deleting old generations..."
sudo nix-env --delete-generations old

# Clean the temporary build directory
echo "Cleaning the temporary build directory..."
sudo nix-store --delete /nix/var/nix/gcroots/auto/*

# Display disk usage after cleanup
echo "Disk usage after cleanup:"
df -h
 
