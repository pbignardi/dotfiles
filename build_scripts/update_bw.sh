#!/bin/bash

# Install or update Bitwarden CLI
# Paolo Bignardi - 2025

source utils.sh

# Delete Bitwarden if there are updates
if command -v bw >/dev/null 2>&1 && ! $(bw update | grep "No update available" >/dev/null 2>&1); then
    _log "Uninstalling old version of Bitwarden CLI"
    rm $(command -v bw)
fi

# Install Bitwarden CLI
if ! command -v bw >/dev/null 2>&1; then
    _log "Installing Bitwarden CLI"
    cd $LOCALBIN
    if [[ $(identify_system) == "mac" ]]; then
        wget "https://bitwarden.com/download/?app=cli&platform=macos" -O bw.zip
    else
        wget "https://bitwarden.com/download/?app=cli&platform=linux" -O bw.zip
    fi
    unzip bw.zip
    rm bw.zip
    chmod u+x bw
    cd $DOTFILES
fi
