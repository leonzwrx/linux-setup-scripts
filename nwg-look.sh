#!/bin/sh

# Function to install dependencies based on the package manager
install_dependencies() {
  # ... (rest of the install_dependencies function remains unchanged)
}

# Install dependencies
install_dependencies

# Define variable to store latest version tag
latest=$(curl -sL https://api.github.com/repos/nwg-piotr/nwg-look/releases/latest | jq -r '.tag_name')

# Download archive for latest version
source_dir="$HOME/SourceBuilds"  # Define source directory
mkdir -p "$source_dir"  # Create SourceBuilds directory if it doesn't exist

cd "$source_dir"
wget https://github.com/nwg-piotr/nwg-look/archive/refs/tags/"$latest".zip

# Unzip archive
unzip "$latest".zip

# Extract directory name (assuming consistent naming)
directory_name="nwg-look-${latest#v}"

# Change directory to extracted folder (within source_dir)
cd "$directory_name"

# Build nwg-look using Go
go build -o bin/nwg-look

# Install nwg-look
# ... (rest of the installation commands remain unchanged)

# Clean up downloaded files (within source_dir)
cd ..
rm -rf "$directory_name"
rm "$latest".zip
