#!/bin/bash

# Common files.
# Paolo Bignardi - 2025

set -eou pipefail

LOCALBIN=$HOME/.local/bin
LOCALSRC=$HOME/.src
DOTFILES=$HOME/dotfiles
USERNAME=pbignardi
VERSION="1.1.0"

# Log stuff
GREEN="\033[0;32m"
GRAY="\033[0;90m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC="\033[0m"
BOLD="\033[1m"
ITALIC="\033[3m"
NOITALIC="\033[23m"
RESETBOLD="\033[22m"

function _breakline() {
    echo -e ""
}

function _info() {
    local message=$1
    echo -e "${CYAN}[init: info]${NC} ${GRAY}${message}${NC}"
}

function _warn() {
    local message=$1
    echo -e "${YELLOW}[init: warn]${NC} ${message}"
}

function _error() {
    local message=$1
    echo -e "${RED}[init: error]${NC} ${message}"
}

function _log() {
    local message=$1
    echo -e "${GREEN}[init: status]${NC} ${BOLD}${message}${RESETBOLD}"
}

function identify_system() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            # rhel systems
            fedora) echo "fedora" ;;
            # suse systems
            opensuse*) echo "opensuse" ;;
            # debian systems
            debian) echo "debian" ;;
            ubuntu) echo "debian" ;;
            linuxmint) echo "debian" ;;
            pop*) echo "debian" ;;
            # arch systems
            arch*) echo "arch" ;;
            *) echo "" ;;
        esac
    elif [[ $(uname -s) == "Darwin" ]]; then
        echo "mac"
    else
        echo ""
    fi
}
