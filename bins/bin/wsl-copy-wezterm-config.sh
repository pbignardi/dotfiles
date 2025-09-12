#!/usr/bin/env bash

USERNAME=$(powershell.exe -NoProfile -Command "\$env:USERPROFILE" | tr -d '\r' | tr '\\' '/' | xargs -- basename)

# copy wezterm configuration
cp -r wezterm/.config/wezterm "/mnt/c/Users/$USERNAME/.config/"
