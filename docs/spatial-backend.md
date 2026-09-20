# Spatial integer backend

The compiler can now emit the complete retrained segmentation graph through
verified torch-mlir: 13 quantized convolutions, three max pools, two nearest
resamplers, two scale-aligned channel joins, and a byte comparison. These are
generic operator/shape rules. No model names, layer names, board properties or
resource budgets participate in lowering.

The explicit-configuration emitter remains available. A new `schedule-network`
command consumes actor/FIFO resource catalogues and translates the spatial RTL
into the agreed joint CP-SAT model. Small repeated-frame deadline tests pass;
the full per-word problem returned `UNKNOWN` in the bounded scale probe.
The current measured full-model catalogue is resource-infeasible before timing
expansion. Emitting RTL does not establish hardware fit or a routed clock.

The compiler also narrows spatial storage using proved graph value ranges.
Explicit mixed-precision experiments now pass full-graph RTL checks; one four-bit
actor configuration uses 44 BRAM blocks before graph FIFOs, but its accuracy is
below the required baseline. [Storage narrowing and its measurements](narrow-storage.md)
record the exact scope and limits.

A [191-option synthesis survey](option-survey.md) now demonstrates the cost of
different reduction/output parallelism choices. For the same four-bit graph,
selected actor parameters improve the sampled RTL interval to approximately
3.98 million cycles, still with oversized verification FIFOs and no routed
full-model clock.

## Verified full-graph result

The newest wider-stem INT8 model uses an explicitly trained requantization
right shift of 16 and reaches validation Dice **0.6671145**, below the required
**0.6768431**, with **27,576 bytes** of constants. Its exported integer graph has
240,583,680 direct MACs per inference. See the
[training report](../build/training/short-requantizer/report.json).

QAT/integer masks match on all 246 supplied images, and the reloaded export
matches all 49 validation images. Three validation images with the largest
annotated foreground counts were checked through the serialized integer and
fused graphs, then through full-network RTL. All **96,768 output pixels** match
with random input/output stalls. This RTL sample is not hardware validation of
the entire accuracy dataset. The previous wider-stem export also had all 21
common intermediate tensors checked before its full-network RTL simulations.

The newest four-lane simulation's frame completions are 5,815,893, 10,406,935
and 14,997,972 cycles. Its two observed intervals are **4,591,042** and
**4,591,037 cycles**, including injected stalls. These three frames do not
establish an asymptotic throughput certificate or a routed clock. Earlier,
the two-lane configuration of the previous export had two unstalled intervals
of 4,582,512 cycles, which would require 137.47536 MHz for 30 FPS.

Numerical simulations deliberately allocate one full frame per graph edge.
The earlier two-lane allocation totals **6,213,376 bytes of logical FIFO
capacity**, far above the selected FPGA's fabric RAM; the four-lane allocation
also exceeds it. These are simulated fabric FIFOs, not SDRAM. They are verification
allocations and must not be presented as deployable memory configurations.
Both weights and activations must fit fabric memory.

Individually synthesized actor costs for the new export/configuration are:

| Resource | Actor-only use | Supplied capacity |
| --- | ---: | ---: |
| LUT equivalents | 22,169 | 20,736 |
| FFs | 7,614 | 15,552 |
| Byte-multiplier slots | 81 | 96 |
| BRAM blocks | 60 | 46 |
| Distributed-RAM bits | 23,680 | 41,472 |

This excludes graph FIFOs and is not a whole-design fit or routing proof.
The configuration exceeds LUT and BRAM budgets. It was selected by an
arithmetic-only per-actor cycle screen, not by the joint CP-SAT solver.
Resource failures for this configuration are not an infeasibility theorem
about all legal parameter choices.

