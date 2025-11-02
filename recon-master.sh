#!/bin/bash
# recon-master v1.0 - Automated Reconnaissance Tool
# Author: YourName | White Hat Hacker

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOMAIN=$1
OUTPUT_DIR="output"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}[!] Usage: $0 <domain.com>${NC}"
    exit 1
fi

mkdir -p $OUTPUT_DIR

echo -e "${YELLOW}[*] Starting recon on $DOMAIN at $TIMESTAMP${NC}"

# 1. Subdomain Enumeration
echo -e "${GREEN}[+] Enumerating subdomains...${NC}"
subfinder -d $DOMAIN -o $OUTPUT_DIR/subdomains_$TIMESTAMP.txt -silent

# 2. Check Live Hosts
echo -e "${GREEN}[+] Probing live hosts...${NC}"
httpx -l $OUTPUT_DIR/subdomains_$TIMESTAMP.txt -silent -o $OUTPUT_DIR/live_$TIMESTAMP.txt

# 3. Vulnerability Scanning
echo -e "${GREEN}[+] Scanning for vulnerabilities...${NC}"
nuclei -l $OUTPUT_DIR/live_$TIMESTAMP.txt -t cves/ -t vulnerabilities/ -severity critical,high -o $OUTPUT_DIR/vulns_$TIMESTAMP.txt

echo -e "${GREEN}[✔] Recon completed! Results in $OUTPUT_DIR/${NC}"
echo -e "    Subdomains: subdomains_$TIMESTAMP.txt"
echo -e "    Live:       live_$TIMESTAMP.txt"
echo -e "    Vulns:      vulns_$TIMESTAMP.txt"