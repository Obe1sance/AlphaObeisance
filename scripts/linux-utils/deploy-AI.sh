#!/bin/bash

                                    #\\\\\\\\\\\\\\\/////////////////#
                                    ###         TOPHAT-AI          ###
                                    #\\\\\\\\\\\\\\\/////////////////#
# The purpose of this script is to assist in setting up and managing different AI tools and Docker containers.
# This includes installing Ollama & OpenWebUI, setting up Stable Diffusion, and updating Docker containers using Watchtower.
# It provides a simple menu-driven interface for these tasks.
# This script effectively deploys the ollama,openwebui,stable-diffusion,and AUTOMATIC1111 projects for your convenience.

# Define color codes for Green/Teal color scheme
GREEN='\033[0;32m'  # Green
TEAL='\033[1;36m'   # Teal
NC='\033[0m'        # No Color (reset to default)

while true; do
    clear
    echo -e "${TEAL}=== Menu ===${NC}"
    echo -e "${GREEN}1.${NC} Install Ollama & OpenWebUI"
    echo -e "${GREEN}2.${NC} Install Stable Diffusion & AUTOMATIC1111"
    echo -e "${GREEN}3.${NC} Update OpenWebUI using Watchtower"
    echo -e "${GREEN}4.${NC} Exit"
    echo -n "Enter your choice: "
    read choice  # Get the user's input for the menu option

    case $choice in
        1)
            # Install Ollama & OpenWebUI
            echo -e "${TEAL}Installing Ollama & OpenWebUI. Kick back, this will take a while. Anticipate need for your authorization...${NC}"
            # Update the system and install necessary dependencies:
            sudo pacman -S python3 python-virtualenv git wget curl python-numpy python-pip python-tensorflow python-cuda tensorflow cuda nvidia-container-toolkit ollama &&

            # Pull the Ollama model (example: mixtral):
            ollama pull mixtral

            # Create a Python virtual environment and install additional dependencies for AI processing:
            cd ~ &&
            virtualenv venv &&
            source venv/bin/activate &&
            pip3 install torch torchvision torchaudio &&
            deactivate  # Deactivate the virtual environment

            # Run OpenWebUI with Docker and configure it with GPU support:
            sudo docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main
            ;;
        2)
            # Install Stable Diffusion
            echo -e "${TEAL}Installing Stable Diffusion...${NC}"
            echo -n "Enter installation location (absolute path): e.g. /your/destination/here/ "
            read install_location  # Ask for the path where Stable Diffusion should be installed

            # Validate if the directory exists
            if [[ ! -d "$install_location" ]]; then
                echo -e "${GREEN}Error: Installation location '$install_location' does not exist or is not a directory.${NC}"
                continue  # Go back to the menu if the path is invalid
            fi

            # Install necessary dependencies and clone the Stable Diffusion WebUI repository
            cd "$install_location" &&
            sudo pacman -S git -y &&
            git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui &&
            cd stable-diffusion-webui &&
            yay -S python310 &&  # Install Python 3.10 (if it's not already installed)
            python3.10 -m venv venv &&  # Create a Python virtual environment
            ./webui.sh  # Start the web UI for Stable Diffusion
            ;;
        3)
            # Update Docker using Watchtower
            echo -e "${TEAL}Updating Docker using Watchtower...${NC}"
            # Run Watchtower to automatically check for and update Docker containers
            sudo docker run --rm --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once open-webui
            ;;
        4)
            # Exit the script
            echo -e "${TEAL}Exiting...${NC}"
            break  # Exit the while loop and terminate the script
            ;;
        *)
            # If an invalid option is entered
            echo -e "${GREEN}Invalid option. Please choose again.${NC}"
            ;;
    esac

    # Prompt the user to press Enter to continue after performing the selected action
    echo -e "\n${TEAL}Press Enter to continue...${NC}"
    read
done
