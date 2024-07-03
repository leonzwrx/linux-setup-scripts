#!/bin/bash

# Download URL for the specific wttrbar binary zip file
download_url="https://github.com/bjesus/wttrbar/releases/download/0.10.4/wttrbar_0.10.4_x86_64-unknown-linux-musl.zip"

# Download directory (temporary)
download_dir="/tmp"

# Target binary filename
binary_name="wttrbar"

# Download the zip file
if [[ ! -d "$download_dir" ]]; then
  echo "Error: Download directory '$download_dir' does not exist."
  exit 1
fi

curl -sSL "$download_url" -o "$download_dir/$binary_name.zip"

if [[ $? -eq 0 ]]; then
  echo "Downloaded wttrbar binary zip file."
else
  echo "Error: Download failed."
  exit 1
fi

# Extract the binary
unzip -q "$download_dir/$binary_name.zip" -d "$download_dir"

if [[ -f "$download_dir/$binary_name" ]]; then
  echo "Extracted wttrbar binary."
else
  echo "Error: Could not find wttrbar binary in the zip file."
  exit 1
fi

# Make the binary executable (requires sudo)
sudo chmod +x "$download_dir/$binary_name"

# Move the binary to /usr/bin (requires sudo)
sudo mv "$download_dir/$binary_name" /usr/bin

echo "wttrbar installed (may require logout/login for path changes to take effect)."
