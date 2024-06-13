#!/usr/bin/env bash

# - Start with stock Fedora with mostly defaults
# - Verify internet functionality
# - Make sure you have backups including record of all apps, 
#   home dir and any relevant /etc files such as fstab, yum.repos.d, dnf.conf, crontabs


##################################
# Additional repos, etc 
##################################
# Create folders in user directory (eg. Documents,Downloads,etc.)
mkdir ~/Screenshots ~/Downloads ~/Applications
xdg-user-dirs-update
cd Downloads
chmod +x *.sh

# Additional Fedora Repos
cd ~/Downloads
sudo dnf install -y fedora-workstation-repositories
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm;
sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf config-manager --set-enabled google-chrome
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF

###################################################
# Install core packages that may not be installed
###################################################

# Dev tools
sudo dnf groupinstall -y "Development Tools" "Development Libraries"
sudo dnf install -y light meson xdotool pip jq

# Network File Tools/System Events
sudo dnf install -y dialog acpi ln_sensorur# Thunar plugins
sudo dnf install -y thunar-archive-plugin thunar-volman file-roller nvtop iotop iftop ncdu 

#Sounds and multimedia
sudo dnf install -y mpv mpv-mpris pamixer imv gimp mkvtoolnix-gui redshift lximage-qt brightnessctl pamixeri wf-recorder celluloid cmus pavucontrol-qt

#PDF and scanning
sudo dnf install -y evince pdfarranger simple-scan zathura zathura-pdf-poppler 

##################################
# FONTS and THEMES 
##################################

#FONTS
#can simply copy fonts from other machines to ~/.local/share/fonts (for flatpaks) - otherwise /usr/share/fonts
#or install all below

sudo dnf install -y fontconfig google-droid-sans-fonts google-droid-serif-fonts google-droid-sans-mono-fonts google-noto-sans-fonts google-noto-serif-fonts google-noto-mono-fonts google-noto-emoji-fonts google-noto-cjk-fonts dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts adobe-source-serif-pro-fonts adobe-source-sans-pro-fonts adobe-source-code-pro-fonts fontawesome-fonts-all 

#install nerdfonts
bash ./nerdfonts-fedora.sh

#"CascadiaCode"
#"FiraCode"  
#"Hack"  
#"Inconsolatae
#"JetBrainsMono" 
#"Meslo"
#"Mononoki" 
#"RobotoMono" 
#"SourceCodePro" 
#"UbuntuMono"

# Reloading Font
fc-cache -vf

# Download Nordic Theme
cd /usr/share/themes/
sudo git clone https://github.com/EliverLara/Nordic.git

# Optionally run orchis.sh and teal.sh from bookworm scripts for different Nord themes
#bash ./orchis.sh
#bash ./teal.sh

# Install Nordzy cursor
cd ~/Downloads
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

#Install Nord theme for gedit
cd ~/Downloads
git clone https://github.com/nordtheme/gedit
./install.sh
rm -rf gedit


##################################
# Other tools I use
##################################        

#Chrome
sudo dnf install -y google-chrome-stable

#Flatpak
sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#install flatpaks I use
flatpak install -y onlyoffice appimagepool czkawka gearlever io.github.shiftey.Desktop


#Others
sudo dnf install -y progress firefox htop ranger gh git remmina gedit lsd figlet toilet galculator cpu-x trash-cli bat lolcat tldr xev timeshift fd-find rclone keepassxc

# Install Virtualization tools (including QEMU/KVM
sudo dnf install -y @virtualization
# this is similar to qemu-full package in other distros or install manually below:
# sudo dnf install -y qemu-kvm libvirt-daemon-kvm virt-install virt-manager virt-viewer

#Install VIM plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

######################################
#Other configs and customization - see fedora_configs.txt
######################################


sudo dnf autoremove

printf "\e[1;32mYou can now reboot! Thanks you.\e[0m\n"

