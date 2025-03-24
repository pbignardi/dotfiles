#!/usr/bin/env bash

# Update repository from remote
# Paolo Bignardi - 2025

set -eou pipefail

source common.sh

# If there are changes in the repo, put out a warning and exit
_log "Cloning dotfiles repository"
if [[ `git -C $DOTFILES status --porcelain` ]]; then
    # changes
    _warn "There are pending changes. ${RED}Exiting${NC}"
    exit 1
fi

# Set SSH as URL remote
if git -C $DOTFILES status; then
    git -C $DOTFILES remote set-url origin git@github.com:$USERNAME/dotfiles.git
    git -C $DOTFILES pull --set-upstream origin
    git -C $DOTFILES submodule update --init --recursive
else
    git -C $DOTFILES clone git@github.com:$USERNAME/dotfiles.git $DOTFILES
    git -C $DOTFILES submodule update --init --recursive
fi
