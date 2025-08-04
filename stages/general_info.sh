#!/bin/bash

TARGET=$TARGET

# Remove protocol (http:// or https://) if user provides full URL
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~')

RAW_DIR="results/raw/$TARGET"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

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

# Spinner + progress bar
progress_bar() {
    local duration=$1
    local steps=20
    local step_time=$(echo "$duration / $steps" | bc -l)
    echo -ne "${YELLOW}["
    for ((i = 0; i < steps; i++)); do
        echo -ne "#"
        sleep $step_time
    done
    echo -e "]${NC}"
}

loading() {
    echo -ne "${YELLOW}[*] Processing..."
    for i in {1..3}; do
        echo -ne "."
        sleep 0.4
    done
    echo ""
    progress_bar 2
}

# WHOIS
whois_info() {
    print_box "Collecting WHOIS information for $TARGET" "${CYAN}"
    loading
    whois $TARGET >"$RAW_DIR/whois.txt"
    echo -e "${GREEN}[+] WHOIS data saved to $RAW_DIR/whois.txt${NC}"
}

# DNS
dns_records() {
    print_box "Collecting DNS records for $TARGET" "${CYAN}"
    loading
    dig $TARGET any +short >"$RAW_DIR/dns.txt"
    echo -e "${GREEN}[+] DNS records saved to $RAW_DIR/dns.txt${NC}"
}

# Subdomains
subdomain_enum() {
    print_box "Enumerating subdomains for $TARGET" "${CYAN}"
    loading
    subfinder -d $TARGET >"$RAW_DIR/subdomains.txt"
    echo -e "${GREEN}[+] Subdomains saved to $RAW_DIR/subdomains.txt${NC}"
}

# Hosting Info
server_hosting() {
    print_box "Checking hosting/server info for $TARGET" "${CYAN}"
    loading
    ip=$(dig +short $TARGET | head -n 1)
    if [ -z "$ip" ]; then
        echo -e "${RED}[-] Could not resolve IP for $TARGET${NC}"
        return
    fi
    echo "Resolved IP: $ip"
    curl -s "https://ipinfo.io/$ip" >"$RAW_DIR/hosting.json"
    echo -e "${GREEN}[+] Hosting info saved to $RAW_DIR/hosting.json${NC}"
}

# SSL Certificate
ssl_certificate() {
    print_box "Retrieving SSL certificate information for $TARGET" "${CYAN}"
    loading
    echo | openssl s_client -connect ${TARGET}:443 -servername ${TARGET} 2>/dev/null |
        openssl x509 -noout -text >"$RAW_DIR/ssl_cert.txt"
    echo -e "${GREEN}[+] SSL certificate details saved to $RAW_DIR/ssl_cert.txt${NC}"
}

# Menu Stage 1
run_phase1() {
    mkdir -p "$RAW_DIR"

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
