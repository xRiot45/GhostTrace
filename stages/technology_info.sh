#!/bin/bash

TARGET=$TARGET
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~') # Remove protocol

RAW_DIR_TECH="results/raw/$TARGET/technology_info"

# Detect Web Server
detect_web_server() {
    print_box "Detecting Web Server for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_TECH"
    curl -s -I "http://$TARGET" | grep -i "Server:" >"$RAW_DIR_TECH/web_server.txt"
    curl -s -I "https://$TARGET" | grep -i "Server:" >>"$RAW_DIR_TECH/web_server.txt"
    echo -e "${GREEN}[+] Web server info saved to $RAW_DIR_TECH/web_server.txt${NC}"
}

# Detect CMS / Framework
detect_cms_framework() {
    print_box "Detecting CMS / Framework for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_TECH"
    whatweb $TARGET --color=never >"$RAW_DIR_TECH/cms_framework.txt"
    echo -e "${GREEN}[+] CMS / Framework info saved to $RAW_DIR_TECH/cms_framework.txt${NC}"
}

# Detect Programming Languages
detect_languages() {
    print_box "Detecting Programming Languages for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_TECH"
    curl -s -I "http://$TARGET" | grep -i "X-Powered-By:" >"$RAW_DIR_TECH/languages.txt"
    curl -s -I "https://$TARGET" | grep -i "X-Powered-By:" >>"$RAW_DIR_TECH/languages.txt"
    echo -e "${GREEN}[+] Programming languages info saved to $RAW_DIR_TECH/languages.txt${NC}"
}

# Detect Database (indikasi umum)
detect_database() {
    print_box "Checking Database Indicators for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_TECH"
    curl -s "http://$TARGET" | grep -iE "MySQL|PostgreSQL|MongoDB|SQLite" >"$RAW_DIR_TECH/database.txt"
    curl -s "https://$TARGET" | grep -iE "MySQL|PostgreSQL|MongoDB|SQLite" >>"$RAW_DIR_TECH/database.txt"
    echo -e "${GREEN}[+] Database indicators saved to $RAW_DIR_TECH/database.txt${NC}"
}

# Detect Libraries / Plugins
detect_libraries_plugins() {
    print_box "Detecting Libraries & Plugins for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_TECH"
    whatweb $TARGET --color=never >"$RAW_DIR_TECH/libraries_plugins.txt"
    echo -e "${GREEN}[+] Libraries / Plugins info saved to $RAW_DIR_TECH/libraries_plugins.txt${NC}"
}

# Menu Stage 2
run_phase2() {
    mkdir -p "$RAW_DIR_TECH"

    while true; do
        echo ""
        print_box "Stage 2 : Web Application Technology Info" "${GREEN}"
        echo -e "${CYAN}Target:${NC} $TARGET"
        echo ""
        echo -e "${YELLOW}1)${NC} Web Server"
        echo -e "${YELLOW}2)${NC} CMS / Framework"
        echo -e "${YELLOW}3)${NC} Programming Languages"
        echo -e "${YELLOW}4)${NC} Database Indicators"
        echo -e "${YELLOW}5)${NC} Libraries / Plugins"
        echo -e "${YELLOW}6)${NC} Run ALL"
        echo -e "${YELLOW}0)${NC} Back to Main Menu"
        echo ""
        read -p "Enter your choice: " choice

        case $choice in
        1) detect_web_server ;;
        2) detect_cms_framework ;;
        3) detect_languages ;;
        4) detect_database ;;
        5) detect_libraries_plugins ;;
        6)
            detect_web_server
            detect_cms_framework
            detect_languages
            detect_database
            detect_libraries_plugins
            ;;
        0) break ;;
        *) echo -e "${RED}Invalid option.${NC}" ;;
        esac
    done
}
