
#!/usr/bin/env bash
#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - This script will add some customization to a stock Fedora sway spin
# - Start with stock Fedora Sway spin with mostly defaults
# - Verify internet connection
# - Make sure swaywm is working and functional
# - Make sure this repo is cloned into /Downloads/
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied
set -e

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Set the username variable
username=$(whoami)
userhome="/home/$username"

##################################
# Install sway-related packages
##################################

prepare_environment() {
    cd $userhome/Downloads/linux-setup-scripts
    chmod +x *.sh
}

install_sway_packages() {
    # Sway input configurator using pip:
    sudo pip install sway-input-config

    # Autotiling
    sudo pip install autotiling

    # Install nwg-look
    if [ -f $userhome/Downloads/linux-setup-scripts/nwg-look.sh ]; then
        bash $userhome/Downloads/linux-setup-scripts/nwg-look.sh
    fi

    # Networking and bluetooth
    sudo dnf install -y blueman nm-connection-editor nm-applet nm-connection-editor-desktop NetworkManager 

    # Clipboard and screenshot tools
    sudo dnf install -y clipman grim slurp wl-clipboard swappy

    # Theming
    sudo dnf install -y qt5-style-plugins qt5ct qt6ct papirus-icon-theme kvantum

    # More utilities
    sudo dnf install -y rofi-wayland foot ffmpegthumbnailer jq khal mako tumbler waybar xsettingsd xdg-desktop-portal-wlr python3-send2trash

    # Emoji selector - can also be installed with pip install rofimoji
    sudo dnf install -y rofimoji
}

install_manual_sway_packages() {
    # wttrbar
    cd $userhome/Downloads/linux-setup-scripts/
    bash wttrbar.sh

    # Azote for backgrounds - Manually moved .desktop and icon from azote/dist folder
    cd $userhome/SourceBuilds
    git clone https://github.com/nwg-piotr/azote.git
    cd azote
    python3 setup.py install --user

    # OPTIONAL - if rofi-wayland has to be manually installed:
    cd $userhome/SourceBuilds
    git clone https://github.com/lbonn/rofi.git
    cd rofi
    meson setup build && ninja -C build
    sudo ninja -C build install

    # nwg-bar - could not build from source but it's available as Fedora Copr
    sudo dnf -y copr enable tofik/nwg-shell
    sudo dnf update
    sudo dnf install -y nwg-bar
    sudo dnf -y copr disable tofik/nwg-shell

    # Change login screen background (copy from Backgrounds dir)
    sudo cp $userhome/Backgrounds/Road.jpg* /usr/share/backgrounds/background-road.jpg
    sudo rm /usr/share/backgrounds/default.png
    sudo ln -s /usr/share/backgrounds/background-road.jpg /usr/share/backgrounds/default.png
}

install_custom_systemd_services() {
    # Install custom systemd user services
    cd $userhome/Downloads/linux-setup-scripts/resources
    cp swtch-top-level.service $userhome/.config/systemd/user
    cp waybar.service $userhome/.config/systemd/user
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
