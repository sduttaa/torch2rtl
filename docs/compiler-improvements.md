# Generic memory and throughput optimization

The current work preserves the exported integer model. The stretch objective is
35 BRAM blocks and 50 sustained inferences/s; neither is promised. Target resource
budgets, physical memory modes, clock candidates and search limits are inputs.

An implementation option couples compute lanes, memory geometry, pipeline
contract and resource costs. At a fixed supplied clock, CP-SAT first minimizes
the periodic inference interval and then minimizes BRAM at the same interval.
Repeating with supplied memory budgets exposes the throughput/memory tradeoff.
Scheduling and ordered FIFO occupancy remain inside CP-SAT. Estimates screen
candidates; whole-design synthesis, placement and timing validate selected ones.

The optional resize/concat/convolution fusion retains the original coordinate
mapping and integer requantization boundaries. A shared window provider stores
source rows before expansion and presents the convolution's original logical
window. Fusion eligibility is based only on graph semantics and stream geometry;
unsupported patterns retain their existing actors. Memory-port schedules and row
lifetimes are part of the fused actor contract.

Characterization is cached by emitted RTL, target synthesis settings and tool
identity. Cheap geometry, period bounds and joint schedule checks precede new
synthesis. Full-network simulation and routing are reserved for candidates with
a demonstrated reason to improve resource use or throughput.

The latest timing-checked selection uses **35 BRAMs** at **30.7049 scheduled
inferences/s**, with a 3,737,193-cycle period at 114.75 MHz. Nextpnr reports a
115.674-MHz setup limit and the bitstream packs successfully. The unchanged
model retains validation Dice 0.6500655308. This saves nine BRAMs over the prior
44-BRAM result while preserving the required 30 FPS. The 50-FPS stretch goal
remains unmet. No physical-board FPS measurement was performed. See
[the saved result and scope](../results/bram-reduction/README.md) and
[the additional storage and timing changes](bram-reduction.md).
The previous accepted artifacts remain under `results/compiler-optimization`
and `results/on-chip-inference`.

## Compiler entry point

`optimize-network` takes a model, a target description, and finite search limits.
No actor names or hand-selected per-layer settings are required:

```sh
source ./env.sh
python -m torch2rtl optimize-network results/on-chip-inference/model.pt2 \
  --target inputs/optimization-target.json \
  --search inputs/optimization-search.json \
  --cache build/characterization-cache --stage screen \
  --output build/compiler-optimization/screen
```

`screen` performs geometry and actor-period analysis and reuses exact existing
actor-cost cache hits; it never synthesizes a cache miss. `measure` additionally
synthesizes retained actor/FIFO options, keyed by exact RTL, tool identity and
target mapping settings. `schedule` also solves the complete joint event problem
and emits its selected configuration and RTL. Every option remains subject to
whole-design placement and timing. Raw isolated cell totals omit physical
packing overhead; the optional pack-only accounting includes mandatory site
reservations but still does not establish legal placement or timing.

The screen first solves a global resource/period relaxation across generated
options, then retains a bounded neighborhood, including memory and compute-lane
tradeoffs. This is a heuristic restriction of the architecture catalogue, not a
global optimality claim. All retained schedules and FIFO occupancy constraints
are represented directly in CP-SAT. Alternative implementations share internal
event variables, and identical dependencies across all alternatives are factored
out exactly, reducing model construction and solver memory.

The target supplies memory widths, depths, read/write ports, and resource costs.
Geometry records distinguish useful payload from allocated physical capacity.
Weight ROMs can put an incomplete block-sized tail in logic. Fused spatial views
store compact source rows at the smaller of the proven source and aligned
widths. Exact scale alignment occurs on write or read accordingly. Proven graph
ranges determine widths; calibration samples never justify narrowing. Window
readiness uses the last required source word, and row overwrite protection and
extra source rows are represented in both RTL and scheduling.

Characterization has separate raw-synthesis, optional family mapping, and
pack-only physical-accounting cache layers. Changing a mapping policy can reuse
raw synthesis. Gowin targets can request exclusive product-register absorption into
DSP output registers and area-oriented LUT mapping. The physical flow checks
mandatory LUT sites before placement; isolated LUT totals alone miss FF packing
restrictions. Each target chooses these mechanisms explicitly.

The pack-only layer includes carry-chain padding, distributed-RAM reserved
sites, and FF placement restrictions. Temporary isolated actor pads receive
distinct device sites only to satisfy packing; they are never board pin
assignments or routed designs. The cache includes the packer build and chip
database hash. The final design still needs legal placement and timing closure.

With mapped characterization enabled, `optimize-network` also emits a
`schedule/mapped` directory. `route-smoke.py --mapped-network` links these exact
implementations and synthesizes the wrapper, preserving measured internal
mapping. `emit-network --mapped-target TARGET --cache CACHE` exposes the same
path for an explicit configuration. It removes isolated I/O pads before
linking. `prove-mapped-network.py` checks each distinct actor's register packing
and LUT mapping. A mapped-link backpressure simulation checks the interface
transformation separately.

An optional `initial_configuration` search input supplies architecture hints.
An optional `initial_schedule` names a directory containing `configuration.json`,
`report.json`, and `offsets.jsonl.gz`. Reuse checks model identity and every
constraint of the current complete problem. Hints never lock actor or FIFO
choices. A verified incumbent survives a joint-search timeout with `FEASIBLE`
status, without claiming joint optimality. Solver limits exclude Python model
construction and validation time.
Resource totals are recomputed from the current catalogue before a saved
schedule is validated, so a template's changed cost cannot silently retain
stale resource accounting.
`schedule-network --validate-only` checks such an incumbent against the complete
current problem and emits current RTL without rebuilding a CP-SAT search model.
It requires `initial_schedule`, clears old optimality claims and lower bounds,
and still rejects stale event timing or insufficient resources. This is useful
after a latency-preserving template improvement.