The new options are generic. Separate reduction parallelism saves multipliers
in slower layers without changing stream/FIFO width. Static join writers cut
2,252 LUT equivalents across the previous model's two joins. Nonoverlapping
pooling accumulates one reduced row, saving two BRAM blocks in that model.
Packing row delays into one sequentially accessed RAM saved a further four
blocks when selected everywhere, but increased logic and slowed the simulated
frame interval to about 4.81 million cycles. It is optional, not an automatic
improvement. Explicit logic ROM mapping can exchange BRAM for LUTs; forced
initialized distributed ROM was rejected by this target's Yosys mapping.
Recent Yosys alias buffers are normalized to connections before costing/routing.

## Numerical and streaming contracts

- Streams carry raster pixels, then channel vectors. Unused lanes in the last
  vector of each pixel are zero. Tensor semantics remain NCHW.
- Convolution supports signed/unsigned byte inputs, signed byte weights, groups,
  rectangular kernels, stride, padding and dilation. Group boundaries must align
  with the selected input vector width; width one always satisfies this condition.
  Reduction parallelism independently divides stream width, selecting the MAC
  and weight-ROM widths. Output-channel parallelism is another independent choice.
- INT32 accumulation and the graph's INT64 multiply/add/shift/clamp/cast are
  preserved, including overflow. Proven narrower widths use modular arithmetic
  only where the final value remains exactly representable. The dot-product
  multipliers are reused for byte-Horner requantization.
- Ordinary convolution and a complete integer unfold/matmul convolution both
  normalize to the same actor. Observable intermediate branches prevent fusion.
- Max pooling supports floor output geometry and explicit signed padding minima.
  `ceil_mode` is rejected. Unpadded, undilated pooling with kernel equal to
  stride uses a reduced-row accumulator with same-address forwarding. Nearest and nearest-exact resampling preserve the
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
  --configuration build/network/short-requantizer/configuration.json \
  --output build/network/reproduced
python scripts/simulate-rtl.py \
  --rtl build/network/reproduced/inference.sv \
  --input build/network/short-requantizer/input.hex \
  --expected build/network/short-requantizer/expected.hex \
  --input-bits 32 --output-bits 32 --outputs-per-frame 32256 \
  --max-cycles 50000000 --stalls --output build/network/reproduced-simulation
python scripts/characterize-actors.py \
  --configuration build/network/short-requantizer/configuration.json \
  --target inputs/target.json --workers 2 --output build/network/reproduced-actors
pytest -q
```

The configuration contains the model path/hash, vector width, convolution output
parallelism and every logical FIFO depth. Optional `reduction_lanes` maps actor
IDs to MAC widths. Optional `memories` maps actor IDs to `weight` and `line`
mapping styles, `line_layout` (`parallel` or `packed`), or `storage` for pooling
and resampling. All choices come from this input; the compiler has no board or
model defaults. It is an exploration input, not a
CP-SAT result. `emission.json` explicitly marks scheduling, fit and timing as
unverified. The generated transport is a ready/valid stream, not a board camera
or host interface.

An earlier compact-model stem actor alone was routed in the observable harness:
2 BRAM blocks, 16 byte-multiplier slots, and a nextpnr timing estimate of
176.34 MHz at a 27-MHz constraint. That result applies only to its archived
stem RTL. It must not be transferred to a different actor or the full network.

Key artifacts:

- [Latest complete-network RTL](../build/network/short-requantizer/inference.sv)
- [Latest full-network simulation](../build/network/short-requantizer-simulation/report.json)
- [Two-lane simulation](../build/network/wide-stem-simulation/report.json)
- [Two-lane stalled simulation](../build/network/wide-stem-stalled-simulation/report.json)
- [Actor synthesis catalogue](../build/network/short-requantizer-actors/report.json)
- [Earlier stem routing report](../build/convolution/stem-route/route-report.json)
- [Proposed spatial event contracts](spatial-scheduling.md)

The current test suite has **318 passing tests**, including independent reduction
widths, signed overflow, packed line storage, odd-size block pooling, frame
boundaries, and input/output backpressure.

The [spatial scheduling interface and scale measurements](spatial-scheduling.md)
describe the implemented contracts, explicit input catalogue and remaining
full-model solver limitation.
