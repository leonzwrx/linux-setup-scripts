#!/usr/bin/env bash
#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - Start with stock Fedora Sway spin with mostly defaults
# - Make sure swaywm is working and functional
# - Make sure you have backups including record of all apps, 
#   home dir and any relevant /etc files such as fstab, yum.repos.d, dnf.conf, crontabs

set -e

##################################
# Install sway-related packages
##################################

prepare_environment() {
  cd ~/Downloads/linux-setup-scripts
  chmod +x *.sh
}

install_sway_packages() {
  # Sway input configurator using pip:
  sudo pip install sway-input-config

  # Autotiling
  sudo pip install autotiling

  #install nwg-look
  if [ -f ~/Downloads/linux-setup-scripts/nwg-look.sh ]; then
    bash ~/Downloads/linux-setup-scripts/nwg-looks.sh
  fi

  # Networking
  sudo dnf install -y blueman nm-connection-editor nm-applet nm-connection-editor-desktop NetworkManager-tui 

  # Clipboard and screenshot tools
  sudo dnf install -y clipman grim slurp wl-clipboard swappy

  # Theming
  sudo dnf install -y qt5-style-plugins qt5ct qt6ct papirus-icon-theme kvantum

  # More utilities
  sudo dnf install -y rofi-wayland foot ffmpegthumbnailer jq khal mako polkit-gnome tumbler waybar xsettingsd xdg-desktop-portal-wlr python3-send2trash 

    #OPTIONAL - if rofi-wayland has to be manually installed:
    cd ~/Downloads
        git clone https://github.com/lbonn/rofi.git
        cd rofi
        meson setup build && ninja -C build
        sudo ninja -C build install

        cd ..
        rm -rf rofi

  # Emoji selector - can also be installed with pip install rofimoji
  sudo dnf install -y rofimoji
}

install_manual_sway_packages() {
  # wttrbar
  cd ~/Downloads/linux-setup-scripts
  bash wttrbar.sh

  # Azote for backgrounds - Manually moved .desktop and icon from azote/dist folder
  cd ~/Applications
  git clone https://github.com/nwg-piotr/azote.git
  cd azote
  python3 setup.py install --user

  # Change login screen background (copy from Backgrounds dir)
  sudo cp ~/Backgrounds/Road.jpg* /usr/share/backgrounds/background-road.jpg
  sudo rm /usr/share/backgrounds/default.png
  sudo ln -s /usr/share/backgrounds/background-road.jpg /usr/share/backgrounds/default.png
}

install_custom_systemd_services() {
  # Install custom systemd user services
  cd ~/Downloads/linux-setup-scripts/resources
  cp swtch-top-level.service ~/.config/systemd/user
  cp waybar.service ~/.config/systemd/user
  sudo systemctl daemon-reload
  systemctl --user enable swtch-top-level.service --now
  systemctl --user enable waybar.service --now
}

final_cleanup() {
  sudo dnf autoremove
}

main() {
  prepare_environment
  install_sway_packages
  install_manual_sway_packages
  install_custom_systemd_services
  final_cleanup

  printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
}

main
