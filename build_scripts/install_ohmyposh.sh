#!/usr/bin/env bash
# Install oh-my-posh
# Paolo Bignardi - 2025

source utils.sh

if ! command -v oh-my-posh >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}oh-my-posh${NC}"
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi
