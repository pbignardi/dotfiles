#!/bin/bash

# Pull dotfiles from Github
# Paolo Bignardi - 2025

source common.sh

# If there are changes in the repo, put out a warning and exit
_log "Cloning dotfiles repository"
if [[ $(git -C $DOTFILES status --porcelain) ]]; then
    # changes
    _warn "There are pending changes. ${RED}Exiting${NC}"
    exit 1
fi

# check if ~/dotfiles exists and is not a git repo
if [[ -d $DOTFILES ]] && ! git -C $DOTFILES status >/dev/null 2>&1; then
    _warn "$DOTFILES exists, but is not a git repo."
    _info "Moving $DOTFILES to $DOTFILES.old"
    mv $DOTFILES "$DOTFILES.old"
fi

# Set SSH as URL remote
if git -C $DOTFILES status >/dev/null 2>&1; then
    cd $DOTFILES
    git remote set-url origin git@github.com:$USERNAME/dotfiles.git
    git pull --set-upstream origin
    git submodule update --init --recursive
else
    git clone git@github.com:$USERNAME/dotfiles.git $DOTFILES
    cd $DOTFILES
    git submodule update --init --recursive
fi

# return to dotfiles
cd $DOTFILES
