#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#   UPDATED SEPTEMBER 2025 (TESTED ON FEDORA 42 W/DNF 5)
#
# - This script installs a list of extra, optional and non-essential applications I use
# - Make sure Fedora is installed with all of the essentials and DE/WM 
# - Make sure your (non-root) user exists and sudo is installed

set -e


# Network/File/System tools
sudo dnf install -y ranger ncdu psmisc mangohud cpu-x btop powertop iftop iotop nvtop keepassxc fd-find \
    tldr bat lsd bleachbit nmap iw filezilla testdisk nfs-utils btrfs-assistant

# Bluetooth - optional - uncomment if needed
# sudo dnf install -y bluez blueman pipewire-pulseaudio

# Sounds and multimedia (added -allowerasing flag for ffmpeg conflict
sudo dnf install -y gimp ImageMagick celluloid cmus cava ffmpeg ffmpegthumbnailer pandoc pandoc-pdf --allowerasing

# PDF, printing and scanning
sudo dnf install -y evince pdfarranger simple-scan zathura zathura-pdf-poppler cups system-config-printer
sudo systemctl enable cups

# Others
sudo dnf install -y gh lolcat figlet toilet cmatrix progress remmina fastfetch 

# install starship
sudo dnf -y copr enable atim/starship
sudo dnf -y install starship

# Install neovim plugins and its python packages
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# VIM undodir
mkdir -p $HOME/.config/nvim/undodir
sudo dnf -y install python3-neovim

# Install ONLYOFFICE
sudo dnf -y install https://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice-repo.noarch.rpm
sudo dnf -y install onlyoffice-desktopeditors

# Install your preferred Flatpaks (modify according to your needs)
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install --user -y flathub io.github.prateekmedia.appimagepool com.github.qarmin.czkawka it.mijorus.gearlever io.github.shiftey.Desktop \
    com.github.PintaProject.Pinta de.leopoldluley.Clapgrep com.belmoussaoui.Obfuscate io.missioncenter.MissionCenter org.gnome.Calculator \
      org.gnome.Loupe de.leopoldluley.Clapgrep

# OPTIONAL - Install auto-cpufreq if laptop

mkdir -p $HOME/SourceBuilds && cd $HOME/SourceBuilds
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer


printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
                                                
