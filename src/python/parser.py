import sys
import os
import csv

if len(sys.argv) < 3:
    sys.exit(1)

target = sys.argv[1]
stage = sys.argv[2].lower()

raw_dir_general = f"data/raw/{target}/general_info"
raw_dir_tech = f"data/raw/{target}/technology_info"
parsed_dir = "data/parsed"
os.makedirs(parsed_dir, exist_ok=True)

def read_file(path, filename):
    file_path = os.path.join(path, filename)
    if os.path.exists(file_path):
        with open(file_path, "r", encoding="utf-8") as f:
            return f.read().strip()
    return "No data found"

# Stage 1: General Info
if stage == "general":
    output_file = os.path.join(parsed_dir, f"{target}_general_info.csv")

    data = {
        "WHOIS": read_file(raw_dir_general, "whois.txt"),
        "DNS": read_file(raw_dir_general, "dns.txt"),
        "Subdomains": read_file(raw_dir_general, "subdomains.txt"),
        "Hosting": read_file(raw_dir_general, "hosting.json"),
        "SSL/TLS": read_file(raw_dir_general, "ssl_cert.txt"),
    }

    with open(output_file, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["Category", "Detail", "Collected Data"])
        for k, v in data.items():
            writer.writerow([k, k + " Information", v])

    print(f"[+] General Info report generated: {output_file}")

# Stage 2: Tech Info
elif stage == "tech":
    output_file = os.path.join(parsed_dir, f"{target}_tech_info.csv")

    data = {
        "Web Server": read_file(raw_dir_tech, "web_server.txt"),
        "CMS/Framework": read_file(raw_dir_tech, "cms_framework.txt"),
        "Programming Languages": read_file(raw_dir_tech, "languages.txt"),
        "Database": read_file(raw_dir_tech, "database.txt"),
        "Libraries/Plugins": read_file(raw_dir_tech, "libraries_plugins.txt"),
    }

    with open(output_file, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["Category", "Detail", "Collected Data"])
        for k, v in data.items():
            writer.writerow([k, k + " Information", v])

    print(f"[+] Tech Info report generated: {output_file}")

else:
    print("Invalid stage. Use 'general' or 'tech'.")
