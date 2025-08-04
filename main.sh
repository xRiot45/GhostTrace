#!/bin/bash

RAW_DIR="results/raw"
PARSED_DIR="results/parsed"

mkdir -p $RAW_DIR $PARSED_DIR

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

TARGET=$1

# Remove protocol (http:// or https://) if user provides full URL
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~')

# Load stage scripts
source stages/general_info.sh
# (Nanti tambahkan stage2, stage3, stage4 setelah dibuat)

while true; do
    echo ""
    echo "=== Footprinting Tool Main Menu ==="
    echo "Target: $TARGET"
    echo "1) Stage 1: General Domain & Website Information"
    echo "2) Stage 2: Web Application Technology Information (Coming soon)"
    echo "0) Exit"
    read -p "Enter your choice: " choice

    case $choice in
    1) run_stage1_menu ;;
    5) python3 parser.py $TARGET ;;
    0)
        echo "Exiting."
        break
        ;;
    *) echo "Invalid option." ;;
    esac
done
