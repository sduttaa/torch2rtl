# Automatic architecture selection and overlapped quantization

The current acceptance target is met: 35.0000032 sustained scheduled inferences/s,
35 BRAM blocks and 17,527 actual routed logic sites, preserving the unchanged
model's integer semantics and 0.6500655308 validation Dice. The 108-MHz route
passes timing with a reported 110.509-MHz limit. All 18 packaging gates pass.
[Accepted result and scope](../results/automatic-throughput/README.md).
Board resources, clocks, model contents and search limits remain inputs.

The final solve reused a compiler-generated catalogue: all 233 retained actor
options and 196 FIFO options were remeasured with the final templates, then the
normal compiler selection and complete CP-SAT schedule ran with the revised
35-FPS/108-MHz target. No architecture, FIFO or schedule override was supplied.
The provenance records the source catalogue and target hashes. This avoids
repeating characterization for a clock-input change; it is not a claim that
the final result was regenerated from an empty cache in one cold invocation.

## Independent quantizer stage

The `overlap` requantization option uses the existing exact inverse-threshold
quantizer. One completed tile's accumulators and channel-block tag are held in
registers while the dot-product engine begins the next tile. A registered ROM
read primes the threshold search. No additional multiplier or full activation
buffer is required. The extra registers and control are characterized normally.

The `overlap_shift_add` alternative replaces the threshold tree with a
bit-serial multiplier in logic. It consumes coefficient bits from least to
most significant, replacing them with product bits in the same shift register.
Only an accumulator-width-plus-one upper slice needs an adder. The signed
coefficient's final bit is subtracted. The exact coefficient width determines
the number of steps; byte padding is only needed by the DSP-reuse alternative.
The product is narrowed before offset addition at the proved requantization
width, preserving INT64 wrapping and the subsequent signed shift.
The implementation uses no additional DSP and can be smaller than channel-
dependent threshold tables. It supports full byte outputs and signed
coefficients; the existing fusion legality checks still apply to pooling.

`overlap_folded` shares that shift-and-add arithmetic across output lanes. The
compiler chooses the smallest number of quantizers dividing the output-lane
count whose complete service interval fits the compute tile. Each group costs
`multiplier_bits+2` cycles. Small registers retain earlier groups' quantized
bytes, so the completed tile still commits atomically under backpressure. The
parallel and folded implementations remain separate characterized candidates;
sharing is neither required nor assumed to improve every actor.
The held accumulators form a shift queue: after a group finishes, remaining
values move to the fixed engine lanes. This removes the group-indexed operand
mux and separate engine holding registers; coefficient selection still follows
the original channel order.

Backpressure holds the quantizer at commit until the previous output pixel is
consumed. It then prevents the compute engine from handing off another tile
until this stage is free. A partial pixel, quantizer input or unfinished dot
product cannot be overwritten. Pooling comparisons finish before the pooled
sum enters the quantizer; the original arithmetic and clamping remain exact.

Let `D` be dot steps, `P` pool items and `R` one when the reduction has an extra
register stage. For pooled dots with `D >= 4`, the operand pipeline continues
across pooling positions with one boundary bubble. That bubble lets the maximum
register update and the next dot's accumulator reset to bias on the same edge.
The comparison uses the maximum register's enable, avoiding an additional bias
mux in the accumulator's carry path or a second accumulator bank. Other
geometries retain the drained controller. Write `S = (P-1)*(1+R)` when this
pipeline is enabled, otherwise zero.

Compute-to-handoff cycles are `C = P*(D+2+R)+1+[P>1]-S` and the
handoff-to-quantizer-commit delay is `Q = threshold_bits+2`, or
`Q = groups*(multiplier_bits+2)` for shift-and-add. These options require
`C >= Q+1`. Shorter tiles retain existing implementations. This is a
generic contract restriction, independent of model or board identity.

For the first tile of a pixel, handoff follows compute start by at least `C`;
quantizer commit follows handoff by at least `Q` and waits for the previous
pixel's last output transfer. The second tile's handoff follows both the first
handoff plus `C` and its commit plus one. Subsequent tile handoffs have constant
spacing `C`. Because compute service is at least quantizer service, those later
internal events can be eliminated exactly. Window releases, source-buffer reuse,
output transfers and frame wrap remain explicit dependencies. Both resource
screening and the complete event model use the same timing constants.

