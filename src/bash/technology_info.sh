#!/bin/bash

TARGET=$TARGET
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~')

RAW_DIR_TECH="data/raw/$TARGET/technology_info"
mkdir -p "$RAW_DIR_TECH"

VENV_PATH="$(dirname "$0")/../../venv"

run_python() {
    if [ -d "$VENV_PATH" ]; then
        "$VENV_PATH/bin/python" "$@"
    else
        python3 "$@"
    fi
}

# Web Server Detection
detect_web_server() {
    print_box "Detecting Web Server for $TARGET" "${CYAN}"
    loading
    curl -s -I "http://$TARGET" | grep -i "Server:" >"$RAW_DIR_TECH/web_server.txt"
    curl -s -I "https://$TARGET" | grep -i "Server:" >>"$RAW_DIR_TECH/web_server.txt"

    if [ ! -s "$RAW_DIR_TECH/web_server.txt" ]; then
        echo "404 Not Found" >"$RAW_DIR_TECH/web_server.txt"
        echo -e "${RED}[!] Web server not detected (404 Not Found)${NC}"
    else
        echo -e "${GREEN}[+] Web server info saved to $RAW_DIR_TECH/web_server.txt${NC}"
    fi
}

# CMS / Framework Detection (Python Wappalyzer)
detect_cms_framework() {
    print_box "Detecting CMS / Framework (Wappalyzer) for $TARGET" "${CYAN}"
    loading
    result=$(run_python src/python/tech_detect.py "https://$TARGET")
    echo "$result" >"$RAW_DIR_TECH/cms_framework.txt"

    if grep -q "404 Not Found" "$RAW_DIR_TECH/cms_framework.txt"; then
        echo -e "${RED}[!] CMS / Framework not detected (404 Not Found)${NC}"
    else
        echo -e "${GREEN}[+] CMS / Framework info saved to $RAW_DIR_TECH/cms_framework.txt${NC}"
    fi
}

# Programming Languages Detection
detect_languages() {
    print_box "Detecting Programming Languages for $TARGET" "${CYAN}"
    loading
    curl -s -I "http://$TARGET" | grep -i "X-Powered-By:" >"$RAW_DIR_TECH/languages.txt"
    curl -s -I "https://$TARGET" | grep -i "X-Powered-By:" >>"$RAW_DIR_TECH/languages.txt"

    if [ ! -s "$RAW_DIR_TECH/languages.txt" ]; then
        echo "404 Not Found" >"$RAW_DIR_TECH/languages.txt"
        echo -e "${RED}[!] Programming languages not detected (404 Not Found)${NC}"
    else
        echo -e "${GREEN}[+] Programming languages info saved to $RAW_DIR_TECH/languages.txt${NC}"
    fi
}

# Database Indicators
detect_database() {
    print_box "Checking Database Indicators for $TARGET" "${CYAN}"
    loading
    curl -s "http://$TARGET" | grep -iE "MySQL|PostgreSQL|MongoDB|SQLite" >"$RAW_DIR_TECH/database.txt"
    curl -s "https://$TARGET" | grep -iE "MySQL|PostgreSQL|MongoDB|SQLite" >>"$RAW_DIR_TECH/database.txt"

    if [ ! -s "$RAW_DIR_TECH/database.txt" ]; then
        echo "404 Not Found" >"$RAW_DIR_TECH/database.txt"
        echo -e "${RED}[!] Database indicators not detected (404 Not Found)${NC}"
    else
        echo -e "${GREEN}[+] Database indicators saved to $RAW_DIR_TECH/database.txt${NC}"
    fi
}

# Libraries / Plugins Detection (Python Wappalyzer)
detect_libraries_plugins() {
    print_box "Detecting Libraries & Plugins (Wappalyzer) for $TARGET" "${CYAN}"
    loading
    result=$(run_python src/python/tech_detect.py "https://$TARGET")
    echo "$result" >"$RAW_DIR_TECH/libraries_plugins.txt"

    if grep -q "404 Not Found" "$RAW_DIR_TECH/libraries_plugins.txt"; then
        echo -e "${RED}[!] Libraries / Plugins not detected (404 Not Found)${NC}"
    else
        echo -e "${GREEN}[+] Libraries / Plugins info saved to $RAW_DIR_TECH/libraries_plugins.txt${NC}"
    fi
}

run_phase2() {
    while true; do
        echo ""
        print_box "Stage 2 : Web Application Technology Info" "${GREEN}"
        echo -e "${CYAN}Target:${NC} $TARGET"
        echo ""
        echo -e "${YELLOW}1)${NC} Web Server"
        echo -e "${YELLOW}2)${NC} CMS / Framework (Wappalyzer)"
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
