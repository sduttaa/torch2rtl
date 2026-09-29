# Timing, templates, search, and regression checks

The compiler still optimizes input-defined graphs and devices. Model names,
board names, parts, frequencies, budgets and pinouts do not select implementations
inside the compiler.

## Clock-aware implementation

```sh
source ./env.sh
python scripts/compile-and-verify.py --job inputs/demo-clock-job.json
```

This example job supplies two generated PLL implementations and allows at most
two physical attempts. Existing single-clock jobs keep their command and behavior.
Other boards must supply their own target, constraints and legal clock RTL.
The current physical verification harness supports Gowin; this change does not
claim equivalent end-to-end Lattice support.

For each supplied clock `f`, the compiler solves actor choices, scheduling and
FIFO occupancy using the same characterized candidate catalogue. A verified
schedule with period `P` predicts `f/P` inferences/s. Resource estimates alone
never establish clock feasibility. The first physical attempt is ranked by
scheduled throughput, then resource pressure for nearly equal rates.

On a frequency miss, the next attempt prioritizes legal clock choices below
`routed_fmax * (1 - timing_margin)` and compares their predicted throughput.
That feedback is a heuristic: a changed architecture or placement can change
timing. Every attempted clock gets actual RTL simulation, mapping proofs,
place-and-route and the existing timing-model audits. A failed numerical,
resource or audit check remains fatal. Retries cannot change the model or budget.

The final selection prefers a clock-safe bitstream and then its reported FPS.
It stops when no remaining plan predicts better FPS than a safe result, or when
the attempt budget is exhausted. Reaching the requested FPS stops exploration
only when the search input explicitly enables `stop_at_required_fps`; the supplied
demo and automatic search files disable it. Scheduling likewise continues to
minimize the period within its solver budget after meeting the FPS target.
If every attempt
misses timing, it preserves the best performance report without an unsafe
bitstream. A missed throughput goal falls back to scheduling within the input
period limit instead of failing solely because of that goal. This is a bounded
search, not a proof of globally best routed FPS.

`clock-plans.json` records predictions. `implementation-search.json` records
attempts, feedback and selection. `clock-verification.json` checks actual
synthesized clock connectivity and static PLL dividers against the target before
packing. A lower timing constraint paired with an unchanged faster PLL is rejected.
The verifier currently understands direct clocks and Gowin static internal-feedback
`rPLL.CLKOUT`; unsupported clock mechanisms fail explicitly.

## Fused address decoding

The resize/concatenate/convolution actor used two consecutive lookups: dot-product
step to window word, then window word to source coordinates. The new template
composes these static maps during elaboration. It removes the output-block index
from single-group view addressing and leaves unreachable array indices undefined,
as in the original lookups. Branch ownership gates validity rather than every
address bit; row, column and channel validity are factored separately. Source
storage, quantization, startup, row lifetimes
and the two-edge memory pipeline are unchanged.

Cycle contracts therefore stay the same. Grouped, dilated, signed, ragged,
hybrid-memory and consecutive-frame simulations check that claim, including exact
scheduled transfers and backpressure. This change alone does not establish an
end-to-end FPS gain; synthesis/packing and routing evidence must distinguish area
from timing effects.

An isolated resize/concat/convolution probe used 672 LUTs and 766 packed logic
sites after this change, versus 698 LUTs and 784 sites before it. Both used three
BRAM blocks and two DSP slots; flip-flops increased from 321 to 328. This is a
small template comparison, not the trained model's whole-design result.

## Bounded characterization

Analytical geometry and cycle bounds screen the space first. `max_actor_options`
caps each actor's retained set. Optional `initial_actor_options` can reduce the
first measured set; it must not exceed that cap. The existing retention heuristic
keeps compute, memory, quantizer and buffering alternatives.

`refinement_options` bounds new actor measurements **across the whole graph per
refinement round**, defaulting to `max_actor_options`. Refinement prioritizes the
new global resource proposal, bottleneck improvements and savings in pressured
resources. It preserves the measured incumbent. It does not call different burst
or row-lifetime contracts equivalent merely because their period bounds match.
Cached alternatives can be reconsidered without consuming synthesis jobs.

All raw synthesis, mapping and packing cache entries use per-entry process locks.
A second compiler process waits for the first producer. A complete JSON report is
published with atomic replacement only after its artifacts exist. Interrupted or
malformed entries are rebuilt. Identity includes RTL, relevant tool/settings and
mapping identity, so changing templates does not reuse stale costs.

`compile-metrics.json` records elapsed compile time and actual actor synthesis,
mapping and packing invocations. `phase-metrics.json` records end-to-end stage
times. Cache hits are not counted as synthesis jobs.

An optional `joint_event_limit` bounds the number of events sent to CP-SAT when
implementation choices remain variable. The compiler first minimizes the period
of its own feasible proposal, releasing the earlier proposal model before
expanding alternatives. If the joint event budget is exceeded, it retains that
verified proposal and reports the limitation. The resource lower bound is kept
separate from the fixed proposal's optimum; only matching the former establishes
the minimum period for the retained catalogue. This budget does not set an FPS
cap. Small problems continue through the full joint search.

## Small benchmark suite

```sh
python scripts/benchmark.py --target inputs/throughput-target.json \
  --output build/benchmarks
```

The default `quick` mode performs **no synthesis or routing**. Four data-defined
PyTorch graphs cover convolution/pool/head, depthwise/pointwise, resize/concat
branches and ragged dilated convolution. Each goes through export and torch-mlir,
automatic CP-SAT selection, exact scheduled RTL transfers, randomized backpressure,
midstream reset and at least three consecutive frames. Depthwise uses a scalar
stream as explicit case input because current grouped actors require stream words
to align with group boundaries.

Use `--mode measure --cache build/characterization-cache` for measured candidate
costs. Use `--mode route --physical-job inputs/automatic-job.json` to opt into
whole-design routing using explicit pins and clock RTL. The supplied target must
match those physical inputs. Routing mode records tool timing; the benchmark report
does not certify vendor timing-model coverage or physical board behavior.

The report separates analytical costs, characterized costs, scheduled FPS and
routed FPS. It includes period, first-frame latency, resources, elapsed time and
actor tool-job counts. Unperformed physical measurements are `null`, not predictions
presented as measurements. Quick success means correctness and a verified schedule;
it does not prove physical fit or optimal throughput.

Validation of this implementation included 266 focused tests, all four quick
benchmark graphs, and one routed resize/concat benchmark with mapping proofs.
That small graph passed a 96 MHz constraint with a reported 140.13 MHz Fmax and
1,277 routed logic sites. The trained demo model has not been rerouted as part of
this change, so its FPS improvement remains unmeasured.
