#!/bin/bash

#The following script should effectively install ucode/microcode for amd/intel CPU's as well as AMD/NVIDIA GPU drivers respective of user selection through the submenu system.
#Option 1 will prompt user to select their "parent" distro, if you don't know, google it. Upon selecting your parent distro it will list derivative distro's that should still be compatible with this scripts functionality.
#NOTE: most derivatives typically retain the syntax and repo's of it's parent distro, therefor the syntax should still be functional and packages available.
#Option 2 will take you through choosing your parent distro, your hardware configuration selection and then finally it will install packages based on your selections.
#Report issues so they can be addressed, if you know what you're doing (likely better than I), please do a pull request with your changes and I'll review them asap.

#DISCLAIMER: The foundation of this script was generated by GPT and modified by yours truely. It's been tested on Arch Linux, Fedora, and Ubuntu and seemingly works as intended. Anyone willing to elaborately test functionality across distro's is welcome to do so and report back to encourage an updated compatability list.


# Function to display main menu
main_menu() {
    clear
    echo "$(tput setaf 3)=== Main Menu ===$(tput sgr0)"
    echo "$(tput setaf 2)1. Compatability Check"
    echo "2. Choose Distro"
    echo "$(tput setaf 1)3. Exit$(tput sgr0)"
}

# Function to list derivatives based on user selection for Arch Linux
list_derivatives_arch() {
    local distro_name="Arch Linux"
    derivatives=("Arch Linux" "Manjaro" "EndeavourOS" "ArcoLinux" "Artix Linux" "Garuda Linux" "Anarchy Linux" "ArcolinuxD" "ArchBang Linux" "ArchLabs Linux" "RebornOS" "Hyperbola GNU/Linux-libre" "Chakra" "Parabola GNU/Linux-libre" "Alpine Linux" "BlackArch Linux")
    clear
    echo "$(tput setaf 3)===$distro_name Derivatives=== $(tput sgr0)"
    for (( i=0; i<${#derivatives[@]}; i++ )); do
        echo "$((i+1)). ${derivatives[$i]}"
    done
    echo ""
    read -p "$(tput setaf 2)Press Enter to return to Main Menu$(tput sgr0)"
}

# Function to list derivatives based on user selection for Fedora
list_derivatives_fedora() {
    local distro_name="Fedora"
    derivatives=("Fedora" "Red Hat Enterprise Linux" "Rocky Linux" "AlmaLinux" "Oracle Linux" "CentOS" "ClearOS" "Scientific Linux" "Springdale Linux" "Virtuozzo Linux" "Endless OS" "Fedora CoreOS" "openSUSE Leap" "openSUSE Tumbleweed" "Mageia" "PCLinuxOS" "ROSA Linux" "ALT Linux" "SUSE Linux Enterprise Server")

    clear
    echo "$(tput setaf 3)===$distro_name Derivatives=== $(tput sgr0)"
    for (( i=0; i<${#derivatives[@]}; i++ )); do
        echo "$((i+1)). ${derivatives[$i]}"
    done
    echo ""
    read -p "$(tput setaf 2)Press Enter to return to Main Menu$(tput sgr0)"
}

# Function to list derivatives based on user selection for Debian
list_derivatives_debian() {
    local distro_name="Debian"
    derivatives=("Debian" "Ubuntu" "Linux Mint" "Pop!_OS" "MX Linux" "Kali Linux" "elementary OS" "Zorin OS" "Parrot OS" "PureOS" "BunsenLabs Linux" "Netrunner" "Deepin" "antiX" "Devuan" "SparkyLinux" "Lubuntu" "Xubuntu" "Kubuntu" "Ubuntu MATE" "Ubuntu Budgie" "Ubuntu Studio" "Ubuntu Kylin")

    clear
    echo "$(tput setaf 3)===$distro_name Derivatives=== $(tput sgr0)"
    for (( i=0; i<${#derivatives[@]}; i++ )); do
        echo "$((i+1)). ${derivatives[$i]}"
    done
    echo ""
    read -p "$(tput setaf 2)Press Enter to return to Main Menu$(tput sgr0)"
}

# Function to install packages for Arch Linux based on hardware selection
install_packages_arch() {
    local hardware=$1

    case $hardware in
        1)  # AMD CPU / NVIDIA GPU
            echo "Installing packages for AMD CPU / NVIDIA GPU on $(tput setaf 3)Arch Linux$(tput sgr0)"
            sudo pacman -S amd-ucode nvidia-dkms nvidia-utils nvidia-settings vulkan-tools
            ;;
        2)  # Intel CPU / NVIDIA GPU
            echo "Installing packages for Intel CPU / NVIDIA GPU on $(tput setaf 3)Arch Linux$(tput sgr0)"
            sudo pacman -S intel-ucode nvidia-dkms nvidia-utils nvidia-settings vulkan-tools
            ;;
        3)  # AMD CPU / AMD GPU
            echo "Installing packages for AMD CPU / AMD GPU on $(tput setaf 3)Arch Linux$(tput sgr0)"
            sudo pacman -S amd-ucode mesa vulkan-radeon vulkan-tools
            ;;
        4)  # Intel CPU / AMD GPU
            echo "Installing packages for Intel CPU / AMD GPU on $(tput setaf 3)Arch Linux$(tput sgr0)"
            sudo pacman -S intel-ucode mesa vulkan-radeon vulkan-tools
            ;;
        *) echo "$(tput setaf 1)Error: Invalid hardware selection.$(tput sgr0)";;
    esac
}

# Function to install packages for Fedora based on hardware selection
install_packages_fedora() {
    local hardware=$1

    case $hardware in
        1)  # AMD CPU / NVIDIA GPU
            echo "Installing packages for AMD CPU / NVIDIA GPU on $(tput setaf 3)Fedora$(tput sgr0)"
            sudo dnf install amd-ucode kernel-devel akmod-nvidia nvidia-settings vulkan-tools
            ;;
        2)  # Intel CPU / NVIDIA GPU
            echo "Installing packages for Intel CPU / NVIDIA GPU on $(tput setaf 3)Fedora$(tput sgr0)"
            sudo dnf install intel-ucode kernel-devel akmod-nvidia nvidia-settings vulkan-tools
            ;;
        3)  # AMD CPU / AMD GPU
            echo "Installing packages for AMD CPU / AMD GPU on $(tput setaf 3)Fedora$(tput sgr0)"
            sudo dnf install amd-ucode kernel-devel mesa-libGL-devel vulkan-radeon vulkan-tools
            ;;
        4)  # Intel CPU / AMD GPU
            echo "Installing packages for Intel CPU / AMD GPU on $(tput setaf 3)Fedora$(tput sgr0)"
            sudo dnf install intel-ucode kernel-devel mesa-libGL-devel vulkan-radeon vulkan-tools
            ;;
        *) echo "$(tput setaf 1)Error: Invalid hardware selection.$(tput sgr0)";;
    esac
}

