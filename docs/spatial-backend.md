# Spatial integer backend

The compiler can now emit the complete retrained segmentation graph through
verified torch-mlir: 13 quantized convolutions, three max pools, two nearest
resamplers, two scale-aligned channel joins, and a byte comparison. These are
generic operator/shape rules. No model names, layer names, board properties or
resource budgets participate in lowering.

This is an explicit-configuration emitter. The existing CP-SAT backend still
needs the spatial actors' event contracts and resource-option catalogues wired
into it. Emitting RTL does not establish a feasible schedule or hardware fit.

## Verified full-graph result

The wider-stem INT8 model has validation Dice **0.6637466**, below the required
**0.6768431**, with **27,576 bytes** of constants. Its exported integer graph has
240,583,680 direct MACs per inference. See the
[training report](../build/training/wide-stem-integer/report.json).

Three validation images with positive annotations were checked through the
original integer graph, fused graph and serialized export. All 21 common
intermediates and the final masks matched. Full-network RTL then matched all
96,768 output pixels across the three frames, including random input/output
stalls. This is a numerical RTL check on three images, not hardware validation
of the entire accuracy dataset.

The two-lane configuration's two observed inter-frame intervals were
**4,582,512 cycles** without stalls. That interval would require
**137.47536 MHz** for 30 FPS. The four-lane configuration
also passes full-model simulation. Neither result establishes the full design's
routed clock, long-run throughput certificate or physical-board throughput.

The numerical test deliberately allocates one full frame per graph edge. The
two-lane allocation totals **6,213,376 bytes of logical FIFO capacity**, far above
the selected FPGA's fabric RAM. These are simulated fabric FIFOs, not SDRAM.
They are a verification allocation and must not be presented as a deployable
memory configuration. The user still requires all weights and activations in
fabric memory.

Individually synthesizing the actors also exposed excessive LUT and BRAM use.
Sharing window-memory read ports, using circular window banks, simplifying
static indices, removing zero products, and proving arithmetic widths all
preserve the integer contract. The current synthesis reports retain the exact
costs; summing actor costs excludes graph FIFOs and is not a whole-design fit
or routing proof.

For the current four-lane exploration configuration, the actor-only total is
23,968 LUT equivalents, 7,337 FFs, 98 byte-multiplier slots, 62 BRAM blocks and
28,800 distributed-RAM bits. It exceeds the supplied LUT, DSP and BRAM budgets
even before graph FIFOs. This measured failure is not a proof that every legal
parameter/memory-mapping choice is infeasible.

## Numerical and streaming contracts

- Streams carry raster pixels, then channel vectors. Unused lanes in the last
  vector of each pixel are zero. Tensor semantics remain NCHW.
- Convolution supports signed/unsigned byte inputs, signed byte weights, groups,
  rectangular kernels, stride, padding and dilation. Group boundaries must align
  with the selected input vector width; width one always satisfies this condition.
- INT32 accumulation and the graph's INT64 multiply/add/shift/clamp/cast are
  preserved, including overflow. Proven narrower widths use modular arithmetic
  only where the final value remains exactly representable. The dot-product
  multipliers are reused for byte-Horner requantization.
- Ordinary convolution and a complete integer unfold/matmul convolution both
  normalize to the same actor. Observable intermediate branches prevent fusion.
- Max pooling supports floor output geometry and explicit signed padding minima.
  `ceil_mode` is rejected. Nearest and nearest-exact resampling preserve the
  original static size/scale-factor rules and retain one source row.
- Concatenation preserves each branch's explicit integer scale alignment. Byte
  truth tables retain exact overflow and rounding without extra multipliers.
- Branches are duplicated atomically into separate FIFOs. Each output retains
  stable data under backpressure. FIFO depth counts every live word, including
  its output register.
- A depth-one FIFO has one-cycle forward latency. Larger synchronous-memory
  FIFOs have two-cycle forward latency and one-word-per-cycle steady throughput.
  The solver-independent FIFO model now exposes per-option forward latency.

## Reproduction

From the repository root after `source ./env.sh`:

```sh
python -m torch2rtl emit-network \
  --configuration build/network/wide-stem-four-lanes/configuration.json \
  --output build/network/reproduced
python scripts/simulate-rtl.py \
  --rtl build/network/reproduced/inference.sv \
  --input build/network/wide-stem-four-lanes/input.hex \
  --expected build/network/wide-stem-four-lanes/expected.hex \
  --input-bits 32 --output-bits 32 --outputs-per-frame 32256 \
  --max-cycles 50000000 --stalls --output build/network/reproduced-simulation
python scripts/characterize-actors.py \
  --configuration build/network/wide-stem-four-lanes/configuration.json \
  --target inputs/target.json --workers 2 --output build/network/reproduced-actors
pytest -q
```

The configuration contains the model path/hash, vector width, convolution output
parallelism and every logical FIFO depth. It is an exploration input, not a
CP-SAT result. `emission.json` explicitly marks scheduling, fit and timing as
unverified. The generated transport is a ready/valid stream, not a board camera
or host interface.

An earlier compact-model stem actor alone was routed in the observable harness:
2 BRAM blocks, 16 byte-multiplier slots, and a nextpnr timing estimate of
176.34 MHz at a 27-MHz constraint. That result applies only to its archived
stem RTL. It must not be transferred to a different actor or the full network.

Key artifacts:

- [Latest complete-network RTL](../build/network/wide-stem-circular/inference.sv)
- [Latest full-network simulation](../build/network/wide-stem-circular-simulation/report.json)
- [Two-lane simulation](../build/network/wide-stem-simulation/report.json)
- [Two-lane stalled simulation](../build/network/wide-stem-stalled-simulation/report.json)
- [Actor synthesis catalogue](../build/network/wide-stem-trimmed-actors/report.json)
- [Earlier stem routing report](../build/convolution/stem-route/route-report.json)
- [Proposed spatial event contracts](spatial-scheduling.md)
