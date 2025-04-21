#!/usr/bin/env bash

# Update system packages
# Paolo Bignardi - 2025

source common.sh

_log "Update system packages"
case "$(identify_system)" in
opensuse)
    sudo zypper dup
    ;;
mac)
    brew update && brew upgrade
    ;;
fedora)
    sudo dnf upgrade
    ;;
esac
