 ```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                    
# Post-Install guide [Setup/Configuration]
![Linux](https://img.shields.io/badge/OS-Linux-black?style=for-the-badge&logo=linux&logoColor=white)

_UPDATED September 2025_

This document is my basic checklist for configuring and customizing my Linux distros after a fresh install as well as any additional configs. My setup balances simplicity and usability. Both Debian and Fedora (currently using [Sway spin](https://fedoraproject.org/spins/sway) setups utilize Wayland.

# Following first boot:
**DISPLAY MANGER** 
If there are display/login manager issues, few culprits:
    - If using NVIDIA, then it's likely video drivers.
    - SDDM might behave weird due to theming incompatibility with Qt versioning with older themes. There might be errors complaning about theme's `.qml` files. If so, it's best to avoid copying themes into `/usr/share/sddm/themes` and to just install sddm themes from official repos such as `sddm-theme-maui`- or `sddm-theme-elarun`. Various qt5 and qt6 dependencies are bundled together in a package `kde-config-sddm` if necessary      

Optionally, put a PNG sized to 128x128 px or 256 x 256px named `/var/lib/AccountsService/icons/$USER`. [Instruction here](https://wiki.archlinux.org/title/SDDM)
Make sure  to set correct permissions, etc and make sure users's metadata file exists:
```bash
root@powerspec:/var/lib/AccountsService/users# cat leo
[User]
Icon=/var/lib/AccountsService/icons/leo
root@powerspec:/var/lib/AccountsService/users# 
```
- Verify video card drivers' function with tools like `glxinfo`, `mangohud`, `cpu-x`, `radeontop`, `vulkaninfo`, `vkcube` if using AMD card or `nvtop`, 
- Make sure essentials are set up, working, and DE/WM functions are operational
- Set up git and GitHub
	- Add new machine's SSH keys to GitHub 
	- Start interactive setup
	```bash 
	gh auth login #start interactive setup to GitHub
	ssh -T git@github.com #test SSH connection to GitHub
	git remote add "origin" git@github.com:User/UserRepo.git #add repos using SSH
    ```
- Configure or restore any other config files such as GRUB defaults, etc
- Add longer timeout to `sudoers` file:
  ```plaintext
  Defaults        timestamp_type=global,timestamp_timeout=240
  ```

## Applications
- Make sure configs and dotfiles are in place
- Verify keyboards/languages setup
- Setup timeshift using BTRFS - 1m/3w/5d - include @home
- Verify video card drivers' function with tools like `glxinfo`, `mangohud`, `cpu-x`, `radeontop`, `vulkaninfo`, `vkcube` if using AMD card or `nvtop`, `nvidia-smi` if using NVIDIA card
- Verify vim/neovim plugins are being installed and functioning.
- Make changes to `/etc/fstab` and verify all storage is mounted inlcluding NFS
- Configure/Verify browser / sync and extensions, bookmarks, etc
- For setup of common individual applications, use the [homelab-wiki](https://github.com/leonzwrx/homelab-wiki/tree/main) repo

## Fedora/RHEL-specific stuff 
![Made for Fedora](https://img.shields.io/badge/Made%20for-Fedora-294172?style=for-the-badge&logo=fedora&logoColor=white)
- Good post-install script/guide [here](https://github.com/devangshekhawat/Fedora-41-Post-Install-Guide)
- Configure or restore `/etc/dnf/dnf.conf`:
  ```ini
  fastestmirror=True
  max_parallel_downloads=10
  defaultyes=True
  keepcache=True
  ```
## Debian/Ubuntu-specific stuff:
![Made for Debian](https://img.shields.io/badge/Made%20for-Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white)
- run `nala fetch` to set fast mirrors
- If NetworkManager doesn't show the NIC properly in `nm-applet` or `nmcli`/`nmtui`:
  - May need to edit `/etc/NetworkManager/NetworkManager.conf` file and change `managed=false` to `true`.
  - May also need to change the interface name if it's named something funky like `ifupdown` (or add/remove):
    ```bash
    sudo nmcli con add con-name "EthernetConnection" ifname enp6s0
    sudo nmcli con up "EthernetConnection"
    sudo nmcli connection delete "ifupdown (enp6s0)"
    ```
- Install ROCm now that Debian 13 is supported [(Link)](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html)
## Mint-specific stuff:
Moved [here](https://github.com/leonzwrx/linux-setup-scripts/blob/main/documentation/post-install-configs_mint.md) 
![Made for Linux Mint](https://img.shields.io/badge/Made%20for-Linux%20Mint-87C54E?style=for-the-badge&logo=linux-mint&logoColor=white)

## VIRTUALIZATION
- In order to get a VM on a physical network, a new bridge with the VM host has to be created. By default, besides a NAT bridge, Libvirt does not create a bridge network automatically because bridging requires additional configuration and may affect network security. Instead, you must manually set up a bridge that connects to your physical network interface.
- [This guide](https://youtu.be/DYpaX4BnNlg?si=kwJaJMdL6RUega1m) shows how to properly setup a bridge between libvirt VM and the physical network properly. Basically - a new bridge has to be created, add Ethernet connection as a slave. THEN delete the existing 'device'. If there is an issue with the deleted connection constantly coming back - this is most likely because it's getting picked up from `/etc/network/interfaces` file. Comment this portion out:

```toml
   1   │ # This file describes the network interfaces available on your system
   2   │ # and how to activate them. For more information, see interfaces(5).
   3   │ 
   4   │ source /etc/network/interfaces.d/*
   5   │ 
   6   │ # The loopback network interface
   7   │ auto lo
   8   │ iface lo inet loopback
   9   │ 
  10   │ # The primary network interface
  11   │ #allow-hotplug enp6s0
  12   │ #iface enp6s0 inet dhcp
  13   │ # This is an autoconfigured IPv6 interface
  14   │ #iface enp6s0 inet6 auto
```
- It might also be necessary to allow multicast traffic on the `libvirt-bridge` interface:
```bash
sudo ufw allow in on libvirt-bridge
```
#### Set up QEMU/KVM stuff:

Follow [this guide](https://christitus.com/vm-setup-in-linux/).

```bash
sudo virsh net-start default
sudo virsh net-autostart default
sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG kvm $USER
sudo usermod -aG input $USER
sudo usermod -aG disk $USER
```

- Install Windows virtIO drivers if needed for Windows.
- If needed, install `qemu-guest-agent`:
  ```bash
  sudo apt-get install qemu-guest-agent
  ```
  - Then, verify devices are using virtIO drivers, for example:
    ```bash
    ethtool -i eth0
    ```

#### GPU Passthru:
[This guide](https://3os.org/infrastructure/proxmox/gpu-passthrough/igpu-passthrough-to-vm/#windows-virtual-machine-igpu-passthrough-configuration) desribes the process of getting a video card to pass through to the VM properly. General steps on Debian:
1. Make required change to enable IOMMU in `/etc/default/grub` and update grub config
2. Reboot and verify IOMMU is enabled via `dmesg`
3. Locate the `bind_vfio.sh` and place into `/etc/initramfs-tools/scripts/init-top` directory
4. Add vfio-pci kernel driver to the `/etc/modulues` file and run
5. Update configuration changes by running `update-initramfs -u -k all`
6. Verify vfio-pci driver is in use by checking output of `lspci -nnv` command

- **Import old VM(s):**
  Locate or copy the XML files from the old VMs - usually stored in `/etc/libvirt/qemu` and run:
  ```bash
  sudo virsh define ~/Downloads/Win11-KVM.xml
  ```
- For convenience, place a `.desktop` file for each running VM into `~/.local/share/applications` with this Exec line:
  ```plaintext
  exec=virt-viewer --connect=qemu:///system --domain-name VM_Name
  ```

## RCLONE Configuration

1. Run:
   ```bash
   rclone config
   ```
   Follow mostly defaults.

2. Create mount point:
   ```bash
   mkdir -p ~/mnt/gdrive
   ```

3. Mount:
   ```bash
   rclone mount gdrive: ~/mnt/gdrive/
   ```

4. Then create a systemd service to start:
   ```bash
   sudo cp ~/Downloads/linux-setup-scripts/resources/rclone-gdrive.service /etc/systemd/system
   sudo systemctl daemon-reload
   sudo systemctl enable rclone-gdrive --now
   ```

## Networking and remote configs

- Optionally, enable SSH:
  ```bash
  sudo systemctl enable --now sshd
  ```
- Copy VPN profile from import
	+ On Fedora, manual DNS override to resolve local records may be needed:
	```bash
	sudo mkdir -p /etc/systemd/resolved.conf.d
	sudo vim /etc/systemd/resolved.conf.d/dns_overrides.conf
	```
	- Add the following lines to the dns_overrides.conf file:
	```ini
	[Resolve]
	DNS=192.168.1.210 #or whatever local DNS address is
	Domains=domain.local
	```
	+ Restart `systemd-resolved`
	```bash
	sudo systemctl restart systemd-resolved
	```
### Remote Access - Wayland

- For VNC connections to and **existing** Wayland desktop session - need to start `wayvnc` with the following  command
`WAYLAND_DISPLAY=wayland-1 wayvnc -C /home/leo/.config/wayvnc/config &` 
- This is automatated via a script in `~/.local/bin/wayvnc_existing_desktop.sh`
- For a headless connection (without connecting to an existing session), launch `~/.local/bin/wayvnc_headless.sh`
- To kill the wayvnc service, launch `wayvncctl wayvnc-exit`

## THEMING

- For Flatpak theming, see [this guide](https://itsfoss.com/flatpak-app-apply-theme/).
	- Use FlatSeal to allow access to homedir and set all Flatpaks' env variables including:
		+ GTK_THEME=Nordic
		+ ICON_THEME=Papirus
		+ QT_STYLE_OVERRIDE=kvantum

- If needed to manually theme _gedit_, go into Preferences - Fonts & Colors tab, select Nord.

## TROUBLESHOOTING

- If GUFW or another application throws a GTK error, temporarily run:
	
```bash 
xhost si:localuser:root
```
**What `xhost si:localuser:root` Does**
* The `xhost` command manages access control for the X11 server.
* `xhost si:localuser:root` allows the `root` user to connect to the X11 display server. This is a temporary fix but is **not recommended** for regular use because it weakens security.
* another option: Replace .desktop Exec with: `Exec=sh -c "xhost +si:localuser:root && gufw && xhost -si:localuser:root`

## OTHERS

- Copy my dot files from GitHub:
  [https://github.com/leonzwrx/dotfiles](https://github.com/leonzwrx/dotfiles)
- Make sure `.profile` or `.bashrc` don't have anything that isn't relevant to current distribution.
- Configure printing and scanning
- Verify Flatpaks launch correctly and themes look correct
- Configure AppImages and Gearlever and make sure AppImages are in the correct location and `.desktop` files are seen by app launchers
    - Each application may need its update URL set in Gearlevel such as: `https://github.com/Zettlr/Zettlr/releases/download/*/Zettlr-*-x86_64.AppImage`
- Configure/setup firewall - `ufw`/`firewalld` if using ufw, disable IPV6 via `/etc/default/ufw`
- Configure urbackup client (refer to [homelab-wiki](https://github.com/leonzwrx/homelab-wiki))
- **[OPTIONAL]** Configure mutt-wizard and neomutt [guide here](https://github.com/leonzwrx/homelab-wiki/tree/main/general_linux_guides/neomutt.md)
- **[OPTIONAL]** Configure OpenRGB and ckb-next (refer to [homelab-wiki](https://github.com/leonzwrx/homelab-wiki))
- **[OPTIONAL ]** Setup [Tizenbrew](https://github.com/reisxd/TizenTube) if controlling Samsung TVs