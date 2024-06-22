#!/usr/bin/env bash

#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - Start with stock Fedora with mostly defaults
# - Verify internet connection
# - Make sure your (non-root) user exists
# - Make sure you have backups including
#             - record of all packages, flatpaks, appimages, etc
#             - home dir and any relevant /etc files such as
#             - fstab, yum.repos.d, dnf.conf, crontabs


set -e

#add your user to wheel group (if not already done)
sudo usermod -aG wheel $(whoami)

# Update package lists and upgrade installed packages

dnf update
sudo dnf upgrade -y 

# Function to install core packages
install_core_packages_fedora() {

    # Update the package list and upgrade existing packages
    sudo dnf update -y
    # Dev & build tools
    sudo dnf groupinstall -y "Development Tools" "Development Libraries" "C Development Tools and Libraries"

    # Install additional build tools
    sudo dnf install -y dkms kernel-devel curl git git-lfs patch cmake diffutils wget meson xdotool jq gcc-c++ go

    # Python tools
    sudo dnf install -y python3-pip python3-virtualenv python3-devel
    pip3 install --user pipx
    python3 -m pipx ensurepath

    # Node.js and npm (Consider using NodeSource for the latest version)
    curl -fsSL https://rpm.nodesource.com/setup_22.x -o nodesource_setup.sh
    bash nodesource_setup.sh    
    sudo dnf install -y nodejs

    # Install flawfinder via pipx
    pipx install flawfinder

    # Install cmake-init via pipx
    pipx install cmake-init

    # Additional useful tools for building from source
    sudo dnf install -y autoconf automake libtool pkgconf \
      openssl-devel libcurl-devel libxml2-devel zlib-devel \
      readline-devel ncurses-devel bzip2-devel \
      sqlite-devel pcre-devel libffi-devel \
      gmp-devel expat-devel

    # Network/File/System tools
    sudo dnf install -y ntp dialog acpi lm_sensors nmap-ncat htop ranger ncdu zip unzip gedit
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
  #copy the scripts
  git clone https://github.com/leonzwrx/linux-setup-scripts
  cd ~/Downloads/linux-setup-scripts
  chmod +x *.sh


}

install_fonts_and_themes() {
  # FONTS
  sudo dnf install -y fontconfig google-droid-sans-fonts google-droid-serif-fonts google-droid-sans-mono-fonts google-noto-sans-fonts google-noto-serif-fonts google-noto-mono-fonts google-noto-emoji-fonts google-noto-cjk-fonts dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts adobe-source-serif-pro-fonts adobe-source-sans-pro-fonts adobe-source-code-pro-fonts fontawesome-fonts-all 

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
  sudo dnf install -y mpv mpv-mpris imv gimp mkvtoolnix-gui redshift lximage-qt brightnessctl wf-recorder celluloid cmus pavucontrol-qt
  sudo pip install pulsemixer

  # PDF and scanning
  sudo dnf install -y evince pdfarranger simple-scan zathura zathura-pdf-poppler

  # Flatpak
  sudo dnf install -y flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # Install flatpaks I use
  flatpak install -y onlyoffice appimagepool czkawka gearlever io.github.shiftey.Desktop

  # Install Virtualization tools (including QEMU/KVM)
  sudo dnf install -y @virtualization

  # Install VIM plugins
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Others
  sudo dnf install -y progress firefox gh git remmina lsd figlet toilet galculator cpu-x trash-cli bat lolcat tldr xev timeshift fd-find rclone keepassxc nvtop iotop iftop light
  # Install Starship
  curl -sS https://starship.rs/install.sh | sh

  #Install auto-cpufreq
  cd ~/Applications
  git clone https://github.com/AdnanHodzic/auto-cpufreq.git
  cd auto-cpufreq && sudo ./auto-cpufreq-installer --install
  sudo auto-cpufreq --install
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