Two-word FIFOs use head and tail registers with one-edge write-to-read latency
and one-word-per-edge sustained service. Occupancy alone controls upstream
ready, so downstream ready does not propagate combinationally across the FIFO.
Larger FIFOs retain the synchronous RAM pipeline and two-edge latency.
The event model, catalogue pruning, resource proposal and measurement reports
share the same latency function. Slot reuse still has a one-edge credit delay.

## Cold buffer planning

`automatic_buffering` rejects externally supplied configuration and schedule
seeds. The compiler first selects an architecture using characterized resource
and actor-period costs. It then solves a fresh finite-FIFO CP-SAT schedule with
FIFO resource charges temporarily relaxed. This produces a storage hint from
the graph's actual branch timing. The planning report explicitly identifies the
relaxation and must never be interpreted as a physical implementation.
When throughput is supplied, this pass hints its corresponding period and
stops once CP-SAT finds a complete schedule meeting it. Starting from a loose
search ceiling can otherwise produce unhelpful storage hints. All event and
occupancy constraints still participate in the planning solve.

The generic source-storage transformation absorbs eligible branch queues into
fused source-row buffers. Within each physical allocation it maximizes complete
rows, preferring a capacity that divides the frame size and supports rolling
prefetch. The changed memories are characterized, and the final
joint schedule uses the actual target resource budget and ordered FIFO
occupancy constraints. The compiler-derived hint guides, rather than fixes,
architecture choices in that final search. No node identifiers, previous
solution files or per-layer settings appear in the search input.

The resource proposal uses the permitted period and first favors pipeline-capable
FIFOs weighted by stream traffic: a one-slot queue's alternating transfers
cost more on a high-traffic edge. The maximum actor period bound follows that preference, allowing compute
and memory to be reallocated toward the slowest stage. Minimizing the sum can
instead spend lanes accelerating stages that already have ample throughput.
This small resource proposal represents the maximum with a virtual choice over
the ordered distinct period bounds. For every actor, complementary nonnegative
costs enforce `rank(actor) <= rank(maximum)`. Objective weights derived from
the finite resource budgets give pipeline capability priority, then this maximum,
then agreement with the preliminary storage hint, then resource cost. Large
eager planning queues must not displace compute or internal buffering needed
for throughput. Storage-hint agreement is weighted by each stream's
per-inference word count. The virtual choice is removed before generating hardware.
Preserving the initial planning geometry too strongly can also trap retries in
small FIFO changes. These are search heuristics, not a substitute for complete
scheduling.
A full CP-SAT check of the proposed actor/FIFO combination runs first; only a
verified schedule becomes an incumbent. If it is proved infeasible, the compiler
looks for a blocking cycle in those same fixed event inequalities. Summing a
closed cycle cancels event offsets: a cycle with total delay `D` and frame
advance `F` requires `D <= F*T`. Only an exact violation at the allowed period
produces an exclusion. The resource solver then changes at least one temporal
contract or FIFO depth on that cycle. Physical implementations with identical
contracts share the exclusion. Choices outside the witness remain unrestricted.
`proposal_attempts` bounds these retries (default four); no witness or a timeout
adds no exclusion. The full joint search remains the fallback and every accepted
schedule still comes from CP-SAT. Individual options are removed only when a resource
relaxation proves that no feasible combination can include them; timeouts keep
the option.

The `stop_at_required_fps` search input ends objective refinement once a complete
schedule meets the supplied `required_fps` target. This current experiment uses
it to prioritize verification of the requested result. It does not fix any
actor or FIFO choices and does not claim a global throughput optimum. Omit it
or set it false to continue minimizing the period within the solver budget.
Fully fixed buffer-planning graphs use a direct period search. All stages use
CP-SAT, and every returned schedule is independently checked against its
constraints.

This is a bounded heuristic architecture search, not a proof of a global
architecture optimum. Search limits and all intermediate choices are saved.
The acceptance evidence must include numerical and deadline simulation,
physical capacity, mapping checks and routed timing in addition to the solver
result. Core scheduled throughput is distinct from physical-board measurement
and host/camera transport throughput.

