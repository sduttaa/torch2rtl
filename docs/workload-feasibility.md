# Requested workload: verified findings

The full supplied INT8 export imports and verifies through the native torch-mlir
frontend. **There is no 30-FPS implementation of this workload yet.** Its current
semantics and storage requirements conflict with the proposed direct streaming
implementation on the selected FPGA. Calling the file INT8 does not make all
of its computation integer.

The model is an input at
`/Users/Obi-wan/Documents/oneAI-scratches/OneAI.QuickStart/Projects/Scratches/Models/scratches_int8.pt2`.
The selected board is supplied separately in `inputs/target.json`; neither name
appears in compiler source code.

| Quantity | Measured from the export |
| --- | ---: |
| Stored INT8 weights | 284,704 bytes |
| All stored constants, including FP32 scales/biases | 291,240 bytes |
| Convolutions | 20, operating on FP32 tensors |
| Dynamic activation maximum reductions | 20 |
| First normalization's direct FP32 replay buffer | 517,120 bytes |
| Largest normalization's direct FP32 replay buffer | 12,386,304 bytes |
| Largest replay payload after regenerating index-only views | 4,128,768 bytes |
| Direct convolution work per inference | 2,558,324,736 MACs |
| Direct convolution work at 30 FPS | 76,749,742,080 MACs/second |
| Selected target BRAM + distributed RAM | 111,168 bytes |

The last figure comes from the [board manufacturer's resource specification](https://wiki.sipeed.com/hardware/en/tang/tang-nano-20k/nano-20k.html):
46 × 18-Kibit block RAMs plus 41,472 distributed RAM bits. SDRAM is excluded, as
requested. Physical packing, port/bank requirements, replication, actor state,
FIFOs and interface logic further restrict usable capacity.

## What the export actually computes

Before each convolution it computes a maximum over the whole activation tensor,
divides by 255, clamps the scale, rounds/clamps each activation into UINT8, then
converts those integers back into FP32 and multiplies by the dynamic scale.
Weights are similarly dequantized from their stored INT8 representation into
FP32. The convolution itself is FP32 and its bias is FP32. This is visible both
in the supplied training/export script and in the imported graph.

Changing the order of a reduction is permitted. Moving scale multiplications
outside a floating-point reduction and replacing it with integer accumulation
also changes multiplication/rounding boundaries. That transformation needs a
separate numerical contract; reduction reassociation alone does not authorize it.
Replacing the frame's maximum with a calibrated fixed scale changes the model.

## Why the whole-frame maximum matters

The maximum depends on the last word of the tensor. Earlier words cannot pass
through normalization with the final scale until that maximum is known. In the
agreed single-pass actor architecture, their values must be retained on the
bypass path. This is precisely the kind of dependency that joint scheduling and
FIFO occupancy must enforce; merely balancing MAC rates would miss it.

Even the first such FP32 buffer exceeds the available memory. The largest is
more than 100 times that memory, before storing weights or any other state.
Lossless coding or explicit recomputation is a different architecture that must
account for decoder state, input replay, storage and extra compute. The raw
constant count is **not** a proof against every conceivable compressed circuit.
Likewise, the MAC count is for direct convolution, not a lower bound over
Winograd, FFT or other algorithms. No universal impossibility claim is made.

A standard lossless compression probe also did not bridge the gap: all constants
compressed to 267,958 bytes with zlib and 265,868 bytes with LZMA, still over twice
the fabric RAM before decoder/workspace costs. These are software compression
measurements, not proposed random-access hardware implementations or lower bounds
on all possible encodings. Results are in `build/workload/compression-probe.json`.

## Additional generic storage checks

The inspector now compares raw, range-packed, fixed-palette, zero-bitmap and
canonical-Huffman payloads for each integer constant. It includes the described
codebooks, keeps floating-point constants unchanged, and optimistically omits
decoders, banking, alignment and selector costs. The smallest combination in this
catalogue is **271,633 bytes**. This differs from the cross-tensor software
compression measurements above because it uses independently encoded tensors.

CP-SAT returns **INFEASIBLE** for the storage-only selection problem even with a
generous **154,584-byte** allowance. That allowance assigns every LUT truth table
and every flip-flop to storage in addition to all fabric RAM. It leaves no
arithmetic resources and can double-count physically shared resources, favoring
feasibility. It is an optimistic accounting model for these stored representations,
not an information-theoretic limit on all possible circuits. The problem contains
only constant encoding choices and capacity; this failure does not arise from a
chosen schedule period or solver timeout. `build/workload/storage-problem.json`
records the solver-independent instance, and `analysis.json` records its result.

The inspector also considers retaining the sources of nearest-neighbor upsampling,
padding and other index-only views, regenerating those views when replayed. Shared
sources are counted once. This reduces the largest candidate replay payload from
12,386,304 to **4,128,768 bytes**; the first normalization still needs **517,120
bytes** in this representation. These are analysis candidates, not implemented
replay actors, and they do not recompute arithmetic or move floating-point rounding
boundaries. They still exceed the target's fabric RAM substantially.

## What requires a decision

The compiler can continue to grow generic operator coverage and optimization.
However, reaching the requested workload/board/FPS combination needs a change
in the deployment contract or compelling evidence for a substantially different
implementation architecture:

- Keep the current model semantics and select hardware with enough memory and
  arithmetic throughput, after proper sizing and routing.
- Keep this board and authorize a separately evaluated model/quantization
  conversion. Static activation quantization removes these dynamic replay
  barriers, but **alone does not solve weight capacity or compute demand**.
- Keep all current requirements and continue researching generic compression,
  recomputation and arithmetic implementations, with no promised 30-FPS result.

No model, weights, calibration, input shape or output semantics have been changed.

## Reproduce the findings

From the repository after sourcing `env.sh`:

```sh
python -m torch2rtl inspect \
  /Users/Obi-wan/Documents/oneAI-scratches/OneAI.QuickStart/Projects/Scratches/Models/scratches_int8.pt2 \
  --target inputs/target.json --fps 30 --output build/workload
```

`build/workload/analysis.json` contains every constant, convolution, reduction,
shape, dtype, the input SHA-256 and the target data. `model.mlir` contains the
verified torch-mlir backend-contract module. The analysis is based only on graph
operators, shapes and dtypes; it has no model-specific detection rules.
