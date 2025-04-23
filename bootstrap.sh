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
    echo -e "${STYLE}init.sh${RESET} -- Initialize a new system, automatically"
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
_log "Installing base dependencies"
install_packages ${BASE_PACKAGES[@]}

_log "Installing core packages"
install_packages ${CORE_PACKAGES[@]}

_log "Installing extra packages"
case "$(platform)" in
wsl) install_packages ${WSL_PACKAGES[@]} ;;
linux) install_packages ${LINUX_PACKAGES[@]} ;;
mac) install_packages ${MAC_PACKAGES[@]} ;;
esac

# Install packages from build_script directory
for s in $(ls build_scripts); do
    _log "Running $s build script"
    source build_scripts/$s
done

# Setup SSH

key_name=$(bw list items --search "Github SSH Key" 2>/dev/null | jq -r '.[] | .name' | gum choose --header="Choose SSH key" --cursor.foreground="6" --header.foreground="8")

if github_authenticated; then
    key_name=$(bw list items --search "Github SSH Key" 2>/dev/null | jq -r '.[] | .name' | gum choose --header="Choose SSH key" --cursor.foreground="6" --header.foreground="8")
    # | xargs -I bw get item "{}" 2>/dev/null | jq -r ".sshKey.privateKey"
fi

# Remove old dotfiles
_log "Deleting old dotfiles"
