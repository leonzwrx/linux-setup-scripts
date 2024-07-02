#!/usr/bin/env bash
#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - Adapted from https://github.com/drewgrif/sway
# - This script will install Sway on Debian Bookworm (tested on Trixie/testing as well)
# - Start with minimal fresh Debian install (run debian_base_bookworm.sh first)
# - Make sure this repo is cloned into ~/Downloads
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

  #clone the repository 
  rm -rf ~/Downloads/linux-setup-scripts
  git clone https://github.com/leonzwrx/linux-setup-scripts

  # Proceed regardless (assuming scripts are already present)
  cd ~/Downloads/linux-setup-scripts
  # Make scripts executable (if they exist)
  chmod +x *.sh
  
# Dependencies that may or may not have been installed as a part of base install
sudo apt install -y build-essential cmake cmake-extras curl gettext libnotify-bin light meson ninja-build libxcb-util0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-cursor-dev libxcb-xinerama0-dev libstartup-notification0-dev

# Sway installation for Debian Bookworm
sudo apt install -y sway waybar swaylock swayidle swaybg mako wofi

# Clipboard and screenshot tools
sudo apt install -y clipman grim slurp wl-clipboard

# Swappy - not available in bookworm repos. Installing from source using swappy.sh
bash swappy.sh

# nwg-look - gtk3 theming for Wayland
# 
bash ~/Downloads/linux-setup-scripts/nwg-look.sh

REVIEW
# Sway input configurator using pip:
sudo pip install sway-input-config

# Autotiling
sudo pip install autotiling

# [OPTIONAL] Printing and scanning - Comment out if not needed
sudo apt install -y cups system-config-printer simple-scan
sudo systemctl enable cups

# [OPTIONAL] Bluetooth - Comment out if not needed
sudo apt install -y bluez blueman
sudo systemctl enable bluetooth

# Networking
sudo apt install -y network-manager network-manager-gnome network-manager-curses wpasupplicant

# Others

# Install SDDM Console Display Manager - Comment out if a different Display Manager is used
# sudo apt install --no-install-recommends -y sddm
# sudo systemctl enable sddm

# Manual install of rofi-wayland fork
bash ~/Downloads/linux-setup-scripts/rofi-wayland.sh

sudo apt autoremove

printf "\e[1;32mYou can now reboot! DO NOT FORGET TO COPY dotfiles. Thanks you.\e[0m\n"
