# Current result

There is a working compiler foundation and a verified path from PyTorch export
through torch-mlir, CP-SAT, generated RTL, simulation, synthesis, placement/routing
and bitstream packing. **The requested full-model 30-FPS result is not achieved.**

| Work | Result |
| --- | --- |
| Local toolchain under Documents | Installed and verified, including native torch-mlir |
| Full supplied INT8 model → torch-mlir | Imports, lowers and verifies successfully |
| Joint schedule/FIFO/resource solver | Implemented behind a plain-data interface |
| Integer pointwise fusion and sum actors | Compile and simulate correctly |
| Tests | 33 passing |
| Generated integer integration kernel | Synthesizes, routes at 27 MHz, and packs |
| Full supplied model at 30 FPS | Not achieved; storage/semantic issues documented |
| Physical-board inference measurement | Not performed |

The integration kernel improves from a 14-cycle frame period with one lane to
five cycles with four lanes, selected by CP-SAT. Simulation confirms the periods.
That is a 2.8× improvement for this small test over its serial configuration;
it is not a performance claim for the full model or against another compiler.
The selected core uses 397 synthesis LUT-equivalents and 135 FFs under the
supplied cost rules. Routing the core in a test harness passes its 27-MHz target.

The full model contains 291,240 bytes of constants, while the selected target has
111,168 bytes of fabric RAM. Its dynamic activation quantization creates direct
FP32 replay buffers as large as 12,386,304 bytes, and its convolutions execute in
FP32 after dequantization. Merely changing reduction order does not resolve these
constraints. See [the detailed workload findings](docs/workload-feasibility.md).

The model/board/deployment tradeoff is queued for discussion. In the meantime,
the existing model is unchanged, and no board/model special cases were added to
compiler code. Target resources, clocks, parts, pins, candidate lane counts and
FIFO depths are explicit inputs.

- [Implementation and reproduction](docs/implementation.md)
- [Installed toolchain](docs/toolchain.md)
- [Full-model machine-readable analysis](build/workload/analysis.json)
- [Verified full-model MLIR](build/workload/model.mlir)
- [Integration compile result](build/acceptance/compiled/compile.json)
- [Routed test-harness report](build/acceptance/physical/route-report.json)
- [Tests](build/tests.log)
