#!/bin/bash

# winpath.sh - Convert Windows paths to WSL paths and navigate.
# 
# Usage: winpath "C:\Users\Name\Documents"
# Note: Must be aliased or sourced to change the parent shell's directory.

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Usage:${NC} winpath \"C:\\path\\to\\folder\""
    exit 1
fi

# Combine all arguments in case the user didn't use quotes
input_path="$*"

if [ -z "$input_path" ]; then
    echo -e "${BLUE}Usage:${NC} winpath <C:\\path\\to\\folder>"
    exit 1
fi

# Use the built-in wslpath utility (-u converts Windows to Unix/WSL)
# This handles drive letters and slashes more reliably than sed
wsl_path=$(wslpath -u "$input_path" 2>/dev/null)

if [ -d "$wsl_path" ]; then
    echo -e "${GREEN}Navigating to:${NC} $wsl_path"
    cd "$wsl_path" || exit
else
    echo -e "${RED}Error:${NC} Directory does not exist or path is mangled."
    echo -e "Try wrapping the path in single quotes: ${GREEN}winpath 'C:\\Users\\...'${NC}"
    exit 1
fi