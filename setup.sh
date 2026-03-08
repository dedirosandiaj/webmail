#!/bin/bash

# Mailserver Setup Script for Coolify
# ====================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Mailserver Setup for Coolify ===${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo -e "${YELLOW}Warning: Some operations may require root privileges${NC}"
fi

# Get domain from .env
if [ -f .env ]; then
    source .env
else
    echo -e "${RED}Error: .env file not found${NC}"
    exit 1
fi

# Update domain
read -p "Enter your domain (default: $DOMAINNAME): " NEW_DOMAIN
if [ ! -z "$NEW_DOMAIN" ]; then
    sed -i.bak "s/DOMAINNAME=.*/DOMAINNAME=$NEW_DOMAIN/" .env
    DOMAINNAME=$NEW_DOMAIN
fi

# Update postmaster
read -p "Enter postmaster email (default: $POSTMASTER): " NEW_POSTMASTER
if [ ! -z "$NEW_POSTMASTER" ]; then
    sed -i.bak "s/POSTMASTER=.*/POSTMASTER=$NEW_POSTMASTER/" .env
    POSTMASTER=$NEW_POSTMASTER
fi

echo ""
echo -e "${GREEN}Domain: $DOMAINNAME${NC}"
echo -e "${GREEN}Postmaster: $POSTMASTER${NC}"
echo ""

# Check SSL certificates
if [ ! -f "data/ssl/cert.pem" ] || [ ! -f "data/ssl/key.pem" ]; then
    echo -e "${YELLOW}SSL certificates not found in data/ssl/${NC}"
    echo "Options:"
    echo "1. Place your existing certificates as cert.pem and key.pem in data/ssl/"
    echo "2. Generate self-signed certificates (for testing only)"
    read -p "Generate self-signed certificates? (y/n): " GEN_SSL
    
    if [ "$GEN_SSL" = "y" ] || [ "$GEN_SSL" = "Y" ]; then
        echo "Generating self-signed certificates..."
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout data/ssl/key.pem \
            -out data/ssl/cert.pem \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=mail.$DOMAINNAME"
        echo -e "${GREEN}Self-signed certificates generated${NC}"
        echo -e "${YELLOW}WARNING: Use real SSL certificates for production!${NC}"
    else
        echo -e "${RED}Please place SSL certificates in data/ssl/ before continuing${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}SSL certificates found${NC}"
fi

echo ""
echo -e "${GREEN}Starting mailserver...${NC}"
docker-compose up -d

echo ""
echo "Waiting for mailserver to start..."
sleep 10

echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Next steps:"
echo "1. Add email accounts: docker exec -it mailserver setup email add user@$DOMAINNAME"
echo "2. Configure DNS records (see DNS_SETUP.md)"
echo "3. Test email sending/receiving"
echo ""
echo "Useful commands:"
echo "  - View logs: docker logs -f mailserver"
echo "  - Add account: docker exec -it mailserver setup email add <email>"
echo "  - List accounts: docker exec -it mailserver setup email list"
echo "  - Generate DKIM: docker exec -it mailserver setup config dkim"
echo ""
