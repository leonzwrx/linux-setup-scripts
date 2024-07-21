```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                    

# Backup and System Information Checklist

*Updated July 2024*

This is my basic checklist prior to wiping and reinstalling an OS

## 1. Verify Backups Exist
- **Timeshift/home dir, etc**
- **System Configuration Files**
  - `/etc/default/grub`
  - `/etc/fstab`
  - `/etc/environment`
  - `/etc/hosts`
  - `/etc/hostname`
  - `/etc/ssh`
  - `/etc/network/interfaces` (or equivalent network configuration)
  - `/etc/resolv.conf`
  - `/etc/yum.repos.d`, `dnf.conf` or `/etc/apt/sources.list.d`
  - Any other custom configuration files in `/etc`

- **User Data**
  - Home directories (e.g., `/home/username`), SSH keys (`~/.ssh`)
  - Any DE customizations (if KDE Plasma, use `PlasmaConfigSave` on `konsave`)
  - Make sure any other application data has backups or config files accounted for (Plex, DB dumps e.g., MySQL, PostgreSQL)

```bash
sudo cp -r /etc/nginx ~/backup/nginx
sudo cp -r /etc/apache2 ~/backup/apache2
sudo cp -r /etc/mysql ~/backup/mysql
sudo cp -r /etc/postgresql ~/backup/postgresql
```

## 2. Look for Any Other Scripts or Modules
- `bind_vfio.sh`, etc.

## 3. Note Down System Info Including Mount Points and Disk Partitions
```bash
lsblk -f
```

## 4. Hardware Info
```bash
lshw > ~/hardware-info.txt
lscpu > ~/cpu-info.txt
lsusb > ~/usb-info.txt
lspci > ~/pci-info.txt
```

## 5. Note Network Configuration
- Static IPs, DNS

## 6. Containers and Images
```bash
podman ps -a > ~/podman-containers.txt
podman images > ~/podman-images.txt
podman volume ls > ~/podman-volumes.txt
```

### Backup Podman Configuration Files
```bash
sudo cp -r /etc/containers ~/backup/podman/etc_containers
sudo cp -r /usr/share/containers ~/backup/podman/usr_share_containers
```

- **Optionally, Backup Volume Data**
```bash
mkdir -p ~/backup/podman/volumes
for volume in $(podman volume ls -q); do
  podman volume inspect $volume -f '{{.Mountpoint}}' | xargs -I {} cp -r {} ~/backup/podman/volumes/$volume
done
```

- **Backup Podman Config Files**
```bash
sudo cp -r /var/lib/containers ~/backup/podman/containers_storage
```

- **List Custom Networks and Backup Network Configs**
```bash
podman network ls > ~/podman-networks.txt
sudo cp -r /etc/cni/net.d ~/backup/podman/networks
```

## 7. Miscellaneous
- **Fonts**
  - `/usr/share/fonts`
  - `~/.fonts`

- **Themes and Icons**
  - `/usr/share/themes`
  - `~/.themes`
  - `/usr/share/icons`
  - `~/.icons`

## 8. Scheduled Tasks and Cron Jobs
```bash
crontab -l > ~/user-crontab-backup.txt
```

## 9. Systemd Services and Timers
- **List Active Services and Timers**
```bash
systemctl list-unit-files --type=service > ~/systemd-services.txt
systemctl list-unit-files --type=timer > ~/systemd-timers.txt
```

- **Backup Custom Service Files**
```bash
sudo cp -r /etc/systemd/system ~/backup/etc_systemd_system
sudo cp -r /lib/systemd/system ~/backup/lib_systemd_system
```

## 10. VMs - QEMU/KVM
```bash
virsh list --all > ~/vms-list.txt
```

- **Backup VM Configs**
```bash
sudo cp -r /etc/libvirt/qemu ~/backup/libvirt_qemu
sudo cp -r /var/lib/libvirt/images ~/backup/libvirt_images
```

## 11. Firewall Rules
```bash
sudo cp -r /etc/ufw ~/backup/ufw
sudo cp -r /etc/firewalld ~/backup/firewalld
```

## 12. Environmental Variables and Shell Profiles
```bash
cp ~/.bashrc ~/backup/bashrc
cp ~/.profile ~/backup/profile
sudo cp /etc/profile ~/backup/etc_profile
sudo cp -r /etc/profile.d ~/backup/etc_profile.d
sudo cp /etc/environment ~/backup/etc_environment
```

## 13. Review Printer/Scanner Configuration

## 14. Record Inputs and Keyboard Settings

## 15. Record All Current Apps in Use
```bash
dnf list installed > ~/dnf-installed-packages.txt

dpkg --get-selections > ~/apt-installed-packages.txt
# or
apt list --installed > ~/apt-installed-packages.txt

flatpak list --app --columns=name,application > ~/flatpak-installed-apps.txt

ls ~/Applications/*.AppImage > ~/appimages-list.txt
```