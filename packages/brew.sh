#!/usr/bin/env bash

# Setup Homebrew and install required packages
# Paolo Bignardi - 2025

source utils.sh

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> Installing packages"
# Install packages using `brew bundle`
brew bundle --file=- << EndOfFile
## Core packages
brew "fastfetch"
brew "wget"
brew "curl"
brew "git"
brew "stow"
brew "jq"
brew "unzip"
brew "zsh"
brew "gcc"
brew "go"
brew "gum"
brew "nodejs"
brew "neovim"
brew "fzf"
brew "tmux"
brew "fd"
brew "ripgrep"
brew "bat"
brew "btop"
brew "npm"
brew "deno"
brew "eza"
brew "zoxide"

brew "bitwarden-cli"
brew "podman"

## Casks
cask "skim"
cask "wezterm"

EndOfFile
