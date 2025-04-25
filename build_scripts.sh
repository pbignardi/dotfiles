#!/usr/bin/env bash

# Install packages using package manager and script build
# Paolo Bignardi - 2025

source common.sh
source packages.sh

_log "Install base packages"
install_packages ${BASE_PACKAGES[@]}

_log "Install core packages"
install_packages ${CORE_PACKAGES[@]}

_log "Install platform-specific packages"
if [[ $wsl == true ]]; then
    _info "Package set: WSL"
    install_packages ${WSL_PACKAGES[@]}
elif [[ $OS == "mac" ]]; then
    _info "Package set: Mac"
    install_packages ${MAC_PACKAGES[@]}
else
    _info "Package set: Linux desktop"
    install_packages ${LINUX_PACKAGES[@]}
fi

# Install source packages
if ! command -v uv >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}uv${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! command -v oh-my-posh >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}oh-my-posh${NC}"
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi
