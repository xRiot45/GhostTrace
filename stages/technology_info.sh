#!/bin/bash

TARGET=$TARGET
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~') # Remove protocol

RAW_DIR_TECH="results/raw/$TARGET/technology_info"
mkdir -p "$RAW_DIR_TECH"

# Jalankan fingerprinting menggunakan Wappalyzer + curl
detect_technologies() {
    local url_http="http://$TARGET"
    local url_https="https://$TARGET"

    print_box "Running Wappalyzer Fingerprint on $TARGET" "${CYAN}"
    loading

    # Jalankan wappalyzer (HTTP + HTTPS) dan simpan JSON hasilnya
    wappalyzer "$url_http" --pretty >"$RAW_DIR_TECH/wappalyzer_http.json" 2>/dev/null
    wappalyzer "$url_https" --pretty >"$RAW_DIR_TECH/wappalyzer_https.json" 2>/dev/null

    # Ambil headers juga untuk info tambahan
    curl -s -I "$url_http" >"$RAW_DIR_TECH/http_headers.txt"
    curl -s -I "$url_https" >"$RAW_DIR_TECH/https_headers.txt"
}

# Extract info dari wappalyzer JSON
parse_web_server() {
    print_box "Detecting Web Server for $TARGET" "${CYAN}"
    loading
    grep -i "Server:" "$RAW_DIR_TECH/http_headers.txt" >"$RAW_DIR_TECH/web_server.txt"
    grep -i "Server:" "$RAW_DIR_TECH/https_headers.txt" >>"$RAW_DIR_TECH/web_server.txt"
    echo -e "${GREEN}[+] Web server info saved to $RAW_DIR_TECH/web_server.txt${NC}"
}

parse_cms_framework() {
    print_box "Detecting CMS / Framework via Wappalyzer" "${CYAN}"
    loading
    jq '.technologies[] | select(.categories[]?.name == "CMS" or .categories[]?.name == "Frameworks") | .name' \
        "$RAW_DIR_TECH/wappalyzer_http.json" "$RAW_DIR_TECH/wappalyzer_https.json" \
        >"$RAW_DIR_TECH/cms_framework.txt"
    echo -e "${GREEN}[+] CMS / Framework info saved to $RAW_DIR_TECH/cms_framework.txt${NC}"
}

parse_languages() {
    print_box "Detecting Programming Languages via Wappalyzer" "${CYAN}"
    loading
    grep -i "X-Powered-By:" "$RAW_DIR_TECH/http_headers.txt" >"$RAW_DIR_TECH/languages.txt"
    grep -i "X-Powered-By:" "$RAW_DIR_TECH/https_headers.txt" >>"$RAW_DIR_TECH/languages.txt"
    jq '.technologies[] | select(.categories[]?.name == "Programming languages") | .name' \
        "$RAW_DIR_TECH/wappalyzer_http.json" "$RAW_DIR_TECH/wappalyzer_https.json" \
        >>"$RAW_DIR_TECH/languages.txt"
    echo -e "${GREEN}[+] Programming languages info saved to $RAW_DIR_TECH/languages.txt${NC}"
}

parse_database() {
    print_box "Checking Database Indicators via Wappalyzer" "${CYAN}"
    loading
    jq '.technologies[] | select(.categories[]?.name == "Databases") | .name' \
        "$RAW_DIR_TECH/wappalyzer_http.json" "$RAW_DIR_TECH/wappalyzer_https.json" \
        >"$RAW_DIR_TECH/database.txt"
    echo -e "${GREEN}[+] Database indicators saved to $RAW_DIR_TECH/database.txt${NC}"
}

parse_libraries_plugins() {
    print_box "Detecting Libraries & Plugins via Wappalyzer" "${CYAN}"
    loading
    jq '.technologies[] | select(.categories[]?.name == "JavaScript frameworks" or .categories[]?.name == "UI frameworks") | .name' \
        "$RAW_DIR_TECH/wappalyzer_http.json" "$RAW_DIR_TECH/wappalyzer_https.json" \
        >"$RAW_DIR_TECH/libraries_plugins.txt"
    echo -e "${GREEN}[+] Libraries / Plugins info saved to $RAW_DIR_TECH/libraries_plugins.txt${NC}"
}

# Menu Stage 2
run_phase2() {
    detect_technologies

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
        1) parse_web_server ;;
        2) parse_cms_framework ;;
        3) parse_languages ;;
        4) parse_database ;;
        5) parse_libraries_plugins ;;
        6)
            parse_web_server
            parse_cms_framework
            parse_languages
            parse_database
            parse_libraries_plugins
            ;;
        0) break ;;
        *) echo -e "${RED}Invalid option.${NC}" ;;
        esac
    done
}
