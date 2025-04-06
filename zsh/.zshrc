export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin

# setup ZSH PLUGINS
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlight/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-completions/zsh-completions.plugin.zsh

autoload -U compinit && compinit

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

# source fzf theme
source $HOME/.config/fzf/fzf-chalk.conf

# setup fzf
eval "$(fzf --zsh)"

# setup bitwarden autocompletion
eval "$(bw completion --shell zsh); compdef _bw bw;"

# setup pyenv and pyenv-virtualenv
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Initialize juliaup
export PATH=$PATH:$HOME/.juliaup/bin

# Scripts binds
bindkey -s ^f "tmss\n"
bindkey -s ^b "tmsm\n"
