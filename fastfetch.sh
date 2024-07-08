#!/bin/bash

# Install fastfetch from Github (not available in Debian's repos)
cd ~/Downloads

# Get the latest release information from Github API
latest_url=$(curl -sL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest)

# Extract the download URL for the Debian package
download_url=$(echo "$latest_url" | jq -r '.assets[] | select(.name | contains("linux-amd64.deb")) | .browser_download_url')

# Check if a download URL was found
if [[ -z "$download_url" ]]; then
  echo "Error: Could not find a suitable Debian package in the latest release."
  exit 1
fi

# Download the package
wget -qO fastfetch.deb "$download_url"

# Install the downloaded package
sudo dpkg -i fastfetch.deb

# Fix potential dependencies
sudo apt install -f

