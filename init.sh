#!/usr/bin/env bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

set -eou pipefail

source common.sh

LOCALBIN=$HOME/.local/bin
LOCALSRC=$HOME/.src
DOTFILES=$HOME/dotfiles
USERNAME=pbignardi
VERSION="0.1.0"

common_bundle=("tmux" "neovim" "alacritty" "fzf" "go" "oh-my-posh" "juliaup" "uv" "firefox")
mac_bundle=(${common_bundle[@]} "skim")
linux_bundle=(${common_bundle[@]} "zathura")

brew_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "skim")
dnf_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "zathura")
pacman_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "zathura")
zypper_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "zathura")
apt_pkgs=("tmux" "alacritty" "go" "firefox" "zathura")

function _init_info () {
    STYLE="\033[1;32m"
    RESET="\033[0m"

    pretty=${PRETTY:-true}
    if [[ $pretty ]]; then
        echo '     _       _ __         __  '
        echo '    (_)___  (_) /_  _____/ /_ '
        echo '   / / __ \/ / __/ / ___/ __ \'
        echo '  / / / / / / /__ (__  ) / / /'
        echo ' /_/_/ /_/_/\__(_)____/_/ /_/ '
        echo
    fi
    echo -e "${STYLE}init.sh${NC} -- Initialize a new system, automatically"
    echo "version $VERSION"
    echo
}

function _get_req () {
    local os=$1
    if [[ $os == "mac" ]]; then
        printf '%s\n' "${mac_bundle[@]}"
    else
        printf '%s\n' "${linux_bundle[@]}"
    fi
}

function _get_avail () {
    local os=$1
    case "$os" in
        fedora) local avail=$(printf '%s\n' "${dnf_pkgs[@]}");;
        opensuse) local avail=$(printf '%s\n' "${zypper_pkgs[@]}");;
        debian) local avail=$(printf '%s\n' "${apt_pkgs[@]}");;
        arch) local avail=$(printf '%s\n' "${pacman_pkgs[@]}");;
        mac) local avail=$(printf '%s\n' "${brew_pkgs[@]}");;
        *) _error "Unknown distribution: $OS"; exit 1;;
    esac

    local req=$(_get_req $OS)
    echo -e "$req\n$avail" | sort | uniq -d
}

# Display init.sh info
_init_info

# Identify target system
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
        # rhel systems
        fedora) OS="fedora";;
        # suse systems
        opensuse*) OS="opensuse";;
        # debian systems
        debian) OS="debian";;
        ubuntu) OS="debian";;
        linuxmint) OS="debian";;
        pop*) OS="debian";;
        # arch systems
        arch*) OS="arch";;
        *) _error "Distribution with $ID not supported"; exit 1;;
    esac
elif [[ $(uname -s) == "Darwin" ]]; then
    OS="mac"
else
    _error "Unknown operating system. Aborting"
    exit 1
fi
_info "Identified OS: $OS"


# Configure PATH
if [[ ! -d $LOCALBIN ]]; then
    mkdir $LOCALBIN
fi
export PATH=$LOCALBIN:$PATH

# Query for personal information
_log "Enter configuration details"
# Ask for work/personal alternative
read -p "- Is this your work computer? (y/N) " yn
case $yn in
    [Yy]* ) work=true;;
    * ) work=false;;
esac

# Ask for WSL
read -p "- Is this a WSL instance? (y/N) " yn
case $yn in
    [Yy]* ) wsl=true;;
    * ) wsl=false;;
esac

# Ask if it is personal laptop
read -p "- Is this your personal laptop? (y/N) " yn
case $yn in
    [Yy]* ) personal_laptop=true;;
    * ) personal_laptop=false;;
esac

# Ask for email address
read -p "- Enter your email address: " email
_breakline

# Install homebrew on Mac
if [[ $OS == "mac" ]] && ! command -v brew >/dev/null 2>&1; then
    _log "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    _breakline
