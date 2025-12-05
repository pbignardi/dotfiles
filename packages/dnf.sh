#!/usr/bin/env bash

# Install packages using dnf
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
    "golang"
    "gum"
    "nodejs-npm"
    "curl"
    "wget1"
    "openssh"
    "flatpak"
    "socat"
    "neovim"
    "fzf"
    "tmux"
    "fd-find"
    "ripgrep"
    "bat"
    "btop"
    "eza"
    "zathura"
    "zathura-pdf-poppler"
    "google-noto-color-emoji-fonts"
)
uninstalled=()

for pkg in "${packages[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

echo "==> Installing core packages"
echo "${uninstalled[@]}"

sudo dnf install -y "${uninstalled[@]}"

isWsl && return

####################
## Extra packages ##
####################

packages=(
    "distrobox"
    "podman"
)
uninstalled=()

packages+=("flatpak")

for pkg in "${packages[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

echo "==> Installing extra packages"
echo "${uninstalled[@]}"

sudo dnf install -y "${uninstalled[@]}"

# wezterm
if [ ! -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:wezterm-nightly.repo ]; then
    sudo dnf copr enable -y wezfurlong/wezterm-nightly
    sudo dnf install -y wezterm
fi
