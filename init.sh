#!/usr/bin/env bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

source common.sh

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
fi

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

# Install homebrew on Mac
if [[ $OS == "mac" ]] && ! command -v brew >/dev/null 2>&1; then
    _log "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check if homebrew is on path
if ! [[ $PATH == *"homebrew"* ]]; then
    # add homebrew to path
    export PATH=$PATH:/opt/homebrew/bin
fi

# Update system
. _scripts/update_system.sh

# Install packages
. _scripts/install_packages.sh

# Setting gitconfig global options
_log "Setting .gitconfig file"
git config --global core.editor "nvim"
if ! [[ -z $name ]] && ! [[ -z $email ]]; then
    git config --global user.name "$name"
    git config --global user.email "$email"
fi

# Change shell to ZSH
if [[ $SHELL != *"zsh"* ]]; then
    _log "Changing shell to ZSH"
    chsh -s $(which zsh) $USER
    _info "Change will take effect after logout"
fi

# Install or update Bitwarden CLI
. _scripts/update_bw.sh

# Install nerd-fonts
if [[ -z ${nerdfonts:-} ]]; then
    . _scripts/install_nerdfonts.sh
fi

# setup SSH
. _scripts/setup_ssh.sh

# Clone dotfiles repo
. _scripts/pull_dotfiles.sh

# Apply dotfiles
. _scripts/stow_dotfiles.sh
