#!/usr/bin/env bash

#
#  _____ _____ ___  _  _ _____
# | |   | ____/ _ \| \ | |__  /
# | |   |  _|| | | |  \| | / /
# | |___| |__| |_| | |\  |/ /_
# |_____|_____\___/|_| \_/____|
#
#
#   UPDATED SEPTEMBER 2025 (TESTED ON FEDORA 42 W/DNF 5)
#  
# - Start with freshly installed Fedora w/GUI
# - Verify internet connection
# - Make sure your (non-root) user exists and sudo works
# - To download this script, use:
#       wget https://raw.githubusercontent.com/leonzwrx/linux-setup-scripts/main/fedora_install_base.sh

set -e

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Set the username variable
username=$(whoami)
userhome="/home/$username"

# --- Critical System Configuration ---

echo "Adding user to wheel group and ensuring correct home directory ownership..."
sudo usermod -aG wheel $username

# Take ownership of homedir (using safe variables)
# This is a good practice, though usually not needed after initial install
sudo chown -R $username:$username $userhome

# --- DNF Package Management Functions ---

# Function to install core packages
install_core_packages() {
    echo "Updating package lists and upgrading installed packages..."
    sudo dnf update -y
    
    echo "Installing core development tools and libraries..."
    sudo dnf install -y "@development-tools" "@c-development"

    echo "Installing additional build tools..."
    sudo dnf install -y dkms kernel-devel curl git git-lfs patch cmake \
    diffutils meson xdotool jq gcc-c++ go iniparser iniparser-devel fftw3 \
    fftw-devel libwnck3-devel cargo
    echo "Installing Python tools..."
    sudo dnf install -y python3-pip python3-virtualenv python3-devel python3-pillow python3-build python3-installer 

    echo "Installing additional libraries for building from source..."
    sudo dnf install -y autoconf automake libtool pkgconf \
      openssl-devel libcurl-devel libxml2-devel zlib-devel \
      readline-devel ncurses-devel bzip2-devel \
      sqlite-devel pcre-devel libffi-devel \
      cairo cairo-devel cairo-gobject cairo-gobject-devel \
      pango pango-devel gdk-pixbuf2 gdk-pixbuf2-devel gtk3 \
      gtk3-devel gtk-layer-shell-devel libappindicator-gtk3 \
      gmp-devel expat-devel systemd-devel libevdev-devel

    echo "Installing network, file, and system tools..."
    sudo dnf install -y dialog acpi lm_sensors nmap-ncat htop zip unzip gedit \
      pcmanfm libfm-qt network-manager-applet kitty vim neovim trash-cli file-roller
}

# Function to install additional repositories
install_additional_repos() {
    echo "Enabling Fedora Workstation repositories..."
    sudo dnf install -y fedora-workstation-repositories

    echo "Adding RPM Fusion free and non-free repositories..."
    sudo dnf install -y \
      https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
      https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

# --- Directory & Git Management ---

create_directories() {
    echo "Creating standard user directories and updating XDG paths..."
    mkdir -p $userhome/Screenshots $userhome/Downloads $userhome/Applications $userhome/SourceBuilds $userhome/Backgrounds
    xdg-user-dirs-update --force
    cd "$userhome/Downloads"
}

# Use a temporary directory for all git clones
temp_dir=$(mktemp -d -p "$userhome/Downloads")

clone_and_install_git_repos() {
    echo "Cloning setup scripts into a temporary directory..."
    git clone https://github.com/leonzwrx/linux-setup-scripts.git "$temp_dir/linux-setup-scripts"

    echo "Cloning and installing Nordzy cursors..."
    git clone https://github.com/guillaumeboehm/Nordzy-cursors.git "$temp_dir/Nordzy-cursors"
    cd "$temp_dir/Nordzy-cursors"
    ./install.sh

    echo "Cloning and installing Nord theme for Gedit..."
    git clone https://github.com/nordtheme/gedit.git "$temp_dir/gedit"
    cd "$temp_dir/gedit"
    ./install.sh

    echo "Cloning and copying wallpapers..."
    git clone https://github.com/leonzwrx/leonz-wallpaper.git "$temp_dir/leonz-wallpaper"
    cp -r "$temp_dir/leonz-wallpaper"/* "$userhome/Backgrounds/"

    # Make scripts executable (if they exist)
    if [ -d "$temp_dir/linux-setup-scripts" ]; then
        chmod +x "$temp_dir/linux-setup-scripts"/*.sh
    fi
}

# --- Theming and Customization ---

install_fonts_and_themes() {
    echo "Installing fonts from DNF repositories..."
    sudo dnf install -y fontconfig google-droid-sans-fonts google-droid-serif-fonts google-droid-sans-mono-fonts \
      google-noto-sans-fonts google-noto-serif-fonts google-noto-mono-fonts google-noto-emoji-fonts google-noto-cjk-fonts \
      dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts adobe-source-serif-pro-fonts adobe-source-sans-pro-fonts \
      adobe-source-code-pro-fonts fontawesome-fonts-all terminus-fonts

    # Install nerdfonts if the script exists in the temporary directory
    if [ -f "$temp_dir/linux-setup-scripts/nerdfonts.sh" ]; then
        echo "Installing Nerd Fonts..."
        bash "$temp_dir/linux-setup-scripts/nerdfonts.sh"
    fi

    echo "Installing Ubuntu family of fonts..."
    sudo dnf -y copr enable atim/ubuntu-fonts
    sudo dnf install -y ubuntu-family-fonts
    sudo dnf -y copr disable atim/ubuntu-fonts

    echo "Rebuilding font cache..."
    fc-cache -vf

    # Install Nordic theme
    echo "Installing Nordic theme..."
    rm -rf "$HOME/.themes/Nordic"
    git clone https://github.com/EliverLara/Nordic.git "$HOME/.themes/Nordic" 
}

# --- Other Tool Installation ---

install_other_tools() {
    echo "Installing multimedia and sound tools..."
    sudo dnf install -y mpv imv mkvtoolnix brightnessctl \
      pavucontrol pipewire wireplumber playerctl pamixer pamix

    #pulsemixer not available in main repos, using pip / pipx
    #pipx install pulsemixer
    
    echo "Installing Flatpak and Flathub repository..."
    sudo dnf install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Installing Virtualization tools (QEMU/KVM)..."
    sudo dnf install -y @virtualization qemu-kvm qemu-img virt-manager virt-viewer libvirt-daemon-config-network libvirt-daemon-kvm

    echo "Installing other utilities..."
    sudo dnf install -y bc timeshift rclone
}

# --- Cleanup ---

clean_up() {
    echo "Cleaning up temporary files and packages..."
    sudo dnf autoremove -y
    # Remove the temporary directory and all its contents
    rm -rf "$temp_dir"
}

# --- Main Execution ---

main() {
    install_core_packages
    install_additional_repos
    create_directories
    clone_and_install_git_repos
    install_fonts_and_themes
    install_other_tools
    clean_up

    printf "\n\e[1;32mInstallation complete! You can now reboot to apply all changes. Thank you.\e[0m\n"
}

main