fi

# Check if homebrew is on path
if ! [[ $PATH == *"homebrew"* ]]; then
    # add homebrew to path
    export PATH=$PATH:/opt/homebrew/bin
fi

# Install required base packages
base_deps=("git" "stow" "jq" "gpg" "wget" "unzip" "zsh")
toinst_deps=()
for dep in ${base_deps[@]}; do
    if ! type $dep >/dev/null 2>&1; then
        toinst_deps+=($dep)
    fi
done

if [[ ! -z ${toinst_deps[@]+"${toinst_deps[@]}"} ]]; then
    _log "Installing base dependencies"
    case "$OS" in
        fedora) sudo dnf -y install ${toinst_deps[@]};;
        debian) sudo apt -y install ${toinst_deps[@]};;
        opensuse) sudo zypper in -y install ${toinst_deps[@]};;
        arch) sudo pacman -S --noconfirm ${toinst_deps[@]};;
        *) _error "Unknown operating system. Aborting";;
    esac
else
    _info "Base dependencies already satisfied"
fi
_breakline

# Install bitwarden cli
if ! command -v bw >/dev/null 2>&1; then
    _log "Installing Bitwarden CLI"
    cd $LOCALBIN
    if [[ $OS == "mac" ]]; then
        wget "https://bitwarden.com/download/?app=cli&platform=macos" -O bw.zip
    else
        wget "https://bitwarden.com/download/?app=cli&platform=linux" -O bw.zip
    fi
    unzip bw.zip
    rm bw.zip
    chmod u+x bw
    cd
    _breakline
fi

# Setup bitwarden cli
bw_session="${BW_SESSION:-}"
debug="${DEBUG:-}"
if [[ -z $bw_session ]]; then
    _log "Setting up Bitwarden CLI"
    export BW_SESSION=$(bw login --raw || bw unlock --raw)
    _breakline
fi

# Retrieve required packages
required=$(echo -n $(_get_req $OS))
available=$(echo -n $(_get_avail $OS))
_info "Required packages for $OS: $required"
_breakline

installable=""
for pkg in $required; do
    case "$available" in
        *$pkg*) installable+="$pkg ";;
        *) ;;
    esac
done

# Install packages via package manager
case "$OS" in
    opensuse)
        _log "Installing packages with ${CYAN}zypper${NC}"
        sudo zypper in -y $installable
        ;;
    arch)
        _log "Installing packages with ${CYAN}pacman${NC}"
        sudo pacman -S --noconfirm $installable
        ;;
    debian)
        _log "Installing packages with ${CYAN}apt${NC}"
        sudo apt install -y $installable
        ;;
    fedora)
        _log "Installing packages with ${CYAN}dnf${NC}"
        sudo dnf install -y $installable
        ;;
    mac)
        _log "Installing packages with ${CYAN}brew${NC}"
        brew install $installable
        ;;
    *)
        _error "Unknown operating system. Aborting"
        exit 1
        ;;
esac

# Install source packages
if ! command -v nvim >/dev/null 2>&1; then
    _log "Build from source: ${CYAN}neovim${NC}"

    _info "Installing neovim dependencies"
    # install neovim dependencies
    if [[ $OS == "opensuse" ]]; then
        sudo zypper install ninja cmake gcc-c++ gettext-tools curl
    fi
    if [[ $OS == "fedora" ]]; then
        sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra
    fi
    if [[ $OS == "debian" ]]; then
        sudo apt-get install ninja-build gettext cmake curl build-essential
    fi
    if [[ $OS == "arch" ]]; then
        sudo pacman -S base-devel cmake ninja curl
    fi

    # clone into
    _info "Cloning neovim into $LOCALSRC"
    if [[ ! -d $LOCALSRC ]]; then
        mkdir $LOCALSRC
    fi
    git clone https://github.com/neovim/neovim
    cd neovim
    git checkout stable

    # build & install
    _info "Build and install neovim"
    make CMAKE_BUILD_TYPE=Release
    sudo make install
