# [ Path set ]
# Add Homebrew to PATH
export PATH=/opt/homebrew/bin:$PATH
# export PATH=/usr/local/bin:$PATH
export PATH=~/.local/bin:$PATH
# Add local rbenv to path
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
# Add python with pyenv
export PATH=$(pyenv root)/shims:$PATH
# Add matlab to PATH
export PATH="/Applications/MATLAB_R2023b.app/bin/:$PATH"

# [ evals ]
# Activate Oh-my-posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
	eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/pseudorussel.omp.json)"
fi
# Execute RBENV automatically
eval "$(rbenv init - zsh)"

# [ aliases ]
# config alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# alias ls -la 
alias lla='ls -la'
# Replace vim with neovim
alias vim=nvim
# alias tmux for appropriate color
alias tmux="TERM=screen-256color-bce tmux"
