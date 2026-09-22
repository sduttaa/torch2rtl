# Template inspection and retained improvements

The inspection started with cached mapped netlists, not new full-design runs.
Register fan-in cones identified quantizer arithmetic/storage, weight ROMs and
fused-view control as substantial costs. Cones overlap and are not additive
resource totals. Small output-formatting changes were not the main opportunity.

## Retained changes

1. The serial requantizer uses a narrow upper-slice adder and one combined
   coefficient/product shift register. The exact coefficient bit width replaces
   byte-rounded work. Signed coefficients, modular INT64 offset arithmetic and
   clamping remain exact. Shared quantizers consume held accumulators through
   a shift queue instead of a group-indexed operand mux and additional holding
   registers. Engine count still follows the generic compute/service constraint.
2. Fused convolution/pooling overlaps the next dot's operand pipeline with the
   previous dot's completion. One boundary bubble permits the maximum-register
   update and bias reset on an idle accumulator edge. The maximum uses a clock
   enable; there is no additional bias mux in the carry feedback or second
   accumulator bank. Short dots retain the drained controller.
3. A two-word FIFO uses head/tail registers. Its latency is one edge and its
   sustained service is one word per edge, with registered occupancy controlling
   upstream readiness. The head-data mux selects only from registered
   occupancy; downstream readiness controls the register enable. This removes
   readiness from the data-selection path. It introduces no combinational ready
   chain. The old
   general RAM implementation took two edges and sustained two words per three
   edges at this depth. CP-SAT uses the new delay and the unchanged one-edge
   slot-credit delay. Pruning and resource proposals use the same delay function.

The pooled pipeline saves `(pool_items-1)*(1+reduction_register_stage)` cycles
when enabled. See `automatic-throughput.md` for the full timing equations and
finite-buffer contract. No model names, board budgets or per-layer overrides
were added to compiler code.

4. Prefetch windows maintain a signed occupancy register directly. Upstream
   readiness no longer traverses pointer subtraction, pending-write addition
   and a capacity comparison. A constant-selected delta updates occupancy with
   one adder; the RAM pointers retain only physical address bits. Window
   availability excludes the pending write through constant comparisons. Five
   induction proofs establish the count, pointer congruence, bounds and the
   original handshake behavior under the window-release contract. This changes
   no transfer delay or finite-memory lifetime in CP-SAT.

5. Padding regions are registered at fixed raster boundaries, matching the
   existing row/column comparisons without putting those comparisons on ready.
   The two-word FIFO uses direct equations for its three legal occupancy states.
   Its valid-register paths from downstream ready each synthesize to one LUT
   level; the previous tail-state path had three. Induction covers padding
   flags and FIFO equivalence, including arbitrary stalls and reset.

## Matched mapped measurements

These are individual actor measurements using identical model values, lane
counts and memory choices from an earlier compiler-generated catalogue. Engine
sharing follows the revised service contract automatically. Logic sites are
mandatory packed-site lower bounds, not whole-design routed occupancy.

| Actor geometry | Previous sites | Revised sites | Compute tile cycles |
|---|---:|---:|---:|
| Pooled convolution, 8 output / 2 reduction lanes | 1,932 | 1,956 | 86 → 80 |
| Convolution, 3 output / 4 reduction lanes | 1,665 | 1,556 | 22 → 22 |
| Fused view/convolution, 4 output / 4 reduction lanes | 1,851 | 1,703 | 67 → 67 |
| Fused view/convolution, 8 output / 2 reduction lanes | 2,670 | 2,520 | 85 → 85 |
| Total for these four actors | 8,118 | 7,735 | — |

BRAM and DSP counts are unchanged in all four comparisons. The pooled actor
spends 24 additional sites for the shorter compute period; the combined saving
is 383 sites (4.7%). One fused actor's quantizer count falls from two to one.
The final measurements and emitted RTL are in
`build/template-review/shift-queue/`; the prior catalogue is
`build/automatic-throughput/prefetch/catalogue.json`.

Separating the two-word FIFO's enable and data selection measured 24/40/56
mandatory sites at 8/16/24 bits, down from 35/59/83. The final valid-state
simplification further reduces the measured 24-bit instance to 55 sites. It is
a throughput/latency improvement; logical depth reduction must not be confused
with an equal reduction in physical RAM cost.

## Changes rejected after inspection and measurement

- Incremental fused-view row tables added feedback/control cost. Direct lookup
  and the existing factored column maps remain.
- Moving logic-ROM bank selection before one output register increased cost.
  A whole-ROM lookup saved too little to justify its unverified timing tradeoff.
- Static per-channel output writers prevented distributed-RAM inference for
  scalar actors. The original output storage remains.
