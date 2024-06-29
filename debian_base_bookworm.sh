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
    curl git git-lfs patch make cmake diffutils meson xdotool jq gcc g++ go \
    libnotify-dev libnotify-bin wmctrl

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
    sudo apt install -y ntp dialog acpi acpid lm-sensors netcat htop zip unzip gedit nala \
      thunar lxqt-policykit xdg-utils vim vim-gtk3 sddm mtools dosfstools terminator \ 
      avahi-daemon avahi-utils gvfs-backends network-manager nmtui iw network-manager-gnome zram-tools \
            
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
sudo apt install -y fonts-fontconfig fonts-droid-sans fonts-droid-serif fonts-droid-fallback fonts-noto-sans \
  fonts-noto-serif fonts-noto-mono fonts-noto-color-emoji fonts-noto-cjk fonts-dejavu xfonts-dejavu \
  fonts-dejavu-extra fonts-firacode fonts-jetbrains-mono powerline fonts-font-awesome fonts-recommended fonts-ubuntu \
  fonts-terminus

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
sudo apt install -y mpv mpv-mpris imv mkvtoolnix redshift brightnessctl \
  wf-recorder pavucontrol pavucontrol-qt pulsemixer pipewire wireplumber

# Install Flatpak
sudo apt install -y flatpak

# Add Flathub repository (if not already added)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# Install Virtualization tools (including QEMU/KVM)
sudo apt install -y qemu-kvm qemu-system qemu-utils virt-viewer libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y

# Others
sudo apt install -y bc xev timeshift rclone light


#Enable SDDM at boot (default display manager) - uncomment this line if you want to boot into GUI
#sudo enable sddm
#sudo systemctl set-default graphical.target

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
