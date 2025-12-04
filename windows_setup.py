import os
import platform
import shutil
import sys
from pathlib import Path

appdata_local = Path(os.getenv("LOCALAPPDATA")).resolve()
appdata_roaming = Path(os.getenv("APPDATA")).resolve()
userprofile = Path(os.getenv("USERPROFILE")).resolve()

if not platform.system() == "Windows":
    print("Not a Windows system")
    sys.exit(0)


sources = {
    "nvim": Path() / "nvim" / ".config" / "nvim",
    "wezterm": Path() / "wezterm" / ".config" / "wezterm",
    "ohmyposh": Path() / "oh-my-posh" / ".config" / "oh-my-posh",
    "alacritty": Path() / "alacritty" / ".config" / "alacritty",
}

dests = {
    "nvim": appdata_local / "nvim",
    "wezterm": appdata_local / "wezterm",
    "ohmyposh": userprofile / ".config" / "ohmyposh",
    "alacritty": appdata_roaming / "alacritty",
}

source_to_dest = {s: d for s, d in zip(sources.values(), dests.values())}

for source, dest in source_to_dest.items():
    if dest.exists() and dest.is_dir() and not dest.is_symlink():
        shutil.rmtree(dest)

    if dest.is_symlink():
        dest.unlink(missing_ok=True)

    dest.symlink_to(source.resolve())
