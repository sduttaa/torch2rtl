# Generic compiler optimization result

The unchanged integer model now has a **44-BRAM, 30.2226 scheduled-FPS**
implementation at **108 MHz**. Its periodic interval is **3,573,484 cycles**.
Nextpnr reports a **109.218-MHz** setup limit, passes the clock constraint, and
produces the included bitstream. The **35-BRAM / 50-FPS goal remains unmet**.

| Metric | Previous result | Current result |
| --- | ---: | ---: |
| BRAM blocks | 46 | 44 |
| Scheduled inferences/s | 30.1131 | 30.2226 |
| Period, cycles | 3,810,633 | 3,573,484 |
| Configured clock, MHz | 114.75 | 108 |
| Signed 9×9 multiplier slots | 88 | 95 |
| Mandatory logic sites | 18,784 | 18,636 |
| Validation Dice | 0.6500655308 | 0.6500655308 |

Both weights and intermediate storage remain in FPGA fabric memory. The model
is identical to `../on-chip-inference/model.pt2`; no retraining, operator
substitution, or model-specific compiler rule produced this improvement.
Accuracy is inherited from that unchanged model. The 49-image validation split
was used for checkpoint selection and is not an independent test set.

## Implemented changes

1. Target-supplied memory geometry and ports guide block/distributed/logic
   allocation, packed line storage, and hybrid weight-ROM tails. Cached
   physical packing accounts for carry padding and reserved memory sites.
2. Generic actor and FIFO catalogues expose lane counts, memory styles and
   capacities to the solver. Resource/period screening precedes characterization;
   exact mapped actor implementations are reused in the full design.
3. Registered row/bias lookups, prefetch control and startup coordinate selection
   shorten critical paths without changing the arithmetic or actor interval.
4. Legal nearest-resize → quantized-concat → convolution patterns become fused
   actors storing compact source rows. Coordinate maps, rounding, overflow,
   padding and proven narrow storage are preserved. This result contains two
   such actors and one convolution/pooling actor.
5. Ordered FIFO slot reuse, row lifetimes, branch dependencies and periodic
   scheduling are represented directly in CP-SAT. Reports include peak and
   average FIFO occupancy. The problem representation remains backend independent.

Rules depend on graph semantics, shapes and explicit target/search inputs.
They do not inspect board names, model names or particular layer identifiers.
Unsupported fusion patterns retain their existing actors.

## Verification and limits

Three complete nonzero RTL frames match the integer reference exactly and meet
every scheduled input/output deadline. Their completion cycles are 4,301,165,
7,874,649 and 11,448,133, giving the claimed steady interval. The emitted,
scheduled and simulated RTL hashes agree. All 24 distinct mapped modules pass
their applicable mapping equivalence checks. Focused regression batches and
their original logs are recorded in `result.json`; no new training or repeated
full-model accuracy sweep was necessary.

The physical flow uses the corrected timing database, a passing guard for the
exact 95 DSP configurations, and a structural audit with no missing used pins.
No timing failure was waived. These checks do not constitute independent timing
signoff or a physical-board measurement. The timing margin remains modest.

`harness.fs` is the counter-source/checksum toolflow bitstream represented by
`harness.sv`, `pll.sv` and `constraints.cst`. It does not implement a camera or
host image-transfer interface. No board programming or physical-board FPS
measurement was performed.

The final architecture was selected by a CP-SAT resource/actor-period relaxation
over the bounded, measured `candidate-catalogue.json`. Its output is
`architecture-bound.json`. The complete event/FIFO problem was then solved using
the fixed choices in `selected-catalogue.json`. The schedule's `OPTIMAL` status
applies only to those choices. The implementation supports joint choice/event
search, but cold searches on this roughly two-million-event graph can time out;
this result is not a claim of globally optimal architecture.

The 35-BRAM candidate scheduled at approximately 20 FPS and was not routed.
Other smaller candidates failed physical capacity, placement or timing checks.
The final choice preserves the required 30 FPS while saving two blocks.
`timing-development.json` retains the timing experiments, including the reverted
row-slot representation. At 108 MHz, 50 FPS would require a 2,160,000-cycle
interval, about 40% shorter than the current one. The design already consumes
95 of 96 multiplier slots, so additional lanes alone offer little headroom.

## Artifacts and reproduction

`result.json` records the acceptance gates, scope, and SHA-256 references to the
full evidence. `manifest.json` covers the saved files. `compiler-source-hashes.json`
identifies the producing source. Large netlists, simulation vectors and solver
offsets remain under `build/compiler-optimization/rate-headroom-*` and are linked
by hash. The prior accepted result remains untouched in `../on-chip-inference`.

From the repository directory, these commands reproduce emission or scheduling
from the saved compiler-selected choices:

```sh
source ./env.sh
python -m torch2rtl emit-network \
  --configuration results/compiler-optimization/configuration.json \
  --mapped-target results/compiler-optimization/target.json \
  --cache build/characterization-cache --output build/reproduce-optimization

python -m torch2rtl schedule-network \
  --catalogue results/compiler-optimization/selected-catalogue.json \
  --target results/compiler-optimization/target.json \
  --seconds 60 --output build/reproduce-schedule
```

The saved external inputs contain local model/tool paths. Update those paths
when moving the project. `search.json` records the broader search space; the
final candidate catalogue is a bounded neighborhood of prior compiler outputs,
so rerunning that broad search is not guaranteed to reproduce the same selection.
See [the compiler workflow](../../docs/compiler-improvements.md) for generating
new catalogues without per-layer settings. Route only after schedule and
resource checks justify the cost:

```sh
python scripts/route-smoke.py \
  --mapped-network build/reproduce-optimization/mapped \
  --input-bits 32 --output-bits 32 \
  --target results/compiler-optimization/target.json \
  --constraints results/compiler-optimization/constraints.cst \
  --clock-rtl results/compiler-optimization/pll.sv \
  --reference-clock-hz 27000000 --output build/reproduce-route
```

After routing, repeat the DSP-configuration and pin-coverage checks with the
recorded timing database. `toolflow-summary.json` intentionally reports only the
route tool's scope; `result.json` combines its evidence with the separate checks.
