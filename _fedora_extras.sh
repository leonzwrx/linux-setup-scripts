#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - This script installs a list of extra, optional and non-essential applications I use
# - Make sure Fedora is installed with all of the essentials and DE/WM 
# - Make sure your (non-root) user exists and sudo is installed

set -e


# Network/File/System tools
sudo dnf install -y ranger ncdu psmisc mangohud cpu-x btop powertop iftop iotop nvtop keepassxc fd-find \
  tldr bat lsd bleachbit nmap iw filezilla testdisk

# Bluetooth - optional - uncomment if needed
# sudo dnf install -y bluez blueman pipewire-pulseaudio

# Sounds and multimedia
sudo dnf install -y gimp imagemagick celluloid cmus cava ffmpeg ffmpegthumbnailer

# PDF, printing and scanning
sudo dnf install -y evince pdfarranger simple-scan zathura zathura-poppler-qt cups system-config-printer
sudo systemctl enable cups

# Others
sudo dnf install -y gh lolcat figlet toilet cmatrix galculator remmina progress remmina fastfetch ghostwriter rhinote

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Install VIM plugins (using vim-plug)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install ONLYOFFICE
sudo dnf install https://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice-repo.noarch.rpm
sudo dnf install onlyoffice-desktopeditors

# Install your preferred Flatpaks (modify according to your needs)
flatpak install -y flathub io.github.prateekmedia.appimagepool com.github.qarmin.czkawka it.mijorus.gearlever io.github.shiftey.Desktop com.github.PintaProject.Pinta 

# OPTIONAL - Install auto-cpufreq if laptop
# cd ~/Applications (this might not be the default download directory in Fedora)
# git clone https://github.com/AdnanHodzic/auto-cpufreq.git
# cd auto-cpufreq && sudo dnf install autoconf automake libtool -y  # Additional dependencies for Fedora
# ./autogen.sh && ./configure && make
# sudo make install  # Manual installation instead of a package manager

printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
