#!/usr/bin/env bash

# Install uv using install script
# see reference here: https://docs.astral.sh/uv/#installation

if ! command -v uv >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}uv${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
