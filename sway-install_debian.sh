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
# - Make sure this repo is cloned into $userhome/Downloads
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Set the username variable
username=$(whoami)
userhome="/home/$username"

#clone the repository 
rm -rf $userhome/Downloads/linux-setup-scripts
git clone https://github.com/leonzwrx/linux-setup-scripts

# Proceed regardless (assuming scripts are already present)
cd $userhome/Downloads/linux-setup-scripts
# Make scripts executable (if they exist)
chmod +x *.sh
  
# Dependencies that may or may not have been installed as a part of base install
sudo apt install -y build-essential cmake cmake-extras curl gettext libnotify-bin light meson ninja-build libxcb-util0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-cursor-dev libxcb-xinerama0-dev libstartup-notification0-dev

# Sway installation for Debian Bookworm
sudo apt install -y sway waybar swaylock swayidle swaybg mako wofi

# Clipboard and screenshot tools
sudo apt install -y clipman grim slurp wl-clipboard


# Theming
sudo apt install -y libqt5-qtstyleplugins libqt5ct libqt6ct papirus-icon-theme kvantum qt5-style-kvantum qt6-style-kvantum qt5-style-kvantum-l10n qt5-style-kvantum-themes
#Install Nord-Kvantum theme
mkdir -p $userhome/.config/Kvantum
tar -xzf $userhome/Downloads/linux-setup-scripts/resources/Nord-Kvantum.tar.gz -C $userhome/.config/Kvantum

#Use pipx to install rofimoji to a local virtual environment
pipx install rofimoji

#Use pipx to install sway-input-config
pipx install sway-input-config
# [OPTIONAL if pipx doesn't work] sway-input-configurator from source - not currently available in Debian's repos
# bash $userhome/Downloads/linux-setup-scripts/sway-input-configurator_debian.sh

pipx install autotiling
#  [OPTIONAL if pipx doesn't work] Autotiling from source - not currently available in Debian's repos
# bash $userhome/Downloads/linux-setup-scripts/autotiling_debian.sh

# [OPTIONAL] Printing and scanning - Comment out if not needed
sudo apt install -y cups system-config-printer simple-scan
sudo systemctl enable cups

# [OPTIONAL] Bluetooth - Comment out if not needed
sudo apt install -y bluez blueman
sudo systemctl enable bluetooth

# Networking
sudo apt install -y network-manager network-manager-gnome network-manager-curses wpasupplicant

# More Sway tools and utilities
sudo apt install -y foot ffmpegthumbnailer khal mako-notifier tumbler waybar xsettingsd xdg-desktop-portal-wlr python3-send2trash

## MANUAL SOURCE INSTALL

# Azote for backgrounds - Manually moved .desktop and icon from azote/dist folder
cd $userhome/SourceBuilds
git clone https://github.com/nwg-piotr/azote.git
cd azote
sudo python3 setup.py install

# wttrbar - Could not get the script to dynamically download the latest version. This script downloads a specific version (can change in the script).
# Alternative solution, download the binary from https://github.com/bjesus/wttrbar/releases/latest and place into /usr/bin manually
cd $userhome/Downloads/linux-setup-scripts/
sudo bash wttrbar.sh

# Swappy - not currently available in Debian's repos 
bash $userhome/Downloads/linux-setup-scripts/swappy_debian.sh

# nwg-look - gtk3 theming for Wayland
bash $userhome/Downloads/linux-setup-scripts/nwg-look.sh


# Install SDDM Console Display Manager - Comment out if a different Display Manager is used
# sudo apt install --no-install-recommends -y sddm
# sudo systemctl enable sddm

# Rofi-wayland fork - not currently available in Debian's repos
bash $userhome/Downloads/linux-setup-scripts/rofi-wayland_debian.sh

# Cleanup
sudo apt autoremove

printf "\e[1;32mYou can now reboot! DO NOT FORGET TO COPY dotfiles. Thanks you.\e[0m\n"
