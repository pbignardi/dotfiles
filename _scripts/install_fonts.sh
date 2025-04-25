#!/bin/bash

# Install fonts manually (no NerdFont -- base font only).
# Paolo Bignardi - 2025

source utils.sh

# determine system
OS=$(identify_system)
if [[ -z ${OS:-} ]]; then
    _error "Unsupported system"
    exit 1
fi

# Install Hack font
if ! $(fc-list | grep "Hack" >/dev/null 2>&1); then
    case "$OS" in
        arch) sudo pacman --noconfirm -Syu ttf-hack ;;
        opensuse*) sudo zypper in -y hack-fonts ;;
        debian) sudo apt-get -y install fonts-hack-ttf ;;
        fedora) sudo dnf install -y source-foundry-hack-fonts ;;
        mac) sudo brew install font-hack ;;
    esac
fi

# return to dotfiles
cd $DOTFILES
