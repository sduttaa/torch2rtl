# Current result

**Accuracy meets the revised threshold; fabric-memory-only 30 FPS is not achieved.**
The compiler now produces full-model RTL and CP-SAT schedules with independently
checked constraints and RTL transfer deadlines. A four-bit-activation candidate
now completes **full-model placement, routing and bitstream packing**, with setup
and hold checks passing with a generated 135 MHz clock using an explicitly corrected nextpnr database.
Its weights and activations fit fabric memory. Its 0.656095 validation Dice
meets the user's revised >= 0.65 threshold. Thirty-FPS throughput remains unmet; the toolflow harness has not been run as inference on a physical board.

## Accuracy and deployment scope

The user now accepts **validation Dice >= 0.65**, superseding the earlier
baseline-matching requirement. Training experiments below retain their original
comparisons; the current priority is 30 sustained FPS.

| Model | Validation Dice | Constants | Status |
| --- | ---: | ---: | --- |
| Supplied integer export | 0.676843 | 291,240 bytes | Baseline; contains FP32 computation and exceeds the tested fabric-storage budget |
| Best retrained full-range INT8 | 0.667590 | 27,576 bytes | Integer export verified; meets revised accuracy threshold |
| Retrained INT8 weights / four-bit hidden activations | 0.656095 | 27,576 bytes | Routes with fabric-only storage; accuracy accepted, 30 FPS unmet |

The retained full-range model matches QAT on all 246 supplied images and its
serialized export on all 49 validation images. It has no floating-point tensor
nodes, passes torch-mlir verification, and matches complete RTL outputs for three
images under backpressure using oversized verification FIFOs. The existing validation split has been
used to select many experiments; no independent test set was supplied.
Batch-wide Dice loss improves the previous 0.667115 score slightly to 0.667590.
Decision calibration and lighting augmentation did not improve their starting
checkpoint. Per-channel activation calibration also falls short:
0.663091 Dice for full-range INT8 and 0.656158 for four-bit hidden activations.
Both pass all 246 QAT/integer and 49 saved-export comparisons and verify through
torch-mlir. [Training evidence](docs/training-results.md).

Two lower-operation architectures complete 300 epochs each, reducing direct work
to 128.6M and 165.0M MACs. Their floating-point Dice scores are only 0.647327 and
0.644617; neither is adopted. Training-only threshold calibration of the best
INT8 checkpoint retains zero and its existing 0.667590 score.
An 80-epoch focal-loss continuation also retains the exact starting checkpoint;
its integer/export and torch-mlir checks pass, with no accuracy improvement.

The user requires **both weights and activations in FPGA fabric memory**.
SDRAM is excluded. The selected target remains explicit input in
`inputs/target.json`: 46 BRAM blocks, 20,736 LUT equivalents, 15,552 FFs,
96 byte-multiplier slots and 41,472 distributed-memory bits. Board names,
resource budgets, model details and clocks are not compiler lookup tables.

## Latest scheduling and RTL evidence

