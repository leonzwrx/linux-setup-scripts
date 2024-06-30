#!/bin/bash

# Define variables
REPO_URL="https://github.com/chubin/wttr.in/releases/latest/download/wttrbar-linux-amd64"
DESTINATION="/usr/bin/wttrbar"  # Destination path

# Function to check for root privileges
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges to install system-wide."
    exit 1
  fi
}

# Function to download the binary securely
download_binary() {
  echo "Downloading wttrbar binary..."
  curl -Lsf --output /tmp/wttrbar "$REPO_URL"  # Use secure option (-s) and silent (-f)
  if [ $? -ne 0 ]; then
    echo "Download failed!"
    exit 1
  fi
  echo "Download completed."
}

# Function to install the binary (without execution)
install_binary() {
  echo "Installing wttrbar to $DESTINATION..."
  mv /tmp/wttrbar "$DESTINATION"
  if [ $? -ne 0 ]; then
    echo "Installation failed!"
    exit 1
  fi
  # Set permissions but avoid unnecessary execution (security best practice)
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

echo "wttrbar installation completed successfully. Remember to add wttrbar to your PATH environment variable for easy access."


