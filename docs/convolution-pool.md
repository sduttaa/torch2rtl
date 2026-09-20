# Exact convolution/max-pool fusion

The optional `convolution_pool` fusion combines a single-consumer quantized
convolution with nonoverlapping, unpadded, undilated max pooling. It operates on
graph semantics and explicit shapes; no model or board names participate.
It is opt-in because the larger window and comparisons have a measured logic
cost. The complete accuracy, fabric-fit and 30-FPS goal remains unmet.

## Numerical contract

For each channel, the existing requantizer is

```text
q(a) = cast(clamp((INT64(a) * multiplier + offset) >> shift, low, high))
```

The compiler requires a nonnegative multiplier, a mathematical multiply-plus-
offset result within INT64 for every INT32 accumulator, a valid right shift,
and clamp limits inside the destination byte type. Therefore `q` is monotone,
and `max(q(a[i])) = q(max(a[i]))`. Intermediate INT32 convolution overflow is
retained: the comparison uses the final signed, wrapped accumulator. Negative
scales, unproved INT64 wrapping, wrapping casts, overlapping/padded/dilated
pools, and observable convolution branches prevent this fusion.

The independent graph evaluator retains the original convolution, rescaling,
and pooling order. RTL computes every convolution position in one pooling
block, retains the maximum accumulator per output lane, and rescales once.
This does not change precision, thresholds, weights or predictions.

For pool extent `P`, convolution stride `S`, kernel `K` and dilation `D`, the
combined input window has extent `(K-1)*D + 1 + (P-1)*S` and stride `P*S` on each
axis. It stores input rows rather than an additional row of convolution output
activations. Rectangular extents, nonunit convolution stride/dilation, channel
groups, incomplete vectors and discarded right/bottom remainders are covered.

## Timing contract

Let `M` be the pool area, `D` the dot-product issue count, `N` the requantization
issue count, and `B` the number of output-channel tiles. In the existing spatial
event contract, replace the tile delay and window-release offset with:

```text
E = M*(D+2) + N + 3
L = M*(D+2) - 2
```

`M=1` recovers the original `E=D+N+5` and `L=D`. The same per-word events and
ordered FIFO occupancy constraints remain inside CP-SAT. Larger-window issue
timing uses the existing parallel/packed line-memory rules. Tests compare
repeated-frame RTL transfers to the solver's deadlines.

## Measurements

Twenty-four fused configurations were synthesized for each of the full-range
and four-bit-hidden-activation retrained models, **48 measurements total**.
Options vary output/reduction widths and parallel/packed input line storage.

For the four-bit graph, one useful comparison is:

| Actor implementation | LUT equivalents | FFs | BRAM | DSP byte slots |
| --- | ---: | ---: | ---: | ---: |
| Separate convolution (12 output, 2 reduction lanes, packed lines) and pool | 4,281 | 1,600 | 3 | 24 |
| Fused actor (6 output, 4 reduction lanes, parallel lines) | 3,567 | 1,075 | 3 | 18 |

These are different parallelism choices implementing the same operation chain.
The arithmetic period bound improves from 3,490,560 to 3,257,856 cycles for this
chain. The fusion also removes its intermediate stream and FIFO. Other fused
choices cost considerably more logic, so fusion alone is not a guarantee of
improvement.

A whole-network arithmetic/resource relaxation over the measured catalogue
selected 20,008 LUT equivalents, 7,439 FFs, 46 BRAMs and 95 DSP byte slots, with
period bound 3,806,208 cycles. The corresponding unfused relaxation selected
20,448 LUTs, 8,182 FFs, 45 BRAMs and 96 DSP slots at 3,872,736 cycles. Both omit
window stalls and FIFO occupancy and select depth-one FIFOs. Neither certifies
a feasible schedule or physical fit; the fused selection leaves no BRAM reserve.

Full-model numerical RTL simulation with oversized verification FIFOs matches
all **96,768 pixels** from the same three images under random source/sink stalls.
Frame completions are 5,012,247, 8,994,935 and 12,977,624 cycles. The observed
intervals, 3,982,688 and 3,982,689 cycles, are effectively unchanged from the
previous selection. A downstream window/compute interaction remains limiting.
This result is a logic/resource tradeoff, not an end-to-end throughput gain.
The model's validation Dice remains 0.656095, below the required 0.676843.

- [Four-bit measurements](../build/network/convolution-pool/four-bit/measurements/report.json)
- [Full-range measurements](../build/network/convolution-pool/eight-bit/measurements/report.json)
- [Unfused relaxation](../build/scheduling/convolution-pool/unfused-relaxation.json)
- [Fused relaxation](../build/scheduling/convolution-pool/fused-relaxation.json)
- [RTL verification](../build/network/convolution-pool/selected/simulation/report.json)

## Usage and validation

Add `"fusions": ["convolution_pool"]` to an explicit network configuration or
spatial catalogue. Actor names and edge names must describe the resulting
graph; stale unfused configurations fail validation. The emitter,
characterization script and catalogue compiler preserve this input. Omitting
the field keeps the existing graph unchanged.

```sh
source ./env.sh
python -m torch2rtl emit-network \
  --configuration build/scheduling/convolution-pool/verification-configuration.json \
  --output build/network/reproduced-convolution-pool
```

The dedicated tests check fusion rejection, signed data, INT32 wrapping, grouped
and dilated convolution, rectangular pooling, line layouts, repeated frames,
random stalls, and solver deadlines. Additional tests remove all implied timing
bounds and window-path summaries and compare the unrestricted optimal periods.
