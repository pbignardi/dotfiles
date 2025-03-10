#!/bin/bash

#        __      __            __
#   ____/ /___  / /_________  / /___  ______
#  / __  / __ \/ __/ ___/ _ \/ __/ / / / __ \
# / /_/ / /_/ / /_(__  )  __/ /_/ /_/ / /_/ /
# \__,_/\____/\__/____/\___/\__/\__,_/ .___/
#                                   /_/
#
# Automatic dotfiles configuration
# Paolo Bignardi - 2025

# import utility functions
source utils.sh

# this could be stored somewhere else
work_key_id="98a1d33a-2ad2-4493-900a-b29b008b1619"
desktop_key_id="98a1d33a-2ad2-4493-900a-b29b008b1619"
mac_key_id="6c23c708-c997-45b8-86ca-b29b008b730d"

base_deps="git jq cmake stow zsh"
common_pkgs="neovim tmux fzf ripgrep go alacritty juliaup uv oh-my-posh"
linux_pkgs="$common_pkgs zathura firefox"
mac_pkgs="$common_pkgs skim"

## packages provided by each package manager
# mac apps
mac_brews="neovim tmux fzf ripgrep go oh-my-posh gum"
mac_casks="alacritty skim"

# apt packages
apt_pkgs="ripgrep go zathura firefox"

# dnf packages
dnf_pkgs="fzf neovim alacritty tmux ripgrep go zathura firefox gum"

# pacman packages
pacman_pkgs="fzf neovim alacritty tmux ripgrep go zathura firefox gum"

# zypper packages
zypper_pkgs="fzf neovim alacritty tmux ripgrep go zathura firefox gum"

#####################
# BASE DEPENDENCIES #
#####################

install_base_dependencies () {
    # if all dependencies are installed, skip
    missing=""
    for d in $(echo $base_deps); do
        [[ ! $(type ${d} >/dev/null 2>&1) ]] && missing+="$d "
    done
    [[ $missing == "" ]] && return

    # install dependencies on mac
    if [[ $(uname -s) == "Darwin" ]]; then
        missing=""
        for d in $(echo $base_deps); do
            if is_installed_brew $d; then missing+="$d "; fi
        done
        echo $missing

        [[ $missing == "" ]] && return
        brew install $(echo $missing)
        return
    fi
    # install dependencies on rhel/fedora
    if [[ $(type dnf >/dev/null 2>&1) ]]; then
        sudo dnf -y install $(echo $base_deps)
        return
    fi
    # install dependencies on debian/ubuntu
    if [[ $(type apt >/dev/null 2>&1) ]]; then
        sudo apt -y install $(echo $base_deps)
        return
    fi
    # install dependencies on arch
    if [[ $(type pacman >/dev/null 2>&1) ]]; then
        sudo pacman --noconfirm -S $(echo $base_deps)
        return
    fi
    # install dependencies on opensuse
    if [[ $(type zypper >/dev/null 2>&1) ]]; then
        sudo zypper install -y $(echo $base_deps)
        return
    fi
}

