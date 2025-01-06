```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                    

# Sway Post-Install guide

_UPDATED August 2024_

This document is my basic checklist for configuring and customizing my SWAY WM on Debian stable and Fedora Sway Spin

### Verifying Functionality and Base Configuration

* Ensure all core Sway functions are running smoothly
	- Test with 
	```bash 
	swaymsg -r get_workspaces
* Verify `rofi` launches successfully (wofi or another launcher can serve as a backup).
* Check if installed fonts (Nerd Fonts/glyphs) work as expected in Waybar and other applications.
* Review `nwg-displays` configuration and verify resolution settings.
* Confirm Sway scripts for autotiling, volume control, workspace switching, etc. are working properly
* By default, the sway.desktop file simply launches`sway`. 
	- However, it's best to copy start-sway (both located in the resources directory) into `/usr/bin` and modify `sway.desktop` file:
```bash
	[Desktop Entry]
	Name=Sway
	Comment=An i3-compatible Wayland compositor
	Exec=start-sway
	Type=Application
```
`start-sway` is a bash script that provides additional systemd integration including `journalctl` logging (`journalctl /usr/bin/sway`)	

### Theming and Aesthetics

**Changing Themes (if not already done):**

* GTK theme: Nordic
* Icons: Papirus
* Cursors: Nordzy

**Alternative Themes:**

* Orchis-teal-dark-nord theme with Colloid-teal-nord-dark icons
* Breeze theme

**Advanced Theming with Kvantum:**

* Kvantum manages Qt application themes across the board (qt5ct and qt6ct manage fonts, icons, and other settings).
* Add the following lines to your `/etc/environment` file (or via another .conf file optionally):

```
QT_STYLE_OVERRIDE=kvantum  # Use Kvantum theme for Qt applications
QT_QPA_PLATFORMTHEME=qt5ct  # (Optional) Might be a leftover setting, removable if Kvantum works.
```

### Waybar Configuration

* Double-check all Waybar icons for appearance and functionality. Ensure variables in config files are set correctly and nothing is missing.
* Verify alignment and borders are configured as desired

### Source Installation Adjustments

* For applications built from source (e.g., Azote, nwg-look), icons and `.desktop` files might need t o be manually copied from the source folder to `/usr/share/applications` and `/usr/share/pixmaps`.
* For applications like Rofi, where themes are expected in `/usr/share`, move them from `/usr/local/share/rofi`

### Issues to troubleshoot
- _SDDM_
	- If SDDM shows the LXqt desktop in the dropdown, uninstall LXqt components (reinstalling `lximage-qt` might be necessary afterward)

- _OnlyOffice_

	- A bug prevents OnlyOffice from opening normally. While supposedly fixed in Sway 1.9 and wlroots with OnlyOffice 8.1, Debian stable might not have these updates yet

	- _Workaround:_

		- Manually install the `.deb` package for OnlyOffice 7.2.1. - can be found at https://github.com/ONLYOFFICE/DesktopEditors/releases
		- Modify the OnlyOffice desktop file to include a prefix: `Exec=env QT_QPA_PLATFORM=xcb`

### Additional Verifications
* Review keyboard/input settings.
* Confirm power menu functionality (nwg-bar).
* Verify systemd user services in `~/.config/systemd/user` are present, enabled, and working (especially `waybar.service`). You might need to copy them manually from resources if desired.
* Ensure notifications and screenshots work as expected.
