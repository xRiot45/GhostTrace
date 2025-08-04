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

# Colors (dipilih secukupnya)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Typing effect
typing_effect() {
    text="$1"
    delay=0.015
    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# Glitch effect
glitch_effect() {
    for i in {1..2}; do
        echo -ne "${GREEN}▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓\r${NC}"
        sleep 0.05
        echo -ne "${CYAN}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\r${NC}"
        sleep 0.05
    done
}

# Box print
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

# Fancy loading
loading() {
    echo -ne "${YELLOW}[*] Processing"
    for i in {1..3}; do
        echo -ne "."
        sleep 0.4
    done
    echo ""
    for i in {1..3}; do
        echo -ne "${YELLOW}>>>${NC} "
        sleep 0.2
    done
    echo ""
}

# Banner
clear
echo -e "${CYAN}"
figlet -f slant "GhostTrace"
echo -e "${NC}"
echo -e "${CYAN}Author:${NC} xRiot45"
echo -e "${CYAN}Target:${NC} $TARGET"
echo -e "${YELLOW}────────────────────────────────────────────${NC}"

# Load stage scripts
source stages/general_info.sh

while true; do
    echo ""
    print_box "GhostTrace - Main Menu" "${GREEN}"
    echo -e "${CYAN}Target:${NC} $TARGET"
    echo ""
    echo -e "${YELLOW}1)${NC} Stage 1: General Domain & Website Information"
    echo -e "${YELLOW}2)${NC} Stage 2: Web Application Technology Info ${CYAN}(Coming soon)${NC}"
    echo -e "${YELLOW}5)${NC} Generate Report (CSV)"
    echo -e "${YELLOW}0)${NC} Exit"
    echo ""
    read -p "Enter your choice: " choice

    case $choice in
    1) run_phase1 ;;
    5) python3 parser.py $TARGET ;;
    0)
        echo -e "${GREEN}Exiting GhostTrace...${NC}"
        sleep 1
        break
        ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
    esac
done
