#!/usr/bin/env bash

mkdir -p ~/.local/share/fonts

cd /tmp
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

shopt -s silent  # Silence confirmation prompts during overwrites

for font in ${fonts[@]}
do
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip
  unzip -q $font.zip -d $HOME/.local/share/fonts/$font/  # Added -q flag for quiet operation
  rm $font.zip
done

fc-cache

shopt -u silent  # Restore default prompt behavior
