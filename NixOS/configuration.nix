# Per request I am providing a generic version of my NixOS configuration. I've removed most optional packages barring examples in environment.systemPackages where I include a small hand full of commonly desired applications.
# This configuration has been tested on 3 different AMD 5/7/9 Nvidia 2/3/4k builds and seemingly performs as to be expected in my experience. May require slight modifications on various hardware.
# The purpose of this configuration is to merely provide a foundational configuration for AMD (CPU) / NVIDIA (GPU) builds. Theoretically, you should be able to apply this to a fresh NixOS install, rebuild, and enjoy. 
# This configuration was fully functionial last I'd used. 
# See the NixOS Manual for more information located at https://nixos.org/manual/nixos/stable/

{ config, pkgs, ... }:

{
  imports = [                                 # Import hardware specific configurations
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;          # Allow the installation of unfree packages like Nvidia drivers
              
  system.stateVersion = "23.11";              # Set to your NixOS version. Check latest version here https://nixos.org/download/


  boot.loader.systemd-boot.enable = true;     # Enable systemd-boot instead of GRUB
  boot.kernelPackages = pkgs.linuxPackages_latest;  # Use the latest stable kernel
  boot.kernelModules = [ "nvidia_uvm" "nvidia_modeset" "nvidia_drm" "nvidia" "glaxnimate" ];  # Load these kernel modules at boot
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "nvme" "sd_mod" "sr_mod" ];  # Specify kernel modules in the initial RAM disk
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];   # Additional kernel parameters
  boot.supportedFilesystems = [ "ext4" "vfat" "ntfs" "exfat" ];  # Filesystems supported by the boot loader
  boot.kernel.sysctl."vm.swappiness" = 10;   # Reduce swappiness to prioritize physical memory over swap

  hardware.cpu.amd.updateMicrocode = true;   # Update AMD CPU microcode for security
  hardware.nvidia.package = pkgs.linuxPackages_latest.nvidiaPackages.stable;  # Specify the Nvidia driver package
  hardware.bluetooth.enable = true;          # Enable Bluetooth support
  hardware.opengl.driSupport32Bit = true;    # Enable 32-bit DRI support for OpenGL

  services.pipewire = {
    enable = true;                           # Enable PipeWire as the multimedia framework
    alsa.enable = true;                      # Enable ALSA support in PipeWire
    alsa.support32Bit = true;                # Enable 32-bit ALSA support
    pulse.enable = true;                     # Enable PulseAudio support in PipeWire
    jack.enable = true;                      # Enable JACK support in PipeWire
  };

  services.xserver = {
    enable = true;                           # Enable the X Server
    videoDrivers = [ "nvidia" ];             # Use the Nvidia driver
    displayManager.sddm.enable = true;       # Enable SDDM display manager
    desktopManager.plasma5.enable = true;    # Enable the Plasma 5 desktop
  };

  services.fail2ban.enable = true;           # Enable fail2ban to ban IPs that show malicious signs
  virtualisation.vmware.host.enable  = true; # Enable virutalization
  networking.firewall.enable = true;         # Enable the firewall

  environment.systemPackages = with pkgs; [  # Define system-wide packages to install. I've included commonly desired packages for example
    cmake dconf dualsensectl file firefox gamemode gcc git gnome.gnome-disk-utility htop iptables ipset
    libsForQt5.kdenlive linuxPackages_zen.cpupower lutris mangohud microcodeAmd
    nano neofetch nmap mlt obs-studio protonup-qt python3 steam tilix unzip
    vlc vscode-with-extensions wget zip 
  ];


  networking.hostName = "THERAK";            # Set the system's hostname
  networking.networkmanager.enable = true;   # Enable NetworkManager for network configuration

  time.timeZone = "America/Chicago";         # Set the system time zone
  i18n.defaultLocale = "en_US.UTF-8";        # Set the system locale

  security.sudo = {
    enable = true;                           # Enable sudo
    configFile = ''                          # Configure sudoers for 'wheel' group
      root ALL=(ALL:ALL) ALL
      %wheel ALL=(ALL:ALL) ALL
    '';
  };

  users.users.obeisance = {
    isNormalUser = true;                     # Indicate this is a normal user account
    extraGroups = [ "wheel" ];               # Add user to 'wheel' group for sudo access
    shell = pkgs.zsh;                        # Set Zsh as the default shell for this user
  };

  programs.zsh.enable = true;                # Enable Zsh for the system

  fonts.packages = with pkgs; [              # Font configuration
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra dejavu_fonts
  ];
                                             # File system configuration for mounting various storage devices
  fileSystems."/mnt/point" = { device = "UUID=your-uuid-here"; fsType = "ext4"; };
  fileSystems."/mnt/point" = { device = "UUID=your-uuid-here"; fsType = "ext4"; };
  fileSystems."/mnt/point" = { device = "UUID=your-uuid-here"; fsType = "ext4"; };

}
