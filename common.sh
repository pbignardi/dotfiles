#!/usr/bin/env bash

# Common functions
# Paolo Bignardi - 2025

LOCALBIN=$HOME/.local/bin
LOCALSRC=$HOME/.src
DOTFILES=$HOME/dotfiles

# Log stuff
GREEN="\033[0;32m"
GRAY="\033[0;90m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC="\033[0m"
BOLD="\033[1m"
RESETBOLD="\033[22m"

function _breakline () {
    echo -e ""
}

function _info () {
    local message=$1
    echo -e "${CYAN}[init: info]${NC} ${GRAY}${message}${NC}"
}

function _warn () {
    local message=$1
    echo -e "${YELLOW}[init: warn]${NC} ${message}"
}

function _error () {
    local message=$1
    echo -e "${RED}[init: error]${NC} ${message}"
}

function _log () {
    local message=$1
    echo -e "${GREEN}[init: status]${NC} ${BOLD}${message}${RESETBOLD}"
}
