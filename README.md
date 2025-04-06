# My *own* dotfiles 🏡

>[!WARNING]
> This is still a work-in-progress, use with caution.

How I store my dotfiles and automate the setup.
The setup is based on `stow` to manage the configuation files
and simple `bash` scripts to automate the setup.

*Why not using a dotfile manager?*
Well there are some good ones, but I feel like they are mostly overkill for what I actually need.
After having tried `chezmoi` I figured it was probably easier to maintain a simple script with all the steps I need to perform to setup a new computer with the software and configuration I need.

## Bootstrap

To automatically setup a new system, clone the repository and run the `init.sh` script with `bash`.

Clone the repo
```sh
git clone https://github.com/pbignardi/dotfiles $HOME/dotfiles
```
and run the setup script with
```sh
bash ~/dotfiles/init.sh
```

> [!CAUTION]
> The `init.sh` assumes a bare system, where almost nothing is installed.
> If you are running it not on a new system, **make sure to backup all your dotfiles before proceeding**.

## How does `init.sh` work?

The `init.sh` script, performs some basic setup, to automate some of the configuration steps that are required on each system.
Dotfiles are assumed to be stored in the `~/dotfiles` directory,
and each program has its own Stow package.

The `init.sh` script performs the following actions:
- Preliminary steps (a few questions, determining the operating system, setting `PATH`, etc...)
- *On Mac only* `brew` gets installed.
- Installation of base dependencies (e.g. `git`, `jq`, etc...).
- Installation (or update) of [Bitwarden](https://bitwarden.com) password manager (CLI).
- Login into Bitwarden CLI and set temporary session key.
- Installation of applications packages (e.g. `nvim`, `tmux`, `fzf`, etc...).
- Build from source packages that are not found (or not up to date) in the conventional repositories.
- Installation of Nerd fonts (JetBrainsMono and Recursive).
- Change shell to `zsh`.
- Copy Github SSH keys from the Bitwarden vault into the `~/.ssh` directory **only if ssh to Github fails**.
- Setting `~/.gitconfig` file.
- Set SSH remote to dotfiles repo.
- Clone and `stow` dotfiles.

Some of the action performed by `init.sh` are separated into different scripts which `init.sh` call.
For reference:
- `install_nerdfonts.sh`: checks for installed Nerd Fonts and install the missing ones.
- `pull_dotfiles.sh`: pulls new changes from the remote git repository.
- `stow_dotfiles.sh`: symlinks all the required dotfiles.
- `update_bw.sh`: checks for updates of Bitwarden CLI and installs them.
