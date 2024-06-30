#!/bin/sh

# Function to install dependencies based on the package manager
install_dependencies() {
  if command -v dnf > /dev/null; then
    echo "Detected Fedora-based system. Installing dependencies using dnf..."
    sudo dnf install -y cairo cairo-devel cairo-gobject cairo-gobject-devel \
      pango pango-devel gdk-pixbuf2 gdk-pixbuf2-devel gtk3 gtk3-devel
  elif command -v apt > /dev/null; then
    echo "Detected Debian-based system. Installing dependencies using apt..."
    sudo apt update
    sudo apt install -y libcairo2 libcairo2-dev libcairo-gobject2 libcairo-gobject2-dev \
      libpango1.0-0 libpango1.0-dev libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev \
      libgtk-3-0 libgtk-3-dev
  else
    echo "Unsupported package manager. Please install the dependencies manually."
    exit 1
  fi
}

# Install dependencies
install_dependencies

# Define variable to store latest version tag
latest=$(curl -sL https://api.github.com/repos/nwg-piotr/nwg-look/releases/latest | jq -r '.tag_name')

# Download archive for latest version
cd ~/Downloads
wget https://github.com/nwg-piotr/nwg-look/archive/refs/tags/"$latest".zip

# Unzip archive
unzip "$latest".zip

# Extract directory name (assuming consistent naming)
directory_name="nwg-look-${latest#v}"

# Change directory to extracted folder
cd "$directory_name"

# Build nwg-look using Go
go build -o bin/nwg-look

# Install nwg-look
sudo mkdir -p /usr/share/nwg-look
sudo mkdir -p /usr/share/nwg-look/langs
sudo mkdir -p /usr/bin
sudo mkdir -p /usr/share/applications
sudo mkdir -p /usr/share/pixmaps
sudo mkdir -p /usr/share/doc/nwg-look
sudo mkdir -p /usr/share/licenses/nwg-look
sudo cp stuff/main.glade /usr/share/nwg-look/
sudo cp langs/* /usr/share/nwg-look/langs/
sudo cp stuff/nwg-look.desktop /usr/share/applications/
sudo cp stuff/nwg-look.svg /usr/share/pixmaps/
sudo cp bin/nwg-look /usr/bin

# Clean up downloaded files
cd ..
rm -rf "$directory_name"
rm "$latest".zip

