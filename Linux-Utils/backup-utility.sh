#!/bin/bash

#A simple backup utility.

# Prompt user for source directory
read -p "Enter the source directory: " source_dir

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

# Prompt user for destination directory
read -p "Enter the destination directory: " dest_dir

# Check if destination directory exists, if not, create it
if [ ! -d "$dest_dir" ]; then
    echo "Destination directory does not exist, creating it..."
    mkdir -p "$dest_dir"
fi

# Get base name of the source directory
base_name=$(basename "$source_dir")

# Create a timestamp for the backup file
timestamp=$(date +"%Y%m%d_%H%M%S")

# Compress the source directory
backup_file="$dest_dir/$base_name-$timestamp.tar.gz"
echo "Compressing $source_dir to $backup_file..."
tar -czf "$backup_file" -C "$(dirname "$source_dir")" "$base_name"

# Check if compression was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully."
else
    echo "Error occurred during backup."
fi
