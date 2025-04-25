#!/usr/bin/env bash

# Install packages using zypper package manager
# Paolo Bignardi - 2025

source utils.sh

_log "Refresh repositories"
sudo zypper ref

# Core packages
_log "Installing core packages"
sudo zypper in -y $(cat << EndOfFile
git
stow
jq
unzip
zsh
gcc
go
gum
nodejs-default

neovim
fzf
tmux
fd
ripgrep
bat
btop
zathura
zathura-plugin-pdf-poppler
EndOfFile
)

# Only non-WSL packages
is_wsl && return

_log "Installing extra packages"
sudo zypper in -y $(cat << EndOfFile
wezterm
distrobox
podman
hack-fonts
EndOfFile
)
