#!/usr/bin/env bash

# Install NerdFonts
# Paolo Bignardi - 2025

# Install nerd-fonts
fontlist=$(fc-list)
if ! $(echo $fontlist | grep RecMonoLinearNerdFont >/dev/null 2>&1); then
    _log "Install font: Recurcive Nerd Font"

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
