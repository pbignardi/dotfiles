#!/usr/bin/env bash

# Install oh-my-posh using install script
# See reference here: https://ohmyposh.dev/docs/installation/macos

source utils.sh

test $(identify_system) == "mac" && return

if ! command -v oh-my-posh >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}oh-my-posh${NC}"
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi
