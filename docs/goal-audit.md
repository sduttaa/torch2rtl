# Full-goal audit

## Current scope after the user's deployment decision

The user now accepts validation Dice >= 0.65, superseding the earlier requirement
to match the 0.676843 baseline. Both weights and activations must remain in FPGA
fabric memory. The current 0.656095 candidate meets the revised accuracy threshold;
30 sustained FPS is still mandatory. Accuracy experiments are no longer the priority.
The goal remains **active and incomplete**. No new user authorization is needed
for the ongoing work; no external/user-input blocker has been established.

The best verified full-range integer candidate remains **0.667590 Dice**, with
27,576 bytes of constants. All 246 QAT/integer and 49 saved-export comparisons
pass, along with torch-mlir and three-image RTL verification using oversized
verification FIFOs. An 80-epoch focal-loss continuation retains exactly the same
58 state tensors and score. The existing validation split has been used for
many choices; no independent test set was supplied. [Training evidence](training-results.md).

The newest verified result is **21.56 scheduled FPS at a generated 135 MHz**,
with 0.656095 Dice and fabric-only weights/activations. Complete CP-SAT proves
6,262,820 cycles for the fixed choices, and three bit-exact RTL frames meet every
transfer deadline. Placement, routing, timing and bitstream packing pass.
There is no physical-board inference measurement. Faster rebalanced candidates
reach 4.58M and 4.94M cycles in simulation but exceed packed logic capacity with
the default carry mapping; implementation work continues on that limit.
[Latest evidence](direct-scheduling.md#compact-pooling-fifos-at-135-mhz).

The preceding result is retained below for comparison.

The current verified physical result uses a generated **108 MHz** clock and
provides **11.21 scheduled FPS** from the unchanged 9,630,209-cycle complete
CP-SAT proof. Three frames are bit-exact and meet every transfer deadline. The
full graph's PLL harness routes and packs with explicit clock constraints and
all timing checks enabled. Native utilization is 14,457 LUT4, 4,336 ALU,
5,908 FFs, 46 BRAMs, 59 multiplier slots, 19,200 distributed-memory bits and one
PLL. There is no physical-board inference or real image transport demonstration.
Accuracy remains 0.656095 Dice. An 80-epoch Lovász continuation retains the
starting checkpoint without improvement. All **442 regression tests** pass.
[Current physical and scheduling evidence](direct-scheduling.md#retimed-pooling-and-generated-inference-clock).

A further FIFO allocation proves a 6,160,715-cycle period and fits whole-core
synthesis; its first routing attempt fails placement. It remains a diagnostic,
not an adopted physical throughput result. Useful implementation progress
continues; the accurate 30-FPS goal remains active and incomplete.

The historical results below retain the accuracy comparisons used when they were
run. Their former baseline-matching acceptance criterion is superseded.

The latest generic resize-buffer option improves throughput by **45.40%** while
retaining fabric-only weights and activations. The complete CP-SAT model proves
a **9,630,209-cycle** period for the fixed configuration; all 3,024,739 offsets
pass independent checking, and three bit-exact RTL frames meet every scheduled
transfer deadline. The full-model harness routes and packs a bitstream with
timing checks enabled. It uses 17,269 LUT sites, 5,915 FFs, 46 BRAMs, 64 multiplier
slots and 19,200 distributed-memory bits. At 27 MHz it provides **2.804 FPS**.
Reported setup Fmax is 78.296 MHz, with no faster clock or physical-board inference
demonstrated. Accuracy remains 0.656095 Dice. The regression suite passes
**429 tests**. [Latest proof and route evidence](direct-scheduling.md#overlapping-resampling-rows).

The preceding single-row implementation provides the comparison below.

A lower-accuracy four-bit-hidden candidate now completes full-model placement,
routing and bitstream packing. Its final report uses 17,197 LUT sites, 5,911 FFs,
46 BRAM blocks, 64 multiplier slots and 19,200 distributed-memory bits. Both
weights and working storage are in fabric. Timing checks pass at 27 MHz using
an explicit locally corrected nextpnr database. The correction moves dual-port
B-address timing from an incorrect single-port entry to the proper dual-port
entries. The original database control reproduces 376 hold violations; the
corrected database restores missing checks and passes without disabling checks.
All eight speed grades and 14 B-address bits pass the timing-table regression.
[Physical toolflow and correction evidence](direct-scheduling.md#complete-place-and-route-result).

The complete CP-SAT model proves 14,002,180 cycles optimal for this fixed
configuration within the stated caps. All 3,024,739 event offsets are independently
checked, and the emitted RTL is byte-identical to the routed input. Three
bit-exact RTL frames meet every scheduled transfer deadline. At the configured
27 MHz, the period gives 1.928 inferences/s. The reported setup limit is 75.654
MHz, but no clock at that rate or physical-board inference has been tested.
The routed graph scores only 0.656095 Dice. Thus physical toolflow progress does
not meet the required accuracy or 30-FPS throughput.

Thirty-nine additional actor memory mappings yield 26 successful measurements.
Moving selected ROMs into logic permits doubling either large skip FIFO within
whole-core synthesis capacity, but neither three-image simulation improves the
14,002,180-cycle interval. The solver mathematics is unchanged. The complete
regression suite passes 385 tests. FP32 actors and a full board transport remain
incomplete. Board/model details remain explicit inputs, and no model-specific
compiler rule has been introduced.

These are verified implementation and toolchain advances, not a complete goal
or a repeated no-progress blocking condition.

The historical audit below concerns the original supplied export. It is not an
impossibility theorem about retrained models or other hardware implementations.

## Original-export audit

The objective remains compiling the supplied INT8 export for the selected FPGA
at 30 sustained inferences per second using generic implementations and fabric
memory only. This audit does not substitute the small integration kernel for
that objective.

| Requirement | Current evidence | Result |
| --- | --- | --- |
| Use the supplied model | Input SHA-256 still matches `build/workload/analysis.json` | Confirmed unchanged |
| Use the selected target as input | `inputs/target.json` matches the target captured in the report | Confirmed unchanged |
| Import through torch-mlir | Verified complete Torch backend-contract module in `build/workload/model.mlir` | Passed |
| Compile the actual model to RTL | Direct invocation recorded in `build/workload/compile-attempt.log` rejects its FP32 input; there is no requested-model RTL | Incomplete |
| Keep constants and working state in fabric memory | Constant encoding catalogue is CP-SAT-infeasible even with a generous storage allowance; replay candidates also exceed RAM | No feasible candidate in the documented architecture/catalogue |
| Close timing and achieve 30 FPS for this model | No full-model placed/routed artifact, simulation throughput, or board measurement exists | Unproven |
| Avoid model-specific implementation rules | Compiler operates on graph operators, shapes, dtypes and supplied target data; the original model was not edited | Preserved in current work |
| Schedule and size FIFOs inside CP-SAT | Generic adapter and integer-kernel tests exercise both; full-model actor lowering is absent | Foundation verified, full model incomplete |

The latest direct compile attempt fails with:

```text
error: RTL subset requires a static integer tensor; got !torch.vtensor<[1,3,256,505],f32>
```

This explicitly identifies missing FP32 coverage. Implementing FP32 actors alone
would not resolve the independently verified storage conflict. The full model has
291,240 bytes of constants, the tested per-tensor encoding catalogue bottoms out
at 271,633 bytes, and available fabric RAM is 111,168 bytes. The first direct
normalization replay is 517,120 bytes. Index-only view regeneration reduces the
largest replay candidate to 4,128,768 bytes. The [feasibility report](workload-feasibility.md)
states the scope and limitations of those accounting models; they are not a
universal impossibility theorem about all circuits.

The same storage/deployment conflict has persisted through the initial discovery,
the generic compression/view-replay investigation, and this fresh input/target
and compile audit. The preceding investigation made progress by testing additional
generic candidates. The current audit confirms the conflict remains; no process
or external job is still running to resolve it.

At the time of this audit, the goal was blocked pending the deployment decision requested from the
user. The actionable choices are to authorize an evaluated model/quantization
change, change the hardware/memory constraint, or explicitly choose further
architecture research under unchanged constraints without a promised 30-FPS
result. The user subsequently authorized model retraining as recorded above.
The goal is not complete.
