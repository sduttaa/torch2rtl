# Spatial actor event contracts

These equations are implemented in `torch2rtl/spatial_schedule.py` using the
agreed periodic event model. `schedule-network` accepts finite actor and FIFO
catalogues, performs a necessary resource check, then solves their joint timing
and occupancy problem with CP-SAT. Twenty-two spatial scheduling tests check
repeated-frame RTL transfers against solver deadlines, including parameter
selection, odd geometries, backpressure at joins and a deadlocking small FIFO
allocation. This evidence does not establish a feasible full-model schedule.

An event time is the clock edge at which a transfer or internal state update
occurs. Frame `n` repeats at `n*T + t[event]`. Actor and FIFO choices remain finite
external catalogues with measured resource costs. Every constraint below is a
difference constraint, conditionally enabled by the selected actor option.

The emitter also states implied period bounds by summing complete one-frame
dependency cycles. Ordered `n`-word transfers imply `T >= n`; the convolution
start/post cycle implies `T >= pixels * (B*E+1)`. Similar sums cover the actual
window issue gaps, general-pool scan cycles, resize reads, joins and lookup
registers. These constraints cancel intermediate offsets algebraically and
leave every per-word schedule available. They strengthen propagation without
adopting the proposed pixel-group restriction. Tests compare the optimum with
and without these redundant constraints and continue to check RTL deadlines.

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

The optional packed line layout serializes row delays in one RAM. With
`R = effective_height-1 > 0`, a real-column issue commits after `2*R` cycles
(one synchronous read and one write per row). Its next issue and the actor's
first window use are at least `2*R+1` cycles later. Horizontal padding bypasses
RAM and commits one cycle after issue, so its next issue/use delay is two.
When `R=0` the ordinary parallel contract applies. Both layouts retain the
same release dependency; storage savings do not imply equal throughput.

## Convolution

For a selected configuration:

```text
D = kernel_height * kernel_width * ceil(input_channels_per_group / reduction_lanes)
N = accumulator_bytes * ceil(multiplier_bytes / reduction_lanes)
B = groups * ceil(output_channels_per_group / output_lanes)
E = D + N + 5
```

Reduction parallelism may be a divisor of stream-vector width. Window and FIFO
word counts still use stream width; only arithmetic/weight-ROM width and these
compute delays use reduction parallelism. Output parallelism is independent.

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

The two pipeline-register delays are included in these constants. Only the
first post event can wait for the preceding output pixel. Later tile posts
have fixed offsets from it, and release has a fixed offset from the last tile's
start. The implementation eliminates these redundant internal events without
restricting transfer schedules. Repeated-frame tests check the resulting
solver deadlines against the emitted RTL for independent reduction/output
parallelism and both line-memory layouts.

## Other actors

General max pooling scans `K = kernel_height*kernel_width` taps per output channel word.
After accepting a window at event `s`, its first output-register commit is at
least `s+K`. Later commits are separated by at least `K` cycles and cannot
overwrite an unconsumed prior output. Each transfer follows its commit by at
least one cycle. The final commit releases the window; the next window can start
one edge later if available.

Nonoverlapping, unpadded, undilated max pooling instead accumulates one reduced
row. Let `i[k]` be ordered input transfers, `last[j]` the final input word of
output block/channel-vector `j`, `c[j]` its output-register commit, and `o[j]`
its accepted output. Its elastic input stage and output register require:

```text
c[j] >= i[last[j]] + 1
c[j] >= o[j-1]
o[j] >= c[j] + 1
i[last[j]+1] >= c[j]
```

Input transfers remain ordered at least one cycle apart, including ignored
right/bottom remainders. Other input commits are exactly one cycle after their
transfers and need no separate scheduling variable. Same-address forwarding
preserves consecutive RAM updates. The timing tests cover rectangular blocks,
odd trailing dimensions, and same-address updates.

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
16 GiB RAM. After exact event aliases, the current model/configuration still
has **4,091,235 events**, **5,513,378 actor dependencies**, and **1,601,728 FIFO
words** across 23 edges. The frontend constructed it in about five seconds,
with a peak process footprint around 1.5 GB. FIFO word-order constraints are
omitted only where the actor contracts already imply them, including frame
wrap; availability and slot reuse remain explicit.

A diagnostic full-model run with the oversized verification FIFOs and no
resource budgets returned `UNKNOWN` after a 60-second solver limit. The memory
monitor subsequently terminated the process when RSS crossed its 6-GiB
ceiling. It found no schedule and proved no infeasibility. See
[`scale-probe/result.json`](../build/scheduling/scale-probe/result.json) and
[`monitor.json`](../build/scheduling/scale-probe/monitor.json).

With the implied cycle bounds, a later 300-second-limit run still returned
`UNKNOWN` under the default CP-SAT settings. It completed normally with an
observed RSS peak of about 4.56 GB. Disabling presolve, probing and LP
linearization in a diagnostic script reached search and reported the explicit
4,588,416-cycle lower bound, but still found no feasible schedule. Its log records
612,237,527 integer propagations and zero branches; observed RSS peaked at about
6.06 GB. Both runs retained oversized FIFOs and omitted resource budgets.
These measurements isolate a solver-scale problem; they do not prove physical
infeasibility. The alternate settings have not replaced backend defaults.

- [Default-settings cycle-bound probe](../build/scheduling/cycle-bound-probe/result.json)
- [Direct-search probe](../build/scheduling/direct-search-probe/result.json)
- [Direct-search solver log](../build/scheduling/direct-search-probe/solve.log)

Pixel-grouped scheduling would restrict this schedule family and could lose
solutions. The user has been asked whether that tradeoff is acceptable; it has
not been adopted. No external simulation-based FIFO optimizer has replaced
the requested CP-SAT occupancy model.

## Catalogue interface

`python -m torch2rtl schedule-network --catalogue INPUT.json --target TARGET.json
--seconds 30 --output OUTPUT` imports the exported model through torch-mlir and
uses these explicit catalogue fields:

- `model`, optional `model_sha256`, and stream `lanes`;
- `period_limit` and `offset_limit`, which bound the searched schedules;
- `actor_options[actor_id][option_name]`, with `resources`, optional
  `output_lanes`, `reduction_lanes`, and `memories`;
- `fifo_options[edge_id][option_name]`, with logical `depth` and `resources`;
- optional `fixed_resources` for explicitly budgeted wiring/control overhead.

Costs must describe the corresponding emitted RTL and target. The FIFO template
has one-cycle forward latency at depth one and two cycles otherwise. FIFO costs
can be measured with `scripts/characterize-fifos.py`; actor costs can be measured
with `scripts/characterize-actors.py`. A feasible result writes selected hardware
parameters, RTL, and compressed per-event offsets. It still marks physical fit
and timing unverified until whole-design synthesis and routing establish them.

The current measured full-model catalogue is rejected by the resource check:
its actor choices alone already exceed LUT/BRAM budgets, independent of FIFO
choice. This is a result for that finite catalogue, not all possible circuits.
The saved input and result are in `build/scheduling/short-requantizer`.
