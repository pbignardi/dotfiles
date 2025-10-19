#!/usr/bin/env bash

# Install packages using zypper
# Paolo Bignardi - 2025

###################
## Core packages ##
###################
packages=(
    "make"
    "tar"
    "cargo"
    "fastfetch"
    "git"
    "stow"
    "jq"
    "unzip"
    "zsh"
    "gcc"
    "go"
    "nodejs-default"
    "npm-default"
    "curl"
    "wget"
    "openssh"
    "flatpak"
    "socat"
    "fzf"
    "tmux"
    "fd"
    "ripgrep"
    "bat"
    "btop"
    "eza"
    "lsd"
    "zoxide"
    "neovim"
)
uninstalled=()

for pkg in "${packages[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        uninstalled+=("$pkg")
    fi
done

if ! [ ${#uninstalled[@]} -eq 0 ]; then
    echo "==> Installing core packages"
    echo "${uninstalled[@]}"

    sudo zypper in -y "${uninstalled[@]}"
fi


# install vivid by building with cargo
if ! command -v vivid &>/dev/null; then
    cargo install vivid
fi


if isWsl; then
    return
fi

####################
## Extra packages ##
####################

packages=(
    "distrobox"
    "podman"
    "wezterm"
)
uninstalled=()


for pkg in "${packages[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        uninstalled+=("$pkg")
    fi
done

echo "i'm where you want"
echo "${uninstalled[@]}"
echo "${#uninstalled[@]}"

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

echo "==> Installing extra packages"
echo "${uninstalled[@]}"

sudo zypper in -y "${uninstalled[@]}"
