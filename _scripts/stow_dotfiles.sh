#!/bin/bash

# Stow the right dotfiles for the system
# Paolo Bignardi - 2025

source common.sh

# Clone dotfiles repo
_log "Stowing dotfiles"
cd $DOTFILES
# stow required packages
# TODO: define packages to stow for each system.
for d in */; do
    _info "Stowing $d"
    stow $d
done
