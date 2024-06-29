#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / / 
#| |___| |__| |_| | |\  |/ /_ 
#|_____|_____\___/|_| \_/____|
#
# - This script installs a list of extra, optional and non-essential applications I use
# - Make sure Debian is installed with all of the essentials and DE/WM 
# - Make sure your (non-root) user exists and sudo is installed
set -e



# Network/File/System tools
sudo apt install -y ranger ncdu psmisc mangohud cpu-x iftop iotop nvtop powertop keepassxc fd-find \
  tldr bat trash-cli lsd bleachbit nmap iw

# Bluetooth - optional - uncomment if needed
# sudo apt install -y bluez blueman bluetooth

# Sounds and multimedia
sudo apt install -y gimp imagemagick celluloid cmus cava

# PDF, printing and scanning
sudo apt install -y evince pdfarranger simple-scan zathura zathura-poppler-qt cups system-config-printer
sudo systemctl enable cups

#Others
gh lolcat figlet toilet galculator remmina progress remmina ghostwriter

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Install fastfetch from Github (not available in Debian's repos)
cd ~/Downloads
latest_url=$(curl -sL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r '.assets[0].browser_download_url')
# Download the package and fix potential dependencies
wget -qO- "$latest_url" | sudo dpkg -i -
sudo apt install -f

# Install VIM plugins (using vim-plug)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install your preferred Flatpaks (modify according to your needs)
flatpak install -y flathub org.onlyoffice.Desktop io.github.prateekmedia.appimagepool com.github.qarmin.czkawka it.mijorus.gearlever io.github.shiftey.Desktop org.openrgb.OpenRGB org.kde.kid org.nicotine_plus.Nicotine io.podman_desktop.PodmanDesktop
# OPTIONAL - Install auto-cpufreq if laptop
#  cd ~/Applications
#  git clone https://github.com/AdnanHodzic/auto-cpufreq.git
#  cd auto-cpufreq && sudo ./auto-cpufreq-installer --install
#  sudo auto-cpufreq --install


  printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
