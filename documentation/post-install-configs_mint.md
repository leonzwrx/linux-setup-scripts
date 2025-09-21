```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                    
# Post-Install guide for Mint[Configuration]
![Made for Linux Mint](https://img.shields.io/badge/Made%20for-Linux%20Mint-87C54E?style=for-the-badge&logo=linux-mint&logoColor=white)
_UPDATED March 2025_

This document is my basic checklist for configuring and customizing my Linux Mint workstation (usually on a laptop) - after a generic GUI install

## During installation - BTRFS and Timeshift
1. Linux Mint does not automatically set up the Btrfs subvolume structure required for Timeshift during installation. The whole process is listed [here](https://www.youtube.com/watch?v=narKYUvPQSA)_ and [here](https://github.com/orgs/linuxmint/discussions/549)_ - optionally enable BTRFS snapshots to show up in GRUB
2. After setting BTRFS partitioning above, proceed with the install. Encrypt home folder 
> If you selected the option to encrypt your home partition during the Linux Mint installation, the system uses eCryptfs to encrypt your home directory, not full disk encryption (LUKS). This means only your /home directory is encrypted, while the rest of the system (e.g., root partition) remains unencrypted.
> ecryptfs does not work well with **URBACKUP server**. If needed, remove it using [this procedure](https://www.howtogeek.com/116179/how-to-disable-home-folder-encryption-after-installing-ubuntu/)

## Following first boot:
1. Check for presense of `~/.ecryptfs` folder - If this directory exists and contains files like `wrapped-passphrase` and `Private.mnt`, your home directory is encrypted.
   - Copy/backup critical ecryptFS:
 ```bash
cp ~/.ecryptfs/wrapped-passphrase /path/to/backup/f #Contains the encryption passphrase
cp ~/.ecryptfs/Private.sig /path/to/backup/ #Contains the signature of your encrypted directory.
cp ~/.ecryptfs/Private.mnt /path/to/backup/ #Contains the mount point for your encrypted directory.
```
2. **Configure Timeshift**: Open Timeshift and set it up to use Btrfs snapshots.
3. Apply all updates and add universe repo
```bash
# Get the latest updates
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get -y upgrade
```

## Additional software
1. First, install some more basics
`sudo apt install ssh nala git lsd -y`
2. Remove unnecessary Mint software:
`sudo apt remove neofetchthunderbird firefox firefox-locale-en libreoffice* -y ; sudo apt autoremove`
3. Install some additional packages
```bash
sudo apt install htop vim neovim rclone ranger ncdu tldr bat filezilla nfs-client \
pdfarranger remmina zram-tools -y
```
5. Install flatpaks
`flatpak install com.github.tchx84.Flatseal com.brave.Browser`
6. Install Starship `curl -sS https://starship.rs/install.sh | sh`
7. Install Fastfetch:
```bash
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update
sudo apt install fastfetch
```
8. Install ONLYOFFICE
```bash
#gpg key
mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg
#add repo
echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list
sudo apt update
sudo apt install -y onlyoffice-desktopeditors
```
6. Install auto-cpufreq
```bash
mkdir ~/Applications
cd ~/Applications
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```

## Other configs
- Go over UFW, configure firewall rules
- Configure keyboards, printers, scanners
- Copy fonts from other machines if previous installs/scripts didn't already do so
- Configure  power options and verify auto-cpufreq if needed
- Verify zram swap works but edit `/etc/default/zramswap` is set to have `ALGO=lz4` and `PERCENT=25`
- Copy `rclone.conf` from a working machine and set rclone with `rclone config` command, then follow rclone instructions [here](https://github.com/leonzwrx/linux-setup-scripts/blob/main/documentation/post-install-configs_all.md)
- Configure Diodon clipboard manager and set **meta+V** as custom shortcut pointing to `/usr/bin/diodon`
- Set up backups with **urbackupserver**#
