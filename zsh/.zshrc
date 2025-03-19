export PATH=$PATH:$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

autoload -Uz compinit
compinit

# ALIASES
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias vim=nvim
alias ss='tmss'
alias sm='tmsm'

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

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/paolo/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# setup ZSH PLUGINS
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlight/zsh-syntax-highlighting.zsh
