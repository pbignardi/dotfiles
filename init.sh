#!/bin/bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

set -eou pipefail

LOCALBIN=$HOME/.local/bin
LOCALSRC=$HOME/.src
DOTFILES=$HOME/dotfiles
USERNAME=pbignardi
VERSION="1.0.1"

common_bundle=("tmux" "neovim" "alacritty" "fzf" "oh-my-posh" "juliaup" "uv" "gum" "pyenv")
mac_bundle=(${common_bundle[@]} "skim")
linux_bundle=(${common_bundle[@]} "zathura")

brew_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "skim" "gum")
dnf_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "zathura" "gum")
pacman_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "zathura" "gum")
zypper_pkgs=("tmux" "neovim" "alacritty" "fzf" "go" "firefox" "zathura" "gum")
apt_pkgs=("tmux" "alacritty" "go" "firefox" "zathura")

# Log stuff
GREEN="\033[0;32m"
GRAY="\033[0;90m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC="\033[0m"
BOLD="\033[1m"
RESETBOLD="\033[22m"

function _breakline () {
    echo -e ""
}

function _info () {
    local message=$1
    echo -e "${CYAN}[init: info]${NC} ${GRAY}${message}${NC}"
}

function _warn () {
    local message=$1
    echo -e "${YELLOW}[init: warn]${NC} ${message}"
}

function _error () {
    local message=$1
    echo -e "${RED}[init: error]${NC} ${message}"
}

function _log () {
    local message=$1
    echo -e "${GREEN}[init: status]${NC} ${BOLD}${message}${RESETBOLD}"
}

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

function github_authenticated() {
  # Attempt to ssh to GitHub
  ssh -T git@github.com &>/dev/null
  RET=$?
  if [ $RET == 1 ]; then
    # user is authenticated, but fails to open a shell with GitHub
    return 0
  elif [ $RET == 255 ]; then
    # user is not authenticated
    return 1
  else
    _error "unknown exit code in attempt to ssh into git@github.com"
  fi
  return 2
}

function _get_avail () {
    local os=$1
    case "$os" in
        fedora) local avail=$(printf '%s\n' "${dnf_pkgs[@]}");;
        opensuse) local avail=$(printf '%s\n' "${zypper_pkgs[@]}");;
        debian) local avail=$(printf '%s\n' "${apt_pkgs[@]}");;
        arch) local avail=$(printf '%s\n' "${pacman_pkgs[@]}");;
        mac) local avail=$(printf '%s\n' "${brew_pkgs[@]}");;
        *) _error "Unknown distribution: $os"; exit 1;;
    esac

    local req=$(_get_req $os)
    echo -e "$req\n$avail" | sort | uniq -d
}

function _get_installed () {
    local os=$1
    case "$os" in
        fedora) ;;
        opensuse) ;;
        debian) ;;
        arch) ;;
        mac) brew list -1 --full-name;;
        *) _error "Unknown distribution: $OS"; exit 1;;
    esac
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
    mkdir -p $LOCALBIN
fi
export PATH=$LOCALBIN:$PATH

# Query for personal information
_log "Enter configuration details"
# Ask for work/personal alternative
read -p '=> Is this your work computer? (y/N) ' yn
case $yn in
    [Yy]* ) work=true;;
    * ) work=false;;
esac

# Ask for WSL
read -p '=> Is this a WSL instance? (y/N) ' yn
case $yn in
    [Yy]* ) wsl=true;;
    * ) wsl=false;;
esac

# Ask if it is personal laptop
read -p '=> Is this your personal laptop? (y/N) ' yn
case $yn in
    [Yy]* ) personal_laptop=true;;
    * ) personal_laptop=false;;
esac

# Ask for email address
read -p '=> Enter email address: ' email

# Ask for name
read -p '=> Enter user name: ' name
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

_log "Installing base dependencies"
if [[ ! -z ${toinst_deps[@]+"${toinst_deps[@]}"} ]]; then
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

# Delete Bitwarden if there are updates
if command -v bw >/dev/null 2>&1 && ! $(bw update | grep "No update available" >/dev/null 2>&1); then
    _log "Uninstalling old version of Bitwarden CLI"
    rm $(command -v bw)
    _breakline
fi

# Install Bitwarden CLI
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

# Setup Bitwarden CLI
bw_session=${BW_SESSION:-}
debug=${DEBUG:-}
if [[ -z $bw_session ]] && [[ -z $debug ]]; then
    _log "Setting up Bitwarden CLI"
    export BW_SESSION=$(bw login --raw || bw unlock --raw)
    _breakline
fi

# Retrieve required packages
required=`echo -n $(_get_req $OS)`
available=`echo -n $(_get_avail $OS)`

