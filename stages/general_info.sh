#!/bin/bash

TARGET=$1

# Remove protocol (http:// or https://) if user provides full URL
TARGET=$(echo $TARGET | sed -e 's~^[^/]*//~~' -e 's~/.*$~~')

RAW_DIR="results/raw/$TARGET" # <-- Special folder for each target

# WHOIS
whois_info() {
    echo "[*] Collecting WHOIS information for $TARGET ..."
    whois $TARGET >"$RAW_DIR/whois.txt"
    echo "[+] WHOIS data saved to $RAW_DIR/whois.txt"
}

# DNS
dns_records() {
    echo "[*] Collecting DNS records for $TARGET ..."
    dig $TARGET any +short >"$RAW_DIR/dns.txt"
    echo "[+] DNS records saved to $RAW_DIR/dns.txt"
}

# Subdomains
subdomain_enum() {
    echo "[*] Enumerating subdomains for $TARGET ..."
    subfinder -d $TARGET >"$RAW_DIR/subdomains.txt"
    echo "[+] Subdomains saved to $RAW_DIR/subdomains.txt"
}

# Hosting Info
server_hosting() {
    echo "[*] Checking hosting/server info for $TARGET ..."
    ip=$(dig +short $TARGET | head -n 1)
    if [ -z "$ip" ]; then
        echo "[-] Could not resolve IP for $TARGET"
        return
    fi
    echo "Resolved IP: $ip"
    curl -s "https://ipinfo.io/$ip" >"$RAW_DIR/hosting.json"
    echo "[+] Hosting info saved to $RAW_DIR/hosting.json"
}

# SSL Certificate
ssl_certificate() {
    echo "[*] Retrieving SSL certificate information for $TARGET ..."
    echo | openssl s_client -connect ${TARGET}:443 -servername ${TARGET} 2>/dev/null |
        openssl x509 -noout -text >"$RAW_DIR/ssl_cert.txt"
    echo "[+] SSL certificate details saved to $RAW_DIR/ssl_cert.txt"
}

# Menu Stage 1
run_stage1_menu() {
    mkdir -p "$RAW_DIR"

    while true; do
        echo ""
        echo "=== Stage 1: General Domain & Website Information ==="
        echo "Target: $TARGET"
        echo "1) WHOIS Information"
        echo "2) DNS Records"
        echo "3) Subdomain Enumeration"
        echo "4) Server Hosting Info (Geo-IP)"
        echo "5) SSL/TLS Certificate Info"
        echo "6) Run ALL"
        echo "0) Back to Main Menu"
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
        *) echo "Invalid option." ;;
        esac
    done
}
