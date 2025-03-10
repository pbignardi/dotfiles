#!/bin/bash
# dotsetup - Some utility functions
# Paolo Bignardi - 2025

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'

LOCALBIN=$HOME/.local/bin
LOCALSRC=$HOME/.src

print_log () {
    level=$1
    message=$2
    d=$(date +%H:%M:%S)

    if [[ $level -eq 1 ]]; then
        indicator="${BLUE}==>${NC} "
    elif [[ $level -eq 2 ]]; then
        indicator="${GREEN}[info]${NC} "
    elif [[ $level -eq 3 ]]; then
        indicator="${ORANGE}[warn]${NC} "
    elif [[ $level -eq 4 ]]; then
        indicator="${RED}[error]${NC} "
    fi
    printf "$indicator$message\n"
}

install_linux_package () {
    print_log 1 "Installing: $1"

    # install on apt system
    if [[ $(type apt >/dev/null 2>&1) ]]; then
        sudo apt install $(echo $1)
        return
    fi

    # install on dnf system
    if [[ $(type dnf >/dev/null 2>&1) ]]; then
        sudo dnf install $(echo $1)
        return
    fi

    # install on arch-based system
    if [[ $(type pacman >/dev/null 2>&1) ]]; then
        sudo pacman -S $(echo $1)
        return
    fi
}

install_package () {
    if [[ $(uname -s) == "Darwin" ]]; then
        brew install $(echo $1)
    else
        install_linux_package $1
    fi

}

is_installed_apt () {
    pkg_list=$(dpkg --get-selections)
    if [[ $pkg_list == *"$1"* ]]; then
        return 0
    fi
    return 1
}

is_installed_dnf () {
    pkg_list=$(dnf list installed)
    if [[ $pkg_list == *"$1"* ]]; then
        return 0
    fi
    return 1
}

is_installed_brew () {
    pkg_list=$(brew list -1 --full-name)
    if [[ $pkg_list == *"$1"* ]]; then
        return 0
    fi
    return 1
}

local_bin_path () {
    # create .local/bin if doesn't exist
    if [[ ! -d $LOCALBIN ]]; then
        mkdir $LOCALBIN
    fi

    # temporarily add .local/bin to path
    export PATH=$PATH:$LOCALBIN
}
