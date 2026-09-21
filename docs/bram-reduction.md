# Reaching the 35-BRAM requirement

The accepted 44-BRAM artifact remains unchanged. This work keeps 30 scheduled
inferences/s, exact integer outputs, the accepted model, and fabric-only storage
as requirements while reducing the physical allocation to at most 35 blocks.
No result is accepted from a resource estimate alone.

The accepted implementation uses **35 BRAM and 91 multiplier slots**, with a
3,737,193-cycle period and **30.7049 scheduled FPS at 114.75 MHz**. Routing passes
with a reported 115.674-MHz maximum, and bitstream packing succeeds. Three full
reference frames meet every transfer deadline; all 22 mapped-module proofs pass.
The unchanged model retains validation Dice 0.6500655308. This is a routed
toolflow and simulation result, not a board measurement. The timing margin is
modest, and the 50-FPS stretch goal remains unmet.
[Saved artifacts and evidence](../results/bram-reduction/README.md).

The previous bounded catalogue is infeasible at 35 BRAM even with the full
logic-site budget. Halving the two large branch FIFOs also produces an
infeasible complete schedule, rather than a useful storage saving. These checks
are recorded under `build/bram-reduction`.

## Exact threshold requantization

For a nonnegative multiplier and an output clamp with at most 16 integer values,

```
q(a) = clamp((a*m + b) >> s, low, high)
q(a) >= k  iff  a >= ceil((k*2**s - b) / m)
```

The compiler computes these thresholds with Python integers. A binary search
decides one output bit per cycle. A zero multiplier has constant thresholds.
Thresholds outside the signed accumulator range become always-true or
always-false comparisons. Non-power-of-two output ranges have unreachable
padded codes. The resulting output still follows the declared integer cast.

The transformation requires a proof that the multiply/add cannot overflow
INT64 over the complete INT32 accumulator domain. It therefore preserves the
existing INT32 accumulator wrap semantics. Negative coefficients, large output
ranges, and potentially wrapping INT64 arithmetic retain multiplication.
This changes the implementation of the declared quantizer; it does not quantize
the model again or introduce a numerical tolerance.

`requantizations` in a search input can include `auto`, `multiply`, and
`threshold`. Actor options carry `requantization`; emitted configurations retain
the selected modes in `requantizations`. Auto only selects a legal threshold
implementation when its cycle count is no greater than the existing quantizer.
Area and whole-design timing still require measurement. The actor's periodic
contract includes the selected quantizer's exact cycle count.

The first physical trial exposed a path through threshold-address decoding,
the threshold ROM, and a signed comparison in one cycle (92.40 MHz). The
template now reads both possible child thresholds while comparing against a
registered current threshold. Both children are registered, and a separately
registered decision selects between them. Registering only the selected child
allowed logic optimization to merge selection back through the ROM, exposing
a 91.68-MHz path in a later route; the separate child registers prevent that
transformation across the pipeline boundary.
A breadth-first binary-tree table stores each sibling pair at one address.
Node zero contains two root thresholds; shifting in comparison decisions walks
the tree, and the leading node bit drops out to leave the final output code.
This avoids two independently decoded table reads, whose measured area exceeded
the target's logic capacity. Both child values still cross explicit registers.
A one-hot search mask avoids a variable shift decoder. This preserves one
output bit per cycle and the existing schedule; it adds no numerical tolerance.
The change requires fresh physical costs and timing evidence.

The paired-table implementation first exceeded the placer’s legal capacity.
A resource-constrained choice with fewer output lanes in one actor reduced
the measured total by 502 mandatory logic sites and placed successfully. Two
resource-feasible uses of its spare multiplier slots improved the complete
period by only 52 cycles or zero cycles, so neither justified another route.

The remaining critical path starts at convolution state and passes through
pooled window-coordinate decoding. The window template now decodes the normal,
first, and alternate coordinates into registers before selecting startup.
The prefetch counter therefore drives coordinate decoding directly; actor
state selects already decoded values. Read latency and the periodic contract
remain unchanged. This applies to every local convolution window, including
grouped and pooled convolutions, without graph-node or board-specific rules.

The next physical trial moved the bottleneck to a deep weight ROM implemented
in logic (92.96 MHz). Logic weight ROMs larger than the template's 64-word bank
depth now register the outputs of small banks in parallel with the operand
capture. The final bank selector feeds the existing multiplier-input stage.
The externally visible read latency and actor schedule are unchanged. Partial
banks are padded with zero, and the source address still determines every
weight; no model-specific contents or layer identifiers control this rule.

Banked weights raised the next route to 98.59 MHz, exposing a control path from
source-frame completion through the row-contract ROM. The row lookup now takes
the existing output-row register directly. Its existing two-stage validity
pipeline masks the previous frame's state while the lookup settles, removing
the redundant advance/reset mux before the ROM without adding a cycle.

Initial isolated measurements save 709 and 159 mandatory logic sites in two
actors; another grows by 49 sites. The solver can use this area tradeoff to move
small memories from BRAM into logic. These are isolated costs, not a completed
35-BRAM physical result.

## Retiring source words after their last use

The fused spatial-view provider previously retained an entire source row until
its final output row completed. It now advances the write limit horizontally
during that final output row. A row still needed by a later output row remains
fully retained, including repeated rows from nearest resampling.

Let `first[y]` be the earliest source row needed by the remaining output rows,
`row_words` the number of source words per row, and `depth` the circular capacity.
On a row whose oldest source row has no later vertical reuse, the capacity limit
includes the earliest source column still needed by the remaining horizontal
windows. Otherwise that column contribution is zero. Limits are monotone and
never exceed the earliest future read address plus `depth`.

RTL registers the new limit. CP-SAT directly constrains the first write admitted
by every limit increase to occur at least three cycles after the preceding
window release. Ordered writes imply the remaining capacity constraints.
Existing readiness dependencies still ensure all operands arrive before a
window starts.

## Absorbing branch queues into source storage

The source provider and its incoming FIFO store the same stream. The optional
`absorb_input_fifos` search transformation derives per-input source-row capacities
from an input seed configuration's FIFO depths, rounds down to complete rows,
and retains small external FIFO candidates. It enlarges only the relevant input
buffer. Neither the seed nor this storage transformation claims feasibility;
the complete periodic schedule must establish it.

When the frame word count is a multiple of the circular-buffer depth, the
provider can retain the next frame's prefix in slots released by the current
frame. Write addresses continue across frame boundaries. The word counter
subtracts one frame at advance, preserving prefetched words and a simultaneous
write. Capacity constraints can therefore connect a current-frame window release
to a next-frame write directly in CP-SAT. Startup permits one buffer's capacity;
later increases retain the registered-control delay.

Nondivisible geometries retain the per-frame implementation: frame advance
precedes the next frame's first source write by three cycles. This fallback
avoids adding frame-base modulo arithmetic to every RAM read.

Focused numerical, backpressure, lifetime, and periodic-deadline checks pass.
The final startup change passes 128 convolution, pooling, and quantizer cases.
Current-template characterization, the complete 35-BRAM schedule, full reference
and deadline simulation, physical mapping, timing, and bitstream packing all
pass. The evidence includes exact source/model hashes, the scoped DSP timing
guard and used-pin coverage audit. The physical harness still uses a counter
source and checksum sink; host/camera transport and board measurement are
outside this result.