fi


if ! command fzf --version >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}fzf${NC}"
    if [[ ! -d $LOCALSRC ]]; then
        mkdir $LOCALSRC
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git $LOCALSRC/fzf
    cd $LOCALSRC/fzf/install --bin

    if [[ ! -d $LOCALBIN ]]; then
        mkdir $LOCALBIN
    fi
    cp bin/* $LOCALBIN
fi

if ! command -v uv >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}uv${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! command -v oh-my-posh >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}oh-my-posh${NC}"
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

if ! command -v juliaup >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}juliaup${NC}"
    curl -fsSL https://install.julialang.org | sh
fi
_breakline

# Install nerd-fonts
fontlist=$(fc-list)
if ! $(echo $fontlist | grep RecMonoLinearNerdFont >/dev/null 2>&1); then
    _log "Install font: Recurcive Nerd Font"

    cd $LOCALSRC
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Recursive.zip"
    unzip -d Recursive Recursive.zip

    if [[ ! -d $HOME/.local/share/fonts ]]; then
        mkdir $HOME/.local/share/fonts
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
        mkdir $HOME/.local/share/fonts
    fi
    if [[ -d $HOME/.local/share/fonts/JetBrainsMono ]]; then
        _warn "Deleting $HOME/.local/share/fonts/JetBrainsMono"
        rm -rf $HOME/.local/share/fonts/JetBrainsMono
    fi
    mv JetBrainsMono $HOME/.local/share/fonts/JetBrainsMono
fi

# Change shell to ZSH
if [[ $SHELL != *"zsh"* ]]; then
    _log "Changing shell to ZSH"
    chsh -s $(which zsh) $USER
    _info "Change will take effect after logout"
fi

# Setup Github SSH keys
# currently copy private key from vault. future: use bitwarden ssh-agent, maybe
if ! ssh -T git@github.com >/dev/null 2>&1 || [[ -z $debug ]]; then
    _log "Setup Github SSH keys and authentication"

    if [[ -f $HOME/.ssh/github ]]; then
        _warn "Moving existing ~/.ssh/github key to ~/.ssh/github.old"
        mv $HOME/.ssh/github $HOME/.ssh/github.old
    fi
    if [[ -f $HOME/.ssh/github.pub ]]; then
        _warn "Moving existing ~/.ssh/github.pub key to ~/.ssh/github.pub.old"
        mv $HOME/.ssh/github.pub $HOME/.ssh/github.pub.old
    fi

    # use fzf to select the SSH key
    key_name=$(bw list items --search "Github SSH Key" 2>/dev/null | jq -r '.[] | .name' | fzf --height=20%)
    # copy private key
    bw get item "$key_name" 2>/dev/null | jq -r ".sshKey.privateKey" > $HOME/.ssh/github
    # copy public key
    bw get item "$key_name" 2>/dev/null | jq -r ".sshKey.publicKey" > $HOME/.ssh/github.pub

    # set permissions for keys
    chmod 600 $HOME/.ssh/github
    chmod 644 $HOME/.ssh/github.pub

    # Update .ssh/config file
    if ! $(cat $HOME/.ssh/config | grep "Host github.com"); then
        _info "Updating ~/.ssh/config"
        echo "" >> $HOME/.ssh/config
        echo "Host github.com" >> $HOME/.ssh/config
        echo -e "\tIdentityFile ~/.ssh/github" >> $HOME/.ssh/config
    else
        _error "Could not update ~/.ssh/config file. Modify it manually before proceding"
        read -p "Press any key to continue"
    fi
fi
_breakline

# Clone dotfiles repo
_log "Stowing dotfiles"
cd $DOTFILES
# stow required packages
for d in $DOTFILES/*/; do
    _info "Stowing $d"
    # stow $d
done
