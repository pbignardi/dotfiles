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
    .           .      .                     .
    |-. ,-. ,-. |- ,-. |- ,-. ,-. ,-.    ,-. |-.
    | | | | | | |  `-. |  |   ,-| | |    `-. | |
    ^-' `-' `-' `' `-' `' '   `-^ |-' :; `-' ' '
                                  |
                                  '

EOF
    echo -e "${STYLE}$0${NC} -- Initialize a new system, automatically"
    echo "version $VERSION"
    echo
}

# Clear and print logo
clear
print_logo

# Determine system
test "$(identify_system)" == "" && _error "Unsupported system" && exit 1
_info "Identified OS: $(identify_system)"

# create LOCALSRC, LOCALBIN
! [[ -d $LOCALSRC ]] && mkdir -p $LOCALSRC
! [[ -d $LOCALBIN ]] && mkdir -p $LOCALBIN

# Install packages with platform package manager
case "$(identify_system)" in
    opensuse) . packages/zypper.sh;;
    fedora) . packages/dnf.sh;;
    arch) . packages/pacman.sh;;
    mac) . packages/brew.sh;;
esac

# Add ~/.local/bin to PATH
export PATH=$PATH:$LOCALBIN

# Install packages with build script
for s in $(ls build_scripts); do
    . build_scripts/$s
done

# Change shell to ZSH
if [[ $SHELL != *"zsh"* ]]; then
    _log "Changing shell to ZSH"
    chsh -s $(which zsh) $USER
    _info "Change will take effect after logout"
fi

# setup SSH
. setup_ssh.sh

# Clone dotfiles repo
. pull_dotfiles.sh

# Create directories
. create_dirs.sh

# Apply dotfiles
. create_symlinks.sh