## Verification and implementation findings

Fused views have numerical, backpressure, grouped/dilated convolution, export,
and periodic-deadline tests. Separate checks cover physical-memory port demand,
cache invalidation, hybrid ROM reads, and FIFO values spanning frame boundaries.

The first fused address implementation inferred runtime division and substantial
unintended arithmetic. One isolated synthesis measured 20,354 LUTs and 32 signed
9x9 multiplier slots. Moving coordinate arithmetic to compile-time tables reduced
that example to 5,737 LUTs and the intended 16 slots, retaining three BRAMs. This
is an actor implementation comparison, not a full-network performance result.
Subsequent characterization also bounds actor input ports by their proven graph
ranges, matching the connected network's narrow FIFO interfaces.

Recorded verification batches cover 159 convolution, pooling, fused-view and
schedule tests; 50 subsequent startup-selection checks; 30 solver/FIFO/saved-
schedule checks; and 13 memory, mapping, cache and linking checks. These batches
overlap and are not a count of distinct tests. The final full model's three-frame
check uses existing nonzero reference vectors and checks exact values and every
periodic transfer deadline. All 24 distinct mapped modules pass their applicable
register-packing and LUT-mapping equivalence checks.

The large graph exposes a remaining solver limitation: cold joint searches over
roughly two million events can time out without an incumbent. Shared events,
factored choice-dependent delays, grouped FIFO depth guards, and verified warm
starts reduce the cost but do not establish scalable global optimality. Search
screening and time limits remain explicit in the reports. A valid schedule
found with fixed choices is only optimal for those choices.

Fused coordinate tables use exact affine expressions when a power-of-two
period exists, with masked padding entries excluded from the fit. Irregular
maps retain the original tables. Readiness shares the same column-address
calculation rather than allocating a second column table. These are static
graph-derived transformations, with no model or board identifiers in the rules.

The fused address pipeline first registers row/column descriptors, then selects
and registers a window coordinate, then adds its pieces at the RAM address.
Readiness uses registered required-word counts. The scheduling contract includes
three cycles from a frame/window advance to a new start and two cycles from a
row release to newly reusable input capacity. Directed schedule tests and the
full-network transfer-deadline simulation check these delays.
The convolution's startup selection occurs after coordinate decoding, so its
state signal does not pass through the large prefetch coordinate multiplexer.
This preserves the same read latency; isolated mapped examples reduced that
control path from 11 to 3 and from 10 to 2 logic levels.
A compact row-slot encoding was also tested. Although its isolated lookup
depth and register count improved, whole-design routed timing regressed, so
that change was reverted. Isolated mapping gains are not accepted as physical
performance gains.

Control-ROM reset belongs on the lookup address. Resetting the ROM output
prevented output-register absorption in Yosys; its memory pass instead absorbed
the input address register, extending the critical path through the row counter
and table. The revised form preserves the same RTL behavior and allows direct
synchronous ROM reads. Isolated synthesis logs verify output-register merging
for each fused row contract. See Yosys's
[memory-register transformation](https://yosyshq.readthedocs.io/projects/yosys/en/latest/using_yosys/synthesis/memory.html).

Convolution control primes the prefetch counter outside dot-product execution.
Tile initialization is registered in the existing operand startup interval;
bias selection uses the newly advanced block and a direct registered ROM read.
This also prevents address-register absorption from moving block-update control
through the bias lookup. Downstream ready therefore does not feed accumulator
initialization in the same cycle. No compute cycle or arithmetic operation is
removed. The template passed 159 focused
convolution, pooling, fused-view and periodic-schedule tests.

The 35-BRAM minimum-row-buffer candidate scheduled at about 20 FPS, so it was
not routed. A 40-BRAM budget with an extra source row in each fused actor
produced a 39-BRAM catalogue selection with a 3,573,483-cycle period. Its three
full RTL frames matched the unchanged model and all deadlines. Physical
results are recorded separately; a catalogue total is not a placement result.
The first whole-design pack rejected that candidate: early actor costs omitted
carry padding and distributed-RAM reserved sites. The pack-only cost layer
corrects that omission. A subsequent 43-BRAM selection met the necessary site
count but failed legal placement near capacity. The search therefore also
reserves explicit placement headroom; neither failure was waived.

The final run reuses cached actor characterization in a bounded neighborhood of
previous compiler-selected configurations. A resource/actor-period relaxation
chooses 44 BRAMs, 95 signed nine-bit multiplier slots and an estimated 18,851
mandatory logic sites including the harness reserve. The full ordered-event
problem then proves the 3,573,484-cycle period with these choices fixed. The
whole-design physical count is 18,636 mandatory sites; placement and timing
pass at 108 MHz. This is a compiler-selected architecture, but not a proof of
globally optimal architecture or throughput. Cold joint architecture searches
remain limited by the graph's roughly two million events.

The two large branch FIFOs have selected depths of 2,048 and 8,192 words. Their
verified peak occupancies are 1,326 and 7,323 words. Average occupancy is not a
safe depth bound, and shrinking a logical depth need not save a physical block.
The current implementation uses 95 of 96 multiplier slots; reaching 50 FPS at
108 MHz would require reducing the interval from 3,573,484 to 2,160,000 cycles.
These observations explain the remaining difficulty without establishing an
impossibility result. Rejected timing experiments are retained in the result's
`timing-development.json`.
