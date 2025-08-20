#!/usr/bin/env bash

# Install packages using apt
# Paolo Bignardi - 2025

###################
## Core packages ##
###################
packages=(
    "git"
    "stow"
    "jq"
    "unzip"
    "zsh"
    "gcc"
    "golang"
    "npm"
    "curl"
    "wget"
    "openssh-client"
    "flatpak"
    "socat"
    "fzf"
    "tmux"
    "fd-find"
    "ripgrep"
    "bat"
    "btop"
    "eza"
    "zathura"
    "zathura-pdf-poppler"
)
uninstalled=()


for pkg in "${packages[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

echo "==> Installing core packages"
echo "${uninstalled[@]}"

sudo apt-get install -y "${uninstalled[@]}"

# Install neovim from source
if ! command -v neovim &> /dev/null; then
    echo "==> Installing neovim from source"
    # dependencies
    sudo apt-get install -y ninja-build gettext cmake unzip curl
    git clone -b stable https://github.com/neovim/neovim /tmp/neovim
    cd /tmp/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd -
fi

isWsl && return

####################
## Extra packages ##
####################

packages=(
    "fonts-noto-color-emoji"
    "distrobox"
    "podman"
)
uninstalled=()

packages+=("flatpak")

for pkg in "${packages[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

echo "==> Installing extra packages"
echo "${uninstalled[@]}"

sudo apt-get install -y "${uninstalled[@]}"

# wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

sudo apt-get update
sudo apt-get install -y wezterm
