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
# - Verify internet functionality and make sure git is installed
# - Make sure you have backups including record of all apps, 
#   home dir and any relevant /etc files such as fstab, yum.repos.d, dnf.conf, crontabs
# - git clone https://github.com/leonzwrx/linux-setup-scripts.git ~/Downloads/linux-setup-scripts

set -e

create_directories() {
  mkdir -p ~/Screenshots ~/Downloads ~/Applications
  xdg-user-dirs-update
  cd ~/Downloads
  #copy the scripts
  git clone https://github.com/leonzwrx/linux-setup-scripts
  cd ~/Downloads/linux-setup-scripts
  chmod +x *.sh


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

install_core_packages() {
  # Dev tools
  sudo dnf groupinstall -y "Development Tools" "Development Libraries" "C Development Tools and Libraries"
  sudo dnf install -y light meson xdotool pip jq cmake gcc-c++

  # Network/File/System tools
  sudo dnf install -y dialog acpi lm_sensors nc htop ranger ncdu zip unzip

  # Thunar plugins
  sudo dnf install -y thunar-archive-plugin thunar-volman file-roller
  
  # Sounds and multimedia
  sudo dnf install -y mpv mpv-mpris imv gimp mkvtoolnix-gui redshift lximage-qt brightnessctl wf-recorder celluloid cmus pavucontrol-qt
  pip install pulsemixer

  # PDF and scanning
  sudo dnf install -y evince pdfarranger simple-scan zathura zathura-pdf-poppler
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
  sudo dnf install -y progress firefox gh git remmina gedit lsd figlet toilet galculator cpu-x trash-cli bat lolcat tldr xev timeshift fd-find rclone keepassxc nvtop iotop iftop
  # Install Starship
  curl -sS https://starship.rs/install.sh | sh
}

clean_up() {
  sudo dnf autoremove -y
}

main() {
  create_directories
  install_additional_repos
  install_core_packages
  install_fonts_and_themes
  install_other_tools
  clean_up
  printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
}

main
