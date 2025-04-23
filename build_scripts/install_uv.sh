#!/usr/bin/env bash
# Install uv
# Paolo Bignardi - 2025

source utils.sh

if ! command -v uv >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}uv${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
