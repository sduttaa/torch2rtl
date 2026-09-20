# Optimized full-model schedules and narrower FIFOs

## Complete place-and-route result

The fixed four-bit-hidden candidate now completes placement, routing and bitstream
packing with all nextpnr timing checks enabled. Combining the explicit Yosys
flags `-noalu -nowidelut` reduces initial packing to 16,054 LUT sites. A corrected
nextpnr device database resolves the subsequent RAM timing-table failure described
below. This is the complete inference graph inside the observable source/sink
harness; it is not a physical-board inference demonstration or a completed I/O
transport.

The final routed report uses **17,197 LUT sites, 5,911 FF sites, 46 BRAM blocks,
64 byte multiplier slots and 19,200 distributed-memory bits**. Both weights and
working storage remain in fabric memory. Setup and hold checks pass at the
supplied **27 MHz** constraint, and the reported setup Fmax is **75.654 MHz**.
The existing three-image bit-exact RTL interval is 14,002,180 cycles, equivalent
to **1.928 inferences/s at 27 MHz**. Merely dividing by the reported setup limit
would give about 5.40 FPS; that clock has not been generated or tested on a board.
The graph's Dice remains **0.656095**, below the required 0.676843. The requested
accuracy-qualified 30-FPS result remains unmet.

The complete agreed CP-SAT model proves **14,002,180 cycles optimal for these
fixed actor/FIFO choices**, under a 20-million-cycle period cap and 40-million
offset cap. All 3,024,739 event offsets pass independent checking. The solver
takes 73.8 seconds; the full monitored run takes 143.3 seconds and peaks at
6.51 GB sampled RSS. Its emitted RTL is byte-identical to the routed input.
The fixed resource term uses the final routed utilization, including the
source/sink harness; per-option costs are zero to avoid double counting. This
is a scoped optimum, not a proof that other actor parameters cannot improve it.
The full RTL replay meets every scheduled input/output deadline for three images,
with 387,840 input words, 96,768 bit-exact output words and completion cycles
15,636,950; 29,639,130; and 43,641,310.