# Function to install packages for Debian based on hardware selection
install_packages_debian() {
    local hardware=$1

    case $hardware in
        1)  # AMD CPU / NVIDIA GPU
            echo "Installing packages for AMD CPU / NVIDIA GPU on $(tput setaf 3)Debian$(tput sgr0)"
            sudo apt install amd64-microcode nvidia-driver nvidia-settings vulkan-tools -y
            ;;
        2)  # Intel CPU / NVIDIA GPU
            echo "Installing packages for Intel CPU / NVIDIA GPU on $(tput setaf 3)Debian$(tput sgr0)"
            sudo apt install intel-microcode nvidia-driver nvidia-settings vulkan-tools -y
            ;;
        3)  # AMD CPU / AMD GPU
            echo "Installing packages for AMD CPU / AMD GPU on $(tput setaf 3)Debian$(tput sgr0)"
            sudo apt install amd64-microcode mesa-vulkan-drivers vulkan-tools -y
            ;;
        4)  # Intel CPU / AMD GPU
            echo "Installing packages for Intel CPU / AMD GPU on $(tput setaf 3)Debian$(tput sgr0)"
            sudo apt install intel-microcode mesa-vulkan-drivers vulkan-tools -y
            ;;
        *) echo "$(tput setaf 1)Error: Invalid hardware selection.$(tput sgr0)";;
    esac
}

