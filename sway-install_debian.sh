#!/usr/bin/env bash
#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - Adapted from https://github.com/drewgrif/bookworm-scripts
# - This script will install SwayWM on Debian Bookworm (tested on Trixie/testing as well)
# - Start with minimal fresh Debian install (run debian_base_bookworm.sh first)
# - Make sure this repo is cloned into ~/Downloads
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Dependencies that may or may not have been installed as a part of base install
sudo apt install -y build-essential cmake cmake-extras curl gettext libnotify-bin light meson ninja-build libxcb-util0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-cursor-dev libxcb-xinerama0-dev libstartup-notification0-dev

# Sway installation for Debian Bookworm
sudo apt install -y sway waybar swaylock swayidle swaybg

# grim (screenshots in Wayland) and slurp (select a region in wayland) - kinda like scrot
sudo apt install -y grim slurp

# Network File Tools/System Events
sudo apt install -y dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends

sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Thunar
sudo apt install -y thunar thunar-archive-plugin thunar-volman file-roller

# Browser Installation (eg. chromium)
#sudo apt install -y firefox-esr 
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update
sudo apt install google-chrome-stable

# dunst or mako
sudo apt install -y dunst unzip xdotool libnotify-dev

# Sound
sudo apt install -y pipewire pavucontrol pamixer

# Multimedia
sudo apt install -y mpv mpv-mpris nvtop pamixer ffmpeg qimgv gimp obs-studio mkvtoolnix-gui redshift eog brightnessctl

# nwg-look takes the place of lxappearance in x11 
# installs an lxappearance program to use GTK themes and icons in Wayland
# 
bash ~/bookworm-scripts/resources/nwg-look

# text editor
# sudo apt install -y l3afpad 
# sudo apt install -y geany geany-plugin-addons geany-plugin-git-changebar geany-plugin-overview geany-plugin-spellcheck geany-plugin-treebrowser geany-plugin-vimode
sudo apt install -y gedit vim-gtk3 

# lsd installation
# make sure .bashrc has an alias that points to lsd 
sudo apt install -y lsd

# Printing and bluetooth (if needed)
# sudo apt install -y cups system-config-printer simple-scan
# sudo apt install -y bluez blueman

# sudo systemctl enable cups
# sudo systemctl enable bluetooth

# PDF 
sudo apt install -y evince pdfarranger

# Others
sudo apt install -y figlet galculator cpu-x whois curl tree neofetch vim git trash-cli nala bat

# Fonts and icons for now
sudo apt install -y fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus papirus-icon-theme
bash ~/bookworm-scripts/resources/nerdfonts.sh

# Install SDDM Console Display Manager
# sudo apt install --no-install-recommends -y sddm
# sudo systemctl enable sddm

# For now, this has to be a manual install
# Install the Ly Console Display Manager
# bash ~/bookworm-scripts/ly.sh

# wofi - confusingly similar to rofi
# sudo apt install wofi
bash ~/bookworm-scripts/resources/rofi-wayland

#Will copy .bashrc later from my own configs
#\cp ~/bookworm-scripts/resources/.bashrc ~

#Enable SDDM at boot (default display manager) - uncomment this line if you want to boot into GUI
#sudo systemctl enable sddm
#sudo systemctl set-default graphical.target


sudo apt autoremove

printf "\e[1;32mYou can now reboot! Thanks you.\e[0m\n"
