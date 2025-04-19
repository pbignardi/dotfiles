#!/usr/bin/env bash

# Package manifest
# Paolo Bignardi - 2025

# base dependencies required to run the scripts
BASE_PACKAGES=(
    git
    stow
    jq
    gpg
    wget
    unzip
    zsh
    gcc
)

# required packages on all istances, even wsl
CORE_PACKAGES=(
    nvim
    fzf
    tmux
    gum
    fd
    ripgrep
    bat
    btop
)

# extra packages required only on linux desktops
LINUX_EXTRAS=(
    wezterm
    zathura
)

# extra packages required only on wsl systems
WSL_EXTRAS=(
    zathura
)

# extra packages required only on mac
MAC_EXTRAS=(
    wezterm
    skim
)