# Install packages via package manager
case "$OS" in
    opensuse)
        _log "Installing packages with ${CYAN}zypper${NC}"
        _info "Required packages: ${required[@]}"
        sudo zypper in -y ${available[@]}
        _breakline
        ;;
    arch)
        _log "Installing packages with ${CYAN}pacman${NC}"
        _info "Required packages: ${required[@]}"
        sudo pacman -S --noconfirm ${available[@]}
        ;;
    debian)
        _log "Installing packages with ${CYAN}apt${NC}"
        _info "Required packages: ${required[@]}"
        sudo apt install -y ${available[@]}
        ;;
    fedora)
        _log "Installing packages with ${CYAN}dnf${NC}"
        _info "Required packages: ${required[@]}"
        sudo dnf install -y ${available[@]}
        ;;
    mac)
        _log "Installing packages with ${CYAN}brew${NC}"
        _info "Required packages: ${available[@]}"

        # grep -v -f <(_pkg_list "mac") <(printf '%s\n' "${installable[@]}")
        if ! grep -v -f <(_get_installed $OS) <(_get_avail $OS); then
            _info "All required packages are already installed"
        else
            to_install=$(grep -v -f <(_get_installed $OS) <(_get_avail $OS))
            brew install ${available[@]}
        fi
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
        mkdir -p $LOCALSRC
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
        mkdir -p $LOCALSRC
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git $LOCALSRC/fzf
    $LOCALSRC/fzf/install --bin

    if [[ ! -d $LOCALBIN ]]; then
        mkdir -p $LOCALBIN
    fi
    for f in $(ls bin); do
        cp bin/$f $LOCALBIN
    done
fi

if ! command -v uv >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}uv${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if command -v pyenv >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}pyenv${NC}"
    curl -fsSL https://pyenv.run | bash
fi

if ! command -v oh-my-posh >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}oh-my-posh${NC}"
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

if ! command -v juliaup >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}juliaup${NC}"
    curl -fsSL https://install.julialang.org | sh
fi

if ! command -v gum >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}gum${NC}"
    if [[ $os == "debian" ]]; then
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install gum
    fi
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

# Change shell to ZSH
if [[ $SHELL != *"zsh"* ]]; then
    _log "Changing shell to ZSH"
    chsh -s $(which zsh) $USER
    _info "Change will take effect after logout"
    _breakline
fi

# Setup Github SSH keys
# currently copy private key from vault. future: use bitwarden ssh-agent, maybe
_log "Setup Github SSH keys and authentication"
if github_authenticated; then
    _info "SSH to Github already working"
else
    if [[ -f $HOME/.ssh/github ]]; then
        _warn "Moving existing ~/.ssh/github key to ~/.ssh/github.old"
        mv $HOME/.ssh/github $HOME/.ssh/github.old
    fi
    if [[ -f $HOME/.ssh/github.pub ]]; then
        _warn "Moving existing ~/.ssh/github.pub key to ~/.ssh/github.pub.old"
        mv $HOME/.ssh/github.pub $HOME/.ssh/github.pub.old
    fi

    # use gum to select the SSH key
    key_name=$(bw list items --search "Github SSH Key" 2>/dev/null | jq -r '.[] | .name' | gum choose --header="Choose SSH key" --cursor.foreground="6" --header.foreground="8")
    # copy private key
    bw get item "$key_name" 2>/dev/null | jq -r ".sshKey.privateKey" > $HOME/.ssh/github
    # copy public key
    bw get item "$key_name" 2>/dev/null | jq -r ".sshKey.publicKey" > $HOME/.ssh/github.pub

    # set permissions for keys
    chmod 600 $HOME/.ssh/github
    chmod 644 $HOME/.ssh/github.pub

    # Update .ssh/config file
    if ! $(cat $HOME/.ssh/config >/dev/null 2>&1 | grep "Host github.com"); then
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

# Setting gitconfig global options
_log "Setting .gitconfig file"
git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.editor "nvim"
_breakline

# If there are changes in the repo, put out a warning and exit
_log "Cloning dotfiles repository"
if [[ `git -C $DOTFILES status --porcelain` ]]; then
    # changes
    _warn "There are pending changes. ${RED}Exiting${NC}"
    exit 1
fi

# Set SSH as URL remote
if git -C $DOTFILES status; then
    git -C $DOTFILES remote set-url origin git@github.com:$USERNAME/dotfiles.git
    git -C $DOTFILES pull --set-upstream origin
    git -C $DOTFILES submodule update --init --recursive
else
    git -C $DOTFILES clone git@github.com:$USERNAME/dotfiles.git $DOTFILES
    git -C $DOTFILES submodule update --init --recursive
fi

# Clone dotfiles repo
_log "Stowing dotfiles"
cd $DOTFILES
# stow required packages
# TODO: define packages to stow for each system.
for d in $DOTFILES/*/; do
    _info "Stowing $d"
    stow $d
done
