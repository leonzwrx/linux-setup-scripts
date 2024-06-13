#!/bin/bash

# Define variables
REPO_URL="https://github.com/chubin/wttr.in/releases/latest/download/wttrbar-linux-amd64"  # URL to the latest release binary
DESTINATION="/usr/bin/wttrbar"  # Destination path

# Function to check for root privileges
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
  fi
}

# Function to download the binary
download_binary() {
  echo "Downloading wttrbar binary..."
  curl -L -o /tmp/wttrbar "$REPO_URL"
  if [ $? -ne 0 ]; then
    echo "Download failed!"
    exit 1
  fi
  echo "Download completed."
}

# Function to move the binary to /usr/bin
install_binary() {
  echo "Installing wttrbar to $DESTINATION..."
  mv /tmp/wttrbar "$DESTINATION"
  if [ $? -ne 0 ]; then
    echo "Installation failed!"
    exit 1
  fi
  chmod +x "$DESTINATION"
  echo "Installation successful."
}

# Main script execution
check_root
download_binary
install_binary

# Cleanup
rm -f /tmp/wttrbar
echo "Cleanup completed."

echo "wttrbar installation completed successfully."

