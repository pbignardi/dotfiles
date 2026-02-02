#!/usr/bin/env bash

# export SSH_AUTH_SOCK variable
if [[ $(uname -s) == "Linux" ]]; then
    export SSH_AUTH_SOCK=$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
elif [[ $(uname -s) == "Darwin" ]]; then
    export SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock
fi
