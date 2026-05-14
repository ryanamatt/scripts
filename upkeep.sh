#!/usr/bin/sh

# upkeep.sh - System maintenance utility for Debian-based distros.
#
# This script automates the process of updating package lists, 
# upgrading packages, and cleaning up unnecessary dependencies.
# Usage: ./upkeep.sh

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Upkeeping system...${NC}"

sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
