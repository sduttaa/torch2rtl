# Current 30-FPS push

**The compiled 30-FPS target now passes:** **30.1131 scheduled FPS** at **114.75 MHz**, with validation **Dice 0.6500655308**. Nextpnr passes the final clock constraint, reports a 115.22065-MHz setup limit, and packs the bitstream successfully. All weights and activations stay in fabric memory. Three complete RTL frames match the integer reference exactly and meet the 3,810,633-cycle periodic schedule.

The deliverable is [results/on-chip-inference](../results/on-chip-inference/README.md). This is a timing-checked compiler result, **not physical-board FPS measurement**. The packaged bitstream runs the counter-source/checksum toolflow harness; camera/host transport and board execution remain separate. The records below preserve the earlier experiments and failed gates for provenance.

The user requires weights and activations in fabric memory, static batch-one inference, generic compiler mechanisms, and economical validation. Target details, model paths, parallelism and FIFO capacities remain explicit configuration inputs. Expensive checks are batched after meaningful changes.

## Latest qualified candidate

`build/throughput-push/rom-precision-qat/model.pt2` achieves **0.6505393919581562** validation Dice. Its `precision-hardware` joint schedule has a **4,137,550-cycle** period. Three reference-matching frames complete at 4,979,090, 9,116,640 and 13,254,190 cycles, meeting every scheduled transfer. The mapped design uses 46 BRAMs and 91 signed 9x9 multiplier slots, with a nextpnr LUT-site lower bound of 20,050. All weights and activations remain in fabric memory.

Nextpnr completed placement/routing but **failed timing at 124.2 MHz**, reporting **107.58 MHz**. Independent vendor routing reports **109.477 MHz**, 551 setup violations and zero hold violations. These imply approximately 26 FPS at their reported setup limits, not a 30-FPS result or board measurement. Register replication was tested on the existing mapped netlist and rejected: vendor timing regressed to 92.322 MHz.

The intermediate `pipelined-reduction` batch separates multi-product reduction from accumulator feedback with one additional pipeline edge, and changes output/reduction lane choices through the explicit input catalogue. **142 focused convolution, pooling, and scheduling checks pass.** A prior schedule-only screen of the wider-output allocation reached 3,995,679 cycles; it predates the extra pipeline stage and is not used to claim current throughput. New scheduling and physical checks are in progress.

## Evidence and current gate

- Model: `build/training/four-bit-calibrated/model.pt2`, SHA-256 `65397db0d0d3c289e771d5029c74af1a2ebd817c36e07e76269a0ac7c52f920f`.
- Validation: `build/training/four-bit-calibrated/report.json`; the reported metric is Dice, on the existing 49-sample validation split.
- Latest joint schedule: `build/throughput-push/rom-memory/schedule/report.json`, including every transfer and FIFO slot-reuse constraint. Catalogue resource costs remain provisional; physical fit has not passed.
- Replay: `build/throughput-push/rom-memory/schedule/simulation/report.json`; frame completions at 4,813,422, 8,812,569 and 12,811,716 cycles.
- Physical build: `build/throughput-push/rom-memory/`. Its LUT remapping is formally equivalent at all 44,061 hard-block input pins. The 96 DSP output-register transformations also pass their functional proof.
- Validation is focused on changed arithmetic, control, storage and scheduling. No full repository suite has been repeated during this push.

## Capacity gate correction

The nextpnr Gowin implementation inserts a pass-through LUT after placement when a FF cannot share its driver's LUT/ALU site. Its packing report omits those LUTs. One local LUT output can share a site with only one FF, so additional FF consumers also need sites. `scripts/check-gowin-capacity.py` adds this necessary lower bound before permitting placement. It uses the supplied netlist and reported device capacity; it contains no board or model budgets.

The earlier `batched` candidate reported 19,540 packed LUTs but required at least **21,289** LUT sites under these nextpnr slice rules, exceeding 20,736. Its independent vendor route reported 83.708 MHz. The subsequent ROM/line-memory allocation reduced the period and required at least 21,038 sites; the new gate rejected it before placement. Reusing that synthesized netlist with a combinational LUT remap reduced the bound to **20,588**, but nextpnr still could not place it. Passing the necessary bound does not account for all slice-control and placement restrictions.

Rejected FIFO-memory trades were stopped at CP-SAT: reducing the larger skip buffer to 6,144 words, or the smaller one to 1,024 words, made the tested schedules infeasible. A packed-stem trial did not save the required BRAM. The adopted diagnostic allocation instead packs a decoder line buffer to fund a BRAM weight ROM. All choices are explicit input catalogues.

## Current batched follow-up

