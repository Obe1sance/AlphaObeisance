#!/bin/bash

#A basic Fedora (and derivative) based user management script providing most general user management functions via a terminal menu.

# Define colors for echo messages
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

while true; do
    echo "Please select an action:"
    echo "1. Add user"
    echo "2. Modify user information"
    echo "3. Delete user"
    echo "4. List users"
    echo "5. List groups"
    echo "6. Modify permissions"
    echo "7. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) # Add user
            read -p "Enter the username: " username
            read -s -p "Enter the password: " password
            sudo useradd "$username" --create-home
            echo "$username:$password" | sudo chpasswd
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}User '$username' added successfully.${NC}"
            else
                echo -e "${RED}Failed to add user '$username'.${NC}"
            fi
            ;;
        2) # Modify user information
            read -p "Enter the username: " username
            while true; do
                echo "Please select an attribute to modify:"
                echo "1. Name"
                echo "2. Password"
                echo "3. Back to main menu"
                read -p "Enter your choice: " attr_choice

                case $attr_choice in
                    1) # Modify name
                        read -p "Enter the new name: " new_name
                        sudo usermod -l "$new_name" "$username"
                        if [ $? -eq 0 ]; then
                            echo -e "${GREEN}Name modified successfully.${NC}"
                        else
                            echo -e "${RED}Failed to modify name.${NC}"
                        fi
                        ;;
                    2) # Modify password
                        read -s -p "Enter the new password: " new_password
                        echo "$username:$new_password" | sudo chpasswd
                        if [ $? -eq 0 ]; then
                            echo -e "${GREEN}Password modified successfully.${NC}"
                        else
                            echo -e "${RED}Failed to modify password.${NC}"
                        fi
                        ;;
                    3) # Back to main menu
                        break;;
                    *) echo -e "${RED}Invalid choice. Please try again.${NC}";;
                esac
            done
            ;;
        3) # Delete user
            read -p "Enter the username: " username
            sudo userdel -r "$username"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}User '$username' deleted successfully.${NC}"
            else
                echo -e "${RED}Failed to delete user '$username'.${NC}"
            fi
            ;;
        4) # List users
            echo "Listing users:"
            cut -d: -f1 /etc/passwd
            ;;
        5) # List groups
            echo "Listing groups:"
            cut -d: -f1 /etc/group
            ;;
        6) # Modify permissions
            read -p "Enter the username: " username
            read -p "Enter the directory/file path: " filepath
            read -p "Enter the new permissions (in octal format, e.g., 755): " permissions

            # Check if the user exists
            if id "$username" &>/dev/null; then
                # Check if the file/directory exists
                if [ -e "$filepath" ]; then
                    # Modify permissions
                    sudo chmod "$permissions" "$filepath"
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Permissions modified successfully.${NC}"
                    else
                        echo -e "${RED}Failed to modify permissions.${NC}"
                    fi
                else
                    echo -e "${RED}File/directory '$filepath' does not exist.${NC}"
                fi
            else
                echo -e "${RED}User '$username' does not exist.${NC}"
            fi
            ;;
        7) # Exit
            break;;
        *) echo -e "${RED}Invalid choice. Please try again.${NC}";;
    esac
done
