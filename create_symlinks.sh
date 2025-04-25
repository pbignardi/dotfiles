#!/bin/bash

# Stow the right dotfiles for the system
# Paolo Bignardi - 2025

source utils.sh

STOW_DIRS=(bins fzf kitty nvim oh-my-posh tmux wezterm zsh git)

# delete packages
_log "Deleting existing dotfiles"
cd $DOTFILES
for d in */; do
    _info "$d"
    stow -D $d
done

# stow required packages
_log "Creating symlinks"
for d in $(echo ${STOW_DIRS[@]}); do
    _info "$d"
    stow $d
done