The input files for this experiment are `inputs/automatic-search.json` and
`inputs/throughput-target.json`. The latter explicitly supplies the target
resources and desired throughput; compiler source contains neither.

`scripts/compile-and-verify.py` runs architecture selection, transfer-cycle
export, numerical/deadline simulation, mapping proofs, routing, timing audits
and gated result packaging. Every model/board/evidence path is supplied in a
job file. The current job is `inputs/automatic-job.json`:

```sh
source ./env.sh
python scripts/compile-and-verify.py --job inputs/automatic-job.json \
  --build build/automatic-throughput/reproduce --output results/automatic-throughput-reproduce \
  --seconds 600 --workers 1
```

`--verify-only` continues from an existing automatically generated compile
after checking that its model, target and search inputs match the job. It does
not accept an architecture override. Packaging refuses the result unless every
acceptance gate passes. The job's timing-audit paths refer to the installed,
configuration-scoped toolchain evidence under Documents.

The active target reserves logic capacity explicitly through its `lut_sites`
budget. The physical flow checks the linked, packed design against that budget
before starting placement. After routing it counts occupied physical slice
positions, including placement-added pass-through LUTs and distributed-memory
blockers, and enforces the budget again. Packaging reports this actual count
and remaining sites. The rejected near-capacity
experiment is not an acceptable result. `TORCH2RTL_SOLVER_LOG=1` enables detailed
event-solver diagnostics.

## One circular window store

The `ring` line-layout candidate replaces row-delay memories plus horizontal
window RAMs with one circular memory. For channel-vector count `V`, effective
kernel extent `(H, W)` and padded input width `P`, the live raster span is
`((H-1)*P+W)*V` words. Its allocation rounds up to a power of two, making every
address wrap a bit truncation. A registered origin identifies the oldest word
in the completed window; static tap offsets implement dilation and channel
selection. Fused pooling uses its existing enlarged effective window.

Writes retain the existing capture/commit protocol, and pipelined reads retain
the existing two-edge coordinate contract. Explicit forwarding defines equal-
address read/write behavior without relying on a device RAM collision mode.
Window release prevents the next input from overwriting a live window. The
CP-SAT contract retains every input transfer, release and frame-wrap constraint.

The ring can accept a new raster word each cycle, unlike the serialized packed
row-delay implementation. Its geometry may require more BRAM on some shapes,
so it remains an alternative, not a forced replacement. Characterized costs and
the whole-network schedule decide where it is worthwhile. No model identities
or board capacities are involved in the transformation.

Catalogue refinement also retains the best fully measured resource solution
while exploring optimistic new candidates, preventing bounded retention from
accidentally discarding its own measured progress.

`ring_compact` uses the exact raster span as its depth. A wrapping write cursor
and a registered biased origin implement modular tap addressing with two
parallel additions and a selection. It preserves the same two-edge read
contract while avoiding the unused capacity from power-of-two rounding.
It remains an alternative because the extra address logic has a cost.

The screen retains both allocations when their optimistic memory costs are
equal: synthesis can choose a different memory aspect ratio from the geometry
bound. On one matched fused convolution/pooling geometry, exact mapping changed
2,488 sites/3 BRAM to 2,057 sites/3 BRAM. This is actor-level evidence, not a
whole-design result. The compact window passed 47 focused functional and
scheduling cases before entering the automatic architecture search.

The `banked_lines` search flag also offers explicit width banks for ring
windows. Their width comes from the memory mode selected by the supplied target
geometry; separate arrays expose this aspect ratio to synthesis. Lanes absent
from every input pixel consume no memory, and their read values are zero-filled.
Read latency and forwarding stay unchanged. This maps the same example to
1,932 sites/3 BRAM, compared with 1,927 sites/4 BRAM for the unbanked power-of-two
ring. Exact characterization, followed by the complete schedule, decides
whether to use it. Width banking introduces no board or model identities.

## Prefetch inside the circular window memory