- The first pooled pipeline inserted a bias mux into the carry path and raised
  the representative actor to 2,071 sites. The retained maximum-enable/bias-reset
  arrangement avoids that cost.

## Validation and scope

Eight bounded formal proofs cover every operand combination of several signed
and unsigned serial-multiplier widths, including one-bit operands. RTL tests
cover INT64 overflow, signed coefficients, stalls, channel tails, grouped
convolutions, pooling, fused views, frame wrap and CP-SAT transfer deadlines.
Pool-control induction proves the maximum update has an idle accumulator edge,
including the shortest pipelined dot. Representative emitted actors pass
Verilator lint. Logs are under `build/template-review/`.

The cold automatic compile in `build/automatic-throughput/template-refined`
found a complete CP-SAT schedule of 3,019,736 cycles: 38.00001 scheduled FPS at
114.75 MHz, with 35 BRAMs and 95 signed 9-by-9 multiplier slots. No external
architecture or schedule seed was supplied. Three complete frames passed
bit-exact simulation for all 96,768 output words and every scheduled boundary
transfer. All 21 distinct mapped modules passed equivalence checks. Initial
whole-design packing needs 17,765 mandatory logic sites.

The route occupies 17,988 logic sites, leaving 2,748 physical sites free, but
fails timing at 69.83 MHz. Its critical path crosses the prefetch occupancy
arithmetic and the upstream FIFO's data selection. This is a rejected result,
not a 38-FPS implementation. The registered-occupancy template removes that
arithmetic from readiness. Across the six affected selected actors it reduces
mandatory sites from 7,034 to 6,527, with unchanged BRAM, DSP and cycle contracts.
Fifty-five focused functional/deadline tests and the five induction proofs pass.
The FIFO refinement also passes an unbounded old/new handshake/data equivalence
proof and eleven focused FIFO/selection tests. The verified routed baseline
remains 30.70 FPS at 35 BRAM until all acceptance gates pass. No physical-board
FPS is claimed.

Explicit width casts in the prefetch template remove simulator diagnostics.
Re-emission from the unchanged compiler configuration produces an identical
complete sequential circuit under Yosys elaboration, after removing only source
location attributes. That evidence permits reuse of the original mapped
modules without another architecture search or synthesis run; see the build's
`source-equivalence/` directory.

### Second routed timing finding

The occupancy/FIFO rewrite reaches 99.24 MHz, up from 69.83 MHz, but still fails
the required 114.75-MHz clock. Its actual routed occupancy is 17,931 sites,
leaving 2,805 free. Three frames again pass all numerical/transfer checks and
all mapped-module proofs pass. This remains a rejected result.

The new 10.08-ns critical path starts at a raster column register, traverses the
padding comparison and upstream-ready logic, and ends at the FIFO tail-valid
register. Registered padding removes the counter comparison from ready;
direct FIFO state equations remove its three-LUT control cascade. Across six
matched prefetch actors, padding registration reduces mandatory sites from
7,313 to 7,130 (183 saved), with two extra registers per actor and unchanged
BRAM, DSP and cycle counts. Seventy-six focused tests pass, including the
expanded counter/padding induction checks. The final FIFO equations additionally
pass eleven focused tests and old/new unbounded equivalence. Evidence is under
`build/template-review/registered-padding/`.

The first automatic search with these final templates did not find a complete
feasible schedule within its solver budget. Its resource proposal changed the
temporal actor contracts used to plan buffering and could discard the small
external queue when counting spare internal capacity. The generic proposal now
prefers preserving those contracts while changing physical memory placement,
and includes a pipeline-capable external queue in the capacity hint. These are
soft proposal preferences; final scheduling and finite-storage constraints are
unchanged. Six focused compiler-selection tests pass. The fresh compile in
`build/automatic-throughput/contract-preserving` uses the final templates and
these proposal corrections, without external actor choices or a schedule seed.

That search also failed within its budget. A directly checked dependency cycle
required at least 3,043,207 cycles, exceeding its 3,019,736-cycle ceiling. The
compiler now feeds proved blocking cycles back into automatic resource
selection before the broad joint fallback. This changes search efficiency, not
the permitted schedules or hardware templates. Forty-seven focused tests pass,
including automatic repair of a branched graph's insufficient queue and
rejection of physically different queues with the same failing depth. The
current cold run is `build/automatic-throughput/cycle-feedback`.

Four proved-cycle retries still changed small queues while retaining almost the
same blocking cycle. The proposal's extra preference for preserving the
planning actor geometry has therefore been removed; its simpler actor-period
objective can reallocate compute. The remaining FIFO preferences and all exact
scheduling constraints are unchanged. The automatically generated measured
catalogue is being reused in `build/automatic-throughput/compute-reallocation`,
with its hash and origin recorded in `resume-provenance.json`. No actor, FIFO or
schedule override is supplied. Forty-seven focused tests pass after this change.

