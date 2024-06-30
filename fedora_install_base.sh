#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - Start with freshly installed Fedora 40 w/GUI
# - Verify internet connection
# - Make sure your (non-root) user exists and sudo works
# - Follow pre-install-prep.txt prior
# - To download this script, use:
#     wget https://raw.githubusercontent.com/leonzwrx/linux-setup-scripts/main/fedora_install_base.sh

set -e

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Set the username variable
username=$(whoami)
userhome="/home/$username"

# Add your user to wheel group (if not already done)
sudo usermod -aG wheel $username
# Take ownership of homedir
sudo chown -R $username:$username $userhome

# Update package lists and upgrade installed packages

# Function to install core packages
install_core_packages() {
    # Update the package list and upgrade existing packages
    sudo dnf update -y
    sudo dnf upgrade -y 
    
    # Dev & build tools
    sudo dnf groupinstall -y "Development Tools" "Development Libraries" "C Development Tools and Libraries"

    # Install additional build tools
    sudo dnf install -y dkms kernel-devel curl git git-lfs patch cmake diffutils meson xdotool jq gcc-c++ go

    # Python tools
    sudo dnf install -y python3-pip python3-virtualenv python3-devel 

    # Additional useful tools for building from source
    sudo dnf install -y autoconf automake libtool pkgconf \
      openssl-devel libcurl-devel libxml2-devel zlib-devel \
      readline-devel ncurses-devel bzip2-devel \
      sqlite-devel pcre-devel libffi-devel \
      gmp-devel expat-devel

    # Network/File/System tools
    sudo dnf install -y dialog acpi lm_sensors nmap-ncat htop zip unzip gedit \
      thunar network-manager-applet terminator vim gvim
}

install_additional_repos() {
  # Additional Fedora Repos
  sudo dnf install -y fedora-workstation-repositories
  sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  sudo dnf config-manager --set-enabled google-chrome
  cat << EOF | sudo tee /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
}

create_directories() {
    mkdir -p $userhome/Screenshots $userhome/Downloads $userhome/Applications $userhome/SourceBuilds
    xdg-user-dirs-update
    cd $userhome/Downloads

    # Clone the repository
    rm -rf $userhome/Downloads/linux-setup-scripts
    git clone https://github.com/leonzwrx/linux-setup-scripts $userhome/Downloads/linux-setup-scripts

    # Make scripts executable (if they exist)
    chmod +x $userhome/Downloads/linux-setup-scripts/*.sh
}

install_fonts_and_themes() {
    # FONTS
    sudo dnf install -y fontconfig google-droid-sans-fonts google-droid-serif-fonts google-droid-sans-mono-fonts \
      google-noto-sans-fonts google-noto-serif-fonts google-noto-mono-fonts google-noto-emoji-fonts google-noto-cjk-fonts \
      dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts adobe-source-serif-pro-fonts adobe-source-sans-pro-fonts \
      adobe-source-code-pro-fonts fontawesome-fonts-all terminus-fonts

    # Install nerdfonts if the script exists
    if [ -f $userhome/Downloads/linux-setup-scripts/nerdfonts.sh ]; then
        bash $userhome/Downloads/linux-setup-scripts/nerdfonts.sh
    fi

  fc-cache -vf

  # Download Nordic Theme
  sudo git clone https://github.com/EliverLara/Nordic.git /usr/share/themes/Nordic

  # Optionally, later on manually install Orchis teal theme items
  # bash ./orchis-teal.sh

  # Install Nordzy cursor
  git clone https://github.com/alvatip/Nordzy-cursors $userhome/Downloads/Nordzy-cursors
  cd $userhome/Downloads/Nordzy-cursors
  ./install.sh
  cd $userhome/Downloads
  rm -rf Nordzy-cursors

  # Install Nord theme for gedit
  git clone https://github.com/nordtheme/gedit $userhome/Downloads/gedit
  cd $userhome/Downloads/gedit
  ./install.sh
  cd $userhome/Downloads
  rm -rf gedit

  # Download Nord wallpaper
  mkdir -p $userhome/Backgrounds
  git clone https://github.com/linuxdotexe/nordic-wallpapers $userhome/Downloads/nordic-wallpapers
  cp $userhome/Downloads/nordic-wallpapers/wallpapers/* $userhome/Backgrounds/
  rm -rf $userhome/Downloads/nordic-wallpapers
}

install_other_tools() {
    # Install Chrome
    sudo dnf install -y google-chrome-stable

    # Thunar plugins
    sudo dnf install -y thunar-archive-plugin thunar-volman file-roller

    # Sounds and multimedia
    sudo dnf install -y mpv imv mkvtoolnix redshift brightnessctl \
      pavucontrol pipewire wireplumber
      pip install pulsemixer
    # Install Flatpak
    sudo dnf install -y flatpak

    # Add Flathub repository (if not already added)
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Install Virtualization tools (including QEMU/KVM)
    sudo dnf install -y @virtualization qemu-kvm qemu-img virt-manager virt-viewer libvirt-daemon-config-network libvirt-daemon-kvm

    # Others
    sudo dnf install -y bc timeshift rclone
}

clean_up() {
    sudo dnf autoremove -y
}

main() {
    install_core_packages
    install_additional_repos
    create_directories
    install_fonts_and_themes
    install_other_tools
    clean_up

    printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
}

main
