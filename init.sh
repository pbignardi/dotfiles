#!/bin/bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

source common.sh
source packages.sh

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

# Update system
update_packages

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

# Install packages
# base deps
install_packages ${BASE_PACKAGES[@]}
# common pkgs
install_packages ${CORE_PACKAGES[@]}
# specific packages
if [[ $wsl == true ]]; then
    install_packages ${WSL_EXTRAS[@]}
elif [[ $os == "mac" ]]; then
    install_packages ${MAC_EXTRAS[@]}
else
    # TODO move adding repository somewhere else
    if [[ "$OS" == "fedora" ]]; then
        echo "ciaooo"
        sudo dnf copr enable wezfurlong/wezterm-nightly
    fi
    install_packages ${LINUX_EXTRAS[@]}
fi

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

# Install source packages
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