The period-sum proposal still spent resources on fast stages while retaining
the blocking slow stage. Its objective now minimizes the maximum actor period
after FIFO preferences, with resource cost as the final tie-break. This follows
the requested rate-balancing approach and introduces no actor-specific weights.
The `balanced-proposal` run reuses the same measured catalogue and templates.
Forty-eight focused tests pass, including a case where minimizing the sum would
accelerate the wrong stage. The obsolete `compute-reallocation` search was
stopped before its expensive broad fallback.

The final proposal hierarchy places actor rate balance before preserving eager
planning-queue sizes. This exposes a 17,556-site/35-BRAM candidate in the same
measured catalogue, with no manual actor choices, in
`build/automatic-throughput/rate-priority`. The focused 48-test batch also checks that
an oversized queue hint cannot consume a resource needed by the bottleneck.

That selection passes the full CP-SAT schedule: period 3,019,736 cycles and
38.00001 scheduled FPS, with 35 BRAM and 96 multiplier slots. All 2,384,445
events and 5,203,923 dependencies pass independent validation. Three full RTL
frames match all 96,768 output words and scheduled transfers. All 20 distinct
mapped modules pass equivalence checks. Actual routed occupancy is 17,724 sites
(3,012 free), but timing fails at 60.64 MHz. This is not an accepted 38-FPS result.

The newly selected hybrid weight ROM exposed simulator width diagnostics at
its guarded prefix access. Local lint annotations preserve the original
full-ROM index and unsigned extension. Complete sequential Yosys elaboration
is identical before/after, removing only source-location attributes; the
replayable evidence is in `rate-priority/source-equivalence`. No arithmetic,
schedule or mapped module was changed, so another synthesis/search was avoided.

### Hybrid weight-ROM pipeline

The failed route exposes a 16.49-ns path through window/control logic into the
hybrid weight-ROM output register. The original shared prefix/tail mux and
conditional read permit a deep synthesized cone: up to 18 LUT levels at the
hybrid-ROM register inputs in the matched actor.

The revised generic template reads the block prefix and small logic banks into
independent registers. Registered selection uses the existing multiplier-input
stage, preserving all actor latencies. Reads outside the dot phase are
unobserved, so these ROMs need no state-dependent enable. Tail addresses have
their actual ROM width, and the final logic bank is padded with zeros.
Prefix sizes of 1, 17, 32 and 71 pass numerical/stall tests, covering unaligned
boundaries, several banks and a one-word tail.

For the matched actor, mandatory sites fall from 2,073 to 1,998, LUTs from 1,909
to 1,831, while FFs rise from 554 to 654. Its three BRAMs and four multiplier
slots are unchanged. Maximum measured LUT depth at hybrid-register inputs falls
from 18 to 8; that is structural evidence, not a routed-clock result. The enabled
intermediate variant used 2,025 sites and had nine levels. Evidence is in
`build/template-review/hybrid-pipeline/`.

All 233 retained actor options and 196 FIFO options were remeasured with the
final templates in `build/automatic-throughput/hybrid-pipeline`. After the user
revised the target to 35 FPS, the compiler selected again with a 108-MHz clock
input in `build/automatic-throughput/clock-margin`. No actor or FIFO choice was
forced; all scheduling and occupancy constraints remained enabled.

### Accepted automatic result

The final result uses 35 BRAMs, 96 multiplier slots and 17,527 actual routed
logic sites, with period 3,085,714 cycles: 35.0000032 scheduled FPS at 108 MHz.
The route reports a 110.509-MHz limit and passes its 108-MHz constraint. This
leaves 473 sites below the requested 18,000-site cap and 3,209 physical sites
free. A preceding run at 114.75 MHz failed timing; that clock was not retained.

Three complete frames match the reference and every scheduled transfer;
20 distinct mapped modules pass equivalence. The model hash and validation Dice
0.6500655308 are unchanged. All 18 packaging gates pass, including configuration-
scoped DSP checks and used-pin coverage. The original archived chip database
reassembles byte-identically to the routed database, and its decoded timing
records match the corrected generator used for the audit. This is tool timing
evidence, not independent signoff or physical-board measurement.

The latest structural ROM change was tested on four prefix geometries and then
validated in the complete design. Expensive checks were batched after substantive
changes. An additional registered window-availability experiment increased the
matched actor by 47 sites and did not address the new routed critical path; it
was not adopted. [Packaged result](../results/automatic-throughput/README.md).
