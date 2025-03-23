# My *own* dotfiles
**This is still a work-in-progress, and as such should be treated**

How I store my dotfiles and automate the setup.
The setup is based on `stow` to manage the configuation files
and simple `bash` scripts to automate the setup.

*Why not using a dotfile manager?*
Well there are some good ones, but I feel like they are mostly overkill for what I actually need.
After having tried `chezmoi` I figured it was probably easier to maintain a simple script with all the steps I need to perform to setup a new computer with the software and configuration I need.

## Bootstrap
There are two possible way to automatically setup the dotfiles onto a new computer: cloning the repository or downloading and running the `init.sh` script.

### Cloning the repository
If `git` is already installed on the system, just clone the repo
```sh
git clone https://github.com/pbignardi/dotfiles $HOME/dotfiles
```
After this, run the setup script with
```sh
bash ~/dotfiles/init.sh
```

### Running the script directly
Using `curl`, just run
```sh
curl <INSERT LINK HERE> | bash
```

> [!IMPORTANT]
> The `init.sh` assumes a bare system, where almost nothing is installed.
> If you are running it not on a new system, **make sure to backup all your data before proceeding**.

## How does `init.sh` work?
The `init.sh` script, performs some basic setup, to automate some of the configuration steps that are required on each system.
Dotfiles are assumed to be stored in the `~/dotfiles` directory,
and each program has its own Stow package.

> [!NOTE]
> While the `init.sh` script is convenient, it is not strictly necessary. If you only want the *dotfiles* you can manually `stow` each Stow package. *You* will have to install packages and configure the system on your own.

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
