"""Keep the downloaded CAD suite's runtime state inside its installation."""

from pathlib import Path

suite = Path(__file__).resolve().parents[1] / ".tools" / "oss-cad-suite"
replacements = {
    'export XDG_CONFIG_HOME=$HOME/.config/yosyshq':
        'export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$release_topdir_abs/../config}"',
    'export XDG_CACHE_HOME=$HOME/.cache/yosyshq':
        'export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$release_topdir_abs/../cache}"',
    'export XDG_DATA_HOME=$HOME/.local/share/yosyshq':
        'export XDG_DATA_HOME="${XDG_DATA_HOME:-$release_topdir_abs/../data}"',
    'mkdir -p $HOME/.config/yosyshq $HOME/.local/share/yosyshq':
        'mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"',
}
for path in (suite / "bin").iterdir():
    if not path.is_file() or path.is_symlink():
        continue
    raw = path.read_bytes()
    if not raw.startswith(b"#!/"):
        continue
    source = raw.decode()
    updated = source
    for original, replacement in replacements.items():
        updated = updated.replace(original, replacement)
    if source != updated:
        path.write_text(updated)
        print("Localized", path.name)
