#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
# - Start with stock minimal Debian 12 install with no GUI:
#   - Use stable or trixie debian-xx.x.x-amd64-netinst.iso image
#   - Preferred installation - expert, no root account, manual partitioning 
#   - Guide: https://www.youtube.com/watch?v=MoWApyUb5w8
#   - Install zram-tools and set zram to 8GB
#   - If updating from stable to testing, use 'trixie' in apt sources instead of testing; 
#   - this will track trixie journey stable and disable backports
# - Verify internet connection
# - Make sure your (non-root) user exists and sudo is installed
# - Follow pre-install-prep.txt prior
# - To download this script into /tmp, use:
#     wget https://raw.githubusercontent.com/leonzwrx/linux-setup-scripts/main/debian_base_bookworm.sh


set -e


#verify your user is in sudo group 

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
  curl git git-lfs patch make cmake cmake-extras diffutils meson xdotool jq gcc g++ golang \
  libnotify-dev libnotify-bin wmctrl

# Additional useful tools for building from source
sudo apt install -y autoconf automake libtool pkg-config \
  libssl-dev libcurl4-openssl-dev libxml2-dev zlib1g-dev \
  libreadline-dev libncurses5-dev libbz2-dev \
  libsqlite3-dev libpcre3-dev libffi-dev \
  libgmp-dev libexpat1-dev \
  libcairo2 libcairo2-dev libcairo-gobject2 libcairo-gobject2-dev \
      libpango1.0-0 libpango1.0-dev libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev \
      libgtk-3-0 libgtk-3-dev

# Python tools (optional, but useful for some build tools)
sudo apt install -y python3-pip python3-dev

# Node.js and npm (optional, only if needed for specific builds)
# Consider using NodeSource for the latest version (not included here)


    # Network/File/System tools
    sudo apt install -y dialog acpi acpid lm-sensors netcat-traditional htop zip unzip gedit nala \
      thunar lxqt-policykit xdg-utils vim vim-gtk3 mtools dosfstools terminator \
      avahi-daemon avahi-utils gvfs-backends network-manager network-manager-gnome zram-tools 

    sudo systemctl enable avahi-daemon
    sudo systemctl enable acpid

  }


install_additional_repos() {
  # Google Chrome install
  sudo mkdir -p /etc/apt/keyrings

  # Download Google Chrome signing key and add it manually
  sudo rm -rf /etc/apt/keyrings/google*.*
  curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg

  # Add Google Chrome repository to sources list
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

  # Update package lists
  sudo apt update
  
  # Install Chrome
  sudo apt install -y google-chrome-stable
}


  create_directories() {
    mkdir -p ~/Screenshots ~/Downloads ~/Applications ~/SourceBuilds
    xdg-user-dirs-update
    cd ~/Downloads

  #clone the repository 
  rm -rf ~/Downloads/linux-setup-scripts
  git clone https://github.com/leonzwrx/linux-setup-scripts

  # Proceed regardless (assuming scripts are already present)
  cd ~/Downloads/linux-setup-scripts
  # Make scripts executable (if they exist)
  chmod +x *.sh

  }

  install_fonts_and_themes() {
    # FONTS
    sudo apt install -y fontconfig fonts-noto fonts-dejavu fonts-dejavu-extra fonts-firacode fonts-jetbrains-mono \
      powerline fonts-font-awesome fonts-recommended fonts-ubuntu fonts-terminus

  # Install nerdfonts if the script exists
  if [ -f ~/Downloads/linux-setup-scripts/nerdfonts.sh ]; then
    bash ~/Downloads/linux-setup-scripts/nerdfonts.sh
  fi

  fc-cache -vf

  # Download Nordic Theme
  sudo rm -rf /usr/share/themes/Nordic
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

# Thunar plugins
sudo apt install -y thunar-archive-plugin thunar-volman file-roller

# Sounds and multimedia
sudo apt install -y mpv mpv-mpris imv mkvtoolnix redshift brightnessctl \
  wf-recorder pavucontrol pavucontrol-qt pulsemixer pipewire wireplumber

# Install Flatpak
sudo apt install -y flatpak

# Add Flathub repository (if not already added)
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Virtualization tools (including QEMU/KVM)
sudo apt install -y qemu-kvm qemu-system qemu-utils virt-viewer libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y

# Others
sudo apt install -y bc timeshift rclone light


#(OPTIONAL)Install and Enable SDDM at boot (default display manager) - uncomment this line if you want to boot into GUI
#sudo apt install -y sddm
#sudo enable sddm
#sudo systemctl set-default graphical.target

# Install and configure greetd
sudo apt install -y greetd
sudo systemctl enable greetd --now

# Enable wireplumber audio service
systemctl --user enable wireplumber.service

#OPTIONAL: update kernel and firmware from backports
sudo apt update && sudo apt install -t bookworm-backports linux-image-amd64 firmware-linux linux-headers-amd64

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
