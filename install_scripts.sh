#!/bin/bash

# install_scripts.sh - Syncs local scripts to /usr/local/bin
#
# This script iterates through the FILES array, checks for changes using 
# MD5 hashes, and updates the system binaries if the local version is newer.
# Usage: ./install_scripts.sh

# Define Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SOURCE_DIR=$(pwd)
DEST_DIR="/usr/local/bin"
FUNC_FILE="$HOME/.thrive_scripts.sh"

FILES=(
    "upkeep.sh:upkeep"
    "wb.py:wb"
    "sprout.py:sprout"
    "mood.sh:mood"
    "winpath.sh:winpath"
    "teleport.sh:teleport"
    "pulse:pulse"
)

echo "Compiling Code..."
if [ -f "pulse.c" ]; then
    gcc pulse.c -o pulse
fi

echo "Checking for updates..."
for entry in "${FILES[@]}";  do
    # Split the mapping 
    src_file="${entry%%:*}"
    dest_name="${entry#*:}"

    src_path="$SOURCE_DIR/$src_file"
    dest_path="$DEST_DIR/$dest_name"

    # 1. Check if source exists
    if [ ! -f "$src_path" ]; then
        echo -e "\033[0;31mError: $src_file not found in $SOURCE_DIR\033[0m"
        continue
    fi

    # 2. Check if update is needed (compare file hashes)
    if [ -f "$dest_path" ]; then
        src_hash=$(md5sum "$src_path" | awk '{print $1}')
        dest_hash=$(md5sum "$dest_path" | awk '{print $1}')

        if [ "$src_hash" == "$dest_hash" ]; then
            echo -e "${BLUE}[Skipped]${NC} $dest_name is already up to date."
            continue
        fi
    fi

    # 3. Perform the copy and set permissions
    echo -e "\033[0;32m[Updating]\033[0m $dest_name..."
    sudo cp "$src_path" "$dest_path"
    sudo chmod +x "$dest_path"

done

# --- Manage shell scripts and bashrc ---

echo "Updating thrive scripts..."
cp "$SOURCE_DIR/thrive_scripts.sh" "$FUNC_FILE"

MARKER="# [Thrive-Scripts-Auto-Source]"
# Define the actual line to append (using single quotes so $HOME isn't evaluated yet)
SOURCE_CMD='[[ -f "$HOME/.thrive_scripts.sh" ]] && source "$HOME/.thrive_scripts.sh"'

# Search for the MARKER instead of the complex code line
if ! grep -Fq "$MARKER" "$HOME/.bashrc"; then
    echo "Adding source command to ~/.bashrc..."
    echo -e "\n$MARKER\n$SOURCE_CMD" >> "$HOME/.bashrc"
else
    echo -e "${BLUE}[Skipped]${NC} Entry already exists in ~/.bashrc"
fi

# --- Cleanup ---
echo "Cleaning up build artifacts..."
if [ -f "$SOURCE_DIR/pulse" ]; then
    rm "$SOURCE_DIR/pulse"
    echo "Removed compiled binary: pulse"
fi

echo -e "${GREEN}Installation complete!${NC}"