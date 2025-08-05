#!/bin/bash

# Directories
RAW_DIR="results/raw"
PARSED_DIR="results/parsed"
mkdir -p $RAW_DIR $PARSED_DIR

# Validate target input
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

TARGET=$1
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~')

# Banner
clear
echo -e "${CYAN}"
figlet -f slant "GhostTrace"
echo -e "${NC}"
echo -e "${CYAN}Author:${NC} xRiot45"
echo -e "${CYAN}Target:${NC} $TARGET"
echo -e "${YELLOW}────────────────────────────────────────────${NC}"

# Load stage scripts
source utils.sh
source stages/general_info.sh
source stages/technology_info.sh

while true; do
    echo ""
    print_box "GhostTrace - Main Menu" "${GREEN}"
    echo -e "${CYAN}Target:${NC} $TARGET"
    echo ""
    echo -e "${YELLOW}1)${NC} Stage 1: General Domain & Website Information"
    echo -e "${YELLOW}2)${NC} Stage 2: Web Application Technology Info"
    echo -e "${YELLOW}5)${NC} Generate Report (CSV)"
    echo -e "${YELLOW}0)${NC} Exit"
    echo ""
    read -p "Enter your choice: " choice

    case $choice in
    1) run_phase1 ;;
    2) run_phase2 ;;
    5) python3 parser.py $TARGET ;;
    0)
        echo -e "${GREEN}Exiting GhostTrace...${NC}"
        sleep 1
        break
        ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
    esac
done
