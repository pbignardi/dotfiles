#!/usr/bin/env bash

# Install Windows packages with winget
# Paolo Bignardi - 2025

packages=(
    "wez.wezterm"
    "albertony.npiperelay"
    "astral-sh.uv"
    "Git.Git"
    "TortoiseGit.TortoiseGit"
    "Bitwarden.Bitwarden"
    "Bitwarden.CLI"
    "ahrm.sioyek"
    "KDE.Okular"
    "Alacritty.Alacritty"
    "JanDeDobbeleer.OhMyPosh"
)
uninstalled=()

for pkg in "${packages[@]}"; do
    if ! winget.exe list --id "$pkg" &> /dev/null; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -eq 0 ]; then
    return
fi

for pkg in "${uninstalled[@]}"; do
    winget.exe install -e --id="$pkg" --silent --accept-package-agreements --accept-source-agreements
done
