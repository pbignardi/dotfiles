#!/usr/bin/env bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

set -eou pipefail

LOCALBIN=$HOME/.local/bin
LOCALSRC=$HOME/.src
DOTFILES=$HOME/dotfiles
DATAFILE=./data.json
USERNAME=pbignardi
VERSION="0.1.0"

# Log stuff
GREEN="\033[0;32m"
GRAY="\033[0;90m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC="\033[0m"
BOLD="\033[1m"
RESETBOLD="\033[22m"

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

function _breakline () {
    echo -e ""
}

function _info () {
    local message=$1
    echo -e "${CYAN}[init: info]${NC} ${GRAY}$message${NC}"
}

function _warn () {
    local message=$1
    echo -e "${YELLOW}[init: warn]${NC} $message"
}

function _error () {
    local message=$1
    echo -e "${RED}[init: error]${NC} $message"
}

function _log () {
    local message=$1
    echo -e "${GREEN}[init: status]${NC} ${BOLD}$message${RESETBOLD}"
}

function _get_req () {
    local os=$1
    if [[ $os == "mac" ]]; then
        cat $DATAFILE | jq -r '.pkgs.req | [.common[], .mac_only[]][]'
    else
        cat $DATAFILE | jq -r '.pkgs.req | [.common[], .linux_only[]][]'
    fi
}

function _get_avail () {
    local os=$1
    case "$os" in
        fedora) local pkg_manager="dnf" ;;
        opensuse) local pkg_manager="zypper" ;;
        debian) local pkg_manager="apt" ;;
        arch) local pkg_manager="pacman" ;;
        mac) local pkg_manager="brew" ;;
        *) _error "Unknown distribution: $OS"; exit 1;;
    esac

    local req=$(_get_req $os)
    local avail=$(cat $DATAFILE | jq -r ".pkgs.prov.${pkg_manager}[]")
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
if [[ $OS == "mac" ]] && ! type brew >/dev/null 2>&1; then
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
if ! type bw >/dev/null 2>&1; then
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
if [[ -z $debug ]] && [[ -z $bw_session ]]; then
    _log "Setting up Bitwarden CLI"
    export BW_SESSION=$(bw login --raw || bw unlock --raw)
    _breakline
fi

# Ensure data.json is decrypted
if [[ ! -f $DATAFILE ]]; then
    _error "Could not retrieve file: $DATAFILE"
    exit 1
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

# Install package manager packages
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
if ! type nvim >/dev/null 2>&1; then
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

if ! type uv >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}uv${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! type oh-my-posh >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}oh-my-posh${NC}"
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

if ! type juliaup >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}juliaup${NC}"
    curl -fsSL https://install.julialang.org | sh
fi
_breakline

# Install nerd-fonts
if ! $(fc-list | grep RecMonoLinearNerdFont >/dev/null 2>&1); then
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

if ! $(fc-list | grep JetBrainsMonoNerdFont >/dev/null 2>&1); then
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

# Setup Github SSH keys
if ! ssh -T git@github.com >/dev/null 2>&1 || [[ -z $debug ]]; then
    _log "Setup Github SSH keys and authentication"

    key_id=""
    read -p "Enter SSH key Bitwarden id: " key_id

    if [[ -f $HOME/.ssh/github ]]; then
        _warn "Deleting existing github key"
        # mv $HOME/.ssh/github $HOME/.ssh/github.old
        rm $HOME/.ssh/github
    fi

    # retrieve private key from bitwarden vault
    bw get notes $key_id > $HOME/.ssh/github
    # set private attributes for private key
    chmod 600 $HOME/.ssh/github

    # Update .ssh/config file
    echo "Host github.com" >> $HOME/.ssh/config
    echo -e "\tIdentityFile ~/.ssh/github" >> $HOME/.ssh/config
fi

# Clone dotfiles repo
_info "Dotfiles installation"
read -p "Clone dotfiles into ~/dotfiles? This will erase existing dotfiles (y/N)" yn
case "$yn" in
    [yY]*) clone=true;;
    *) clone=false;;
esac
if [[ $clone == true ]]; then
    if [[ -d $DOTFILES ]] && [[ ! -z $debug ]]; then
        _warn "~/dotfiles already exists, erasing it now"
        rm -rf $DOTFILES
    fi
    git clone git@github.com:${USERNAME}/github $DOTFILES
    cd $DOTFILES
    stow */
fi
