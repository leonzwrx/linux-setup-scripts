#!/bin/sh

# Define variable to store latest version tag
latest=$(curl -sL https://api.github.com/repos/nwg-piotr/nwg-look/releases/latest | jq -r '.tag_name')

# Download archive for latest version
cd ~/Downloads
wget https://github.com/nwg-piotr/nwg-look/archive/refs/tags/"$latest".zip

# Unzip archive
unzip "$latest".zip

# Extract directory name (assuming consistent naming)
directory_name="nwg-look-$latest"

# Change directory to extracted folder
cd "$directory_name"

# Build and install nwg-look
make build
sudo make install

# Clean up downloaded files
cd ..
rm -rf "$directory_name"
rm "$latest".zip
