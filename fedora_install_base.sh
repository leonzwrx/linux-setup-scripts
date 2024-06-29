#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - Start with freshly installed Fedora 40 w/GUI
# - Verify internet connection
# - Make sure your (non-root) user exists and sudo works
# - Follow pre-install-prep.txt prior# - 
# - To download this script into /tmp, use:
#     wget https://raw.githubusercontent.com/leonzwrx/linux-setup-scripts/main/fedora_install_base.sh

set -e

#add your user to wheel group (if not already done)
sudo usermod -aG wheel $(whoami)
#take ownership of homedir
chown -R $username:$username /home/$username

# Update package lists and upgrade installed packages


# Function to install core packages
install_core_packages() {

    # Update the package list and upgrade existing packages
    dnf update
    sudo dnf upgrade -y 
    
    # Dev & build tools
    sudo dnf groupinstall -y "Development Tools" "Development Libraries" "C Development Tools and Libraries"

    # Install additional build tools
    sudo dnf install -y dkms kernel-devel curl git git-lfs patch cmake diffutils meson xdotool jq gcc-c++ go

    # Python tools
    sudo dnf install -y python3-pip python3-virtualenv python3-devel 

    # Additional useful tools for building from source
    sudo dnf install -y autoconf automake libtool pkgconf \
      openssl-devel libcurl-devel libxml2-devel zlib-devel \
      readline-devel ncurses-devel bzip2-devel \
      sqlite-devel pcre-devel libffi-devel \
      gmp-devel expat-devel

    # Network/File/System tools
    sudo dnf install -y dialog acpi lm_sensors nmap-ncat htop zip unzip gedit \
      thunar network-manager-applet terminator vim gvim
}


install_additional_repos() {
  # Additional Fedora Repos
  sudo dnf install -y fedora-workstation-repositories
  sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  sudo dnf config-manager --set-enabled google-chrome
  cat << EOF | sudo tee /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF

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
  sudo dnf install -y fontconfig google-droid-sans-fonts google-droid-serif-fonts google-droid-sans-mono-fonts \ 
    google-noto-sans-fonts google-noto-serif-fonts google-noto-mono-fonts google-noto-emoji-fonts google-noto-cjk-fonts \
    dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts adobe-source-serif-pro-fonts adobe-source-sans-pro-fonts \
    adobe-source-code-pro-fonts fontawesome-fonts-all terminus-fonts


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
  # Chrome
  sudo dnf install -y google-chrome-stable

  # Thunar plugins
  sudo dnf install -y thunar-archive-plugin thunar-volman file-roller
  
  # Sounds and multimedia
  sudo dnf install -y mpv mpv-mpris imv mkvtoolnix-gui redshift lximage-qt  \
    brightnessctl wf-recorder pavucontrol-qt pipewire wireplumber
  sudo pip install pulsemixer

  # Flatpak
  sudo dnf install -y flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # Install Virtualization tools (including QEMU/KVM)
  sudo dnf install -y @virtualization
  sudo dnf install -y virt-viewer

  # Others
  sudo dnf install -y bc timeshift rclone light virt-viewer
}

clean_up() {
  sudo dnf autoremove -y
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
