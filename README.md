# My *own* dotfiles 🏡

How I store my dotfiles and automate the setup.
The setup is based on `stow` to manage the configuation files
and simple `bash` scripts to automate the setup.

## Bootstrap
To setup these dotfiles, there are two options:

1. Using a the convenience script `init.sh`. This is fully automatic, but requires either `wget` or `curl`.
1. Manually cloning the repo.

### Option 1: `init.sh` script
If `curl` is available run
```bash
curl -s https://raw.githubusercontent.com/pbignardi/dotfiles/refs/heads/v2/init.sh | bash
```
If `wget` is available run
```bash
wget -qO- https://raw.githubusercontent.com/pbignardi/dotfiles/refs/heads/v2/init.sh | bash
```

### Option 2: Clone repo
If `git` is already installed, clone the repository and run the `bootstrap.sh` script with `bash`.

```bash
git clone -b v2 https://github.com/pbignardi/dotfiles $HOME/dotfiles
bash ~/dotfiles/bootstrap.sh
```

## What does `bootstrap.sh` do?

The `bootstrap.sh` script, performs some basic setup, to automate some of the configuration steps that are required on each system.
Dotfiles are assumed to be stored in the `~/dotfiles` directory,
and each program has its own Stow package.

The `bootstrap.sh` script performs the following actions:
- Preliminary steps
- For each system, configure the package manager and install the required packages
    - On Arch, run `packages/pacman.sh`
    - On Mac, run `packages/brew.sh`
    - On Debian/Ubuntu, run `packages/apt.sh`
    - On Fedora, run `packages/dnf.sh`
    - On desktop linux, run `packages/flatpak.sh`
    - On Windows, run `packages/winget.sh`
- Install [Bitwarden](https://bitwarden.com) password manager (CLI).
- TODO: Install `uv`
- Install `oh-my-posh`
- Change shell to ZSH
- Copy public SSH keys from the Bitwarden vault if variable `USE_SECRETS` is true.
- Set SSH remote to dotfiles repo.
- Pull dotfiles from Github
- Delete files that conflicts with `stow` packages
- `stow` dotfiles.
- TODO: copy Windows config files

*Why not using a dotfile manager?*
Well there are some good ones, but I feel like they are mostly overkill for what I actually need.
After having tried `chezmoi` I figured it was probably easier to maintain a simple script with all the steps I need to perform to setup a new computer with the software and configuration I need.

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
