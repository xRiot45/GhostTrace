#!/bin/bash

TARGET=$TARGET
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~') # Remove protocol

RAW_DIR_GENERAL="data/raw/$TARGET/general_info"

# WHOIS
whois_info() {
    print_box "Collecting WHOIS information for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_GENERAL"
    whois $TARGET >"$RAW_DIR_GENERAL/whois.txt"
    echo -e "${GREEN}[+] WHOIS data saved to $RAW_DIR_GENERAL/whois.txt${NC}"
}

# DNS Records
dns_records() {
    print_box "Collecting DNS records for $TARGET" "${CYAN}"
    loading

    mkdir -p "$RAW_DIR_GENERAL"
    records="A AAAA MX TXT NS CNAME"
    >"$RAW_DIR_GENERAL/dns.txt"

    for record in $records; do
        echo "=== $record Records ===" >>"$RAW_DIR_GENERAL/dns.txt"
        result=$(dig $TARGET $record +short @8.8.8.8)

        if [ -z "$result" ]; then
            echo "No $record record found or query failed" >>"$RAW_DIR_GENERAL/dns.txt"
        else
            echo "$result" >>"$RAW_DIR_GENERAL/dns.txt"
        fi

        echo "" >>"$RAW_DIR_GENERAL/dns.txt"
    done

    echo -e "${GREEN}[+] DNS records saved to $RAW_DIR_GENERAL/dns.txt${NC}"
}

# Subdomain Enumeration
subdomain_enum() {
    print_box "Enumerating subdomains for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_GENERAL"
    subfinder -d $TARGET 2>/dev/null >"$RAW_DIR_GENERAL/subdomains.txt"
    echo -e "${GREEN}[+] Subdomains saved to $RAW_DIR_GENERAL/subdomains.txt${NC}"
}

# Hosting Info
server_hosting() {
    print_box "Checking hosting/server info for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_GENERAL"
    ip=$(dig +short $TARGET | head -n 1)
    if [ -z "$ip" ]; then
        echo -e "${RED}[-] Could not resolve IP for $TARGET${NC}"
        return
    fi
    curl -s "https://ipinfo.io/$ip" >"$RAW_DIR_GENERAL/hosting.json"
    echo -e "${GREEN}[+] Hosting info saved to $RAW_DIR_GENERAL/hosting.json${NC}"
}

# SSL Certificate
ssl_certificate() {
    print_box "Retrieving SSL certificate information for $TARGET" "${CYAN}"
    loading
    mkdir -p "$RAW_DIR_GENERAL"
    echo | openssl s_client -connect ${TARGET}:443 -servername ${TARGET} 2>/dev/null |
        openssl x509 -noout -text >"$RAW_DIR_GENERAL/ssl_cert.txt"
    echo -e "${GREEN}[+] SSL certificate details saved to $RAW_DIR_GENERAL/ssl_cert.txt${NC}"
}

# Menu Stage 1
run_phase1() {
    mkdir -p "$RAW_DIR_GENERAL"

    while true; do
        echo ""
        print_box "Stage 1 : General Domain & Website Information" "${GREEN}"
        echo -e "${CYAN}Target:${NC} $TARGET"
        echo ""
        echo -e "${YELLOW}1)${NC} WHOIS Information"
        echo -e "${YELLOW}2)${NC} DNS Records"
        echo -e "${YELLOW}3)${NC} Subdomain Enumeration"
        echo -e "${YELLOW}4)${NC} Server Hosting Info (Geo-IP)"
        echo -e "${YELLOW}5)${NC} SSL/TLS Certificate Info"
        echo -e "${YELLOW}6)${NC} Run ALL"
        echo -e "${YELLOW}0)${NC} Back to Main Menu"
        echo ""
        read -p "Enter your choice: " choice

        case $choice in
        1) whois_info ;;
        2) dns_records ;;
        3) subdomain_enum ;;
        4) server_hosting ;;
        5) ssl_certificate ;;
        6)
            whois_info
            dns_records
            subdomain_enum
            server_hosting
            ssl_certificate
            ;;
        0) break ;;
        *) echo -e "${RED}Invalid option.${NC}" ;;
        esac
    done
}
