#!/usr/bin/env bash

# Package manifest
# Paolo Bignardi - 2025

# base dependencies required to run the scripts
BASE_PACKAGES=(
    git
    stow
    jq
    unzip
    zsh
    gcc
    go
    gum
    nodejs
)

# required packages on all istances (wsl, linux, mac)
CORE_PACKAGES=(
    neovim
    fzf
    tmux
    fd
    ripgrep
    bat
    btop
)

# linux packages
LINUX_PACKAGES=(
    zathura
    wezterm
    distrobox
    hack-fonts
)

# wsl packages
WSL_PACKAGES=(
    zathura
)

# mac packages
MAC_PACKAGES=(
    wezterm
    skim
    font-hack
)
