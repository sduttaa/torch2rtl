#!/bin/sh
# Keep the vendor app, dependent libraries and macOS cache inside the project.
set -eu
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
gowin_dir="$project_dir/.tools/gowin/GowinIDE.app/Contents/Resources/Gowin_EDA/IDE"
export CFFIXED_USER_HOME="$project_dir/.tools/gowin/state"
export QT_QPA_PLATFORM=offscreen
export DYLD_LIBRARY_PATH="$gowin_dir/lib"
export DYLD_FRAMEWORK_PATH="$gowin_dir/lib"
mkdir -p "$CFFIXED_USER_HOME/Library/Caches/GowinSemi/IDE"
exec "$gowin_dir/bin/gw_sh" "$@"
