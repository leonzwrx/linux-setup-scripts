#!/bin/bash

# Application Name
app_name="nwg-bar"

# Go installation (consider changing if you have Go installed already)
go_version="1.20"
go_download_url="https://dl.google.com/go/go$go_version.linux-amd64.tar.gz"

# Script directory (replace with actual location)
script_dir=$(pwd)

# Check for existing Go installation
if ! command -v go &> /dev/null; then
  echo "Go is not installed. Downloading and installing Go $go_version..."

  # Download Go archive
  curl -sSL "$go_download_url" -o "/tmp/go.tar.gz"

  # Extract Go archive
  tar -xzf "/tmp/go.tar.gz" -C /usr/local

  # Add Go to PATH (modify if necessary)
  export PATH="/usr/local/go/bin:$PATH"

  # Verify Go installation
  if ! command -v go &> /dev/null; then
    echo "Error: Go installation failed."
    exit 1
  fi
fi

# Install dependencies
sudo apt install -y git build-essential pkg-config libgtk-3-dev libcairo2-dev libpango1.0-dev libjson-glib-dev libgirepository1.0-dev libx11-xcb-dev libxtst-dev libgconf-2-dev

# Clone the nwg-bar repository
git clone https://github.com/nwg-piotr/nwg-bar.git

# Navigate to the project directory
cd nwg-bar

# Download Go dependencies
make get

# Build the application
make build

# Install the application (requires sudo)
sudo make install

# Print success message
echo "nwg-bar installed successfully."

# (Optional) Return to the script directory
cd "$script_dir"

