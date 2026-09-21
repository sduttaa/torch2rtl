# Generic compiler result at 35 BRAM

The unchanged integer model uses **35 BRAM blocks** and achieves
**30.7049 scheduled inferences/s** at **114.75 MHz**.
Its period is **3,737,193 cycles**. Nextpnr reports
**115.674 MHz** and passes the clock constraint. These are simulation
and routed-toolflow results, not physical-board measurements. The 50-FPS stretch
goal remains unmet.

| Metric | Previous accepted implementation | This implementation |
| --- | ---: | ---: |
| BRAM blocks | 44 | 35 |
| Scheduled inferences/s | 30.2226 | 30.7049 |
| Configured clock, MHz | 108 | 114.75 |
| Period, cycles | 3,573,484 | 3,737,193 |
| Signed 9×9 multiplier slots | 95 | 91 |
| Mandatory logic sites | 18,636 | 19,349 |
| Validation Dice | 0.6500655308 | 0.6500655308 |

All weights and working storage remain in FPGA fabric memory. The model hash
matches the accepted model in `../on-chip-inference/model.pt2`. Accuracy is
inherited from that unchanged model; the 49-image validation split was used
for checkpoint selection and is not an independent test set.

## Generic compiler changes

1. Exact inverse thresholds implement small monotone integer quantizers when
   their overflow proof permits it. CP-SAT can select this implementation or
   multiplication. Registered threshold lookahead preserves the cycle count
   while separating lookup and comparison paths.
2. Fused nearest-resize/concatenate/convolution actors retain compact source
   rows and release words after their last use. Per-input source buffers can
   absorb incoming branch FIFOs, avoiding duplicate physical allocations.
3. Source buffers prefetch across inference boundaries when the circular depth
   divides the frame size. Other geometries retain the existing per-frame
   contract. CP-SAT directly includes these lifetimes and cross-frame writes.
4. Large logic weight ROMs use registered small banks. Selection occupies the
   existing multiplier-input stage, preserving the actor's read latency.
   Convolution startup selection follows registered coordinate decoding, keeping
   control off the pooled/grouped window-address path.
5. Candidate screening reuses exact cached RTL costs before pruning. Board
   resources, model paths, search limits, and initial configurations remain
   external inputs. No rule matches model names, board names, or layer IDs.

The earlier work also supplies target-driven memory geometry, packed storage,
hybrid weight-ROM candidates, generic actor parameter catalogues, legal
convolution/pooling fusion, and direct FIFO occupancy constraints.

## Evidence and scope

Three complete nonzero input frames produce 96,768 bit-exact output words and
meet every scheduled input/output deadline. Their steady completion interval
equals the reported period. All 22 distinct mapped modules
pass the applicable equivalence checks. The final startup change passes 128
focused convolution, pooling, and quantizer tests. Scoped regression logs, current source
hashes, and hashes of the full evidence are recorded in `result.json`.

The first 35-BRAM route failed at 92.40 MHz on threshold lookup/comparison.
Registered threshold lookahead exposed a weight-ROM path at 92.96 MHz. Banking
logic weight ROMs raised the limit to 98.59 MHz and exposed a source-frame
completion path through a row lookup. Removing its redundant address mux
preserves the existing validity pipeline. A further 91.68-MHz route showed that
synthesis had merged threshold selection back into the lookup. Explicit child
registers prevent that merge, and a compact binary-tree table keeps them within
the logic budget. The initial paired-table choice failed legal placement; a
smaller compiler choice freed 502 logic sites and reached 111.78 MHz, still
below its required clock. Moving convolution startup selection after registered
coordinate decoding saved another 118 measured sites and removed that critical
path. All failed reports are preserved; no timing failure was waived. Fresh
costs, full-frame simulation, and physical
checks followed each substantive timing change. Routine edits used focused
checks and cached measurements.

The final periodic schedule was validated against every current constraint
after the template changes. CP-SAT's earlier optimal-period result applies to
the fixed architecture. Candidate screening is bounded and heuristic; there is
no claim of a globally optimal architecture.

The corrected timing database, exact DSP-configuration guard, and used-pin
audit pass. These are not independent timing signoff. `harness.fs` is the
counter-source/checksum toolflow harness; it has no host or camera transport.
No board programming or physical-board FPS measurement was performed.

## Reproduction

Run from the project directory:

```sh
source ./env.sh
python -m torch2rtl schedule-network \
  --catalogue results/bram-reduction/selected-catalogue.json \
  --target results/bram-reduction/target.json \
  --seconds 60 --output build/reproduce-bram/schedule
python -m torch2rtl emit-network \
  --configuration build/reproduce-bram/schedule/configuration.json \
  --mapped-target results/bram-reduction/target.json \
  --cache build/characterization-cache --output build/reproduce-bram/linked
```

`inputs/bram-search.json` describes a generic incremental search from an input
configuration. Run `optimize-network --stage screen` first. A fresh search can
select a different architecture as the exact-cost cache and search limits
change. The saved selected catalogue reproduces this particular implementation.
See `../../docs/bram-reduction.md` for the mathematical contracts and tradeoffs.
