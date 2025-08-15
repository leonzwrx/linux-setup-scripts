#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
# - Start with stock minimal Debian 1333 install with no GUI:
#   - Preferred installation - expert, no root account, manual partitioning
#   - Guide: https://www.youtube.com/watch?v=_zC4S7TA1GI
#   - Install zram-tools and set zram to 8GB
#   - If updating from stable to testing, use 'forky' in apt sources instead of testing;
#     - this will track forky journey as it becomes stable and disable backports
#   - Make sure your (non-root) user exists and sudo is installed
#   - To download this script into /tmp, use:
#     wget https://raw.githubusercontent.com/leonzwrx/linux-setup-scripts/refs/heads/main/_debian_base_trixie.sh

# Exit immediately if a command exits with a non-zero status
set -e

# Take ownership of homedir (using safe variables)
# This is a good practice, though usually not needed after initial install
sudo chown -R $(whoami):$(whoami) $HOME

# --- Functions ---

install_core_packages() {
    echo "Updating system and installing core packages..."
    sudo apt update
    sudo apt upgrade -y

    # Core build tools and libraries
    sudo apt install -y build-essential dkms module-assistant linux-headers-$(uname -r) \
        curl git git-lfs patch make cmake cmake-extras diffutils meson xdotool jq gcc g++ golang \
        libnotify-dev libnotify-bin wmctrl

    # Additional useful tools for building from source
    sudo apt install -y autoconf automake libtool pkg-config \
        libssl-dev libcurl4-openssl-dev libxml2-dev zlib1g-dev \
        libreadline-dev libncurses5-dev libbz2-dev \
        libsqlite3-dev libpcre3-dev libffi-dev \
        libgmp-dev libexpat1-dev \
        libcairo2 libcairo2-dev libcairo-gobject2 \
        libpango1.0-0 libpango1.0-dev libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev \
        libgtk-3-0 libgtk-3-dev libgtk-layer-shell-dev

    # Python tools
    sudo apt install -y python3-pil python3-pip python3-dev python3-i3ipc pipx

    # Network/File/System tools
    sudo apt install -y dialog acpi acpid lm-sensors netcat-traditional htop zip unzip gedit nala \
        pcmanfm libfm-qt12 xdg-utils vim mtools dosfstools kitty locate trash-cli file-roller \
        avahi-daemon avahi-utils gvfs-backends network-manager network-manager-gnome zram-tools mate-polkit

    sudo systemctl enable avahi-daemon
    sudo systemctl enable acpid
}

install_additional_repos() {
    # Placeholder for any additional repos or packages not in normal repos
    echo "No additional repositories to install."
}

create_directories() {
    echo "Creating user directories and cloning scripts..."
    mkdir -p "$HOME/Screenshots" "$HOME/Downloads" "$HOME/Applications" "$HOME/SourceBuilds"
    xdg-user-dirs-update

    # Clone the repository to a temporary directory for safety
    temp_dir=$(mktemp -d)
    git clone https://github.com/leonzwrx/linux-setup-scripts "$temp_dir"

    # Copy the script to a user-local location
    mkdir -p "$HOME/Downloads/linux-setup-scripts"
    cp -r "$temp_dir"/* "$HOME/Downloads/linux-setup-scripts/"

    # Remove temporary directory
    rm -rf "$temp_dir"

    # Make scripts executable (if they exist)
    chmod +x "$HOME"/Downloads/linux-setup-scripts/*.sh || true # `|| true` prevents the script from failing if no .sh files are present
}

install_fonts_and_themes() {
    echo "Installing fonts and themes..."
    # Install repository fonts
    sudo apt install -y fontconfig fonts-noto fonts-dejavu fonts-dejavu-extra fonts-firacode fonts-jetbrains-mono \
        powerline fonts-font-awesome fonts-recommended fonts-ubuntu fonts-terminus

    # Install Nerd Fonts if the script exists
    if [ -f "$HOME/Downloads/linux-setup-scripts/nerdfonts.sh" ]; then
        bash "$HOME/Downloads/linux-setup-scripts/nerdfonts.sh"
    else
        echo "Nerd Fonts script not found. Skipping."
    fi

    # Update font cache
    fc-cache -vf

    # --- Themes and Cursors (installing locally for the user) ---
    mkdir -p "$HOME/.themes" "$HOME/.icons"

    # Download Nordic Theme to the user's local themes directory
    echo "Installing Nordic theme..."
    git clone https://github.com/EliverLara/Nordic.git "$HOME/.themes/Nordic"

    # Install Nordzy cursor to the user's local icons directory
    echo "Installing Nordzy cursors..."
    temp_dir=$(mktemp -d)
    git clone https://github.com/alvatip/Nordzy-cursors "$temp_dir"
    "$temp_dir"/install.sh
    rm -rf "$temp_dir"

    # Install Nord theme for gedit
    echo "Installing Nord theme for gedit..."
    temp_dir=$(mktemp -d)
    git clone https://github.com/nordtheme/gedit "$temp_dir"
    "$temp_dir"/install.sh
    rm -rf "$temp_dir"

    # Download my wallpaper
    echo "Downloading wallpaper..."
    temp_dir=$(mktemp -d)
    git clone https://github.com/leonzwrx/leonz-wallpaper "$temp_dir"
    mkdir -p "$HOME/Backgrounds"
    cp "$temp_dir"/* "$HOME/Backgrounds/"
    rm -rf "$temp_dir"
}

install_other_tools() {
    echo "Installing other tools..."
    # Sounds and multimedia
    sudo apt install -y mpv mpv-mpris imv mkvtoolnix brightnessctl \
        wf-recorder pavucontrol pavucontrol-qt pulsemixer pipewire wireplumber playerctl

    # Install Flatpak
    sudo apt install -y flatpak

    # Add Flathub repository (if not already added)
    flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    # Install Virtualization tools (including QEMU/KVM)
    sudo apt install -y qemu-kvm qemu-system qemu-utils virt-viewer libvirt-clients libvirt-daemon-system bridge-utils virt-manager

    # Others
    sudo apt install -y bc timeshift rclone light

    # Enable wireplumber audio service
    systemctl --user enable wireplumber.service

    #OPTIONAL: update kernel and firmware from backports
    # sudo apt update && sudo apt install -t trixie-backports linux-image-amd64 firmware-linux linux-headers-amd64
}

clean_up() {
    echo "Cleaning up..."
    sudo apt autoremove -y
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