install_homebrew ()
{
    # check if homebrew is already installed
    type brew >/dev/null 2>&1 && return

    # ignore installation on linux
    [[ $(uname -s) == "Linux" ]] && return

    # install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_bitwarden_cli ()
{
    # check for bw cli
    type bw >/dev/null 2>&1 && return

    # installing bitwarden
    cd $LOCALBIN
    if [[ $(uname -s) == "Darwin" ]]; then
        wget "https://bitwarden.com/download/?app=cli&platform=macos" -O bw.zip
    else
        wget "https://bitwarden.com/download/?app=cli&platform=linux" -O bw.zip
    fi
    unzip bw.zip
    rm bw.zip
    chmod +x bw
    cd

    # login and store session token
    export BW_SESSION=$(bw login --raw)
}

install_bitwarden_desktop () {
    # check for bitwarden
    if [[ $(uname -s) == "Darwin" ]]; then
        brew install --cask bitwarden
    fi
    if [[ $(type dpkg >/dev/null 2>&1) ]]; then
        # install bitwarden on deb/ubuntu distro
        cd $LOCALSRC
        wget "https://bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -O bw.deb
        sudo dpkg -i bw.deb
        cd
    fi
    if [[ $(type rpm >/dev/null 2>&1) ]]; then
        # install bitwarden on rpm-based distro
        cd $LOCALSRC
        wget "https://bitwarden.com/download/?app=desktop&platform=linux&variant=rpm" -O bw.rpm
        sudo rpm -i bw.rpm
        cd
    fi
    if [[ $(type pacman >/dev/null 2>&1) ]]; then
        sudo pacman -S --noconfirm bitwarden
    fi

    # point to socket
    export SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock

    print_log 3 "Open Bitwarden desktop and enable SSH Agent"
    read -p "Once done, press enter to continue"



}

#####################
# BUILD FROM SOURCE #
#####################

# build neovim from source
_build_neovim () {
    # ignore if nvim command is already provided
    type nvim >/dev/null 2>&1 && return

    # installing neovim dependencies
    print_log 3 "Installing dependencies"
    if [[ $(type apt >/dev/null 2>&1) ]]; then
        sudo apt -y install ninja-build gettext cmake curl build-essential
    elif [[ $(type dnf >/dev/null 2>&1) ]]; then
        sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra
    elif [[ $(type pacman >/dev/null 2>&1) ]]; then
        sudo pacman --noconfirm -S base-devel cmake ninja curl
    elif [[ $(type zypper >/dev/null 2>&1) ]]; then
        sudo zypper install -y ninja cmake gcc-c++ gettext-tools curl
    fi

    if [[ ! -d $LOCALSRC ]]; then
        mkdir $LOCALSRC
    fi

    cd $LOCALSRC
    print_log 3 "Cloning repo"
    git clone https://github.com/neovim/neovim

    # use neovim stable branch
    git checkout stable

    # build
    print_log 3 "Building"
    make CMAKE_BUILD_TYPE=Release
    # install
    print_log 3 "Install"
    sudo make install

    # return to home
    cd
}

# install fzf from binaries
_build_fzf () {
    # ignore if fzf command is already provided
    type fzf >/dev/null 2>&1 && return

    print_log 3 "Cloning repo"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

# install uv
_build_uv () {
    # ignore if uv command is already provided
    type uv >/dev/null 2>&1 && return

    curl -LsSf https://astral.sh/uv/install.sh | sh
}

# install juliaup
_build_juliaup () {
    # ignore if juliaup command is already provided
    type juliaup >/dev/null 2>&1 && return

    curl -fsSL https://install.julialang.org | sh
}

# install ohmyposh
_build_ohmyposh () {
    # ignore if oh-my-posh command is already provided
    type oh-my-posh >/dev/null 2>&1 && return

    # install only on linux
    if [[ $(uname -s) == "Linux" ]]; then
        curl -s https://ohmyposh.dev/install.sh | bash -s
    fi
}

# build and install
build_pkg () {
    # first argument is package name
    pkg_name=$1

    # pkg install dispatcher
    if [[ $pkg_name == "neovim" ]]; then
        _build_neovim
    elif [[ $pkg_name == "fzf" ]]; then
        _build_fzf
    elif [[ $pkg_name == "uv" ]]; then
        _build_uv
    elif [[ $pkg_name == "juliaup" ]]; then
        _build_juliaup
    elif [[ $pkg_name == "oh-my-posh" ]]; then
        _build_ohmyposh
    fi
}

#########################
# PACKAGES INSTALLATION #
#########################

install_mac_pkgs () {
    brews=""
    casks=""
    buildable=""

    pkg_list=$(brew list -1 --full-name)

    for pkg in $mac_pkgs; do
        [[ $(echo $pkg_list | grep $pkg) ]] && continue
        if [[ $mac_brews == *"$pkg"* ]]; then
            brews+="$pkg "
        elif [[ $mac_casks == *"$pkg"* ]]; then
            casks+="$pkg "
        else
            type $pkg >/dev/null 2>&1 && continue
            buildable+="$pkg "
        fi
    done

    # install brews and casks with bundle
    if [[ $brews != "" ]]; then
        print_log 2 "Installing brews: $brews"
        brew install $(echo $brews)
    fi

    # install casks
    if [[ $casks != "" ]]; then
        print_log 2 "Installing casks: $casks"
        brew install --casks $(echo $casks)
    fi

    # build pkgs
    for pkg in $buildable; do
        print_log 2 "Building and installing $pkg"
        build_pkg $pkg
    done
}

install_dnf_pkgs () {
    installable=""
    buildable=""

    pkg_list=$(dnf list installed)

    for pkg in $linux_pkgs; do
        [[ $() ]] && continue
        if [[ $dnf_pkgs == *"$pkg"* ]]; then
            installable+="$pkg "
        else
            buildable+="$pkg "
        fi
    done

    # install dnf packages
    if [[ $installable != "" ]]; then
        print_log 2 "Installing packages: $installable"
        sudo dnf install -y $(echo $installable)
    fi

    # build pkgs
    for pkg in $buildable; do
        print_log 2 "Building and installing $pkg"
        build_pkg $pkg
    done
}

install_apt_pkgs () {
    installable=""
    buildable=""

    pkg_list=$(dpkg --get-selections)
    for pkg in $linux_pkgs; do
        [[ $(is_installed_apt $pkg) ]] && continue
        if [[ $apt_pkgs == *"$pkg"* ]]; then
            installable+="$pkg "
        else
            buildable+="$pkg "
        fi
    done

    # install dnf packages
    if [[ $installable != "" ]]; then
        print_log 2 "Installing packages: $installable"
        sudo apt install -y $(echo $installable)
    fi

    # build pkgs
    for pkg in $buildable; do
        print_log 2 "Building and installing $pkg"
        build_pkg $pkg
    done
}

###########################
# CONFIGURATION FUNCTIONS #
###########################

_ssh_key_github () {
    # if we can ssh to github, exit
    [[ $(ssh -T git@github.com >/dev/null 2>&1) ]] && return
    # if there exists a github key, exit
    [[ -e $HOME/.ssh/github ]] && return

    # retrieve the ssh key from bw
    if [[ $PROFILE == "work" ]]; then
        ssh_key_id=$work_key_id
    elif [[ $(uname -s) == "Darwin" ]]; then
        ssh_key_id=$mac_key_id
    elif [[ $(uname -s) == "Linux" ]]; then
        ssh_key_id=$desktop_key_id
    fi

    # retrieve private key and put into github file
    bw get item $ssh_key_id | jq -r '.notes' > $HOME/.ssh/github

    # change permission to private
    chmod 600 $HOME/.ssh/github
}

setup_ssh () {
    _ssh_key_github
    # leave room for other ssh config
}

setup_dotfiles () {
    if [[ ! -d $HOME/dotfiles ]]; then
        # clone git@github.com:pbignardi/dotfiles $HOME/dotfiles
        cd $HOME/dotfiles
    else
        cd $HOME/dotfiles
        # set ssh as default remote
        # git remote add github git@github.com:pbignardi/dotfiles.git
        # git branch --set-upstream-to github/main
    fi
    stow */
    cd
}

#################
# HELP FUNCTION #
#################

help () {
    cat << EOF
dotsetup.sh -- Automated system configuration script

Usage:
    bash dotsetup.sh [options]

Available options:
    --help          Show this help message
    --pull          Pull latest dotfile configuration
    --push          Push latest dotfile configuration

EOF
}

#################
# MAIN FUNCTION #
#################

init ()
{
    ## 0) Initial checks
    local_bin_path
    [[ $(uname -s) == "Darwin" ]] && install_homebrew
    install_base_dependencies
    install_bitwarden_cli

    ## 1) select if personal or work computer
    profile=""
    while true; do
        read -p "\nIs this your work computer? [ y/N ] " yn
        case $yn in
            [Yy]* ) profile="work"; break;;
            # [Nn]* ) profile="personal"; break;;
            * ) profile="personal"; break;;
        esac
    done
    export PROFILE=$profile
    print_log 2 "Selected profile: ${GREEN}$profile${NC}"

    ## 2) Install packages
    if [[ $(uname -s) == "Darwin" ]]; then
        install_mac_pkgs
    elif [[ $(type apt) ]]; then
        install_apt_pkgs
    elif [[ $(type dnf) ]]; then
        install_dnf_pkgs
    fi

    ## 3) Configure SSH keys
    setup_ssh

    ## 4) Clone dotfiles
    setup_dotfiles

    ## Reset BW_SESSION token
    unset BW_SESSION
    unset PROFILE
}

main () {
    # Run help
    [[ $1 == "--help" ]] && help && return

    # Run init
    [[ $1 == "" ]] || [[ $1 == "--init" ]] && init && return
}

init