# Function to handle Arch Linux installation menu
install_packages_arch_menu() {
    clear
    echo "$(tput setaf 3)=== Install Packages for Arch Linux ===$(tput sgr0)"
    echo "$(tput setaf 2)Select hardware configuration:"
    echo "1. AMD CPU / NVIDIA GPU"
    echo "2. Intel CPU / NVIDIA GPU"
    echo "3. AMD CPU / AMD GPU"
    echo "4. Intel CPU / AMD GPU"
    echo "$(tput setaf 1)5. Return to Main Menu$(tput sgr0)"
    read -p "$(tput setaf 2)Enter your choice: $(tput sgr0)" hardware_option
    case $hardware_option in
        1|2|3|4) install_packages_arch $hardware_option;;
        5) return;;
        *) echo "$(tput setaf 1)Invalid option. Please try again.$(tput sgr0)";;
    esac
}

# Function to handle Fedora installation menu
install_packages_fedora_menu() {
    clear
    echo "$(tput setaf 3)=== Install Packages for Fedora ===$(tput sgr0)"
    echo "$(tput setaf 2)Select hardware configuration:"
    echo "1. AMD CPU / NVIDIA GPU"
    echo "2. Intel CPU / NVIDIA GPU"
    echo "3. AMD CPU / AMD GPU"
    echo "4. Intel CPU / AMD GPU"
    echo "$(tput setaf 1)5. Return to Main Menu$(tput sgr0)"
    read -p "$(tput setaf 2)Enter your choice: $(tput sgr0)" hardware_option
    case $hardware_option in
        1|2|3|4) install_packages_fedora $hardware_option;;
        5) return;;
        *) echo "$(tput setaf 1)Invalid option. Please try again.$(tput sgr0)";;
    esac
}

# Function to handle Debian installation menu
install_packages_debian_menu() {
    clear
    echo "$(tput setaf 3)=== Install Packages for Debian ===$(tput sgr0)"
    echo "$(tput setaf 2)Select hardware configuration:"
    echo "1. AMD CPU / NVIDIA GPU"
    echo "2. Intel CPU / NVIDIA GPU"
    echo "3. AMD CPU / AMD GPU"
    echo "4. Intel CPU / AMD GPU"
    echo "$(tput setaf 1)5. Return to Main Menu$(tput sgr0)"
    read -p "$(tput setaf 2)Enter your choice: $(tput sgr0)" hardware_option
    case $hardware_option in
        1|2|3|4) install_packages_debian $hardware_option;;
        5) return;;
        *) echo "$(tput setaf 1)Invalid option. Please try again.$(tput sgr0)";;
    esac
}

# Main script logic
while true; do
    main_menu
    read -p "$(tput setaf 2)Select an option: $(tput sgr0)" choice
    case $choice in
        1)
            clear
            echo "$(tput setaf 3)=== Compatability Check ===$(tput sgr0)"
            echo "$(tput setaf 2)Choose your parent distribution:"
            echo "NOTE: Selection will list derivative distro's that should theoretically be compatible with this script based on it's use of parents syntax and repos"
            echo "1. Arch Linux"
            echo "2. Fedora"
            echo "3. Debian"
            echo "$(tput setaf 1)4. Return to Main Menu$(tput sgr0)"
            echo "If you don't know, you should google it"
            read -p "$(tput setaf 2)Select distribution option: $(tput sgr0)" distro_option
            case $distro_option in
                1) list_derivatives_arch;;
                2) list_derivatives_fedora;;
                3) list_derivatives_debian;;
                4) continue;;
                *) echo "$(tput setaf 1)Invalid option. Please try again.$(tput sgr0)";;
            esac
            ;;
        2)
            clear
            echo "$(tput setaf 3)=== Choose Distro ===$(tput sgr0)"
            echo "$(tput setaf 2)Choose your parent Linux distribution:"
            echo "1. Arch Linux"
            echo "2. Fedora"
            echo "3. Debian"
            echo "$(tput setaf 1)4. Return to Main Menu$(tput sgr0)"
            read -p "$(tput setaf 2)Enter your choice: $(tput sgr0)" distro_option
            case $distro_option in
                1) install_packages_arch_menu;;
                2) install_packages_fedora_menu;;
                3) install_packages_debian_menu;;
                4) continue;;
                *) echo "$(tput setaf 1)Invalid option. Please try again.$(tput sgr0)";;
            esac
            ;;
        3)
            echo "$(tput setaf 1)Exiting...$(tput sgr0)"
            exit 0
            ;;
        *) echo "$(tput setaf 1)Invalid option. Please try again.$(tput sgr0)";;
    esac
done