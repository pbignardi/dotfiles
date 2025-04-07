#!/bin/bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

source common.sh

apt_core=("tmux")
apt_extra=("zathura")

dnf_core=("tmux" "neovim" "fzf" "gum")
dnf_extra=("zathura")

zypper_core=("tmux" "neovim" "fzf" "gum")
zypper_extra=("wezterm" "zathura")

pacman_core=("tmux" "neovim" "fzf" "gum")
pacman_extra=("wezterm" "zathura")

brew_core=("wezterm" "tmux" "neovim" "fzf" "gum" "skim")
brew_extra=()

function _get_installed() {
    local os=$1
    case "$os" in
    fedora) ;;
    opensuse) ;;
    debian) ;;
    arch) ;;
    mac) brew list -1 --full-name ;;
    *)
        _error "Unknown distribution: $OS"
        exit 1
        ;;
    esac
}

# Display init.sh info
STYLE="\033[1;32m"
RESET="\033[0m"
echo '     _       _ __         __  '
echo '    (_)___  (_) /_  _____/ /_ '
echo '   / / __ \/ / __/ / ___/ __ \'
echo '  / / / / / / /__ (__  ) / / /'
echo ' /_/_/ /_/_/\__(_)____/_/ /_/ '
echo
echo -e "${STYLE}init.sh${NC} -- Initialize a new system, automatically"
echo "version $VERSION"
echo

# determine system
OS=$(identify_system)
if [[ -z ${OS:-} ]]; then
    _error "Unsupported system"
    exit 1
else
    _info "Identified OS: $OS"
    _breakline
fi

# Update mirrors
_log "Refresh package cache"
case "$OS" in
debian) sudo apt-get update ;;
fedora) sudo dnf upgrade ;;
opensuse) sudo zypper ref ;;
arch) sudo pacman -Syu ;;
esac
_breakline

# Configure PATH
if [[ ! -d $LOCALBIN ]]; then
    mkdir -p $LOCALBIN
fi
export PATH=$LOCALBIN:$PATH

# Query for personal information
if [[ -f .data.sh ]]; then
    _log "Load configuration details"
    _info "To clear configuration details, delete ${ITALIC}.data.sh${NOITALIC}"
    source .data.sh
else
    _log "Enter configuration details"
    echo "#!/usr/bin/env bash" >.data.sh
fi

# Ask for work/personal alternative
if [[ -z ${work:-} ]]; then
    read -p '=> Is this your work computer? (y/N) ' yn
    case $yn in
    [Yy]*) work=true ;;
    *) work=false ;;
    esac
    echo "work=$work" >>.data.sh
fi

# Ask for WSL
if [[ -z ${wsl:-} ]]; then
    read -p '=> Is this a WSL instance? (y/N) ' yn
    case $yn in
    [Yy]*) wsl=true ;;
    *) wsl=false ;;
    esac
    echo "wsl=$wsl" >>.data.sh
fi

# Ask if it is personal laptop
if [[ -z ${personal_laptop:-} ]]; then
    read -p '=> Is this your personal laptop? (y/N) ' yn
    case $yn in
    [Yy]*) personal_laptop=true ;;
    *) personal_laptop=false ;;
    esac

    echo "personal_laptop=$personal_laptop" >>.data.sh
fi

# Ask for email address
if [[ -z ${email:-} ]]; then
    read -p '=> Enter email address: ' email
    echo email=\"$email\" >>.data.sh
fi

# Ask for name
if [[ -z ${name:-} ]]; then
    read -p '=> Enter user name: ' name
    echo name=\"$name\" >>.data.sh
fi

# Ask to install NerdFonts
if [[ -z ${nerdfonts:-} ]]; then
    read -p '=> Do you want to install Nerd Fonts? (y/N) ' yn
    case $yn in
    [Yy]*) nerdfonts=true ;;
    *) nerdfonts=false ;;
    esac

    echo "nerdfonts=$nerdfonts" >>.data.sh
fi
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
base_deps=("git" "stow" "jq" "gpg" "wget" "unzip" "zsh" "gcc")
toinst_deps=()
for dep in ${base_deps[@]}; do
    if ! type $dep >/dev/null 2>&1; then
        toinst_deps+=($dep)
    fi
done

_log "Installing base dependencies"
if [[ ! -z ${toinst_deps[@]+"${toinst_deps[@]}"} ]]; then
    case "$OS" in
    fedora) sudo dnf -y install ${toinst_deps[@]} ;;
    debian) sudo apt -y install ${toinst_deps[@]} ;;
    opensuse) sudo zypper in -y ${toinst_deps[@]} ;;
    arch) sudo pacman -S --noconfirm ${toinst_deps[@]} ;;
    *) _error "Unknown operating system. Aborting" ;;
    esac
else
    _info "Base dependencies already satisfied"
fi
_breakline

# Setting gitconfig global options
_log "Setting .gitconfig file"
git config --global core.editor "nvim"
if ! [[ -z $name ]] && ! [[ -z $email ]]; then
    git config --global user.name "$name"
    git config --global user.email "$email"
