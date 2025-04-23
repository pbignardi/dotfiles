#!/usr/bin/env bash

# Delete existing symlinks and stow packages
# Paolo Bignardi - 2025

source utils.sh

STOW_DIRS=(nvim fzf oh-my-posh bins tmux wezterm zsh)

_log "Delete existing dotfiles"
for folder in */; do
    _info "$folder"
    stow -D $folder
done

_log "Stow dotfiles"
for folder in $(echo ${STOW_DIRS[@]} | sort); do
    _info "$folder"
    stow $folder
done
