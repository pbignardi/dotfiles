#!/usr/bin/env bash

# Install packages using pacman package manager
# Paolo Bignardi - 2025

###################
## Core packages ##
###################
packages=(
    "fastfetch"
    "git"
    "stow"
    "jq"
    "unzip"
    "zsh"
    "gcc"
    "go"
    "gum"
    "npm"
    "deno"
    "curl"
    "wget"
    "base-devel"
    "base"
    "openssh"
    "flatpak"
    "socat"
    "neovim"
    "fzf"
    "tmux"
    "fd"
    "ripgrep"
    "bat"
    "eza"
    "btop"
    "reflector"
)
uninstalled=()

for pkg in "${packages[@]}"; do
    if ! pacman -Q "$pkg" &> /dev/null; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

if ! systemctl is-active --quiet reflector; then
    echo "==> Selecting best mirrors"
    echo "--country France,Germany,Italy" | sudo tee -a /etc/xdg/reflector/reflector.conf
    sudo systemctl enable --now reflector
fi

echo "==> Installing core packages"
echo "${uninstalled[@]}"

sudo pacman -Syu --noconfirm --needed "${uninstalled[@]}"

# paru
if ! command -v paru &>/dev/null; then
    echo "==> Installing paru"
    old_wd=$(pwd)
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
    cd /tmp/paru-bin
    makepkg -si
    cd -
fi

isWsl && return

####################
## Extra packages ##
####################

packages=(
    "wezterm"
    "noto-fonts-emoji"
    "distrobox"
    "podman"
    "zathura"
    "zathura-pdf-poppler"
)
uninstalled=()

packages+=("flatpak")

for pkg in "${packages[@]}"; do
    if ! pacman -Q "$pkg" &> /dev/null; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

echo "==> Installing extra packages"
echo "${uninstalled[@]}"

sudo pacman -Syu --noconfirm --needed "${uninstalled[@]}"
