#!/bin/bash

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
    echo -e "${CYAN}>>>${NC} ${GRAY}${message}${NC}"
}

function _warn() {
    local message=$1
    echo -e "${YELLOW}[warn]${NC} ${message}"
}

function _error() {
    local message=$1
    echo -e "${RED}[error]${NC} ${message}"
}

function _log() {
    local message=$1
    echo -e "${GREEN}[log]${NC} ${BOLD}${message}${RESETBOLD}"
}

function identify_system() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
        fedora)
            echo "fedora"
            ;;
        opensuse*)
            echo "opensuse"
            ;;
        arch*)
            echo "arch"
            ;;
        *)
            echo ""
            ;;
        esac
    elif [[ $(uname -s) == "Darwin" ]]; then
        echo "mac"
    else
        echo ""
    fi
}

function is_installed() {
    local package=$1
    case "$(identify_system)" in
    arch)
        pacman -Qg "$1" &>/dev/null
        ;;
    fedora)
        dnf list --installed "$1" &>/dev/null
        ;;
    opensuse)
        zypper se -i "$1" &>/dev/null
        ;;
    esac
}

function install_packages() {
    local target=("$@")
    local to_install=()

    for pkg in "${target[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=($pkg)
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        _info "Installing ${to_install[*]}"

        case "$(identify_system)" in
        arch)
            sudo pacman -S --noconfirm ${to_install[@]}
            ;;
        opensuse)
            sudo zypper in -y ${to_install[@]}
            ;;
        fedora)
            sudo dnf install -y ${to_install[@]}
            ;;
        esac
    else
        _info "Packages already installed: ${target[*]}"
    fi
}

function update_packages() {
    if [[ "$(uname)" == "Linux" ]]; then
        _log "Updating system packages"
        case "$(identify_system)" in
        arch)
            sudo pacman -Syu --noconfirm
            ;;
        opensuse)
            sudo zypper dup -y
            ;;
        fedora)
            sudo dnf upgrade -y
            ;;
        esac
    fi
}
