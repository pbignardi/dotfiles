#!/usr/bin/env bash

# Create directory tree for files and stuff
# Paolo Bignardi - 2025

source utils.sh

_log "Create directory tree"
! [[ -d ~/projects ]] && mkdir ~/projects
! [[ -d ~/notes ]] && mkdir ~/notes
