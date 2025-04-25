#!/usr/bin/env bash

# Initialize a new system, automatically.
# Paolo Bignardi - 2025

# Source common config and utils
source utils.sh

function print_logo() {
    # Display init.sh info
    STYLE="\033[1;32m"
    RESET="\033[0m"
    cat << "EOF"
         _       _ __         __
        (_)___  (_) /_  _____/ /_
       / / __ \/ / __/ / ___/ __ \
      / / / / / / /__ (__  ) / / /
     /_/_/ /_/_/\__(_)____/_/ /_/

EOF
    echo -e "${STYLE}init.sh${NC} -- Initialize a new system, automatically"
    echo "version $VERSION"
    echo
}

# Clear and print logo
clear
print_logo

# Determine system
test "$(identify_system)" == "" && _error "Unsupported system" && exit 1
_info "Identified OS: $(identify_system)"

# Query for personal information
if [[ -f .data.sh ]]; then
    _log "Load configuration details from ${ITALIC}.data.sh${NOITALIC}"
    source .data.sh
fi
if [[ -z ${email:-} ]] || [[ -z ${name:-} ]]; then
    _error "Edit .data.sh file and re-run $0"
    exit 1
fi

# Install packages with platform package manager
case "$(identify_system)" in
    opensuse) . zypper.sh;;
    fedora) . dnf.sh;;
    arch) . pacman.sh;;
esac

. build_scripts.sh

# Install or update Bitwarden CLI
. update_bw.sh

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

# setup SSH
. _scripts/setup_ssh.sh

# Clone dotfiles repo
. _scripts/pull_dotfiles.sh

# Apply dotfiles
. create_symlinks.sh
