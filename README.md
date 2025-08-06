# GhostTrace - Footprinting & Reconnaissance Tool

## Overview

GhostTrace is a **command-line tool** for the **footprinting phase** in penetration testing or security assessments. It automates the collection of general information about target domains and the web technologies in use.

Main modules of GhostTrace include:

* **Stage 1**: General Domain & Website Information (WHOIS, DNS, Subdomains, Hosting, SSL/TLS)
* **Stage 2**: Web Application Technology Information (Server, CMS/Framework, Programming Languages, Databases, Libraries/Plugins)

Scan results are organized into the `data/raw` directory and can be converted to CSV format using `parser.py`.

---

## Features

### Stage 1: General Information

* WHOIS Information
* DNS Records
* Subdomain Enumeration
* Hosting/Geo-IP Information
* SSL/TLS Certificate Details

### Stage 2: Technology Information

* Web Server Detection (HTTP Headers)
* CMS/Framework Detection (Wappalyzer + Playwright)
* Programming Language Detection (X-Powered-By header)
* Database Indicators (MySQL, PostgreSQL, MongoDB, SQLite)
* Libraries/Plugins Detection (Wappalyzer)

### Additional

* CSV Report Generation
* Modular design for future expansion (Stage 3: Vulnerability enumeration)
* Structured scan output (raw & parsed)

---

## Requirements

### Operating System

* Linux (tested on Debian 12)

### System Dependencies

* `whois`
* `dig` (DNS utilities)
* `curl`
* `openssl`
* `subfinder`
* `figlet`
* `python3`, `pip`, `venv`

### Python Dependencies (Stage 2)

Listed in `requirements.txt`:

```
playwright
python-Wappalyzer
requests
beautifulsoup4
```

Install via:

```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip --break-system-packages
pip install -r requirements.txt --break-system-packages

# Install browser dependencies for Playwright
playwright install
```

---

## Installation

```bash
git clone https://github.com/xRiot45/GhostTrace.git
cd GhostTrace
chmod +x src/bash/main.sh
```

---

## Usage

### Run the tool

```bash
sudo ./src/bash/main.sh <domain>
```

Example:

```bash
sudo ./src/bash/main.sh example.com
```

### Project Structure

```
data/
  ├── raw/         # Raw output (WHOIS, DNS, Subdomains, Hosting, SSL, Technology)
  └── parsed/      # Parsed CSV reports
src/
  ├── bash/        # Footprinting stage scripts
  │   ├── general_info.sh       # Stage 1
  │   ├── technology_info.sh    # Stage 2
  │   └── main.sh               # Main menu
  └── python/      # Parser & technology detection
      ├── parser.py
      └── tech_detect.py
venv/
requirements.txt
```

---

## Workflow

### Stage 1: General Domain & Website Information

1. WHOIS Information
2. DNS Records
3. Subdomain Enumeration
4. Hosting/Server Info (Geo-IP)
5. SSL/TLS Certificate Info
6. Run ALL

### Stage 2: Web Application Technology Information

1. **Web Server Detection**

   * Extracts the `Server:` header from HTTP/HTTPS responses.
2. **CMS / Framework Detection (Wappalyzer)**

   * Uses Playwright + python-Wappalyzer for webpage content analysis.
3. **Programming Language Detection**

   * Detects `X-Powered-By:` header (e.g., PHP, ASP.NET).
4. **Database Indicators**

   * Searches for MySQL, PostgreSQL, MongoDB, SQLite strings in page content.
5. **Libraries / Plugins Detection**

   * Identifies libraries and plugins using Wappalyzer.
6. **Run ALL**

---

## Report Generation

Raw scan results are saved in:

```
data/raw/<domain>/technology_info/
```

Then processed by `parser.py` into CSV:

```
data/parsed/<domain>_footprinting.csv
```

---

## Output Example

* **Web Server**: `data/raw/<domain>/technology_info/web_server.txt`
* **CMS / Framework**: `data/raw/<domain>/technology_info/cms_framework.txt`
* **Languages**: `data/raw/<domain>/technology_info/languages.txt`
* **Database Indicators**: `data/raw/<domain>/technology_info/database.txt`
* **Libraries / Plugins**: `data/raw/<domain>/technology_info/libraries_plugins.txt`

---

## Roadmap

* Stage 3: Basic Vulnerability Enumeration (CVE, Known Exploits)
* JSON/HTML report generation
* External API integration (Shodan, Censys, BuiltWith)

---

## Author

**xRiot45**

---

## License

MIT License
