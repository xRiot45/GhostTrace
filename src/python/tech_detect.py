#!/usr/bin/env python3
import sys
from playwright.sync_api import sync_playwright
from Wappalyzer import Wappalyzer, WebPage

def detect_technologies(url):
    try:
        if not url.startswith(("http://", "https://")):
            url = "https://" + url

        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()

            page.set_extra_http_headers({
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36",
                "Accept-Language": "en-US,en;q=0.9",
            })

            page.goto(url, wait_until="networkidle", timeout=20000)
            content = page.content()
            browser.close()

        webpage = WebPage.new_from_html(content, url)
        wappalyzer = Wappalyzer.latest()
        technologies = wappalyzer.analyze(webpage)

        if technologies:
            for tech in sorted(technologies):
                print(f"- {tech}")
        else:
            print("404 Not Found")

    except Exception:
        print("404 Not Found")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: tech_detect.py <target_url>")
        sys.exit(1)

    target_url = sys.argv[1]
    detect_technologies(target_url)
