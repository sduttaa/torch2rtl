#!/usr/bin/env bash
# Build the installed upstream frontend, not the torch2rtl compiler.
set -euo pipefail
cd "$(dirname "$0")/.."
source ./env.sh

frontend_source="$TORCH2RTL_ROOT/.tools/src/torch-mlir"
frontend_build="$TORCH2RTL_ROOT/.tools/build/torch-mlir"
build_jobs="${BUILD_JOBS:-4}"

uv pip install --python "$TORCH2RTL_ROOT/.venv/bin/python" \
  -r "$frontend_source/build-requirements.txt" \
  -r "$frontend_source/externals/llvm-project/mlir/python/requirements.txt"

cmake -G Ninja -S "$frontend_source/externals/llvm-project/llvm" \
  -B "$frontend_build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX="$TORCH2RTL_ROOT/.tools/torch-mlir" \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_TARGETS_TO_BUILD=host \
  -DLLVM_EXTERNAL_PROJECTS=torch-mlir \
  -DLLVM_EXTERNAL_TORCH_MLIR_SOURCE_DIR="$frontend_source" \
  -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
  -DPython_EXECUTABLE="$TORCH2RTL_ROOT/.venv/bin/python" \
  -DPython3_EXECUTABLE="$TORCH2RTL_ROOT/.venv/bin/python" \
  -DTORCH_MLIR_ENABLE_PYTORCH_EXTENSIONS=OFF \
  -DTORCH_MLIR_ENABLE_JIT_IR_IMPORTER=OFF \
  -DTORCH_MLIR_ENABLE_STABLEHLO=OFF \
  -DTORCH_MLIR_ENABLE_TOSA=OFF \
  -DTORCH_MLIR_ENABLE_REFBACKEND=OFF

cmake --build "$frontend_build" --parallel "$build_jobs" \
  --target TorchMLIRPythonModules torch-mlir-opt FileCheck

# Register the locally built Python package with this environment only.
frontend_package="$frontend_build/tools/torch-mlir/python_packages/torch_mlir"
test -d "$frontend_package/torch_mlir"
python - "$frontend_package" <<'PY'
import pathlib
import sys
import sysconfig

package = pathlib.Path(sys.argv[1]).resolve()
site_packages = pathlib.Path(sysconfig.get_path("purelib"))
(site_packages / "torch_mlir_local.pth").write_text(str(package) + "\n")
PY
mkdir -p "$TORCH2RTL_ROOT/.tools/bin"
ln -sfn "$frontend_build/bin/torch-mlir-opt" "$TORCH2RTL_ROOT/.tools/bin/torch-mlir-opt"
ln -sfn "$frontend_build/bin/FileCheck" "$TORCH2RTL_ROOT/.tools/bin/FileCheck"
python -c 'import torch; import torch_mlir; print("PyTorch:", torch.__version__); print("torch-mlir:", torch_mlir.__file__)'
