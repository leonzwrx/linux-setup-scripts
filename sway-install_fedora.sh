#!/usr/bin/env bash

# - Start with stock Fedora Sway spin with mostly defaults
# - Make sure swaywm is working and functional
# - Make sure you have backups including record of all apps, 
#   home dir and any relevant /etc files such as fstab, yum.repos.d, dnf.conf, crontabs

#solid fedora script install: https://gist.github.com/Surendrajat/ad607b13ece2a302d30fb5746f0e1ffe


##################################
# Install sway-related packages
##################################

#sway input configurator using pip:
sudo pip install sway-input-config

#autotiling
sudo pip install autotiling

# nwg-look takes the place of lxappearance in x11 
# installs an lxappearance program to use GTK themes and icons in Wayland
# also part of nwg-shell project but to just install nwg-look on Fedora, add this copr repo first

sudo dnf copr enable -y tofik/nwg-shell
sudo dnf install -y nwg-look

#networking
sudo dnf install -y blueman nm-connection-editor nm-applet nm-connection-editor-desktop NetworkManager-tui 

#clipboard and screenshot stuff
sudo dnf install -y clipman grim slurp wl-clipboard swappy

#Theming:
sudo dnf install -y qt5-style-plugins qt5ct qt6ct papirus-icon-theme kvantum

#More
sudo dnf install -y rofi wofi foot ffmpegthumbnailer jq khal mako polkit-gnome tumbler waybar xsettingsd xdg-desktop-portal-wlr python3-send2trash 

#emoji selector - can also be installed with pip install rofimoji
sudo dnf install -y rofimoji


##################################
# Other Manual Installs 
##################################

#install auto-cpufreq
cd ~/Applications
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer

#Starship
curl -sS https://starship.rs/install.sh | sh

#wttrbar - 
# install wttrbar separately or using script below, place binary in /usr/bin
# https://github.com/bjesus/wttrbar/releases
bash wttrbar.sh


#Azote for backgrounds - only installing manually since Fedora's repo install didn't work
#Manually moved .desktop and icon from azote/dist folder
cd ~/Applications
git clone https://github.com/nwg-piotr/azote.git
cd azote
python3 setup.py install --user


################################################
# Other sway customization
################################################
# 
# Copy backgrounds and change login screen background

mkdir -p ~/Backgrounds
cp Backgrounds/* ~/Backgrounds/
sudo cp Backgrounds/Road.jpg* /usr/share/backgrounds/background-road.jpg
sudo rm /usr/share/backgrounds/default.png
sudo ln -s /usr/share/backgrounds/background-road.jpg /usr/share/backgrounds/default.png
# 

#######################
Other Sway configs and customization - see sway_configs.txt
######################

sudo dnf autoremove

printf "\e[1;32mYou can now reboot! Thanks you.\e[0m\n"

