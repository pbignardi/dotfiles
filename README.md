# Dotfiles
As in the [the Atlassian tutorial](https://www.atlassian.com/git/tutorials/dotfiles), 
I am using the alias `config` to refer to call git on a bare repo based in the 
`~/.cfg` directory.

## Use the setup
To install these dotfiles refer again to [the Atlassian tutorial](https://www.atlassian.com/git/tutorials/dotfiles). 

In short, clone the repo as bare to `~/.cfg`
```
git clone --bare https://github.com/pbignardi/dotfiles $HOME/.cfg
```
perform the checkout
```
config checkout
```
and DONE!
