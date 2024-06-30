#!/usr/bin/env bash

# Create fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Change to temporary directory (optional)
cd /tmp  # This line can be removed if preferred

# Define fonts array
fonts=(
"CascadiaCode"
"FiraCode"
"Hack"
"Inconsolata"
"JetBrainsMono"
"Meslo"
"Mononoki"
"RobotoMono"
"SourceCodePro"
"UbuntuMono"
)

for font in "${fonts[@]}"; do
  # Check if font directory exists (prevents unnecessary download)
  if [[ ! -d "$HOME/.local/share/fonts/$font" ]]; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"$font.zip"
  fi
  
  # Unzip with confirmation bypassed (less secure)
  unzip -q "$font.zip" -d "$HOME/.local/share/fonts/$font/" <<< $(yes y)
  
  # Remove zip file silently
  rm -f "$font.zip"
done

# Update font cache
fc-cache
