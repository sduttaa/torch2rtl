# torch2rtl

PyTorch export → torch-mlir → streaming hardware actors → SystemVerilog.

The objective is a small, generic compiler for fast FPGA inference with all
weights and working storage on chip. The first board is the Tang Nano 20K.
Lattice support follows through the same actor and optimization interfaces.

**Status: automatic compilation meets 35 BRAMs, 17,527 routed logic sites and
35.0000 scheduled FPS at 108 MHz.** Validation Dice remains 0.6500655. The routed
timing limit is 110.51 MHz; all weights and activations use fabric memory.
This is a compiler/simulation/timing result, not a physical-board FPS measurement.
Architecture, buffering and scheduling are compiler-selected from explicit
model/target/search inputs. Evidence is in
[the automatic result](results/automatic-throughput/README.md).
The previous [35-BRAM / 30.70-FPS result](results/bram-reduction/README.md) is preserved.
The previous [44-BRAM](results/compiler-optimization/README.md) and
[46-BRAM](results/on-chip-inference/README.md) results are preserved.
Generic architecture search, physical-memory costing, compact
resize/concat/convolution fusion, and joint scheduling are documented in
[compiler improvements](docs/compiler-improvements.md).
The current 35-BRAM / 18,000-site / 35-FPS target is met. The earlier 50-FPS
stretch objective remains unmet. [Automatic search](docs/automatic-throughput.md),
[template improvements](docs/template-quality.md) and
[resource attribution](docs/resource-use.md) describe the implementation.
Exact threshold quantization, source-buffer reuse and the final timing changes
are documented in [BRAM reduction](docs/bram-reduction.md).
The [workload findings](docs/workload-feasibility.md) concern the original,
larger export. Training is documented in [the training directory](training/README.md).

- [Optimization proposal](docs/optimization-model.md)
- [Current results](RESULTS.md)
- [Joint scheduling and FIFO mathematics](docs/scheduling-model.md)
- [Toolchain setup](docs/toolchain.md)
- [Implemented subset and verification](docs/implementation.md)
- [Spatial RTL and full-model simulation](docs/spatial-backend.md)
- [Spatial scheduling catalogue and solver limits](docs/spatial-scheduling.md)
- [Optimized full-model schedule and narrower FIFOs](docs/direct-scheduling.md)

All project-specific installations, source dependencies, environments, caches,
and build outputs live in this directory under Documents. Existing Apple
developer tools supply the native compiler and SDK.

## Principles

- Prefer a few parameterized actor families and explicit data contracts.
- Use generic shape- and dtype-based rules, never model-name special cases.
- Fuse only when legality and a conservative benefit are established.
- Select finite legal hardware configurations with a solver-independent problem;
  initially translate it to OR-Tools CP-SAT.
- Measure sustained throughput after routing and verify numerical correctness.
- Unsupported semantics and models that cannot fit must fail clearly.
- All board/model specifics are user inputs; no board/model lookup tables.
- FP32 with permitted reduction reassociation and explicit numerical validation.
- Schedule and size FIFOs directly in the solver; use fabric memory only.

## Run

On the configured Mac, compile and verify an exported model with:

```sh
source ./env.sh
python scripts/compile-and-verify.py --job inputs/automatic-job.json
```

For a compact presentation input, use the same compiler with:

```sh
python scripts/compile-and-verify.py --job inputs/demo-job.json
```

`demo-job.json` contains only `model`, `target` and `setup`. The setup file
supplies reusable search, toolchain and verification settings; fields in the
compact job override those defaults. All paths inside either file are relative
to the repository root, or absolute. Setup files contain complete settings;
nested setup references are not supported. The resolved job is saved with the
build. The supplied compact job resolves to exactly the same inputs as the full
job, including all acceptance checks and automatic architecture selection.

For a faster demo that skips the optional characterization refinement round:

```sh
python scripts/compile-and-verify.py --job inputs/demo-fast-job.json
```

This job uses `inputs/demo-fast-search.json`: `characterization_rounds` is 1
instead of 2. It retains 20 candidate options per actor, the same solver budget,
automatic buffer characterization and all verification checks. The original
profiles are unchanged. Less exploration can reduce the chance of finding an
implementation meeting the target; no speedup or successful fit is guaranteed.

