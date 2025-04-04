#!/bin/bash

# Install nerd fonts by downloading from Github releases.
# Paolo Bignardi - 2025

source common.sh

fontlist=$(fc-list)
if ! $(echo $fontlist | grep "MesloLGM" >/dev/null 2>&1); then
    _log "Install font: Menlo Nerd Font"

    ! [[ -d $LOCALSRC ]] && mkdir $LOCALSRC
    cd $LOCALSRC
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
    unzip -d Meslo Meslo.zip

    if [[ ! -d $HOME/.local/share/fonts ]]; then
        mkdir -p $HOME/.local/share/fonts
    fi
    if [[ -d $HOME/.local/share/fonts/Meslo ]]; then
        _warn "Deleting $HOME/.local/share/fonts/Meslo"
        rm -rf $HOME/.local/share/fonts/Meslo
    fi
    mv Meslo $HOME/.local/share/fonts/Meslo
fi

if ! $(echo $fontlist | grep RecMonoLinearNerdFont >/dev/null 2>&1); then
    _log "Install font: Recurcive Nerd Font"

    ! [[ -d $LOCALSRC ]] && mkdir $LOCALSRC
    cd $LOCALSRC
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Recursive.zip"
    unzip -d Recursive Recursive.zip

    if [[ ! -d $HOME/.local/share/fonts ]]; then
        mkdir -p $HOME/.local/share/fonts
    fi
    if [[ -d $HOME/.local/share/fonts/Recursive ]]; then
        _warn "Deleting $HOME/.local/share/fonts/Recursive"
        rm -rf $HOME/.local/share/fonts/Recursive
    fi
    mv Recursive $HOME/.local/share/fonts/Recursive
fi

if ! $(echo $fontlist | grep JetBrainsMonoNerdFont >/dev/null 2>&1); then
    _log "Install font: JetBrainsMono Nerd Font"

    ! [[ -d $LOCALSRC ]] && mkdir $LOCALSRC
    cd $LOCALSRC
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -d JetBrainsMono JetBrainsMono.zip

    if [[ ! -d $HOME/.local/share/fonts ]]; then
        mkdir -p $HOME/.local/share/fonts
    fi
    if [[ -d $HOME/.local/share/fonts/JetBrainsMono ]]; then
        _warn "Deleting $HOME/.local/share/fonts/JetBrainsMono"
        rm -rf $HOME/.local/share/fonts/JetBrainsMono
    fi
    mv JetBrainsMono $HOME/.local/share/fonts/JetBrainsMono
fi