The stock database finishes routing but reports 376 hold violations. Investigation
of [nextpnr commit `3e53a0bf`](https://github.com/YosysHQ/nextpnr/blob/3e53a0bf/himbaechel/uarch/gowin/gowin_arch_gen.py#L2052) finds a one-variable error in its Gowin database
generator: dual-port B-address timing is added to the last single-port variant
instead of the dual-port variant. The four dual-port variants therefore add four
duplicate arcs to `SPX9` and omit their own B-address arcs. The local patch corrects
the destination; it does not disable or relax a timing check. The regression
checks all 14 B-address bits in all eight speed grades. Regenerated original and
corrected databases share a byte-identical 50,531,510-byte routing-graph prefix.
Controlled runs use the same synthesized netlist: the original again fails hold
analysis, while the corrected database passes and packs a bitstream. This remains
validation against the locally corrected open-source timing model, not independent
vendor signoff or silicon measurement.

- [Result and artifact hashes](../build/network/pipelined-row-lut4-logic/summary.json)
- [Corrected-database route report](../build/network/pipelined-row-lut4-logic/corrected-database/route-report.json)
- [Successful route/pack status](../build/network/pipelined-row-lut4-logic/corrected-database/status.json)
- [Toolflow harness bitstream](../build/network/pipelined-row-lut4-logic/corrected-database/harness.fs)
- [Original-database control](../build/network/pipelined-row-lut4-logic/original-database/status.json)
- [Generic generator correction](../patches/nextpnr-gowin-bram-timing.patch)
- [Timing-table regression](../build/verification/hold-timing/regression.json)
- [Database build provenance](../build/verification/hold-timing/build.json)
- [Explicit target with database override](../build/network/pipelined-row-lut4-logic/target-corrected.json)
- [Complete fixed-configuration CP-SAT proof](../build/scheduling/routed-fixed/report.json)
- [Scheduled three-image RTL replay](../build/scheduling/routed-fixed/simulation/report.json)

## Pipelined packed row memory

The generic packed row store now overlaps each row write with the next row's
synchronous read. With `R` delayed rows, commit latency falls from `2R` to `R`
cycles; the next issue/window-use delay is `R+1`. The scheduling adapter uses
the new measured contract. FIFO occupancy remains inside the agreed CP-SAT
model; the change does not restrict its schedule space.

The RTL has one explicit read port. The parent excludes overlapping transactions,
and simultaneous read/write addresses differ by a complete row. A local
`no_rw_check` attribute allows Yosys to avoid unnecessary read-first emulation.
Multi-frame randomized-stall tests assert both properties, and temporal induction
proves them for three elaborated geometries: a one-word row, a dilated kernel,
and ragged channel vectors. These are parameterized test cases, not a formal
proof over every possible parameter value. The initial two-read RTL trial did
not infer BRAM correctly and was discarded.

For the previous smaller-logic allocation, the complete schedule now has a
**14,007,135-cycle optimum**, with all 3,024,739 offsets independently checked.
Its period cap is 20 million and offset cap 40 million. All 387,840 input and
96,768 output words meet their RTL deadlines over three real images, with frame
completions at 15,605,061; 29,612,196; and 43,619,331 cycles. This is about a
0.77% throughput improvement over the same allocation's old 14,114,637-cycle
interval. CP-SAT takes 75.4 seconds; the full monitored process takes 194.7
seconds and peaks at 5.97 GB sampled RSS. At the proved period, 30 FPS would
require **420.21405 MHz**, which has not been achieved.

All 198 packed actor options were recharacterized. A subsequent resource/rate
screen chooses slightly smaller actors while reserving the same FIFO storage:

| Configuration | Whole-core LUT / FF | BRAM / multiplier slots | Packed LUT / FF | Result |
| --- | ---: | ---: | ---: | --- |
| Previous allocation, new row implementation | 17,584 / 5,999 | 46 / 70 | 19,252 / 7,833 | Placement fails |
| New measured selection | 17,005 / 5,877 | 46 / 64 | 18,853 / 7,711 | Placement fails |

Both use 19,200 distributed-memory bits and produce bit-exact outputs for three
images. The new selection's observed interval is 14,002,180 cycles; the complete
fixed-choice proof is now recorded above. The screen omits graph occupancy and its
six-million-cycle screening period is not an achieved network period. Doubling
the two large skip buffers is infeasible within this finite actor catalogue even
at a 16-million-cycle screening period. This is a scoped catalogue result, not
an impossibility theorem about other implementations. None of these designs
establishes physical fit, a routed clock or 30 FPS. The unchanged four-bit-hidden
model still scores 0.656095 Dice.

- [Row access proofs](../build/verification/row-collisions/report.json)
- [Complete fixed schedule](../build/scheduling/pipelined-row-schedule/report.json)
- [RTL deadline replay](../build/scheduling/pipelined-row-schedule/simulation/report.json)
- [198 measured packed options](../build/network/pipelined-row-safe/options/report.json)
- [New allocation screen](../build/scheduling/pipelined-row-screen/scale-1-period-6000000/screen.json)
- [New allocation numerical check](../build/network/pipelined-row-selected/simulation/report.json)
- [New allocation packing](../build/network/pipelined-row-selected/physical/packing-report.json)
- [New allocation placement failure](../build/network/pipelined-row-selected/physical/place-route.log)

```sh
PYTHONPATH="$PWD" python build/scheduling/replay.py \
  --schedule build/scheduling/pipelined-row-schedule \
  --vectors build/network/window-layouts/fused/simulation --frames 3
```

## Synthesis mapping investigation

### Explicit memory-placement choices

A survey of 39 explicit actor memory placements synthesizes 26 successfully.
All 13 forced distributed-ROM choices are rejected by Yosys's memory mapper;
they are excluded from the resource screen. Line-buffer migration to distributed
RAM is expensive in LUTs. Logic ROMs provide some cheaper trades: one small
actor saves a BRAM block for 202 LUTs. Extending the measured catalogue still
cannot double both large skip FIFOs within the default synthesis resource
budgets, even at the 16-million-cycle necessary actor-rate bound. This remains
a finite-catalogue result, not a general impossibility statement.

Doubling each skip FIFO separately does fit whole-core synthesis. Neither
improves the observed network interval:

| FIFO change | Whole-core LUT / FF | BRAM / multiplier slots | Observed interval |
| --- | ---: | ---: | ---: |
| Middle skip: 2,048 to 4,096 words | 17,830 / 5,945 | 46 / 64 | 14,002,180 cycles |
| Shallow skip: 8,192 to 16,384 words | 19,384 / 6,009 | 46 / 64 | 14,002,180 cycles |

Both use 19,200 distributed-memory bits and match all 96,768 output words over
three real images. Their completion cycles are 15,636,948; 29,639,128; and
43,641,308. These are simulation/synthesis diagnostics; neither has a new
complete CP-SAT certificate or physical timing result. They are not adopted as
throughput improvements. Memory placements are existing generic actor choices,
and the agreed joint scheduling/FIFO formulation is unchanged.

- [Actor memory survey](../build/network/memory-alternatives/measurements/report.json)
- [Accepted/rejected measurement provenance](../build/network/memory-alternatives/screen-provenance.json)
- [Middle-skip simulation](../build/network/memory-middle-fifo/simulation/report.json)
- [Shallow-skip simulation](../build/network/memory-shallow-fifo/simulation/report.json)

### Mapping flags

Two bounded mapping diagnostics use the same new allocation and RTL above:

| Yosys family flag | Packed LUT sites | Packed FF sites | Physical outcome |
| --- | ---: | ---: | --- |
| Default | 18,853 | 7,711 | Placement failed |
| `-noalu` | 17,780 | 7,710 | Placement failed |
| `-nowidelut` | 18,155 | 7,711 | Placement interrupted after 929.4 seconds |

All use 46 BRAM blocks and 64 multiplier slots. The four-input-LUT mapping
reports 20 legalized placement iterations, then makes no further logged progress
for 590 seconds. It is stopped at an external fifteen-minute diagnostic budget
(observed after the limit). It has no completed placement/routing certificate,
bitstream or measured clock. Its result is inconclusive, not an infeasibility
proof or a physical-fit claim. Disabling carry cells also reduces aggregate LUT
usage but does not resolve placement. Neither experiment changes RTL scheduling,
numerics or the model's 0.656095 Dice score.

`synthesis.flags` now accepts explicit standalone family-option names in target
JSON. Characterization and the routing harness share the same validated command
builder; no flag is enabled by default. Resource catalogues must be remeasured
for the chosen mapping. These are target settings, with no board/model lookup
rule added to the compiler. The full regression suite passes **378 tests**.

- [Carry-free placement failure](../build/network/pipelined-row-noalu/physical/place-route.log)
- [Four-input-LUT packing report](../build/network/pipelined-row-nowidelut/physical/packing-report.json)
- [Placement interruption record](../build/network/pipelined-row-nowidelut/termination.json)
- [Effective target input for the LUT4 experiment](../build/network/pipelined-row-nowidelut/target.json)

The original diagnostics used copies of the routing script with one synthesis
flag added. The shared flag interface reproduces the same synthesis settings:

```sh
python scripts/route-smoke.py \
  --rtl build/network/pipelined-row-selected/rtl/inference.sv \
  --input-bits 32 --output-bits 32 \
  --target build/network/pipelined-row-nowidelut/target.json \
  --constraints inputs/smoke.cst --output build/network/reproduced-mapping
```

The routing command itself has no external time limit; the recorded diagnostic
was stopped separately after verifying its process identity and elapsed time.

## Interval search and physical-resource checks

CP-SAT now proves the finite-FIFO candidate's **12,978,517-cycle optimum** in
24.6 seconds of solver wall time. The period is free up to 20 million cycles;
the offset cap is 30 million. All 3,024,739 offsets pass the independent checker.
The full RTL replay accepts all 387,840 input words and produces all 96,768
bit-exact output words at their scheduled deadlines across three images:

```text
14,383,892; 27,362,409; 40,340,926
```

The backend branches on the lower half of the period interval instead of its
minimum value. This prevents an infeasible cycle from advancing a large period
domain one value at a time. Boolean choices retain the same zero-first order.
No actor contract, FIFO constraint or feasible schedule has been removed. The
complete monitored run took 95.8 seconds and peaked at 6.69 GB sampled RSS.
This optimum fixes both actors and FIFO choices. The physical candidate still
exceeds packed LUT capacity, and 30 FPS would require 389.35551 MHz.

Allowing the four join-input FIFOs to choose depths again remains harder. With
the same finite catalogue, a 20-million-cycle period cap and an 80-million-cycle
offset cap, interval branching raises the reported lower bound from 5,936,884
to 9,452,664 cycles. It returns no solution before the external monitor stops
the process at 601.3 seconds, despite a 300-second CP-SAT time limit. Peak sampled
RSS is 6.58 GB. This is an interrupted run, not an infeasibility proof or an
optimized FIFO allocation; the fixed-configuration result above is unaffected.
A bounded comparison that branches on FIFO options before the period also
returns no solution; it is stopped at 241.4 seconds with a 7.67 GB sampled peak.
It does not improve the initial 5,936,884-cycle bound. The production adapter
therefore keeps period-first interval branching. Both comparisons preserve the
same constraints and are inconclusive about the best variable-depth allocation.

A separate necessary actor-rate/resource screen reserves the verified skip
buffers and minimizes the supplied LUT/FF cost weights. At a six-million-cycle
screening period, its selected actors with depth-two shallow FIFOs total
17,107 LUT equivalents, 5,866 FFs, 46 BRAMs, 65 multiplier slots and 19,200
distributed-memory bits. This screen omits network occupancy and is not a
feasible six-million-cycle schedule. It produces a slower RTL interval:

| Shallow FIFO depth | Observed RTL interval | Packed LUT sites | Placement |
| ---: | ---: | ---: | --- |
| 2 | 14,391,256 cycles | Not checked | Not checked |
| 8 | 14,114,637 cycles | 18,954 / 20,736 | Failed |

Both numerical checks pass three real images. The deeper shallow FIFOs improve
throughput by about 1.96%, without using more BRAM. The depth-eight whole design
packs at 46/46 BRAM blocks, 70/96 multiplier slots and 7,840/15,552 FFs, but HeAP
cannot find a legal placement. A diagnostic log shows repeated legalization of
ordinary LUT cells at failure. The alternative SA placer exits with a segmentation
fault before completing initial placement. Aggregate packing capacity is
therefore only a necessary check; neither attempt establishes fabric fit.

A further generic implementation trial removed the product register's enable,
leaving every consumer guarded by `product_valid`. All 363 tests still passed,
but the complete candidate's packed LUT count increased from 18,954 to 19,205
and placement still failed. That trial was reverted; the production actor and
its timing contract remain unchanged. Its [resource comparison](../build/network/ungated-product/comparison.json)
and [placement log](../build/network/ungated-product/physical/place-route.log)
are retained to avoid repeating the unsuccessful experiment.

The complete suite passes **363 tests**, including saved per-channel integer
exports through torch-mlir and RTL, and a large-period scheduling regression.
The training experiments remain below the accuracy target; see
[their results](training-results.md).

- [Optimized finite-FIFO schedule](../build/scheduling/binary-period-probe/report.json)
- [Schedule monitor](../build/scheduling/binary-period-probe/monitor.json)
- [Variable-depth run monitor](../build/scheduling/binary-fifo-probe/monitor.json)
- [Choices-first comparison monitor](../build/scheduling/choices-first-fifo-probe/monitor.json)
- [RTL deadline replay](../build/scheduling/binary-period-probe/simulation/report.json)
- [Logic-first resource screen](../build/scheduling/logic-reserved-options/depth-8-period-6000000/screen.json)
- [Depth-two numerical check](../build/network/logic-reserved/depth-2/simulation/report.json)
- [Depth-eight numerical check](../build/network/logic-reserved/depth-8/simulation/report.json)
- [Depth-eight packing report](../build/network/logic-reserved/depth-8/physical/packing-report.json)
- [Placement diagnostic](../build/network/logic-reserved/depth-8/physical/place-debug-summary.json)

The saved finite-FIFO schedule can be replayed after sourcing `env.sh`:

```sh
PYTHONPATH="$PWD" python build/scheduling/replay.py \
  --schedule build/scheduling/binary-period-probe \
  --vectors build/network/window-layouts/fused/simulation --frames 3
```

## Earlier full-range INT8 scheduling evidence

CP-SAT proves a **4,591,040-cycle minimum period** for the retained full-range
INT8 model with its fixed actor configuration and oversized verification FIFOs.
All 4,091,235 event offsets pass the independent checker. Newly emitted RTL
meets every scheduled input/output transfer over three real images, with all
96,768 output words bit-exact.

This optimum is scoped to those actor/FIFO choices, a five-million-cycle period
cap and a ten-million-cycle offset cap. It is not a fabric-fit result. At this
period, 30 FPS would require 137.7312 MHz; the complete design has not been
placed/routed at that frequency. The model's validation Dice remains 0.667115,
below the required 0.676843. Weights and activations remain restricted to fabric
memory for deployment; no SDRAM is used to claim a feasible implementation.

## Solver evidence and implementation

The production-default comparison spent essentially its entire five-minute
allowance in presolve and returned `UNKNOWN`, without searching. Repeated dual
strengthening visited hundreds of millions of relations. Disabling presolve,
probing and LP linearization allowed direct CP propagation to find and prove the
optimum in about 21.4 seconds of solver wall time, with one branch. The complete
monitored run, including construction, checking and archiving offsets, took
115.3 seconds and peaked at about 6.23 GB sampled RSS.

The backend now uses those settings for event scheduling problems. One-event
resource/period relaxations keep OR-Tools' presolve and LP machinery; that
structural distinction does not depend on a board, model name or tensor shape.
The three measured resource screens all returned `UNKNOWN` after 60 seconds
when those simplifications were also disabled for the one-event case. Restoring
them proved the same optima as before, with the six-million-cycle screen taking
about 0.019 seconds. The settings therefore distinguish the two problem classes.
Scheduling and FIFO capacity remain inside CP-SAT, using the agreed per-word
periodic inequalities. No pixel grouping or fixed within-pixel burst assumption
has been introduced.

FIFO forward latency is now represented once per transfer. If all depth options
have the same latency, it is a constant. Otherwise, an auxiliary integer equals
the exactly-one weighted sum of option latencies. Each availability inequality
uses that value. Capacity constraints still use the selected discrete depth.
This is equivalent to separate guarded availability constraints, while avoiding
repeated copies for every depth option. The finite fabric-budget experiment
removes 653,184 duplicate availability inequalities this way.

The constrained experiment also exposed a separate loading problem in OR-Tools'
new linear propagator. A one-second CPU sample found it inside
`LoadLinearConstraint` → `LinearPropagator.AddConstraint` → propagation ordering.
The monitored process was stopped after 504.8 seconds, having exceeded the
requested 300-second solver limit without returning a result. With the same
model fingerprint and OR-Tools' alternate linear propagator, CP-SAT completed
in 19.2 seconds. The backend now selects that propagator for event problems.

The RTL completion cycles at the optimized period are:

```text
5,815,872; 10,406,912; 14,997,952
```

Every one of the 387,840 input words was accepted at its specified cycle. Every
output was available at its specified cycle, including across inference
boundaries. These are scheduled simulation deadlines, not board measurements.

A repeat under the final production adapter settings proves the same optimum
in 23.8 seconds of CP-SAT wall time. The complete saved schedules are identical:
all 4,091,235 JSON-lines records hash to
`8b2287657b53e0db3400a9487c01eeeabc68adc7a826960f8dde8fd33d802cd0`.
The monitored production run took 122.4 seconds and peaked at 6.32 GB sampled
RSS. The previous RTL deadline check therefore applies to exactly the same
returned event assignment.

## Exact storage reduction

For a stream with `C` tensor channels and `L` vector lanes, a FIFO now stores
`min(C, L)` lanes. If `C < L`, the remaining lanes are absent from every pixel;
reconstructing them as zero cannot change tensor values. The existing proved
per-element storage width is preserved. If `C >= L`, the FIFO retains all lanes,
even when the final word of each pixel is partially filled.

Actor ports and ready/valid timing are unchanged. Tests exercise signed and
unsigned narrow values, branched graphs, parallel and packed row memories,
multiple frames, backpressure and arbitrary junk in unused input lanes.
`emit-network` reports each FIFO's physical word width and logical depth, so
external cost catalogues can use the emitted representation.

Measured standalone FIFO costs for the supplied target include:

| Logical depth | Word width | BRAM blocks | LUT equivalents | FFs |
| ---: | ---: | ---: | ---: | ---: |
| 2,048 | 8 | 1 | 128 | 64 |
| 2,048 | 16 | 2 | 158 | 80 |
| 2,048 | 24 | 3 | 147 | 96 |
| 2,048 | 32 | 4 | 141 | 112 |
| 8,192 | 8 | 4 | 126 | 72 |
| 8,192 | 16 | 8 | 150 | 88 |

These are measured option costs, not a whole-design fit certificate. Smaller
width does not guarantee lower LUT usage: the synthesis tool can choose a
different memory implementation, so resource selection must use measured costs.

## Reproduction and limits

- [Presolve comparison](../build/scheduling/default-period-probe/result.json)
- [Optimized full-model result](../build/scheduling/direct-period-probe/result.json)
- [Solver log](../build/scheduling/direct-period-probe/solve.log)
- [Memory/time monitor](../build/scheduling/direct-period-probe/monitor.json)
- [Final production adapter result](../build/scheduling/production-period-probe/result.json)
- [Complete schedule comparison](../build/scheduling/production-period-probe/schedule-comparison.json)
- [Full RTL deadline verification](../build/scheduling/direct-period-probe/simulation/report.json)
- [Schedule and RTL reproduction](../build/scheduling/direct-period-probe/check-rtl.py)
- [Eight-bit FIFO measurements](../build/scheduling/fifo-options-8/report.json)
- [Twenty-four-bit FIFO measurements](../build/scheduling/fifo-options-24/report.json)
- [Finite fabric-budget catalogue](../build/scheduling/fabric-fifo-probe/catalogue.json)

The complete suite passes **341 tests**. The best retrained accuracy checkpoint
is unchanged. Physical fabric fit, closed full-model timing and sustained 30 FPS
remain unverified.

## Fabric-budget investigation

A measured finite catalogue fixes one low-memory actor configuration and lets
four concatenation inputs choose depths 2, 512, 2,048 or 8,192. Other edges use
depth 2. This is an explicit experimental option set, not a claim to cover all
hardware implementations. The four-bit-activation model is unchanged and still
has Dice 0.656095.

Its resource-only preflight fits, but the full model has 3,024,739 events and
4,194,152 actor dependencies. CP-SAT proves it infeasible both with a
six-million-cycle period / twenty-million-cycle offset cap and with a
ten-million-cycle period / forty-million-cycle offset cap. These results apply
to the given catalogue and caps. A twenty-million-cycle optimization stalled
while advancing its period lower bound by one cycle; it was stopped after
424.2 seconds, without a feasible solution or infeasibility proof.

An independent RTL check of one budget-feasible allocation in this catalogue
helps interpret the caps. It uses 2,048 words on one narrow skip stream and
8,192 on the other, with depth 2 elsewhere. The forty-million-cycle simulation
limit expired after 94,826 correct outputs. Extending that same check completed
all 96,768 outputs bit-exactly, with frame completions:

```text
14,383,890; 27,362,407; 40,340,924
```

Both observed frame intervals are 12,978,517 cycles, above the two caps proved
infeasible. This is an independent diagnostic of a specific allocation; FIFO
optimization remains in CP-SAT. Thirty FPS at this interval would require about
389.36 MHz, which has not been achieved.

Whole-network synthesis of this complete candidate uses:

| Resource | Synthesized | Supplied budget |
| --- | ---: | ---: |
| LUT equivalents | 19,606 | 20,736 |
| FFs | 6,795 | 15,552 |
| BRAM blocks | 43 | 46 |
| Byte-multiplier slots | 94 | 96 |
| Distributed-memory bits | 19,200 | 41,472 |

The full design uses five more multiplier slots than the sum of isolated option
costs, reinforcing the need for whole-design verification. It still fits every
supplied synthesis budget. However, nextpnr packing for the complete source/sink
harness requires **21,539 LUT sites versus 20,736 available (103%)**, while BRAM
and multipliers remain at 43/46 and 94/96. The physical packing overhead and
harness must be accounted for beyond the current Yosys cell-sum estimates.
Placement was stopped after this overrun; no fit or routed frequency is claimed.
The routing harness now removes Yosys alias buffers before exporting JSON, as
the core synthesis flow already does. It also runs nextpnr's pack-only resource
check before placement and rejects any reported positive-capacity resource
overrun. Stale route reports and bitstreams are cleared before a new attempt.

For this exact candidate, a further CP-SAT run fixes the period at 15,000,000
cycles and the offset cap at 30,000,000. All 3,024,739 event offsets, actor
dependencies, resource estimates and FIFO constraints pass the independent
checker. The solver returns `OPTIMAL` because the period and option choices are
fixed; **this is a feasibility certificate, not a throughput optimum**. Including
the resource tie-break, solver time is 38.2 seconds; the monitored run takes
122.0 seconds and peaks at 7.45 GB sampled RSS.

The emitted RTL is byte-identical to the candidate above, with SHA-256
`8d0d49100d6f16afb28bd1f4aeffbf82aeb487ea80cfa3e857aa7647b6b46535`.
All 387,840 scheduled input words and 96,768 output words meet their deadlines
over three images, with output completions at 14,383,892; 29,383,892; and
44,383,892 cycles. The complete test suite remains **341 passing tests**.

- [Six-million-cycle result](../build/scheduling/alternate-fifo-probe/report.json)
- [Ten-million-cycle result](../build/scheduling/fabric-expanded-bounds/report.json)
- [Stalled wider search](../build/scheduling/fabric-wide-bounds/termination.json)
- [Independent candidate configuration](../build/scheduling/fabric-candidate-check/configuration.json)
- [Full candidate RTL simulation](../build/scheduling/fabric-candidate-check/simulation-longer/report.json)
- [Whole-candidate synthesis](../build/scheduling/fabric-candidate-check/synthesis/report.json)
- [Physical packing overrun](../build/scheduling/fabric-candidate-check/physical/termination.json)
- [Automatic packing rejection](../build/scheduling/fabric-candidate-check/packing-preflight/packing-report.json)
- [Successful integration routing with the new check](../build/acceptance/packing-preflight/route-report.json)
- [Budgeted fixed-period schedule](../build/scheduling/fabric-fixed-period/report.json)
- [Byte-identical RTL comparison](../build/scheduling/fabric-fixed-period/rtl-comparison.json)
- [Budgeted schedule RTL deadlines](../build/scheduling/fabric-fixed-period/simulation/report.json)

The packing preflight reproduces the candidate's 803-site LUT overrun and stops
before creating a placement log or bitstream. The small integration kernel
still passes packing, placement, routing at its supplied 27-MHz constraint and
bitstream packing with the updated script. This does not transfer its frequency
result to the full model.

Next work should account for packed resources in option selection, retain
enough memory for the skip paths without minimizing BRAM at the expense of
logic, and expose more shallow FIFO depths to recover the throughput lost with
depth-two links. The low-period search also needs a branching strategy that
does not advance the period by one cycle after each failed trial. Accuracy
requires a separate evaluated training improvement; these compiler changes do
not improve the model's validation predictions.
