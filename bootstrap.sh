#!/usr/bin/env bash
# Bootstrap system configuration
# Paolo Bignardi - 2025
function print_logo() {
    local STYLE="\033[1;32m"
    local RESET="\033[0m"
    cat <<"EOF"

    .           .      .                     .
    |-. ,-. ,-. |- ,-. |- ,-. ,-. ,-.    ,-. |-.
    | | | | | | |  `-. |  |   ,-| | |    `-. | |
    ^-' `-' `-' `' `-' `' '   `-^ |-' :; `-' ' '
                                  |
                                  '
EOF
    echo -e "${STYLE}bootstrap.sh${RESET} -- Initialize a new system, automatically"
    echo
}

# Display logo and script informations
clear
print_logo

# Source common utilities
source utils.sh

# Load configuration data
_log "Load configuration details"
! [[ -f .data.sh ]] && prompt_configuration >.data.sh
source .data.sh

# Install Homebrew on mac
if [[ "$(uname)" == "Darwin" ]] && ! command_exists brew; then
    _log "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Source package list
source packages.sh

# Install packages from package manager
case "$(platform)" in
wsl) EXTRA_PACKAGES=(${WSL_PACKAGES[@]}) ;;
linux) EXTRA_PACKAGES=(${LINUX_PACKAGES[@]}) ;;
mac) EXTRA_PACKAGES=(${MAC_PACKAGES[@]}) ;;
esac

_log "Installing base dependencies"
install_packages ${BASE_PACKAGES[@]}

_log "Installing core packages"
install_packages ${CORE_PACKAGES[@]}

_log "Installing extra packages"
install_packages ${EXTRA_PACKAGES[@]}

# Install packages from build_script directory
for s in $(ls build_scripts); do
    _log "Running ${CYAN}$s${NC}${BOLD} build script"
    source build_scripts/$s
done

# Login in Bitwarden
_log "Bitwarden login"
export BW_SESSION=$(bw login --raw || bw unlock --raw)
test -z ${BW_SESSION:-} && exit 1

# Setup SSH
if ! github_authenticated; then
    _log "Setup Github SSH Keys"
    if [[ -f $HOME/.ssh/github ]]; then
        mv $HOME/.ssh/github $HOME/.ssh/github.old
    fi

    GUM_OPTIONS="--header='Choose SSH key' --cursor.foreground='6' --header.foreground='8'"
    bw list items --search "Github SSH Key" 2>/dev/null | jq -r '.[] | .name' |\
        gum choose | xargs -I bw get item {} 2>/dev/null |\
        jq -r '.sshKey.privateKey' > $HOME/.ssh/github
fi

# Change shell to ZSH
if [[ "$SHELL" != *"zsh"* ]]; then
    _log "Change shell to ZSH"
    chsh -s $(which zsh) $USER
    _info "Change will take effect after logout"
fi
