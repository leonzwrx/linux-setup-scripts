#!/usr/bin/env bash

sudo apt install -y bison flex

mkdir -p ~/SourceBuilds
cd ~/SourceBuilds

git clone https://github.com/lbonn/rofi.git
cd rofi
meson setup build && ninja -C build
sudo ninja -C build install

#Another option if binary isn't launching:

## Update package lists (recommended before building)
#sudo apt update
#
## Install build dependencies (adjust based on project requirements)
#sudo apt install -y bison flex git build-essential libcairo2-dev libxcb-xinerama-dev libxcb-xkb-dev libxkbcommon-dev libstartup-notification-dev pkg-config
#
## Create a custom installation directory (replace /opt/rofi with your preference)
#mkdir -p /opt/rofi
#
## Navigate to the source directory
#cd ~/SourceBuilds
#git clone https://github.com/lbonn/rofi.git
#cd rofi
#
## Configure with custom prefix
#./configure --prefix=/opt/rofi
#
## Build the project
#make
#
## Install (consider creating a Debian package for a cleaner approach)
#sudo make install
#
## (Optional) Verify installation
#rofi -v  # This should print the Rofi version if successful
