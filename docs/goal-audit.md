# Full-goal audit

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

The goal is blocked pending the deployment decision already requested from the
user. The actionable choices are to authorize an evaluated model/quantization
change, change the hardware/memory constraint, or explicitly choose further
architecture research under unchanged constraints without a promised 30-FPS
result. No such change has been assumed. The goal is not complete.
