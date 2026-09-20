# Full-goal audit

## Current scope after the user's deployment decision

The user authorized training a smaller INT8 replacement if it matches or exceeds
0.676843 validation Dice, with both weights and activations in FPGA fabric memory.
The goal remains **active and incomplete**. This removes the earlier deployment
decision blocker; no new user authorization is needed for the ongoing work.

The best verified integer candidate now reaches **0.667590 Dice**, with 27,576
bytes of constants. It passes all 246 QAT/integer and 49 saved-export comparisons
and torch-mlir verification. The existing validation split has been used for
many architecture/checkpoint choices; there is no independent test set.
[Training evidence](training-results.md).

The generic packed row store now pipelines reads and writes, reducing refill
latency without changing the agreed scheduling/FIFO formulation. CP-SAT proves
a 14,007,135-cycle optimum for a fixed smaller-logic four-bit configuration;
all 3,024,739 offsets pass independent checking and all three RTL frames meet
their transfer deadlines. Three induction cases prove the row-access safety
properties. Remeasuring 198 actor options finds a smaller allocation, but it
still fails placement after packing 18,853 LUT sites, 46 BRAMs and 64 byte
multiplier slots. Its observed interval is 14,002,180 cycles and its Dice remains
0.656095. [Scheduling and placement evidence](direct-scheduling.md).

These are verified implementation and training advances, not a complete,
accurate 30-FPS design or a repeated no-progress blocking condition. The complete
suite passes 371 tests. No full-model routed clock, physical inference result,
or accuracy-qualified fabric-only deployment is available. Board/model specifics
remain explicit external inputs. The earlier fixed full-range schedule used
oversized FIFOs and does not establish fabric fit.

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
