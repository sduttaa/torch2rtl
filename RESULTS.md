# Current result

**The requested accurate, fabric-memory-only 30-FPS design is not achieved.**
The compiler now produces full-model RTL and CP-SAT schedules with independently
checked constraints and RTL transfer deadlines. Accuracy, a resource-feasible
optimized schedule and full-design physical timing remain unresolved. A slower
four-bit-activation candidate now passes complete RTL simulation and whole-design
synthesis within the supplied budgets, but nextpnr packing exceeds LUT capacity.

## Accuracy and deployment scope

| Model | Validation Dice | Constants | Status |
| --- | ---: | ---: | --- |
| Supplied integer export | 0.676843 | 291,240 bytes | Baseline; contains FP32 computation and exceeds the tested fabric-storage budget |
| Best retrained full-range INT8 | 0.667115 | 27,576 bytes | Integer export verified; accuracy target unmet |
| Retrained INT8 weights / four-bit hidden activations | 0.656095 | 27,576 bytes | Smaller exact storage; accuracy target unmet |

The retained full-range model matches QAT on all 246 supplied images and its
serialized export on all 49 validation images. It has no floating-point tensor
nodes and passes torch-mlir verification. The existing validation split has been
used to select many experiments; no independent test set was supplied.
Further training, decision calibration and lighting augmentation did not improve
the retained checkpoint. [Training evidence](docs/training-results.md).

The user requires **both weights and activations in FPGA fabric memory**.
SDRAM is excluded. The selected target remains explicit input in
`inputs/target.json`: 46 BRAM blocks, 20,736 LUT equivalents, 15,552 FFs,
96 byte-multiplier slots and 41,472 distributed-memory bits. Board names,
resource budgets, model details and clocks are not compiler lookup tables.

## Latest scheduling and RTL evidence

CP-SAT proves a **4,591,040-cycle minimum period** for the full-range INT8 model's
fixed actor configuration and oversized verification FIFOs, within the reported
period/offset caps. All **4,091,235 event offsets** pass an independent check of
the original constraints. Full RTL accepts all 387,840 scheduled input words and
produces all 96,768 bit-exact output words at their deadlines across three images.

That schedule requires 137.7312 MHz for 30 FPS, but its actors already exceed the
LUT/BRAM budgets before graph FIFOs, and no full-design routed clock is available.
This is a scoped scheduling optimum, not a deployable result.
[Solver settings, exact FIFO narrowing and reproduction](docs/direct-scheduling.md).

For the four-bit graph, a separate measured actor/layout selection achieves an
observed RTL interval of about **3,807,732 cycles** with oversized FIFOs. This
would require about 114.23 MHz for 30 FPS. Its necessary resource/actor-rate
screen omits graph occupancy; it does not establish a feasible network schedule
or physical fit. [Layout measurements](docs/window-layouts.md).

## Implemented and verified

- Tools installed under Documents: PyTorch, native torch-mlir, OR-Tools, Yosys,
  nextpnr, IceStorm/Trellis/Apicula, Verilator, Icarus and openFPGALoader.
- Generic integer convolution, pooling, nearest resize, aligned concatenation,
  lookup and FIFO actors; independent output/reduction parallelism; exact range
  narrowing; optional proved convolution/max-pool fusion.
- Solver-independent periodic event contracts with actor choices, FIFO depths,
  occupancy and resource constraints in CP-SAT; every feasible result checked
  against the original model.
- **341 tests pass**, including numerical overflow, branches, backpressure,
  periodic schedules, signed storage, training and export.
- A small integration kernel synthesizes, routes at 27 MHz and packs a bitstream.
  That result is distinct from the requested full model. Physical-board inference
  has not been measured; FP32 actors and board transport remain incomplete.

Unused vector lanes are now omitted from FIFO storage using static tensor
shapes. Measured 2,048-word FIFOs use one BRAM block at eight bits and two at
16 bits. A complete candidate with all storage in fabric produces three bit-exact
frames at observed intervals of **12,978,517 cycles**. Whole-network synthesis
uses **43 BRAM blocks, 19,606 LUT equivalents, 6,795 FFs, 94 multiplier slots and
19,200 distributed-memory bits**, within the supplied budgets. Placement/routing
then exposes a physical overrun: packing requires **21,539 LUT sites versus
20,736 available**. Placement was stopped; physical fit remains unmet.
CP-SAT independently verifies every event and FIFO constraint for this same
candidate at a fixed **15-million-cycle period**, and full RTL meets its deadlines
on three images. This is a feasibility point under the catalogue cost estimates,
not an optimized throughput or physical-fit result. Its validation Dice remains
0.656095, and it does not meet the requested 30 FPS.

- [Implementation and reproduction](docs/implementation.md)
- [Installed toolchain](docs/toolchain.md)
- [Full-model diagnostic schedule and RTL verification](docs/direct-scheduling.md)
- [Fusion proof and synthesis measurements](docs/convolution-pool.md)
- [Original-export feasibility analysis](docs/workload-feasibility.md)
- [Goal audit and remaining requirements](docs/goal-audit.md)
- [Test log](build/tests.log)
