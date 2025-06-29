#!/usr/bin/env bash

# Install packages using pacman package manager
# Paolo Bignardi - 2025

source utils.sh

_log "Refresh repositories"
sudo pacman -Syu --noconfirm

# Core packages
_log "Installing core packages"
sudo pacman -Syu --noconfirm --needed - <<EndOfFile
git
stow
jq
unzip
zsh
gcc
go
gum
npm
deno
curl
wget
base-devel
base
openssh
bitwarden-cli

neovim
fzf
tmux
fd
ripgrep
bat
btop
zathura
zathura-pdf-poppler
reflector
EndOfFile

if ! systemctl is-active --quiet reflector; then
    _log "Use REFLECTOR to select best mirrors"
    echo "--country France,Germany,Italy" | sudo tee -a /etc/xdg/reflector/reflector.conf
    sudo systemctl enable --now reflector
fi

# Install paru
if ! command -v paru %2 >/dev/null; then
    _log "Install Paru"
    old_wd=$(pwd)
    cd $LOCALSRC
    git clone https://aur.archlinux.org/paru-bin.git paru-bin
    cd paru-bin
    makepkg -si
    cd $old_wd
fi

# Only non-WSL packages
is_wsl && return

_log "Installing extra packages"
sudo pacman -Syu --noconfirm --needed - <<EndOfFile
wezterm
ttf-nerd-fonts-symbols-mono
distrobox
podman
EndOfFile
