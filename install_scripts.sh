#!/bin/bash

SOURCE_DIR=$(pwd)
DEST_DIR="/usr/local/bin"

FILES=(
    "upkeep.sh:upkeep"
    "wb.py:wb"
)

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
            echo -e "\033[0;34m[Skipped]\033[0m $dest_name is already up to date."
            continue
        fi
    fi

    # 3. Perform the copy and set permissions
    echo -e "\033[0;32m[Updating]\033[0m $dest_name..."
    sudo cp "$src_path" "$dest_path"
    sudo chmod +x "$dest_path"

done

echo "Done!"