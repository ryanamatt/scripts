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
FUNC_FILE="$HOME/.thrive.sh"

FILES=(
    "upkeep.sh:upkeep"
    "wb.py:wb"
    "sprout.py:sprout"
    "mood.sh:mood"
    "winpath.sh:winpath"
    "teleport.sh:teleport"
    "pulse:pulse"
    "life:life"
)

echo "Compiling Code..."
# if [ -f "pulse.c" ]; then
#     gcc pulse.c -o pulse
# fi
for c_file in *.c; do
    if [ -f "$c_file" ]; then
        binary_name="${c_file%.*}"
        echo -e "${BLUE}[Compiling]${NC} $c_file -> $binary_name"
        gcc "$c_file" -o "$binary_name"
    fi
done

echo "Checking for updates..."
for entry in "${FILES[@]}";  do
    # Split the mapping 
    src_file="${entry%%:*}"
    dest_name="${entry#*:}"

    src_path="$SOURCE_DIR/$src_file"
    dest_path="$DEST_DIR/$dest_name"

    # 1. Check if source exists
    if [ ! -f "$src_path" ]; then
        echo -e "${RED}Error: $src_file not found in $SOURCE_DIR${NC}"
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
    echo -e "${GREEN}[Updating]${NC} $dest_name..."
    sudo cp "$src_path" "$dest_path"
    sudo chmod +x "$dest_path"

done

# --- Manage shell scripts and bashrc ---

echo "Updating thrive scripts..."
cp "$SOURCE_DIR/thrive.sh" "$FUNC_FILE"

MARKER="# [Thrive-Scripts-Auto-Source]"
# Define the actual line to append (using single quotes so $HOME isn't evaluated yet)
SOURCE_CMD='[[ -f "$HOME/.thrive.sh" ]] && source "$HOME/.thrive.sh"'

# Search for the MARKER instead of the complex code line
if ! grep -Fq "$MARKER" "$HOME/.bashrc"; then
    echo "Adding source command to ~/.bashrc..."
    echo -e "\n$MARKER\n$SOURCE_CMD" >> "$HOME/.bashrc"
else
    echo -e "${BLUE}[Skipped]${NC} Entry already exists in ~/.bashrc"
fi

# --- Cleanup ---

# Removes any binary created from a .c file to keep the folder clean
echo "Cleaning up build artifacts..."
for c_file in *.c; do
    binary_name="${c_file%.*}"
    if [ -f "$SOURCE_DIR/$binary_name" ]; then
        rm "$SOURCE_DIR/$binary_name"
    fi
done

echo -e "${GREEN}Installation complete!${NC}"