- Register the window-release pulse and end-of-channel/end-of-column flags without changing transfer timing. Restore the gated weight prefetch after unconditional reads increased FF use without shortening the measured ROM path.
- Use an explicit, balanced carry-save tree for each dot product and its accumulator. The isolated actor removes one serial carry chain; numerical convolution checks pass. It increases some combinational area, so it has not yet justified a complete physical build by itself.
- Store weight constants using their exact signed range, with sign extension into the multiplier. This changes representation only; it does not quantize an exported graph.
- Separately test explicit lower-precision training configurations. The new `rom-precision-qat` candidate preserves the accepted QAT weights/scales, changes three user-configured layers to six-bit weights, and fine-tunes for 24 epochs. It achieves **0.6505393919581562** Dice, SHA-256 `5cf388d99e158dd366f61a6ae13b463982b380677f9ff0206129c87481995574`. Other layers retain eight-bit weights. All weights remain in INT8 export containers, with explicit bounded values. Compiler storage narrowing is lossless. Its `precision-hardware` allocation moves another ROM into BRAM and reduces excess deep-layer parallelism. Earlier fallback results follow for provenance. A smaller existing architecture reached only 0.6383 Dice. Six-bit weight QAT with a training-selected threshold reached **0.649786**, below the required 0.65; it is not rounded up or accepted. Export/reference checks and split caveats remain recorded with each experiment.

The first allocation reduced the period to 4,011,825 cycles but required 22,112 packed LUT sites, exceeding 20,736. Its placement was stopped. Reducing large FIFOs and retaining small buffers only on frequent critical-cycle edges produced a 4,107,348-cycle schedule. That candidate used 19,487 LUT sites, 46 BRAMs and 93 multiplier slots, but nextpnr's heap placer failed and its SA placer crashed. Independent vendor placement succeeded and reported only 87.168 MHz, with 1,321 setup violations and no hold violations. That result does not establish 30 FPS or certify a nextpnr bitstream.

The initial two-build plan therefore did not close the goal. The next build batches changes identified from those actual paths rather than repeating synthesis after individual edits.

## Batched generic changes

1. Combine dot products and the accumulator with a balanced carry-save reduction followed by one carry-propagating addition. Requantization retains its separate arithmetic contract.
2. Remove the dynamic line-address collision comparator when the circular line has more than one word. Temporal induction checks the address invariant under arbitrary stalls and resets, including one-word lines and padding.
3. Register the pooled-max comparison before selecting its data. Only the final pooled dot incurs an additional cycle per output tile; ordinary convolution timing is unchanged.
4. Keep gated weight prefetch; the unconditional-read experiment was rejected after resource and timing checks.

The current actor contract uses `extra = (reduction_lanes > 1)`, `tile_cycles = pool_items * (dot_steps + 2 + extra) + requant_cycles + 3 + (pool_items > 1)`, and `release_delay = pool_items * (dot_steps + 2) + (pool_items - 1) * extra - 2`. The extra edge affects only multi-product dot reduction; requantization retains its existing pipeline. The complete graph schedule is re-solved for this batch.

## Timing-model correction

The packed-pin audit found missing timing on upper data pins after X9 BRAM types were normalized to SP/SDP/DP, plus cloned B-port inputs of wide SP cells. `patches/nextpnr-gowin-packed-bram-timing.patch` preserves existing source delay values while covering the actual packed pins. The expanded table regression passes all eight supplied speed grades. The scoped registered-DSP configuration guard remains required.

`build/throughput-push/final/corrected-pin-coverage.json` reports no missing used datapath pins for the previous packed candidate. This is structural timing coverage, not physical delay validation or board measurement. The current database is `.tools/build/nextpnr-chipdb/packed-bram-dsp.bin`; older incomplete databases are preserved for provenance.

## Compact-model recovery

The compact model `build/throughput-push/compact-recovered/model.pt2` now passes at **0.6580773042616452** validation Dice, SHA-256 `168dcdf1352eb7dd8eba3d1e573bc8d94450954a67f49271da6bb0e8c378eedc`. The input/output shapes and dataset split are unchanged. Its initialization merges four nearly duplicate stem channels into retained channels (cosine similarities above 0.9999), then performs 80 epochs of QAT. This is an explicitly approximate training transformation, independently checked against the validation threshold; it is not a compiler rewrite. QAT/integer agreement passes on 246 samples, and serialized export agreement on all 49 validation samples.

The first compact allocation has a 3,787,022-cycle schedule but needs 47 BRAMs, so placement was stopped. A smaller middle-layer allocation is being screened. The previous, larger model with the pipelined reduction completed nextpnr routing at **120.16 MHz**, short of its required 125.06 MHz; the compact model is intended to lower that requirement.

## Compact capacity and final-clock check

The four-layer six-bit weight candidate `compact-memory-qat` passes **0.6500655307994757** validation Dice, with the same 246/49 integer/export reference checks. SHA-256: `7ccf827c803d7498664e7b103b6652f1da722b781995d5f9d20609bd99b4fc1d`. The successful explicit `compact-balanced` allocation uses 46 BRAMs, 88 signed 9x9 multiplier slots, and a necessary nextpnr LUT-site count of **18,784**.

Its joint schedule repeats every **3,810,633 cycles**. Exact RTL replay completes three frames at 4,628,080, 8,438,713 and 12,249,346 cycles. Routing at a requested 124.2 MHz fails that request but reports a **115.22065 MHz** setup limit. The required frequency for 30 FPS is **114.31899 MHz**. The PLL can generate **114.75 MHz**, giving **30.1131 scheduled FPS** if final-clock timing passes. The routed-design reload shortcut crashed in nextpnr; a fresh route of the unchanged inference netlist at that final clock subsequently passed and packed successfully in `compact-balanced/clock-closed/physical/`. No timing-error suppression is used. Independent vendor placement of the 124.2-MHz candidate reports 97.013 MHz; it is a different placement and is not used as evidence of nextpnr timing closure.
