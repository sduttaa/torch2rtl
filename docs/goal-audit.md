# Full-goal audit

## Current scope after the user's deployment decision

The user has authorized training a smaller INT8 replacement on the supplied
dataset, provided it matches or exceeds the existing model's accuracy. Both
weights and activations must remain in FPGA fabric memory; SDRAM is excluded.
This removes the earlier decision blocker. The goal is active and incomplete.
Interval branching now proves the fixed finite-FIFO candidate's 12,978,517-cycle
optimum, and all three frames meet their RTL deadlines. A smaller-logic candidate
passes aggregate packing capacity but fails placement. Per-channel activation
calibration produces verified integer exports without closing the accuracy gap.
The suite passes 363 tests. These changes make measured progress without meeting
the requested accurate, fabric-only 30-FPS result.
The latest [solver investigation](direct-scheduling.md) proves a 4,591,040-cycle
minimum period for a fixed full-model actor/FIFO configuration and verifies
every RTL input/output deadline over three images. It uses oversized FIFOs and
no resource budgets. Exact unused-lane removal also reduces measured FIFO
memory. A first joint solve with fabric budgets proves its finite catalogue
infeasible within the stated caps; it does not prove all hardware choices
infeasible. These are measured implementation advances. Accuracy, fabric fit
and physical 30 FPS remain unmet, and this turn is progress rather than a
repeated no-progress blocking condition.
The subsequent fabric candidate passes CP-SAT and RTL deadline checks at a
fixed fifteen-million-cycle period. Whole-design synthesis meets the supplied
resource estimates, but nextpnr packing requires 21,539 LUT sites against 20,736
available. Placement was stopped. This exposes a resource-accounting gap and
does not establish physical fit. The model's Dice remains 0.656095.
The latest exact convolution/pool fusion and implied window-path timing bounds
are documented in [the fusion report](convolution-pool.md). They add verified
implementation progress; they do not establish the missing accuracy, full-model
schedule, physical fit or 30-FPS result.
The subsequent [line-layout survey](window-layouts.md) measured 191 more
configurations and improved the same four-bit graph's observed RTL throughput
by about 4.6%, with bit-exact outputs. Its verification FIFOs remain oversized.
A targeted lighting-augmentation experiment did not improve accuracy. These
are completed investigations with useful measured progress, not a completed goal.
Training runs, exact integer verification and their limits are documented in
[the training notes](../training/README.md). The historical audit below applies
to the original export, not a theorem about retrained models.

The latest retrained export reaches 0.667115 Dice versus the required 0.676843.
Its complete graph now emits generic RTL and matches three real images in
simulation with backpressure. That simulation uses oversized FIFOs. Selected
actor costs also exceed LUT/BRAM budgets before graph FIFOs, even though
separate reduction parallelism brought one configuration within the DSP budget. Accuracy,
full-model joint scheduling/resource selection, fabric fit and full-design
timing remain incomplete. Spatial event contracts and their smaller-graph
solver/RTL deadline tests are now implemented; the full per-word scale probe
returned UNKNOWN within its limits. [Spatial evidence](spatial-backend.md) records these limits.
The target's DSP accounting now uses 96 byte-multiplier slots instead of 48
18-bit slots; the selected FPGA and physical capacities have not changed.

Further explicit six-bit and four-bit activation experiments did not improve
accuracy. Generic, exact range propagation nevertheless reduced a four-bit
actor configuration to 44 BRAM blocks and 20,300 LUT equivalents, before FIFOs.
Both mixed-precision graphs pass sampled full-model RTL verification. This is
implementation progress, not completion or a new no-progress blocker. The
[storage report](narrow-storage.md) preserves costs, model hashes, tests and limits.

The subsequent [option survey](option-survey.md) measured 191 convolution
configurations and improved the same mixed-precision graph's sampled RTL frame
interval by selecting different reduction/output widths. More QAT training did
not improve the best validation score. Exact cycle-sum bounds strengthen the
existing CP-SAT formulation, but full-model diagnostic searches still return
`UNKNOWN`. This turn produced measured progress; the complete goal remains
active and unproven.

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
