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

# Remove protocol (http:// or https://) if user provides full URL
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~')

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Typing effect
typing_effect() {
    text="$1"
    delay=0.02
    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# Glitch effect
glitch_effect() {
    for i in {1..2}; do
        echo -ne "${RED}▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓\r${NC}"
        sleep 0.05
        echo -ne "${GREEN}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\r${NC}"
        sleep 0.05
    done
}

# Box print with typing
print_box() {
    local title=$1
    local color=$2
    local len=${#title}
    local border=$(printf '─%.0s' $(seq 1 $len))

    glitch_effect
    echo -e "${color}┌─${border}─┐${NC}"
    echo -ne "${color}│ ${NC}"
    typing_effect "$title"
    echo -e "${color}└─${border}─┘${NC}"
}

# Banner
clear
echo -e "${CYAN}"
figlet -f slant "GhostTrace"
echo -e "${NC}"
echo -e "${PURPLE}Author:${NC} xRiot45"
echo -e "${PURPLE}Target:${NC} $TARGET"
echo -e "${YELLOW}=============================================${NC}"

# Load stage scripts
source stages/general_info.sh

while true; do
    echo ""
    print_box "GhostTrace - Footprinting Tool Main Menu" "${GREEN}"
    echo -e "${CYAN}Target:${NC} $TARGET"
    echo ""
    echo -e "${YELLOW}1)${NC} Stage 1: General Domain & Website Information"
    echo -e "${YELLOW}2)${NC} Stage 2: Web Application Technology Information ${RED}(Coming soon)${NC}"
    echo -e "${YELLOW}5)${NC} Generate Report (Parse Raw to CSV)"
    echo -e "${YELLOW}0)${NC} Exit"
    echo ""
    read -p "Enter your choice: " choice

    case $choice in
    1) run_phase1 ;;
    5) python3 parser.py $TARGET ;;
    0)
        echo -e "${RED}Exiting...${NC}"
        sleep 1
        break
        ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
    esac
done
