#!/bin/bash

# Setup Github SSH keys
# Paolo Bignardi - 2025

source common.sh

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
    bw get item "$key_name" 2>/dev/null | jq -r ".sshKey.privateKey" >$HOME/.ssh/github
    # copy public key
    bw get item "$key_name" 2>/dev/null | jq -r ".sshKey.publicKey" >$HOME/.ssh/github.pub

    # set permissions for keys
    chmod 600 $HOME/.ssh/github
    chmod 644 $HOME/.ssh/github.pub

    # Update .ssh/config file
    if ! $(cat $HOME/.ssh/config >/dev/null 2>&1 | grep "Host github.com"); then
        _info "Updating ~/.ssh/config"
        echo "" >>$HOME/.ssh/config
        echo "Host github.com" >>$HOME/.ssh/config
        echo -e "\tIdentityFile ~/.ssh/github" >>$HOME/.ssh/config
    else
        _error "Could not update ~/.ssh/config file. Modify it manually before proceding"
        read -p "Press any key to continue"
    fi
fi
# return to dotfiles
cd $DOTFILES
