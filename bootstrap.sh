#!/usr/bin/env bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

VERSION="2.1.0"
# Source common config and utils
source utils.sh
clear

# Display init.sh info
STYLE="\033[1;32m"
RESET="\033[0m"
cat << "EOF"
    .           .      .                     .
    |-. ,-. ,-. |- ,-. |- ,-. ,-. ,-.    ,-. |-.
    | | | | | | |  `-. |  |   ,-| | |    `-. | |
    ^-' `-' `-' `' `-' `' '   `-^ |-' :; `-' ' '
                                  |
                                  '

EOF
echo -e "${STYLE}$0${RESET} -- Initialize a new system, automatically"
echo "version $VERSION"
echo

# Ask if its work laptop
read -p "[??] Use secrets from Bitwarden on this machine? (y/N)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    USE_SECRETS="y"
    echo "[>>] Using personal computer profile"
else
    USE_SECRETS="n"
    echo "[>>] Using work laptop profile"
fi
SETUPSSH=false

# create ~/.local/bin
mkdir -p ~/.local/bin

# Install packages with platform package manager
if isDebian; then
    . packages/apt.sh
elif isFedora; then
    . packages/dnf.sh
elif isArchlinux; then
    . packages/pacman.sh
elif isMac; then
    . packages/brew.sh
fi

# Install flatpaks packages
if ! isWsl && ! isMac; then
    . packages/flatpak.sh
fi

# Install winget packages
if isWsl; then
    . packages/winget.sh
fi

# Add ~/.local/bin to PATH
export PATH=$PATH:$LOCALBIN

# Install oh-my-posh
if ! command -v oh-my-posh >/dev/null 2>&1; then
    echo "==> Installing oh-my-posh"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
fi

# Change shell to ZSH
if ! getent passwd $USER | grep zsh &> /dev/null; then
    echo "==> Changing shell to ZSH"
    sudo chsh -s /bin/zsh $USER
    echo "[>>] Change will take effect after logout"
fi

# Setup Bitwarden CLI
. install-bitwarden.sh

if [[ $USE_SECRETS == "y" ]] && ! bw login --check; then
    echo "==> Loggin into Bitwarden CLI"
    bw login
fi

if [[ $USE_SECRETS == "y" ]] && $SETUPSSH; then
    echo "==> Unlocking Bitwarden vault"
    export BW_SESSION=$(bw unlock --raw)
fi

# setup SSH
if [[ $USE_SECRETS == "y" ]] && $SETUPSSH; then
    # get bw public keys
    if isWsl; then
        echo
    elif isMac; then
        bw get item "37124b4a-8174-4a42-b933-b29a00ea5511" | jq -r ".sshKey.publicKey" > ~/.ssh/github.pub
        chmod 644 ~/.ssh/github.pub
    else
        bw get item "b0f6c361-c3d3-4156-abf6-b29b008a74d5" | jq -r ".sshKey.publicKey" > ~/.ssh/github.pub
        chmod 644 ~/.ssh/github.pub
    fi
    bw get item "bf9c1cc4-651b-4747-8335-b32101618396" | jq -r ".sshKey.publicKey" > ~/.ssh/raspberry.pub
fi

# Clone dotfiles repo
SSH_REMOTE="git@github.com:pbignardi/dotfiles.git"
if [[ $USE_SECRETS == "y" ]] && ! git remote -v | grep "$SSH_REMOTE" &> /dev/null; then
    echo "==> Adding origin git remote"
    git remote remove origin &> /dev/null
    git remote add origin $SSH_REMOTE
    if [[ $? -ne 0 ]]; then
        echo "[!!] Error in git remote setup. Aborting."
        exit 1
    fi
    git remote -v
fi
echo "==> Pulling changes from remote"
git pull
git submodule update --init --recursive

# Create directories
echo "==> Creating directories ~/projects and ~/notes"
mkdir -p ~/projects
mkdir -p ~/notes

# Delete stow packages
echo "==> Deleting existing dotfiles"
stow -D bins
stow -D fzf
stow -D nvim
stow -D oh-my-posh
stow -D tmux
stow -D wezterm
stow -D zsh
isWsl && stow -D wsl || stow -D unix

# stow required packages
echo "==> Creating symlinks"
stow bins
stow fzf
stow nvim
stow oh-my-posh
stow tmux
stow wezterm
stow zsh
isWsl && stow wsl || stow unix

# copy config files for windows for wsl
# wezterm.lua --> %APPDATA%/.config/wezterm/
# .ssh/ --> %USERPROFILE&/.ssh/
if isWsl; then
    # TODO
    USERPROFILE=$(powershell.exe -NoProfile -Command "\$env:USERPROFILE" | tr -d '\r')
    APPDATA=$(powershell.exe -NoProfile -Command "\$env:APPDATA" | tr -d '\r')
fi
