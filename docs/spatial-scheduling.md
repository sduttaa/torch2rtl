# Spatial actor event contracts

These equations describe the intended translation of the new RTL into the
already agreed periodic event model. The full spatial translation is not yet
implemented or solver-validated. They do not replace the requirement to put
FIFO occupancy and scheduling inside CP-SAT.

An event time is the clock edge at which a transfer or internal state update
occurs. Frame `n` repeats at `n*T + t[event]`. Actor and FIFO choices remain finite
external catalogues with measured resource costs. Every constraint below is a
difference constraint, conditionally enabled by the selected actor option.

## Window storage

Let `p[k]` be issue events for the padded raster, including synthetic padding
words. Real input transfers are a subset of these events. Issue order requires
`p[k+1] >= p[k]+1`, with a two-cycle gap where successive real-column accesses
would otherwise collide in a one-word line memory. Horizontal padding bypasses
line RAM; vertical padding still shifts the stored rows.

For window `j`, let `last[j]` be its final issued channel vector and `release[j]`
the last computation that needs its contents. The first issue after `last[j]`
must wait for `release[j]`. The actor can begin using the window no earlier than
`p[last[j]]+2`: one edge commits the pending vector, and the next observes
`window_available`. The circular horizontal bank does not alter this ownership
rule. Frame wrap obeys the same raster and storage dependencies.

## Convolution

For a selected configuration:

```text
D = kernel_height * kernel_width * ceil(input_channels_per_group / lanes)
N = accumulator_bytes * ceil(multiplier_bytes / lanes)
B = groups * ceil(output_channels_per_group / output_lanes)
E = D + N + 5
```

Let `s[j]` be the idle-to-dot-product transition, `post[j,b]` the output-bank
update for tile `b`, and `o[j,k]` the accepted output words of pixel `j`.

```text
s[j]        >= p[last[j]] + 2
s[j+1]      >= post[j,B-1] + 1
post[j,0]   >= s[j] + E
post[j,0]   >= o[j-1,last]
post[j,b]   >= post[j,b-1] + E                  (b > 0)
o[j,0]      >= post[j,B-1] + 1
o[j,k+1]    >= o[j,k] + 1
```

The window is released at the last dot-product issue, before requantization and
output retirement. For one tile this is `s[j]+D`; for multiple tiles it is
`post[j,B-2]+D`. Keeping this event separate is essential: the next window can
load while requantization and output transfer finish. Each tile's post event
also depends on that tile's final dot issue plus `N+5` cycles. No input/output
burst is assumed to be unstalled merely because it is contiguous in the tensor.

The two pipeline-register delays are included in these constants. The equations
must be checked against transfer/internal-event traces for representative
parameters, frame boundaries and adversarial backpressure before being used as
a throughput certificate.

## Other actors

Max pooling scans `K = kernel_height*kernel_width` taps per output channel word.
After accepting a window at event `s`, its first output-register commit is at
least `s+K`. Later commits are separated by at least `K` cycles and cannot
overwrite an unconsumed prior output. Each transfer follows its commit by at
least one cycle. The final commit releases the window; the next window can start
one edge later if available.

Nearest resampling reads a complete source row before issuing its first output
read. Each synchronous RAM read reaches the output register one cycle before
its external transfer. Read issues are at least one cycle apart and each waits
for the previous output-register slot to be free. Repeated output rows reuse the
same source row. Capturing the next source row can start one edge after the last
read issue that needs the current row. Skipped input rows are still consumed.
The compile-time nearest-coordinate maps determine these dependencies exactly.

Channel concatenation accepts the branches of each pixel in fixed order, one
vector per clock when available. The first output follows the final input by
one cycle. The next pixel's first input follows the preceding pixel's final
output by one cycle. The lookup actor is a one-register elastic pipeline:
`output[k] >= input[k]+1` and `input[k+1] >= output[k]`.

## FIFO constraints and remaining scale issue

For logical capacity `d` and selected forward latency `l`:

```text
read[k]  >= write[k] + l
write[k] >= read[k-d]
```

Indices wrap across frames using `T`, exactly as in the existing CP-SAT backend.
Writes and reads retain their one-word-per-cycle ordering constraints. Fanout
edges share the same producer write events, because their writes are atomic.
For the new FIFO, `l=1` at depth one and `l=2` for larger synchronous-memory
implementations; replacement can occur on the same edge as the retiring read.

A literal word-event expansion of the real model is large, and this Mac has
16 GiB RAM. Algebraically equivalent event aliases and duplicate-constraint
elimination are possible implementation optimizations. Forcing dense pixel
bursts would instead restrict the schedule family and could lose solutions;
that change has not been adopted. No external simulation-based FIFO optimizer
has been substituted for the requested CP-SAT occupancy model.
