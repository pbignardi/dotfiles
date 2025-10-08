export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin

# Set systemd editor
export SYSTEMD_EDITOR=nvim

# setup ZSH PLUGINS
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlight/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-completions/zsh-completions.plugin.zsh
source $HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh

autoload -U compinit && compinit

# ZSH options
HISTSIZE=5000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Keybinds
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

# Add Homebrew to PATH on MAC (in the future move to different STOW)
if [[ $(uname -s) == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Import aliases
source $HOME/.zsh_aliases

# oh my posh enabling
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/oneminimal.toml)"

# source fzf theme
source $HOME/.config/fzf/theme.conf
export FZF_DEFAULT_COMMAND='fd'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# setup fzf
eval "$(fzf --zsh)"

# setup zoxide
eval "$(zoxide init zsh)"

# setup batcat
eval "$(batcat --completion zsh)"

# use vivid for LS_COLORS
export LS_COLORS="$(vivid generate one-dark)"

# setup xum sessionizer
# eval "$(xum zsh)"
bindkey -s "^b" "xum create^M"
bindkey -s "^f" "xum switch^M"


# setup pyenv and pyenv-virtualenv
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Initialize juliaup
export PATH=$PATH:$HOME/.juliaup/bin

# source SSH configuration script
source $HOME/.ssh/.setup-ssh.sh

# run fastfetch
if command -v fastfetch &> /dev/null; then
    echo
    fastfetch
fi
