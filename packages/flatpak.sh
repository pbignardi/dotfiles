#!/usr/bin/env bash

# Install packages using flatpak
# Paolo Bignardi - 2025

packages=(
    "com.bitwarden.desktop"
    "com.github.ahrm.sioyek"
    "org.kde.okular"
    "org.telegram.desktop"
)
uninstalled=()

isFlatpakInstalled() {
    local app_id="$1"
    flatpak list --app --columns=application | grep -qx "$app_id"
}

# enable flathub remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# select uninstalled packages
for pkg in "${packages[@]}"; do
    if ! isFlatpakInstalled "$pkg"; then
        uninstalled+=("$pkg")
    fi
done

if [ ${#uninstalled[@]} -gt 0 ]; then
    echo "==> Installing flatpaks"
    echo "${uninstalled[@]}"

    for pkg in "${uninstalled[@]}"; do
        flatpak install flathub -y "$pkg"
    done
fi
