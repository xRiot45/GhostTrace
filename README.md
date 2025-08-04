# GhostTrace - Footprinting & Reconnaissance Tool

## Overview

GhostTrace is a command-line tool designed for performing the **footprinting phase** of penetration testing or security assessments. It automates the process of collecting general information about a target domain, including WHOIS data, DNS records, subdomain enumeration, hosting details, and SSL/TLS certificate information.

The tool provides:

* Clean and interactive terminal UI with minimal colors and glitch/typing effects.
* Structured output saved into raw text/JSON files.
* CSV report generation for collected data.
* Modular architecture allowing future expansion (e.g., technology detection, vulnerability scanning).

---

## Features

* **WHOIS Information Collection**: Retrieves domain registration data.
* **DNS Records Gathering**: Collects A, AAAA, MX, TXT, NS, and CNAME records.
* **Subdomain Enumeration**: Uses `subfinder` to enumerate subdomains quickly.
* **Hosting/Geo-IP Info**: Fetches server location and ASN data via IP resolution and external APIs.
* **SSL/TLS Certificate Details**: Extracts certificate validity, issuer, subject, and SAN fields.
* **CSV Report Generation**: Consolidates raw data into a readable CSV format.

---

## Requirements

* **Operating System**: Linux (tested on Debian)
* **Dependencies**:

  * `whois`
  * `dig` (DNS utilities)
  * `curl`
  * `openssl`
  * `subfinder` (for subdomain enumeration)
  * `python3` (for CSV parsing)
  * `figlet` (for ASCII banners)

Ensure all dependencies are installed:

```bash
sudo apt install whois dnsutils curl openssl python3 figlet

# Install subfinder separately
sudo apt update
sudo apt install wget unzip -y

wget https://github.com/projectdiscovery/subfinder/releases/download/v2.6.5/subfinder_2.6.5_linux_amd64.zip

unzip subfinder_2.6.5_linux_amd64.zip
sudo mv subfinder /usr/local/bin/
sudo chmod +x /usr/local/bin/subfinder

subfinder -version

```

---

## Installation

Clone the repository and give execution permissions:

```bash
git clone <repository-url>
cd GhostTrace
chmod +x main.sh
```

---

## Usage

Run the main script with a target domain:

```bash
./main.sh <domain>
```

Example:

```bash
./main.sh example.com
```

---

## Directory Structure

```
results/
  ├── raw/          # Raw outputs (WHOIS, DNS, Subdomains, Hosting, SSL)
  └── parsed/       # Parsed CSV reports
stages/
  └── general_info.sh # Stage 1 script for general info collection
main.sh               # Entry point of GhostTrace
parser.py             # Converts raw data into CSV
```

---

## Workflow

### Stage 1: General Domain & Website Information

1. WHOIS Information
2. DNS Records
3. Subdomain Enumeration
4. Hosting/Server Info (Geo-IP)
5. SSL/TLS Certificate Info
6. Run ALL (executes all above modules)

### Report Generation

* Converts raw results into a consolidated CSV file located in `results/parsed/<domain>_footprinting.csv`.

---

## Output Example

**WHOIS Data**: `results/raw/<domain>/whois.txt`
**DNS Records**: `results/raw/<domain>/dns.txt`
**Subdomains**: `results/raw/<domain>/subdomains.txt`
**Hosting Info**: `results/raw/<domain>/hosting.json`
**SSL Certificate**: `results/raw/<domain>/ssl_cert.txt`

---

## Roadmap

* Stage 2: Web Application Technology Information
* Stage 3: Basic Vulnerability Enumeration
* JSON and HTML report formats
* API integrations (Shodan, Censys)

---

## Author

**xRiot45**

---

## License

MIT License
