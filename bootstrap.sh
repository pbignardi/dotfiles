#!/usr/bin/env bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

VERSION="2.1.0"
# Source common config and utils
source utils.sh

usage() {
    echo "usage: bootstrap.sh [OPTIONS]"
    echo "OPTIONS:
        -u      update config
        -w      work config flag
    "
}

UPDATE=false
WORK=false
while getopts "uw" o; do
    case "${o}" in
    u) UPDATE=true ;;
    w) WORK=true ;;
    *)
        usage
        exit 1
        ;;
    esac
done

# Display init.sh info
clear
STYLE="\033[1;32m"
RESET="\033[0m"
cat <<"EOF"
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

if [ "$WORK" == "true" ]; then
    echo "[>>] Using work laptop profile"
else
    echo "[>>] Using personal computer profile"
fi
echo

# create ~/.local/bin
mkdir -p ~/.local/bin

# Install packages with platform package manager
if isDebian; then
    . packages/apt.sh
elif isFedora; then
    . packages/dnf.sh
elif isArchlinux; then
    . packages/pacman.sh
elif isOpensuse; then
    . packages/zypper.sh
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
export PATH=$PATH:$HOME/.local/bin

# Install oh-my-posh
if ! command -v oh-my-posh >/dev/null 2>&1; then
    echo "==> Installing oh-my-posh"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
fi

# Install uv
if ! command -v uv &>/dev/null; then
    echo "==> Installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Change shell to ZSH
if isMac; then
    if ! dscl . -read ~/ UserShell | grep zsh &>/dev/null; then
        echo "==> Changing shell to ZSH"
        sudo chsh -s /bin/zsh $USER
        echo "[>>] Change will take effect after logout"
    fi
else
    if ! getent passwd $USER | grep zsh &>/dev/null; then
        echo "==> Changing shell to ZSH"
        sudo chsh -s /bin/zsh $USER
        echo "[>>] Change will take effect after logout"
    fi
fi

# Setup Bitwarden CLI
if [ "$UPDATE" == "false" ]; then
    . install-bitwarden.sh

    if ! bw login --check; then
        echo "==> Loggin into Bitwarden CLI"
        bw login
    fi

    echo "==> Unlocking Bitwarden vault"
    export BW_SESSION=$(bw unlock --raw)

    if [ "$WORK" == "true" ]; then
        bw get item "8028ff0c-64ea-42f7-83f0-b29b008ca35d" | jq -r ".sshKey.publicKey" >~/.ssh/github.pub
        chmod 644 ~/.ssh/github.pub
    else
        bw get item "b0f6c361-c3d3-4156-abf6-b29b008a74d5" | jq -r ".sshKey.publicKey" >~/.ssh/github.pub
        bw get item "bf9c1cc4-651b-4747-8335-b32101618396" | jq -r ".sshKey.publicKey" >~/.ssh/raspberry.pub
        chmod 644 ~/.ssh/github.pub
        chmod 644 ~/.ssh/raspberry.pub
    fi

    # Set dotfiles repo origin
    SSH_REMOTE="git@github.com:pbignardi/dotfiles.git"
    if git remote -v | grep origin &>/dev/null; then
        echo "==> Setting origin git remote"
        git remote set-url origin $SSH_REMOTE &>/dev/null
        if [[ $? -ne 0 ]]; then
            echo "[!!] Error in git remote setup. Aborting."
            exit 1
        fi
    fi
fi

# Create directories
if [ "$UPDATE" == "false" ]; then
    echo "==> Creating directories ~/projects and ~/notes"
    mkdir -p ~/projects
    mkdir -p ~/notes
fi

# Update submodules
if [ "$UPDATE" == "false" ]; then
    echo "==> Pull submodules"
    git submodule update --init
fi

# Delete stow packages
echo "==> Deleting existing dotfiles"
stow -D bins
stow -D fzf
stow -D nvim
stow -D oh-my-posh
stow -D tmux
stow -D wezterm
stow -D zsh
stow -D ssh
stow -D unix
stow -D wsl
stow -D fastfetch
stow -D lsd
stow -D batcat

# stow required packages
echo "==> Creating symlinks"
stow bins
stow fzf
stow nvim
stow oh-my-posh
stow tmux
stow wezterm
stow zsh
stow ssh
stow fastfetch
stow lsd
stow batcat
if isWsl; then
    stow wsl --adopt
    git restore wsl
else
    stow unix --adopt
    git restore unix
fi

if isWsl; then
    # .ssh/ --> %USERPROFILE&/.ssh/
    USERNAME=$(powershell.exe -NoProfile -Command "\$env:USERPROFILE" | tr -d '\r' | tr '\\' '/' | xargs -- basename)
    APPDATA="/mnt/c/Users/$USERNAME/AppData/Roaming"

    # copy ssh configuration
    cp -r wsl/.ssh/ "/mnt/c/Users/$USERNAME/"
fi

echo "[!!] Remember to fill .gitconfig.local with info"
