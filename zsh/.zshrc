export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin

# Add Homebrew to PATH on MAC (in the future move to different STOW)
if [[ $(uname -s) == "Darwin" ]]; then
    export PATH=$PATH:/opt/homebrew/bin
fi

# Load autocompletion on ZSH
autoload -Uz compinit
compinit

# Import aliases
source $HOME/.zsh_aliases

# oh my posh enabling
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/oneminimal.toml)"
eval "$(zoxide init zsh)"

# source fzf theme
source $HOME/.config/fzf/fzf-moonfly.conf

# setup fzf
eval "$(fzf --zsh)"

# setup bitwarden autocompletion
eval "$(bw completion --shell zsh); compdef _bw bw;"

# setup pyenv and pyenv-virtualenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Initialize juliaup
path=('/Users/paolo/.juliaup/bin' $path)
export PATH

# setup ZSH PLUGINS
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlight/zsh-syntax-highlighting.zsh

# Scripts binds
bindkey -s ^f "tmss\n"
bindkey -s ^b "tmsm\n"
