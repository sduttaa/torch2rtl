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
| Tests | 149 passing, including spatial RTL, overflow, backpressure and integer training/export |
| Generated integer integration kernel | Synthesizes, routes at 27 MHz, and packs |
| Full supplied model at 30 FPS | Not achieved; storage/semantic issues documented |
| Physical-board inference measurement | Not performed |

The complete **retrained** model now emits generic spatial RTL and matches its
integer reference on three real validation images, with and without random
stalls. Both observed inter-frame intervals were 4,582,512 cycles in the
two-lane simulation with oversized verification FIFOs. That interval would require 137.47536 MHz for
30 FPS, but its 6,213,376-byte logical FIFO allocation exceeds fabric memory.
No full-model routed clock or feasible buffer allocation has been established.
See [the spatial backend and reproduction](docs/spatial-backend.md).

The newest verified INT8 candidate reaches **0.663747 Dice**, with **27,576 bytes**
of constants and **240,583,680 MACs** per inference. It remains below the required
0.676843. The latest four-lane actor-only synthesis totals 23,968 LUT equivalents,
7,337 FFs, 98 byte-multiplier slots and 62 BRAM blocks, before graph FIFOs. This
configuration exceeds the supplied LUT, DSP and BRAM budgets and is not deployable.

The user authorized retraining while keeping weights and activations in fabric
memory. The compact verified replacement reaches **0.659503 validation Dice**,
below the supplied model's **0.676843**. Its constants total **26,988 bytes** and
its direct workload is **212,686,848 MACs per inference**: 10.8× smaller constants
and 12.0× fewer MACs than the original export. These are size/workload reductions,
not a measured speedup. The serialized model uses integer tensors throughout,
matches its QAT simulation on all 246 images, and imports through torch-mlir.
See [training results](docs/training-results.md) and the
[integer model report](build/training/cropped-integer/report.json).
A previous wider-context integer candidate reaches **0.660307 Dice** with 37,644
bytes of constants and 240,556,032 MACs per inference. All candidates remain below
the accuracy requirement.

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

Further generic checks did not bridge the gap. The tested per-tensor lossless
encoding catalogue needs 271,633 bytes and is CP-SAT-infeasible even under a
154,584-byte allowance that gives every LUT table and FF to storage. Regenerating
index-only views reduces the largest candidate replay payload to 4,128,768 bytes,
still much larger than fabric RAM. These results apply to the documented candidate
representations, not every conceivable compression or recomputation architecture.

The earlier deployment-decision blocker was removed by the user's retraining
approval. The goal remains active and incomplete; see the
[full-goal audit](docs/goal-audit.md). The existing model is unchanged, and no board/model special cases were added to
compiler code. Target resources, clocks, parts, pins, candidate lane counts and
FIFO depths are explicit inputs.

- [Implementation and reproduction](docs/implementation.md)
- [Installed toolchain](docs/toolchain.md)
- [Full-model machine-readable analysis](build/workload/analysis.json)
- [Verified full-model MLIR](build/workload/model.mlir)
- [Integration compile result](build/acceptance/compiled/compile.json)
- [Routed test-harness report](build/acceptance/physical/route-report.json)
- [Tests](build/tests.log)
