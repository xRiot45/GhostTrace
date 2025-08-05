#!/usr/bin/env python3
from Wappalyzer import Wappalyzer, WebPage
import requests
import sys

def find_version(versions):
    """Return first version if available, else 'nil'."""
    return versions[0] if versions else 'nil'

def analyze_technologies(url):
    """Analyze web technologies with Wappalyzer and return structured result."""
    if '.' in url and 'http' not in url:
        temp_url = 'http://' + url
        try:
            url = requests.head(temp_url, allow_redirects=True).url
        except:
            print("[!] Error resolving URL, using raw input")
            url = temp_url

    try:
        webpage = WebPage.new_from_url(url)
        wappalyzer = Wappalyzer.latest()
        techs = wappalyzer.analyze_with_versions_and_categories(webpage)
    except Exception as e:
        print(f"[!] Error analyzing technologies: {e}")
        return {}

    return techs

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 tech_detect.py <url> [output_file]")
        sys.exit(1)

    url = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    techs = analyze_technologies(url)

    print(f"\n[+] TECHNOLOGIES DETECTED FOR {url.upper()}:\n")
    for tech_name, details in techs.items():
        category = details['categories'][0] if details['categories'] else "Unknown"
        version = find_version(details['versions'])
        print(f"{category} : {tech_name} [version: {version}]")

    if output_file:
        with open(output_file, 'w') as f:
            f.write(f"[+] TECHNOLOGIES DETECTED FOR {url.upper()}:\n\n")
            for tech_name, details in techs.items():
                category = details['categories'][0] if details['categories'] else "Unknown"
                version = find_version(details['versions'])
                f.write(f"{category} : {tech_name} [version: {version}]\n")

        print(f"\n[+] Results saved to {output_file}")

if __name__ == "__main__":
    main()
