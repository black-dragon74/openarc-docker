#!/bin/bash

set -e

# Required variables, read from ENV or use defaults
KEYFILE=${KEYFILE:-"DKIM.key"}
DOMAIN=${DOMAIN:-""}
SELECTOR=${SELECTOR:-"dkim"}
SIG_ALG=${SIG_ALG:-"rsa-sha256"}

# Ensure that DOMAIN defined, else exit
if [ -z $DOMAIN ]; then
    echo "ERR: Required ENV item 'DOMAIN' is undefined"
    exit 1
fi

# This script serves 3 purposes
#   - Create /etc/openarc
#   - Copy keyfile from mountpoint to /etc/openarc/DKIM.key
#   - Update /etc/openarc.conf acc to vars
#   - Set proper permissions
#   - Launch openarc and keep-alive the container

# Create openarc directory
mkdir -p /etc/openarc

# Copy keyfile
cp /app/${KEYFILE} /etc/openarc/DKIM.key

# Update default config at /etc/openarc.conf
sed -i \
    -e "s|[ ]*Socket.*|Socket  inet:8894|" \
    -e "s|#[ ]*Mode.*|Mode  sv|" \
    -e "s|#[ ]*Domain.*|Domain ${DOMAIN}|" \
    -e "s|#[ ]*Selector.*|Selector ${SELECTOR}|" \
    -e "s|#[ ]*SignatureAlgorithm.*|SignatureAlgorithm ${SIG_ALG}|" \
    -e "s|#[ ]*KeyFile.*|KeyFile /etc/openarc/DKIM.key|" \
    /etc/openarc.conf

# Set proper permissions, in accordance with openarc
chown -R openarc:openarc /etc/openarc/
chmod 600 /etc/openarc/DKIM.key

# Unset the flag as setup is done
set +e

# Off we go then, eh?
echo "openarc is starting..."
openarc -c /etc/openarc.conf; sleep infinity
