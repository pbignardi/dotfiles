# My *own* dotfiles
**This is still a work-in-progress, and as such should be treated**

How I store my dotfiles and automate the setup.
The setup is based on `stow` to manage the configuation files
and simple `bash` scripts to automate the setup.

*Why not using a dotfile manager?*
Well there are some good ones, but I feel like they are mostly overkill for what I actually need.
After having tried `chezmoi` I figured it was probably easier to maintain a simple script with all the steps I need to perform to setup a new computer with the software and configuration I need.

## Bootstrap
There are two possible way to automatically setup the dotfiles onto a new computer: cloning the repository or downloading and running the `dotsetup.sh` script.

### Cloning the repository
If `git` is already installed on the system, just clone the repo
```sh
git clone https://github.com/pbignardi/dotfiles $HOME/dotfiles
```
After this, run the setup script with
```sh
bash ~/dotfiles/dotsetup.sh
```

### Running the script directly
Using `curl`, just run
```sh
curl <INSERT LINK HERE> | bash
```

## How does it work?
Dotfiles are assumed to be stored in the `~/dotfiles` directory,
and each program has its own Stow package.
The `dotsetup.sh` script performs the following actions:
- Install `brew` (on Mac only).
- Install base dependencies (e.g. `git`, `jq`, etc...).
- Install [Bitwarden](https://bitwarden.com) password manager.
- Install applications packages (e.g. `nvim`, `tmux`, `fzf`, etc...).
- Copy SSH keys from the Bitwarden vault into the `~/.ssh` directory.
- Clone and `stow` dotfiles.
