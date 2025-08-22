```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                        
## [TLDR]
_Updated August 2025_
This repository is my take on installation, configuration and customization Debian, Fedora and WM setup (currently only SWAY). Created for me to use personally but free for anyone to use

## [CREDITS]

https://github.com/drewgrif/bookworm-scripts  
https://github.com/ChrisTitusTech/Debian-titus  
https://github.com/Ubuntu-sway

## [WHAT’S INCLUDED] - REVISIT

### Install Scripts:

* debian_base_trixie.sh - installs base Debian Trixie tools and packages after minimal-install without GUI
* debian_extras_trixie.sh - additional packages and tools I use for Debian
* fedora_install_base.sh - base Fedora tools and packages post fresh-install
* [REVISIT LATER]fedora_extras.sh - additional packages and tools I use for Fedora
* [WORK IN PROGRESS]sway-install_debian.sh - installs SWAY on Debian Trixie
* [REVISIT LATER]sway-install_fedora.sh - installs additional tools for Fedora 
___

### Other Scripts:
* [OPTIONAL] neovim.sh - downloads and installs the latest neovim from source on Debian
* nerdfonts.sh – downloads and installs Nerd Fonts I use
* nwg-wrapper_debian.sh - installs Wayland-friendly script output wrapper from source (Fedora should have these in official repos)
* [OPTIONAL] rofi-wayland_debian.sh - installs Wayland fork of Rofi from source on Debian. Standard rofi should now work in Wayland
* [OPTIONAL] sway-input-configurator_debian.sh - installs SWAY input manager for keyboards, touchpad, etc from source. Can be installed using pipx
* sway-systemd.sh - #installs sway-systemd, which allows easy systemd service integration for SWAY from source
* wttrbar.sh - installs wttr bar (for waybar) from source
* /resources - other files referenced by scripts
* /archive - collection of legacy scripts and documentation
 ___

### DOCUMENTATION
* pre-install-prep.md - checklist with pre-install tasks
* post-install-configs_all.md - tasks and checklists for all fresh installs
* post-install-configs_sway.md - tasks and checklists post-install specific to SWAY and Wayland
* post-install-configs_mint.md - tasks and checklist for a fresh Linux mint (mostly for a laptop) after a GUI install
* https://github.com/leonzwrx/dotfiles/tree/master - my dotfiles repo 
* https://github.com/leonzwrx/homelab-wiki/tree/master - my documentation / wiki repo