import sys
import os
import csv

target = sys.argv[1]
raw_dir = f"results/raw/{target}"
parsed_dir = "results/parsed"

os.makedirs(parsed_dir, exist_ok=True)

output_file = os.path.join(parsed_dir, f"{target}_footprinting.csv")

def read_file(filename):
    path = os.path.join(raw_dir, filename)
    if os.path.exists(path):
        with open(path, "r") as f:
            return f.read().strip()
    return "No data found"

# Collect data
whois_data = read_file("whois.txt")
dns_data = read_file("dns.txt")
subdomains_data = read_file("subdomains.txt")
hosting_data = read_file("hosting.json")
ssl_cert_data = read_file("ssl_cert.txt")

# Write to CSV
with open(output_file, mode="w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["Category", "Detail", "Collected Data"])
    writer.writerow(["WHOIS", "WHOIS Information", whois_data])
    writer.writerow(["DNS", "DNS Records", dns_data])
    writer.writerow(["Subdomains", "Detected Subdomains", subdomains_data])
    writer.writerow(["Hosting", "Server Hosting Info", hosting_data])
    writer.writerow(["SSL/TLS", "SSL Certificate Details", ssl_cert_data])

print(f"[+] Footprinting report generated: {output_file}")
