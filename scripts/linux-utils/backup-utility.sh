#!/bin/bash

                    #///////////////////////////////////////////#
                    ###        ManBak Utility          ###
                    #///////////////////////////////////////////#
# Description:
# This script is a simple backup utility that:
# 1. Prompts the user to enter the source and destination directories.
# 2. Checks if the source directory exists and if not, exits with an error.
# 3. Verifies if the destination directory exists, and if it doesn't, creates it.
# 4. Creates a compressed backup of the source directory in the destination directory with a timestamp.
# 5. Reports the success or failure of the backup process.

# Prompt the user to enter the source directory
read -p "Enter the source directory (the folder you want to back up): " source_dir

# Check if the source directory exists
if [ ! -d "$source_dir" ]; then
    # If the source directory does not exist, print an error message and exit the script
    echo "Error: Source directory '$source_dir' does not exist."
    exit 1  # Exit the script with an error code
fi

# Prompt the user to enter the destination directory
read -p "Enter the destination directory (where you want to save the backup): " dest_dir

# Check if the destination directory exists
if [ ! -d "$dest_dir" ]; then
    # If the destination directory does not exist, print a message and create it
    echo "Destination directory '$dest_dir' does not exist, creating it..."
    mkdir -p "$dest_dir"  # Create the destination directory and any necessary parent directories
fi

# Get the base name of the source directory (i.e., the last part of the path)
base_name=$(basename "$source_dir")

# Generate a timestamp for the backup file, formatted as YYYYMMDD_HHMMSS
timestamp=$(date +"%Y%m%d_%H%M%S")

# Define the backup file path using the destination directory, base name, and timestamp
backup_file="$dest_dir/$base_name-$timestamp.tar.gz"

# Start compressing the source directory into a tar.gz file
echo "Compressing '$source_dir' to '$backup_file'..."

# Use the tar command to create a compressed archive of the source directory
tar -czf "$backup_file" -C "$(dirname "$source_dir")" "$base_name"

# Check if the tar command was successful
if [ $? -eq 0 ]; then
    # If the backup was successful, print a success message
    echo "Backup completed successfully. The backup file is located at '$backup_file'."
else
    # If there was an error during the backup, print an error message
    echo "Error occurred during backup."
    exit 1  # Exit the script with an error code
fi
