#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
# - Start with stock minimal Debian 12 install with no GUI
# - Use stable or trixie debian-xx.x.x-amd64-netinst.iso image
# - Verify internet connection
# - Make sure your (non-root) user exists and sudo is installed
# - Follow pre-install-prep.txt prior


set -e


#add your user to sudo group (if not already done)

sudo usermod -aG sudo $(whoami)
#take ownership of homedir
chown -R $username:$username /home/$username

# Function to install core packages
install_core_packages() {
    # Update the package list and upgrade existing ones
    sudo apt update
    sudo apt upgrade -y
    
# Install software-properties-common for managing repositories
    sudo apt install -y software-properties-common

    # Core build tools and libraries
    sudo apt install -y build-essential dkms module-assistant linux-headers-$(uname -r) \
    curl git git-lfs patch make cmake diffutils wget meson xdotool jq gcc g++ go

    # Python tools
    sudo apt install -y python3-pip python3-venv python3-dev
    pip install --user pipx
    python3 -m pipx ensurepath

    # Node.js and npm (Consider using NodeSource for the latest version)
    curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
    bash nodesource_setup.sh   
    sudo apt-get install -y nodejs

    # Install flawfinder via pipx
    pipx install flawfinder

    # Install cmake-init via pipx
    pipx install cmake-init

    # Additional useful tools for building from source
    sudo apt install -y autoconf automake libtool pkg-config \
      libssl-dev libcurl4-openssl-dev libxml2-dev zlib1g-dev \
      libreadline-dev libncurses5-dev libbz2-dev \
      libsqlite3-dev libpcre3-dev libffi-dev \
      libgmp-dev libexpat1-dev

    # Network/File/System tools
    sudo apt install -y ntp dialog acpi acpid lm-sensors netcat htop ranger ncdu zip unzip gedit nala \
      thunar lxqt-policykit xdg-utils psmisc mangohud vim vim-gtk3 sddm mtools dosfstools \ 
      avahi-daemon avahi-utils gvfs-backends network-manager nmtui iw
    sudo systemctl enable avahi-daemon
    sudo systemctl enable acpid
    }

  }

  install_additional_repos() {
    # Add Google Chrome repository
    echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
  }

  create_directories() {
    mkdir -p ~/Screenshots ~/Downloads ~/Applications ~/SourceBuilds
    xdg-user-dirs-update
    cd ~/Downloads
  #copy the scripts
  git clone https://github.com/leonzwrx/linux-setup-scripts
  cd ~/Downloads/linux-setup-scripts
  chmod +x *.sh

}

install_fonts_and_themes() {
  # FONTS
sudo apt install -y fonts-fontconfig fonts-droid-sans fonts-droid-serif fonts-droid-fallback fonts-noto-sans fonts-noto-serif fonts-noto-mono fonts-noto-color-emoji fonts-noto-cjk fonts-dejavu xfonts-dejavu fonts-dejavu-extra fonts-firacode fonts-jetbrains-mono powerline fonts-fontawesome

  # Install nerdfonts if the script exists
  if [ -f ~/Downloads/linux-setup-scripts/nerdfonts.sh ]; then
    bash ~/Downloads/linux-setup-scripts/nerdfonts.sh
  fi

  fc-cache -vf

  # Download Nordic Theme
  sudo git clone https://github.com/EliverLara/Nordic.git /usr/share/themes/Nordic

  # Optionally, later on manually install Orchis teal theme items
  # bash ./orchis-teal.sh

  # Install Nordzy cursor
  git clone https://github.com/alvatip/Nordzy-cursors ~/Downloads/Nordzy-cursors
  cd ~/Downloads/Nordzy-cursors
  ./install.sh
  cd ~/Downloads
  rm -rf Nordzy-cursors

  # Install Nord theme for gedit
  git clone https://github.com/nordtheme/gedit ~/Downloads/gedit
  cd ~/Downloads/gedit
  ./install.sh
  cd ~/Downloads
  rm -rf gedit

  # Download Nord wallpaper
  mkdir -p ~/Backgrounds
  git clone https://github.com/linuxdotexe/nordic-wallpapers ~/Downloads/nordic-wallpapers
  cp ~/Downloads/nordic-wallpapers/wallpapers/* ~/Backgrounds/
  rm -rf ~/Downloads/nordic-wallpapers
}

install_other_tools() {

# Install Chrome
sudo apt install -y google-chrome-stable

# Thunar plugins
sudo apt install -y thunar-archive-plugin thunar-volman file-roller

# Sounds and multimedia
sudo apt install -y mpv mpv-mpris imv gimp mkvtoolnix redshift imagemagick brightnessctl \
  wf-recorder celluloid cmus pavucontrol pavucontrol-qt pulsemixer pipewire wireplumber

# PDF and scanning
sudo apt install -y evince pdfarranger simple-scan zathura zathura-poppler-qt

# Install Flatpak
sudo apt install -y flatpak

# Add Flathub repository (if not already added)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install your preferred Flatpaks (modify according to your needs)
flatpak install -y flathub org.onlyoffice.Desktop appimagepool com.github.czkawka.Gearlever io.github.shiftey.Desktop

# Install Virtualization tools (including QEMU/KVM)
sudo apt install -y qemu-kvm qemu-system qemu-utils libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y

# Install VIM plugins (using vim-plug)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Others
sudo apt install -y progress firefox curl git remmina lsd figlet toilet bc galculator lm-sensors trash-cli bat lolcat tldr xev timeshift fd-find rclone keepassxc nvtop iotop iftop light gh cpu-x

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Install fastfetch from Github (not available in Debian's repos)
cd ~/Downloads
latest_url=$(curl -sL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r '.assets[0].browser_download_url')
# Download the package and fix potential dependencies
wget -qO- "$latest_url" | sudo dpkg -i -
sudo apt install -f

#Enable SDDM at boot (default display manager) - uncomment this line if you want to boot into GUI
#sudo enable sddm
#sudo systemctl set-default graphical.target

# OPTIONAL - Install auto-cpufreq if laptop
#  cd ~/Applications
#  git clone https://github.com/AdnanHodzic/auto-cpufreq.git
#  cd auto-cpufreq && sudo ./auto-cpufreq-installer --install
#  sudo auto-cpufreq --install

# Enable wireplumber audio service
sudo -u $username systemctl --user enable wireplumber.service

}

clean_up() {

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
