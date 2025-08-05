#!/usr/bin/env bash

# Initialise system to launch bootstrap.sh

BRANCH="v2"

# retrieve utils.sh file
_tmp_utils="/tmp/utils.sh"
_utils_link="https://raw.githubusercontent.com/pbignardi/dotfiles/refs/heads/$BRANCH/utils.sh"

echo "==> Downloading utils.sh file"
if command -v curl &> /dev/null; then
    curl -L "$_utils_link" -o "$_tmp_utils"
elif command -v wget &> /dev/null; then
    wget "$_utils_link" -O "$_tmp_utils"
else
    echo "[!!] Missing dependencies: install either CURL or WGET"
    exit 1
fi

# source utils
source $_tmp_utils

echo "==> Installing git"
if isArchlinux; then
    sudo pacman -S git --noconfirm
elif isFedora; then
    sudo dnf install -y git
elif isDebian; then
    sudo apt-get install -y git
fi

# clone dotfiles
echo "==> Cloning dotfiles to ~/dotfiles"
git clone -b "$BRANCH" https://github.com/pbignardi/dotfiles.git

# call bootstrap.sh
cd dotfiles
bash bootstrap.sh
