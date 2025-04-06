#!/bin/bash

# Install nerd fonts by downloading from Github releases.
# Paolo Bignardi - 2025

source common.sh

function font_install() {
    local specific_font=$2
    local font_filename=$1
    if ! $(fc-list | grep $specific_font >/dev/null 2>&1); then
        _log "Install font: $font_filename Nerd Font"

        ! [[ -d $LOCALSRC ]] && mkdir $LOCALSRC
        cd $LOCALSRC
        wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_filename.zip"
        unzip -d $font_filename $font_filename.zip

        if [[ ! -d $HOME/.local/share/fonts ]]; then
            mkdir -p $HOME/.local/share/fonts
        fi
        local nf_name="${font_filename}_NF"
        if [[ -d $HOME/.local/share/fonts/$nf_name ]]; then
            _warn "Deleting $HOME/.local/share/fonts/$nf_name"
            rm -rf $HOME/.local/share/fonts/$nf_name
        fi
        mv $font_filename $HOME/.local/share/fonts/$nf_name
    fi
}

font_install "SauceCodePro Nerd Font" "SourceCodePro"
font_install "MesloLGM" "Meslo"
font_install "RecMonoLinear Nerd Font" "Recursive"
font_install "JetBrainsMonoNerdFont" "JetBrainsMono"
font_install "VictorMono Nerd Font" "VictorMono"

# return to dotfiles
cd $DOTFILES
