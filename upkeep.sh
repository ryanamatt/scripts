#!/usr/bin/sh

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Upkeeping system...${NC}"

sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
