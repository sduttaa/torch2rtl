# Local toolchain

Project and all new installations are under
`/Users/Obi-wan/Documents/torch2rtl`. The project uses existing Apple Clang and the
Xcode SDK. It does not install packages into Homebrew or the system Python.

Activate the environment in bash or zsh:

```sh
cd /Users/Obi-wan/Documents/torch2rtl
source ./env.sh
```

This prepends the local executables and directs Python/package caches, temporary
files, Torch downloads, and XDG state into `.tools`. It does not modify shell
startup files. Source it in each new project terminal.

## Installed software

| Component | Installed version / source |
| --- | --- |
| OSS CAD Suite | Native darwin-arm64, release 2026-09-19 |
| Yosys | 0.69+75, f0b945f63 |
| nextpnr | 0.11.1-30-g3e53a0bf; iCE40, ECP5, Himbaechel and other bundled backends |
| IceStorm | Bundled icepack, iceunpack, icetime, iceprog and chip data |
| Trellis | Bundled ECP5 packing/programming tools and chip data |
| Apicula | Bundled gowin_pack, gowin_unpack and Gowin chip data |
| Verilator | 5.053 development build, v5.052-119-g014c9820d |
| Icarus Verilog | 14.0 development build, s20260301-474-g5591c2dde |
| openFPGALoader | 1.1.1 |
| uv | 0.12.17 |
| Python | Managed native CPython 3.11.16 |
| PyTorch | 2.15.0.dev20260917, as pinned by torch-mlir |
| OR-Tools CP-SAT | 9.15.6755 |
| Python build/test dependencies | Exact versions in `requirements.lock` |

The CAD archive's SHA-256 was checked against GitHub release metadata:

```text
01577fe50829202f76013a30606193134778f577b7a959618dc4ffe94c9a037e
```

Some upstream GUI-capable wrappers override XDG paths with home-directory
locations. `scripts/localize-cad.py` patches only those wrapper paths to honor
the local environment, so nextpnr also keeps its runtime state inside Documents.
It leaves the tool binaries unchanged.

The CAD suite's separate bundled Python also has NumPy, msgspec, and fastcrc installed
locally for faster Apicula packing. This is separate from the compiler's virtual
environment; the two interpreters do not mix package directories.

## torch-mlir native build

The current official development-wheel release has Linux and Windows wheels,
but no macOS wheel. The native source build is used instead.

Pinned sources:

| Repository | Commit |
| --- | --- |
| llvm/torch-mlir | 0d633318dbdd7c3ee80dbb4ed7b7d55e4103e221 |
| llvm/llvm-project | 10dbfc4863c9aea2fb237022c3f47fc24c02265e |
| openxla/stablehlo | 7b1b15781ccbd770f50c7eef4b0c3e03834649fd |

`scripts/build-frontend.sh` builds the native Python bindings, `torch-mlir-opt`,
and `FileCheck`. The required export/FX path does not need the old TorchScript
native importer, a reference execution backend, TOSA, or StableHLO, so those
optional components are disabled. LLVM/MLIR are built at the upstream-pinned
revision. Builds default to four jobs on this 16-GB Mac; `BUILD_JOBS` can override
that build setting.

Build/rebuild:

```sh
bash scripts/build-frontend.sh > build/frontend-build.log 2>&1
```

The Python binding is registered through a `.pth` file only in this project's
environment. Sources and build products remain in `.tools`. This builds an
upstream dependency, not the torch2rtl compiler.

The native build completed successfully. The full supplied exported model loads
with PyTorch, imports through `torch_mlir.fx.export_and_import`, lowers to the
Torch backend contract, and passes MLIR verification. The verified module is
`build/workload/model.mlir`. The compiler also uses this import path in its tests.

## Validation completed

- Native Yosys, nextpnr backends, simulators, and programmer executables run.
- OR-Tools solved a bounded integer smoke problem to its known optimum.
- `uv pip check` reports all Python dependencies compatible.
- Icarus executed a small SystemVerilog arithmetic/reset check successfully.
- Verilator lint passed on that SystemVerilog module.
- Yosys synthesized that module for iCE40 and ECP5.
- For the user's Tang Nano 20K selection, the upstream Apicula example passed
  Gowin synthesis, placement/routing at a supplied 27-MHz target, and bitstream
  packing. The device and constraints were passed as test inputs, not stored in
  compiler code. The resulting file is `build/toolchain-smoke/gowin.fs`.

No board has been programmed, and no physical-board inference measurement has
been made. Compiler-generated integer map/reduction RTL has now passed numerical
and handshake simulation as well as Gowin synthesis. The LED example does not
establish inference performance or broad primitive coverage.

## Reproducibility and files

- `.tools/downloads`: original release metadata, downloaded archives, upstream
  example/constraint inputs.
- `.tools/oss-cad-suite`: FPGA tools.
- `.tools/python`, `.venv`: isolated Python installation and packages.
- `.tools/src`, `.tools/build`: upstream frontend sources and native build.
- `requirements.lock`: frozen Python package versions. PyTorch requires the
  official nightly wheel index listed in upstream `pytorch-requirements.txt`.
- `toolchain.lock.json`: pinned upstream source revisions and CAD archive digest.
- `build/toolchain-smoke`: synthesis, routing, packing, and simulator logs.
- `build/frontend-build.log`: native compilation log.

Large tool installations and build outputs are ignored by Git. A board chosen
for a future compiler invocation must arrive as user input, including its
resources, part/package, clocks and pin constraints. There is no board database
or model-specific configuration in this repository's compiler code.

## Official references

- [OSS CAD Suite releases and installation](https://github.com/YosysHQ/oss-cad-suite-build)
- [nextpnr backends](https://github.com/YosysHQ/nextpnr)
- [Apicula Gowin flow](https://github.com/YosysHQ/apicula)
- [torch-mlir build guide](https://github.com/llvm/torch-mlir/blob/main/docs/development.md)
- [uv storage locations](https://docs.astral.sh/uv/reference/storage/)

IceStorm supports iCE40. ECP5 uses Trellis, and Gowin uses Apicula plus the
Himbaechel backend of nextpnr. Select the family-specific flow from user input.
