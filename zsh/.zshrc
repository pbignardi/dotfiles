export PATH=$PATH:$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# bitwarden ssh agent
export SSH_AUTH_SOCK=/Users/paolo/.bitwarden-ssh-agent.sock

# setup ZSH PLUGINS
# source $HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

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
# WSL ALIASES

# MAC ALIASES



# oh my posh enabling
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/oneminimal.toml)"
eval "$(zoxide init zsh)"

# source fzf theme
source $HOME/.config/fzf/fzf-jellybeans.conf

# setup fzf
eval "$(fzf --zsh)"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/paolo/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

#
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list ''
zstyle :compinstall filename '/Users/paolo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
