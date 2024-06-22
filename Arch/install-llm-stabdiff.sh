#!/bin/bash

#NOTICE: The following script is intended to install software that is most optimized with NVIDIA GPU's. Effectively tested on AMD Ryzen 9 5950x / RTX 4090 24GB with satisfactory ressults.

#The following script will effectively provide you with options to automatically install Ollama with OpenWebUI front end, Stable Diffusion WebUI by AUTOMATIC1111, or provide you
#with the option to update your OpenWebUI container.

#!/bin/bash

while true; do
    clear
    echo "=== Menu ==="
    echo "1. Install Ollama & OpenWebUI"
    echo "2. Install Stable Diffusion"
    echo "3. Update Docker using Watchtower"
    echo "4. Exit"
    echo -n "Enter your choice: "
    read choice

    case $choice in
        1)
            echo "Installing Ollama & OpenWebUI..."
            sudo pacman -S python3 python-virtualenv git wget curl python-numpy python-pip python-tensorflow python-cuda tensorflow cuda nvidia-container-toolkit ollama &&
            ollama pull mixtral
            cd ~ &&
            virtualenv venv &&
            source venv/bin/activate &&
            pip3 install torch torchvision torchaudio &&
            deactivate &&
            sudo docker run -d -p 3000:8080 --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
            ;;
        2)
            echo "Installing Stable Diffusion..."
            echo -n "Enter installation location (absolute path): "
            read install_location

            # Validate installation location
            if [[ ! -d "$install_location" ]]; then
                echo "Error: Installation location '$install_location' does not exist or is not a directory."
                continue
            fi

            cd "$install_location" &&
            sudo pacman -S git -y &&
            git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui &&
            cd stable-diffusion-webui &&
            yay -S python310 &&
            python3.10 -m venv venv &&
            ./webui.sh
            ;;
        3)
            echo "Updating Docker using Watchtower..."
            sudo docker run --rm --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once open-webui
            ;;
        4)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac

    echo -e "\nPress Enter to continue..."
    read
done