The `prefetch` layout separates the padded-raster writer from the window reader.
A ring with physical depth `D` and live span `S` can hold `D-S` future words
while convolution uses its current window. This absorbs raster bursts using
capacity already allocated to that RAM. The earlier ring controller stopped
input whenever a completed window was held, leaving this capacity idle.

The writer counts committed words `w`; the reader tracks its oldest live word
`r`. A pending capture reserves one additional slot. Capture is allowed while
`w + pending - r < D`, and the window is available when `w-r >= S`. The reader
advances only on window release. Signed modular distances handle unused tail
padding and counter wrap; physical addresses remain power-of-two truncations.
The two-edge coordinate-read contract and explicit collision forwarding remain
unchanged.

Every padded issue is still an ordered CP-SAT event. For a window beginning at
word `r`, its start follows issue `r+S-1` by two cycles. Issue `r+D` follows its
release by at least one cycle, preventing reuse of a live slot. Indices crossing
a frame become the corresponding periodic dependency with a frame advance.
These constraints replace the old rule that refilling must wait for release;
the finite storage lifetime itself determines when the writer can proceed.

The small resource proposal can satisfy a compiler-derived buffering hint `H`
using external FIFO depth `F` plus internal prefetch capacity `P`: `F+P >= H`.
The planning hint includes both its external queue peak and the capacity
already inside the selected planning actor, so replacing that actor cannot
silently discard its buffering.
The proposal caps `H` at available internal space: an eager schedule's peak
occupancy is not a minimum requirement for every valid schedule.
This is expressed with complementary nonnegative costs in the existing
solver-independent resource model. If that heuristic proposal cannot fit, the
physical resource check remains available. These hints never substitute for
the final joint event and occupancy solve. Catalogue retention preserves an
internal-buffer alternative because frame-period bounds alone do not capture
its effect on burst propagation.

The external input is paced by the generated schedule and needs no internal
producer-burst hint. Small FIFO depths explicitly requested in the search input
survive the geometry screen: identical RAM allocation can still have different
pointer and control costs. Dominance pruning uses complete measured costs.

The change was motivated by an independently checked dependency cycle in a
small-FIFO proposal: its delay was 4,955,463 cycles per frame despite much lower
individual actor bounds. The cycle crossed ordinary raster stages, not the
skip branches. This diagnostic was not accepted as an implementation or used
as an external architecture/schedule seed.

### Registered prefetch occupancy

Let `q` count issued raster words minus the oldest live raster-word index,
including the one possible pending RAM write. On an edge with issue bit `i`
and released span advance `a` (zero without release), update `q' = q+i-a`.
The RTL selects the constant `i-a` before one carry-propagating adder.
Upstream readiness is `q < capacity`; window availability is `q > span` or
`q == span` with no pending write. A release is legal only with a live window.
Under that contract, `-frame_words <= q <= capacity`, so the comparisons are
identical to subtracting the pending bit from `q`. The proof also checks
congruence with the former full-width read/write pointers across wraparound.
The physical RAM pointers now need only address bits. This is a retiming of
bookkeeping; CP-SAT transfer, release and ordered-slot constraints are unchanged.

Raster padding is tracked with two state bits that change at the exact image
boundaries; counter comparisons no longer feed upstream ready. The counter and
padding invariants are checked together by induction.

For the two-word FIFO, let `h` and `t` be head/tail validity, `v` input validity,
and `r` output readiness. Outside reset, its legal states are `(0,0)`, `(1,0)`
and `(1,1)`. The updates are `h' = v | t | (h & !r)` and
`t' = !r & (t | (v & h))`. A full queue blocks input acceptance; its existing
valid tail absorbs `v` in these expressions. Data capture still uses accepted
pushes. The head-data mux depends only on the registered tail-valid bit.
These equations preserve the one-cycle slot-credit delay and avoid cascaded
control muxes; they do not bypass backpressure or change the CP-SAT model.

The capacity proposal retains spare prefetch storage plus the smallest available
pipeline-capable FIFO, capped at the planning hint. Keeping only the internal
spare space could discard a final external slot needed by the original plan.
These are soft proposal heuristics: resource pressure can change contracts,
and the full CP-SAT event model independently accepts or rejects the result.
No architecture from an earlier run is supplied as a seed.
