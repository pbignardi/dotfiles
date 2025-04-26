#!/usr/bin/env bash

# Install packages using pacman package manager
# Paolo Bignardi - 2025

source utils.sh

_log "Refresh repositories"
sudo pacman -Syu --noconfirm

# Core packages
_log "Installing core packages"
sudo pacman -Syu --noconfirm $(cat << EndOfFile
git
stow
jq
unzip
zsh
gcc
go
gum
nodejs

neovim
fzf
tmux
fd
ripgrep
bat
btop
zathura
zathura-pdf-poppler
EndOfFile
)

# Only non-WSL packages
is_wsl && return

_log "Installing extra packages"
sudo pacman -Syu --noconfirm $(cat << EndOfFile
wezterm
ttf-nerd-fonts-symbols-mono
distrobox
podman
ttf-hack
EndOfFile
)
