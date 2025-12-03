import os
import platform
import shutil
import sys
from pathlib import Path

appdata_local = Path(os.getenv("LOCALAPPDATA")).resolve()
userprofile = Path(os.getenv("USERPROFILE")).resolve()

if not platform.system() == "Windows":
    print("Not a Windows system")
    sys.exit(0)


source_to_dest = {
    Path() / "nvim" / ".config" / "nvim": appdata_local / "nvim",
    Path() / "wezterm" / ".config" / "wezterm": appdata_local / "wezterm",
    Path() / "oh-my-posh" / ".config" / "oh-my-posh": userprofile
    / ".config"
    / "ohmyposh",
}

source = Path() / "nvim" / ".config" / "nvim"
dest = source_to_dest[source]

for source, dest in source_to_dest.items():
    if dest.exists() and dest.is_dir() and not dest.is_symlink():
        shutil.rmtree(dest)

    if dest.is_symlink():
        dest.unlink(missing_ok=True)

    dest.symlink_to(source.resolve())
