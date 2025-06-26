```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                    
# Post-Install guide [Setup/Configuration]

_UPDATED April 2025_

This document is my basic checklist for configuring and customizing my Linux distros after a fresh install as well as any additional configs

## Following first boot:
- If there are display/login manager issues, likely culprit is video drivers, especially NVIDIA:
- Follow separate procedure to bind it to `vfio-pci` driver if that GPU will be passed through
- Verify video card drivers' function with tools like `glxinfo`, `mangohud`, `cpu-x`, `radeontop`, `vulkaninfo`, `vkcube` if using AMD card or `nvtop`, `nvidia-smi` if using NVIDIA card
- Set up Timeshift and use BTRFS and take an initial snapshot
- Make changes to `/etc/fstab` and verify all storage is mounted
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

## Fedora/RHEL-specific stuff 
(May need to verify with DNF5)
- Good post-install script/guide [here](https://github.com/devangshekhawat/Fedora-41-Post-Install-Guide)
- Configure or restore `/etc/dnf/dnf.conf`:
  ```ini
  fastestmirror=True
  max_parallel_downloads=10
  defaultyes=True
  keepcache=True
  ```
## Debian/Ubuntu-specific stuff:

- If NetworkManager doesn't show the NIC properly in `nm-applet` or `nmcli`/`nmtui`:
  - May need to edit `/etc/NetworkManager/NetworkManager.conf` file and change `managed=false` to `true`.
  - May also need to change the interface name if it's named something funky like `ifupdown` (or add/remove):
    ```bash
    sudo nmcli con add con-name "EthernetConnection" ifname enp6s0
    sudo nmcli con up "EthernetConnection"
    sudo nmcli connection delete "ifupdown (enp6s0)"
    ```
> As of January 2025, AMD's ROCm drivers are now natively supported on Debian 12 - however, only with default 6.1 kernel - procedure [here](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/install-methods/amdgpu-installer/amdgpu-installer-debian.html#) -The only way to get OpenCL with ROCm drivers successfully running is to downgrade to the standard, non-backported kernel as their [compativility matrix shows](https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html)
## Mint-specific stuff:
Moved [here](https://github.com/leonzwrx/linux-setup-scripts/blob/main/documentation/post-install-configs_mint.md) 

## VIRTUALIZATION
 -In order to get a VM on a physical network, a new bridge with the VM host has to be created. By default, besides a NAT bridge, Libvirt does not create a bridge network automatically because bridging requires additional configuration and may affect network security. Instead, you must manually set up a bridge that connects to your physical network interface.
 -[This guide](https://youtu.be/DYpaX4BnNlg?si=kwJaJMdL6RUega1m) shows how to properly setup a bridge between libvirt VM and the physical network properly
-Basically - a new bridge has to be created, add Ethernet connection as a slave. THEN delete the existing 'device'
-If there is an issue with the deleted connection constantly coming back - this is most likely because it's getting picked up from `/etc/network/interfaces` file. Comment this portion out:

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

Set up QEMU/KVM stuff:

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
- For VNC connections to Wayland desktop (**existing** session)- need to start `wayvnc` with the following  command (should be located inside a script in ~/.local/bin)
`WAYLAND_DISPLAY=wayland-1 wayvnc -C /home/leo/.config/wayvnc/config &`

## THEMING

- For Flatpak theming, see [this guide](https://itsfoss.com/flatpak-app-apply-theme/).
	- Use FlatSeal to allow access to homedir and set all Flatpaks' env variables including:
		+ GTK_THEME=Nordic
		+ ICON_THEME=Papirus
		+ QT_STYLE_OVERRIDE=kvantum

- If needed to manually theme `gedit`, go into Preferences - Fonts & Colors tab, select Nord.

## TROUBLESHOOTING

- If GUFW or another application throws a GTK error, temporarily run:
	
```bash 
xhost si:localuser:root
```
**What `xhost si:localuser:root` Does**
* The `xhost` command manages access control for the X11 server.
* `xhost si:localuser:root` allows the `root` user to connect to the X11 display server. This is a temporary fix but is **not recommended** for regular use because it weakens security.
* another option:* `pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY gufw`
## OTHERS

- Copy my dot files from GitHub:
  [https://github.com/leonzwrx/dotfiles](https://github.com/leonzwrx/dotfiles)
- Verify vim/Gvim/neovim plugins are being installed and functioning.
- Make sure `.profile` or `.bashrc` don't have anything that isn't relevant to current distribution.
- Configure printing and scanning
- Verify Flatpaks launch correctly and themes look correct
- Configure AppImages and Gearlever and make sure AppImages are in the correct location and `.desktop` files are seen by app launchers
    - Each application may need its update URL set in Gearlevel such as: `https://github.com/Zettlr/Zettlr/releases/download/*/Zettlr-*-x86_64.AppImage`
- Configure/setup firewall - `ufw`/`firewalld`
- Configure urbackup client (refer to [homelab-wiki](https://github.com/leonzwrx/homelab-wiki))
- **[OPTIONAL]**  Configure mutt-wizard and neomutt [guide here](https://github.com/leonzwrx/homelab-wiki/tree/main/general_linux_guides/neomutt.md)
- **[OPTIONAL]** Configure OpenRGB and ckb-next (refer to [homelab-wiki](https://github.com/leonzwrx/homelab-wiki))
