#!/usr/bin/env bash

# Install bitwarden cli
command -v bw &> /dev/null && return

BW_LINUX_ZIP="https://github.com/bitwarden/clients/releases/download/cli-v2025.7.0/bw-linux-2025.7.0.zip"

echo "==> Installing Bitwarden CLI"
if isMac; then
    brew install bitwarden-cli
else
    # linux
    cd /tmp
    curl -LO $BW_LINUX_ZIP
    unzip bw-linux*.zip
    mkdir -p ~/.local/bin
    mv bw ~/.local/bin
    chmod +x ~/.local/bin
    cd -
fi
