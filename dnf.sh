#!/usr/bin/env bash

# Install packages using zypper package manager
# Paolo Bignardi - 2025

source utils.sh

_log "Refresh repositories"
sudo dnf upgrade

# Core packages
_log "Installing core packages"
sudo dnf install -y $(cat << EndOfFile
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
fd-find
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

sudo dnf copr enable wezfurlong/wezterm-nightly
sudo dnf install -y wezterm

sudo dnf install -y $(cat << EndOfFile
distrobox
podman
source-foundry-hack-fonts
EndOfFile
)