The latest accepted candidate achieves **21.56 scheduled FPS** at a generated
**135 MHz**, with full routing, timing checks and bitstream packing complete.
CP-SAT proves its **6,262,820-cycle** fixed-choice period, and all scheduled
transfers pass three-frame bit-exact RTL replay. Native final use is 14,756 LUT4,
4,382 ALU, 5,932 FF, 46 BRAM, 59 multiplier slots and 22,784 distributed-memory
bits. Its **0.656095 Dice meets the revised accuracy threshold**. Thirty FPS
and physical-board inference remain unverified. A 150 MHz attempt fails timing;
it is not counted as a throughput result.
[Current scheduling, timing and artifact evidence](docs/direct-scheduling.md#compact-pooling-fifos-at-135-mhz).

A subsequent generic constant-based optimization removes unused requantizer
paths, saving **1,199 LUT equivalents and 125 registers** in a faster allocation
without changing its numerical outputs or cycle count. All **448 tests** pass.
That faster allocation still fails physical placement, so 21.56 FPS remains the
verified result. [Implementation evidence](docs/direct-scheduling.md#coefficient-aware-multiplier-sharing).

The preceding 108 MHz result is retained below for comparison.

Retiming the fused pooling comparison and eliminating unreachable non-pooling
hardware preserve all numerical results while improving physical timing. An
externally supplied **108 MHz PLL clock** now routes and packs a bitstream with
explicit reference/output constraints and timing checks enabled. The verified
**9,630,209-cycle** period gives **11.21 scheduled FPS**, with all storage in
fabric. Native utilization is 14,457 LUT4, 4,336 ALU, 5,908 FF, 46 BRAM and
59 multiplier slots, plus 19,200 distributed-memory bits. This is a toolflow
harness result, without physical-board inference or real input transport.
The model's Dice remains 0.656095. The full regression suite passes **442 tests**.
[Retiming, clock and provenance evidence](docs/direct-scheduling.md#retimed-pooling-and-generated-inference-clock).

An additional Lovász-loss training continuation retains all 58 starting state
tensors and the same accuracy; complete integer/export and torch-mlir checks pass.
A new pool-row FIFO diagnostic proves a 6,160,715-cycle schedule and fits whole-core
synthesis using distributed RAM, but its first physical placement attempt fails.
It is not yet a routed throughput result.

The preceding resize-only implementation provides the comparison below.

Generic overlapping resize buffers improve the routed candidate's throughput
by **45.40%**, to **2.804 FPS at 27 MHz**, without increasing BRAM use. CP-SAT
proves its **9,630,209-cycle** fixed-choice period; all 3,024,739 offsets pass
independent checking and three bit-exact RTL frames meet every transfer deadline.
Placement, routing and bitstream packing succeed with all timing checks enabled.
Final use is **17,269 LUT sites, 5,915 FFs, 46 BRAMs and 64 multiplier slots**,
plus 19,200 distributed-memory bits. Reported setup Fmax is **78.296 MHz**;
that clock and physical-board inference have not been demonstrated.
The model's Dice remains 0.656095. [Row-buffer contracts, tests and physical
evidence](docs/direct-scheduling.md#overlapping-resampling-rows).

The previous single-row result provides the comparison below.

The combined `-noalu -nowidelut` mapping completes full place-and-route after
correcting a nextpnr RAM timing-table generator error. The controlled original
database run reproduces 376 hold violations; the corrected database restores
missing dual-port address checks and passes without suppressing timing errors.
The final report uses **17,197 LUT sites, 5,911 FFs, 46 BRAM blocks and 64 byte
multiplier slots**, plus 19,200 distributed-memory bits. Bitstream packing succeeds.

CP-SAT proves a **14,002,180-cycle minimum period** for these fixed actor/FIFO
choices, with all 3,024,739 event offsets independently checked. This is
**1.928 FPS at the configured 27 MHz**. The reported setup limit is 75.654 MHz,
but no clock at that rate or physical-board inference has been demonstrated.
Three images pass bit-exact RTL replay with every scheduled transfer on time.
This remains the lower-accuracy four-bit-hidden graph. [Route, timing correction
and artifact evidence](docs/direct-scheduling.md#complete-place-and-route-result).

Moving selected weight ROMs into logic permits doubling either large skip FIFO
within whole-core synthesis capacity, but both three-image simulations retain
the same interval. Those allocations provide no measured throughput gain.

Pipelining the generic packed row memory reduces its refill latency, with
simulation assertions and three induction proofs checking collision freedom.
CP-SAT proves a **14,007,135-cycle optimum** for the smaller-logic fixed
configuration. All 3,024,739 offsets pass the independent checker and every RTL
transfer deadline is met across three images. This improves throughput by about
0.77% for that configuration but would still require **420.21 MHz** for 30 FPS.

After remeasuring 198 packed actor options, a new selection uses 18,853 packed
LUT sites, 46 BRAM blocks and 64 multiplier slots. It produces three bit-exact
frames at 14,002,180-cycle intervals, then fails placement with the default
mapping. The combined mapping above resolves that placement failure.
[Row-memory and placement evidence](docs/direct-scheduling.md#pipelined-packed-row-memory).

A four-input-LUT synthesis mapping reduces packed use to 18,155 LUT sites and
progresses through 20 placement iterations, but the diagnostic is interrupted
after 929 seconds without completing placement/routing. Disabling carry cells
instead uses 17,780 LUT sites and still fails placement. These experiments do
not establish physical fit. The mapping flags are now explicit target inputs.

### Earlier full-range candidate

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
- **429 tests pass**, including numerical overflow, branches, backpressure,
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
CP-SAT now proves **12,978,517 cycles** optimal for this fixed actor/FIFO
configuration within the stated caps, and full RTL meets all scheduled deadlines
on three images. Interval branching reduces the solver check to about 24.6
seconds. Its validation Dice remains 0.656095, and it does not meet 30 FPS.

The smaller-logic allocation with depth-eight shallow FIFOs produces three
bit-exact images at **14,114,637-cycle intervals**. It packs at **18,954/20,736 LUT
sites, 46/46 BRAM blocks and 70/96 multiplier slots**, then fails placement.
Increasing shallow depth from two to eight improves throughput by only about
1.96%. That earlier allocation has no routed clock or board inference measurement.

- [Implementation and reproduction](docs/implementation.md)
- [Installed toolchain](docs/toolchain.md)
- [Full-model diagnostic schedule and RTL verification](docs/direct-scheduling.md)
- [Fusion proof and synthesis measurements](docs/convolution-pool.md)
- [Original-export feasibility analysis](docs/workload-feasibility.md)
- [Goal audit and remaining requirements](docs/goal-audit.md)
- [Test log](build/tests-resize.log)
