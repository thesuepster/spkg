#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root: sudo ./install.sh"
    exit 1
fi

INSTALL_DIR="/usr/local/bin"
SPKG_URL="https://raw.githubusercontent.com/thesuepster/SuepsPackager/main/spkg"
HASH_URL="https://raw.githubusercontent.com/thesuepster/SuepsPackager/main/spkg.sha256"

TMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo "Downloading spkg..."

curl -fsSL "$SPKG_URL" -o "$TMP_DIR/spkg"
curl -fsSL "$HASH_URL" -o "$TMP_DIR/spkg.sha256"


echo "Verifying checksum..."

cd "$TMP_DIR"

if ! sha256sum -c spkg.sha256; then
    echo "ERROR: SHA256 verification failed!"
    echo "The downloaded file may be corrupted or tampered with."
    exit 1
fi


echo "Checksum verified."

echo "Installing spkg..."

install -m 755 spkg "$INSTALL_DIR/spkg"


echo "Done!"
echo "Done! Run 'spkg doctor' to verify your setup works."
echo "Try: spkg search <app>"
