#!/usr/bin/env bash

# Pull changes from remote and stow
# Paolo Bignardi - 2025

set -eou pipefail

source common.sh

_log "Stowing dotfiles"
cd $DOTFILES
# stow required packages
# TODO: define packages to stow for each system.
for d in */; do
    _info "Stowing $d"
    stow $d
done
