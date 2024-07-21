```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                    
# Post-Install guide

*UPDATED JULY 2024*

This document is my basic checklist for configuring and customizing my Linux distros after a fresh install

## Following first boot:
- If there are display/login manager issues, likely culprit is NVIDIA:
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
- Configure or restore any other config files such as GRUB defaults, etc
- Add longer timeout to `sudoers` file:
  ```plaintext
  Defaults        timestamp_type=global,timestamp_timeout=240
  ```

## Fedora/RHEL-specific stuff:

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

---

## VIRTUALIZATION

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

---

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

---

## REMOTE Configs

- Optionally, enable SSH:
  ```bash
  sudo systemctl enable --now sshd
  ```
- Copy VPN profile from Google Drive and set up VPN profile (username `leovpn`).
- Verify `wayvnc` functionality (script to start headless sway and `wayvnc` should be in `~/.local/bin`).

---

## THEMING

- For Flatpak theming, see [this guide](https://itsfoss.com/flatpak-app-apply-theme/).
	- Use FlatSeal to allow access to homedir and set all Flatpaks' env variables including:
		+ GTK_THEME=Nordic
		+ ICON_THEME=Papirus
		+ QT_STYLE_OVERRIDE=kvantum

- If needed to manually theme `gedit`, go into Preferences - Fonts & Colors tab, select Nord.

---

## TROUBLESHOOTING

- If GUFW throws a GTK error, temporarily run:
	
```bash 
xhost si:localuser:root
```
	

## OTHERS

- Copy my dot files from GitHub:
  [https://github.com/leonzwrx/dotfiles](https://github.com/leonzwrx/dotfiles)
- Verify vim/Gvim/neovim plugins are being installed and functioning.
- Make sure `.profile` or `.bashrc` don't have anything that isn't relevant to current distribution.
- Configure printing and scanning
- Verify Flatpaks launch correctly and themes look correct
- Configure AppImages and Gearlever and make sure AppImages are in the correct location and `.desktop` files are seen by app launchers
- Configure/setup firewall - `ufw`/`firewalld`
- **[OPTIONAL]** Configure (AND DOCUMENT?) OpenRGB and ckb-next (refer to Documentation repo)
