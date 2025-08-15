#!/usr/bin/env bash

# Define the installation directory
FONT_DIR="$HOME/.local/share/fonts"

# Create the fonts directory if it doesn't exist
mkdir -p "$FONT_DIR"

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

# Use a temporary directory for safer operations
temp_dir=$(mktemp -d)
cd "$temp_dir" || exit

# Loop through each font and download/install
for font in "${fonts[@]}"; do
    echo "Downloading and installing $font..."

    # Define the archive filename
    archive_file="$font.tar.xz"
    
    # Download the font archive
    curl -L -o "$archive_file" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$archive_file"
    
    # Check if the download was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download $font. Exiting."
        continue
    fi
    
    # Create the destination directory for the font
    mkdir -p "$FONT_DIR/$font"
    
    # Extract the font files into the destination directory
    tar -xf "$archive_file" -C "$FONT_DIR/$font"
    
    # Check if the extraction was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract $font. Exiting."
        continue
    fi

done

# Cleanup temporary files
cd - > /dev/null
rm -rf "$temp_dir"

echo "Updating font cache..."
fc-cache -fv
echo "Nerd Fonts installation complete."
