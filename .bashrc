# oh my posh enabling
eval "$(oh-my-posh init bash --config $HOME/.config/oh-my-posh/pseudorussel.omp.json)"
# alias vim to neovim
alias vim=nvim
# alias config for dotfiles
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# alias ls -la 
alias lla='ls -la'

# add .local/bin to PATH
export PATH=$PATH:$HOME/.local/bin

# Load pyenv automatically 
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