The script creates a fresh directory under `build/` and runs automatic
compilation, simulation, mapping proofs, synthesis, routing and bitstream
packing. It prints resource usage, scheduled FPS and the paths to `harness.fs`,
`result.json` and `summary.txt` automatically. The supplied job contains the
model path, target, search, toolflow and matching verification evidence.
Each stage prints live progress and elapsed-time updates every 15 seconds while
running; full tool output remains in the build directory's `logs/` files.
Candidate synthesis resource reports print during characterization, marking
new and cached measurements. A resource proposal prints before joint scheduling,
and whole-design synthesis/packing utilization prints before placement/routing.
Those intermediate reports are labeled separately from final routed resources
and verified timing; they are not a completed-build certificate.
If routing misses the requested frequency, the flow continues verification and
reports `min(requested clock, routed Fmax) / inference period` as estimated FPS.
The report marks the missed target instead of failing the process for performance
alone. Numerical, capacity, hold-timing and other tool failures remain fatal.
A clock-missed result does not produce a flashable bitstream: the clock must be
adjusted and timing verified first. The report retains the nominal scheduled FPS
separately; neither number is a physical-board measurement.
The default solver limit is 600 seconds per solve, not a total build deadline;
override it with `--seconds`, and use `--build` or `--output` for explicit paths.
This job requires the existing local tool installation and retained verification
inputs. The bitstream uses a counter-source/checksum harness; camera/HDMI
integration and physical-board FPS measurements remain separate work.

For the lower-level compiler commands:

```sh
source ./env.sh
python -m torch2rtl inspect /path/to/model.pt2 \
  --target /path/to/target.json --fps 30 --output build/inspection
python -m torch2rtl compile /path/to/model.pt2 \
  --target /path/to/target.json --lanes 1 2 4 --depths 1 2 \
  --output build/compiled
pytest -q
```

The current RTL subset supports one integer tensor input, compatible pointwise
add/subtract/multiply, casts, clamp/ReLU, reshape and an optional final full-tensor
sum. It preserves intermediate integer widths, including wraparound. It reads
the verified torch-mlir module, fuses compatible pointwise operations, proves
integer ranges for narrower internal storage, synthesizes candidate hardware,
and solves the joint parameter/schedule/FIFO problem using CP-SAT.

The separate `emit-network` command now emits integer convolution, pooling,
nearest resampling, aligned concatenation and byte comparisons using explicit
actor/FIFO configurations. It supports branched raster networks and preserves
integer overflow and rounding. The `schedule-network` command translates these
actors into joint schedule/FIFO constraints from explicit cost catalogues; the
full-model schedule passes RTL deadline checks with finite fabric-only FIFOs.
The accepted implementation has a verified period of 3,085,714 cycles and uses
an explicitly corrected nextpnr database with configuration-specific DSP timing
guards. Earlier timing-coverage failures and results remain documented in
[the measured evidence](RESULTS.md).
Emission is not a fit certificate.
Proven clamp and lookup bounds narrow line, pooling, resampling and FIFO storage
while preserving byte tensor semantics. Training precision is always explicit.
Nearest-resampling actors accept `memories.row_buffers` to overlap row capture
and reads. Their ordered buffer reuse is included in the CP-SAT contract.
FIFO catalogue entries accept an explicit `memory` choice (`auto`, `block` or
`distributed`); emitted configurations preserve it in `fifo_memories` by edge.
Measure each placement's cost for the supplied target before solving.
The optional `"fusions": ["convolution_pool"]` configuration entry enables an
exact, proved convolution/max-pool fusion. See its [contract and measured
tradeoffs](docs/convolution-pool.md); it is not enabled by default.
The `resize_concat_convolution` fusion preserves nearest coordinate maps and
integer requantization while storing compact source rows. `optimize-network`
generates actor/FIFO alternatives from supplied search limits and memory modes,
caches isolated synthesis, and passes the retained choices to joint CP-SAT.
FP32 actors and board transport integration also remain work to do.
Unsupported operations fail explicitly.
Scheduled throughput is labeled as such; it is not a physical-board measurement.
The solver interface is plain dataclasses; OR-Tools is confined to `cp_sat.py`.

`inputs/target.json` and `inputs/smoke.cst` materialize the user's initial board
selection as external data. They are never loaded by default. Compiler source
contains no board, pin, resource-budget or model-name lookup table.

Clock-aware builds, bounded characterization and the small regression suite are
available; see [timing, search and benchmarks](docs/timing-search-benchmarks.md). The existing
single-clock demo jobs remain valid. Use `inputs/demo-clock-job.json` for the
explicit two-clock, bounded-retry example, or run the inexpensive suite with:

```sh
python scripts/benchmark.py --target inputs/throughput-target.json --output build/benchmarks
```
