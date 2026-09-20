# Source from bash or zsh. All added tools and caches remain under Documents.
if [ -n "${ZSH_VERSION:-}" ]; then
  TORCH2RTL_ROOT="$(cd -- "$(dirname -- "${(%):-%x}")" && pwd)"
else
  TORCH2RTL_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
fi
export TORCH2RTL_ROOT
export UV_CACHE_DIR="$TORCH2RTL_ROOT/.tools/cache/uv"
export UV_PYTHON_INSTALL_DIR="$TORCH2RTL_ROOT/.tools/python"
export UV_PYTHON_BIN_DIR="$TORCH2RTL_ROOT/.tools/bin"
export UV_TOOL_DIR="$TORCH2RTL_ROOT/.tools/uv-tools"
export UV_TOOL_BIN_DIR="$TORCH2RTL_ROOT/.tools/bin"
export PIP_CACHE_DIR="$TORCH2RTL_ROOT/.tools/cache/pip"
export XDG_CACHE_HOME="$TORCH2RTL_ROOT/.tools/cache"
export XDG_CONFIG_HOME="$TORCH2RTL_ROOT/.tools/config"
export XDG_DATA_HOME="$TORCH2RTL_ROOT/.tools/data"
export XDG_STATE_HOME="$TORCH2RTL_ROOT/.tools/state"
export TMPDIR="$TORCH2RTL_ROOT/.tools/tmp"
export TORCH_HOME="$TORCH2RTL_ROOT/.tools/cache/torch"
export PYTHONNOUSERSITE=1
unset PYTHONHOME
export VIRTUAL_ENV="$TORCH2RTL_ROOT/.venv"
export PATH="$TORCH2RTL_ROOT/.venv/bin:$TORCH2RTL_ROOT/.tools/uv-aarch64-apple-darwin:$TORCH2RTL_ROOT/.tools/bin:$TORCH2RTL_ROOT/.tools/oss-cad-suite/bin:$PATH"
