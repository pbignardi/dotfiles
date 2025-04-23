#!/usr/bin/env bash
# Utility functions for dotfiles management
# Paolo Bignardi - 2025

set -eou pipefail

local_bin=$HOME/.local/bin
local_src=$HOME/.src
dotfiles=$HOME/dotfiles
VERSION="2.0.0"

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
    echo -e "${CYAN}>>>${NC} ${message}"
}

function _warn() {
    local message=$1
    echo -e "${YELLOW}[bootstrap: warn]${NC} ${message}"
}

function _error() {
    local message=$1
    echo -e "${RED}[bootstrap: error]${NC} ${message}"
}

function _log() {
    local message=$1
    echo -e "${GREEN}[log]${NC} ${BOLD}${message}${RESETBOLD}"
}

function prompt_configuration() {
    echo "#!/usr/bin/env bash"

    read -p '=> Is this your work computer? (y/N) ' yn
    case $yn in
    [Yy]*) echo "work=true" ;;
    *) echo "work=false" ;;
    esac

    read -p '=> Is this a WSL instance? (y/N) ' yn
    case $yn in
    [Yy]*) echo "wsl=true" ;;
    *) echo "wsl=false" ;;
    esac

    read -p '=> Is this your personal laptop? (y/N) ' yn
    case $yn in
    [Yy]*) echo "personal_laptop=true" ;;
    *) echo "personal_laptop=false" ;;
    esac

    read -p '=> Enter email address: ' email
    echo email=\"$email\"

    read -p '=> Enter user name: ' name
    echo name=\"$name\"

    read -p '=> Do you want to install Nerd Fonts? (y/N) ' yn
    case $yn in
    [Yy]*) echo "nerdfonts=true" ;;
    *) echo "nerdfonts=false" ;;
    esac
}

function command_exists() {
    command -v $1 >/dev/null 2>&1
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
        rpm -q "$1" &>/dev/null
        ;;
    opensuse)
        rpm -q "$1" &>/dev/null
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

function platform() {
    [[ $wsl == true ]] && echo "wsl" && return
    [[ "$(uname)" == "Darwin" ]] && echo "mac" && return
    echo "linux"
}

function github_authenticated() {
    # Attempt to ssh to GitHub
    ssh -T git@github.com &>/dev/null
    RET=$?
    if [ $RET == 1 ]; then
        # user is authenticated, but fails to open a shell with GitHub
        return 0
    elif [ $RET == 255 ]; then
        # user is not authenticated
        return 1
    else
        _error "unknown exit code in attempt to ssh into git@github.com"
    fi
    return 2
}