fi
_breakline

# Change shell to ZSH
if [[ $SHELL != *"zsh"* ]]; then
    _log "Changing shell to ZSH"
    chsh -s $(which zsh) $USER
    _info "Change will take effect after logout"
    _breakline
fi

# Install base packages via package manager
case "$OS" in
opensuse)
    _log "Installing packages with ${CYAN}zypper${NC}"

    _info "Core packages: ${zypper_core[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${zypper_core[@]}") >/dev/null; then
        _info "Core packages already installed"
    else
        sudo zypper in -y ${zypper_core[@]}
    fi
    _info "Extra packages: ${zypper_extra[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${zypper_extra[@]}") >/dev/null; then
        _info "Extra packages already installed"
    else
        sudo zypper in -y ${zypper_extra[@]}
    fi

    _breakline
    ;;
arch)
    _log "Installing packages with ${CYAN}pacman${NC}"

    _info "Core packages: ${pacman_core[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${pacman_core[@]}") >/dev/null; then
        _info "Core packages already installed"
    else
        sudo pacman -S --noconfirm ${pacman_core[@]}
    fi
    _info "Extra packages: ${pacman_extra[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${pacman_extra[@]}") >/dev/null; then
        _info "Extra packages already installed"
    else
        sudo pacman -S --noconfirm ${pacman_extra[@]}
    fi

    _breakline
    ;;
debian)
    _log "Installing packages with ${CYAN}apt${NC}"

    _info "Core packages: ${apt_core[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${apt_core[@]}") >/dev/null; then
        _info "Core packages already installed"
    else
        sudo apt-get install -y ${apt_core[@]}
    fi
    _info "Extra packages: ${apt_extra[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${apt_extra[@]}") >/dev/null; then
        _info "Extra packages already installed"
    else
        sudo apt-get install -y ${apt_extra[@]}
    fi

    _breakline
    ;;
fedora)
    _log "Installing packages with ${CYAN}dnf${NC}"

    _info "Core packages: ${dnf_core[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${dnf_core[@]}") >/dev/null; then
        _info "Core packages already installed"
    else
        sudo dnf install -y ${dnf_core[@]}
    fi
    _info "Extra packages: ${dnf_extra[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${dnf_extra[@]}") >/dev/null; then
        _info "Extra packages already installed"
    else
        sudo dnf install -y ${dnf_extra[@]}
    fi

    _breakline
    ;;
mac)
    _log "Installing packages with ${CYAN}brew${NC}"

    _info "Core packages: ${brew_core[@]}"
    if ! grep -v -f <(_get_installed $OS) <(printf '%s\n' "${brew_core[@]}") >/dev/null; then
        _info "Core packages already installed"
    else
        sudo brew install ${brew_core[@]}
    fi

    _breakline
    ;;
*)
    _error "Unknown operating system. Aborting"
    exit 1
    ;;
esac

# Install source packages
if ! command -v wezterm >/dev/null 2>&1; then
    case "$OS" in
    fedora)
        sudo dnf copr enable wezfurlong/wezterm-nightly
        sudo dnf install wezterm
        ;;
    debian)
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo apt-get update
        sudo apt-get install wezterm
        ;;
    esac
fi

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

    # return to dotfiles
    cd $DOTFILES
fi

if ! command fzf --version >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}fzf${NC}"
    if [[ ! -d $LOCALSRC ]]; then
        mkdir -p $LOCALSRC
    fi

    [[ -d $LOCALSRC/fzf ]] && rm -rf $LOCALSRC/fzf

    git clone --depth 1 https://github.com/junegunn/fzf.git $LOCALSRC/fzf
    $LOCALSRC/fzf/install --bin

    if [[ ! -d $LOCALBIN ]]; then
        mkdir -p $LOCALBIN
    fi
    for f in $(ls $LOCALSRC/fzf/bin); do
        cp $LOCALSRC/fzf/bin/$f $LOCALBIN
    done
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

if ! command -v gum >/dev/null 2>&1; then
    _log "Install from build script: ${CYAN}gum${NC}"
    if [[ $OS == "debian" ]]; then
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install gum
    fi
fi

_breakline

# Install or update Bitwarden CLI
. update_bw.sh

# Setup Bitwarden CLI
bw_session=${BW_SESSION:-}
debug=${DEBUG:-}
if [[ -z $bw_session ]] && [[ -z $debug ]]; then
    _log "Setting up Bitwarden CLI"
    export BW_SESSION=$(bw login --raw || bw unlock --raw)
    _breakline
fi

# Install fonts
. install_fonts.sh

# Install nerd-fonts
if [[ -z ${nerdfonts:-} ]]; then
    . install_nerdfonts.sh
fi

# Setup Github SSH keys
. setup_ssh.sh

# Clone dotfiles repo
. pull_dotfiles.sh

# Apply dotfiles
. stow_dotfiles.sh
