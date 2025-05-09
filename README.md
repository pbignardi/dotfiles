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

To automatically setup a new system, clone the repository and run the `bootstrap.sh` script with `bash`.

Clone the repo
```bash
git clone https://github.com/pbignardi/dotfiles $HOME/dotfiles
```
and run the setup script with
```bash
bash ~/dotfiles/bootstrap.sh
```

> [!CAUTION]
> The `bootstrap.sh` assumes a bare system, where almost nothing is installed.
> If you are running it not on a new system, **make sure to backup all your dotfiles before proceeding**.

## How does `bootstrap.sh` work?

The `bootstrap.sh` script, performs some basic setup, to automate some of the configuration steps that are required on each system.
Dotfiles are assumed to be stored in the `~/dotfiles` directory,
and each program has its own Stow package.

The `bootstrap.sh` script performs the following actions:
- Preliminary steps
- For each system, configure the package manager and install the required packages
    - On Arch, run `packages/pacman.sh`
    - On Mac, run `packages/brew.sh`
- Run scripts from `build_scripts/` directory
    - Install [Bitwarden](https://bitwarden.com) password manager (CLI).
    - Install `uv`
    - Install `oh-my-posh`
- Change shell to ZSH
- Copy Github SSH keys from the Bitwarden vault into the `~/.ssh` directory **only if ssh to Github fails**.
- Pull dotfiles from Github
- Set SSH remote to dotfiles repo.
- Delete files that conflicts with `stow` packages
- `stow` dotfiles.

## Extra: setup Archlinux WSL
Thankfullly there is a way to use Linux on Windows, using WSL.
Below I report some instructions on how to setup Archlinux on WSL, as instructed on [the ArchWiki](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL).

Installation is straightforward using
```ps1
wsl --install archlinux
```

Afterwards, install `sudo`, `sed` and create a user to avoid having to use root.
```bash
pacman -Syu sudo vi
useradd -m -G wheel -s /bin/bash USERNAME
```

Allow the wheel group to use sudo
```bash
visudo
```

Modify `/etc/wsl.conf` and add
```conf
[user]
default=USERNAME
```

Finally exit WSL and terminate it:
```ps1
wsl --terminate archlinux
```
