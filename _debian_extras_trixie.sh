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


# Set the username variable
username=$(whoami)
userhome="/home/$username"

#Clone repository into Downloads
rm -rf $userhome/Downloads/linux-setup-scripts
git clone https://github.com/leonzwrx/linux-setup-scripts "$userhome/Downloads/linux-setup-scripts"

# Network/File/System tools
sudo apt install -y ranger ncdu psmisc mangohud cpu-x iftop iotop btop powertop keepassxc fd-find \
  tealdeer nala bat lsd bleachbit nmap iw whois gnome-packagekit ufw gufw lshw filezilla testdisk \
  nfs-common anacron mtr

# Bluetooth - optional - uncomment if needed
# sudo apt install -y bluez blueman bluetooth

# Sounds and multimedia
sudo apt install -y imagemagick celluloid cmus cava ffmpeg ffmpegthumbnailer pulseaudio-utils inkscape libimage-exiftool-perl

# PDF, printing and scanning
sudo apt install -y evince pdfarranger simple-scan zathura zathura-pdf-poppler cups system-config-printer
sudo systemctl enable cups

#video related
sudo apt install -y radeontop fancontrol vulkan-tools

#deb-get
curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get

#Others
sudo apt install -y gh lolcat figlet toilet cmatrix remmina progress qbittorrent mutt-wizard starship fastfetch

# Install neovim from Github (to get the latest version, not available in stable repos)
bash $userhome/Downloads/linux-setup-scripts/neovim.sh

# Install neovim plugins
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# VIM undodir
mkdir -p $HOME/.config/nvim/undodir

# Install ONLYOFFICE
#gpg key
mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg
#add repo
echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list
sudo apt update
sudo apt install -y onlyoffice-desktopeditors


# Install your preferred Flatpaks (modify according to your needs)
flatpak update
flatpak install -y flathub com.github.tchx84.Flatseal io.github.prateekmedia.appimagepool com.github.qarmin.czkawka it.mijorus.gearlever net.sourceforge.Hugin \
  com.github.PintaProject.Pint aio.github.shiftey.Desktop org.nicotine_plus.Nicotine io.podman_desktop.PodmanDesktop com.gnome.Notes org.kde.kid3 \
  com.brave.Browser de.leopoldluley.Clapgrep com.belmoussaoui.Obfuscate org.gimp.GIMP io.missioncenter.MissionCenter org.gnome.Loupe org.gnome.Calculator 
# OPTIONAL - Install auto-cpufreq if laptop
#  cd ~/Applications
#  git clone https://github.com/AdnanHodzic/auto-cpufreq.git
#  cd auto-cpufreq && sudo ./auto-cpufreq-installer --install
#  sudo auto-cpufreq --install


  printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
