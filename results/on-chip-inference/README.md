# On-chip inference result

The compiler produces **30.1131 sustained scheduled inferences/second** at **114.75 MHz**, with validation **Dice 0.6500655308**. The period is **3,810,633 cycles**. Nextpnr reports a **115.22065 MHz** setup limit, passes the final clock constraint, and the bitstream packs successfully. No timing failure was suppressed.

All weights and activations use FPGA fabric memory: **46 BRAMs**, plus distributed memory. The design uses **88 signed 9x9 multiplier slots**. Three complete RTL frames match the integer model exactly and meet every CP-SAT transfer deadline. QAT/integer agreement was checked on 246 samples; serialized export agreement was checked on the 49-sample validation split.

This is a timing-checked compiler result, **not a physical-board FPS measurement**. The existing validation split was used for model/checkpoint selection; no independent test set was supplied. The timing margin is modest and the generated timing database is scoped to the recorded primitive configurations.

`model.pt2` is the integer PyTorch export. `inference.sv` is the generic streaming network. `configuration.json` and `target.json` are explicit model/target inputs. `harness.fs` implements the clocked counter-source/checksum harness in `harness.sv`; it is a toolflow bitstream, not a camera or host image-transfer interface. `constraints.cst` records its pin assignments. No board programming was performed.

`result.json` records every acceptance gate and links to the original evidence. The individual reports and SHA-256 manifest are included here. Full route logs, mapped/routed netlists, CP-SAT offsets, and simulation vectors remain in `build/throughput-push/compact-balanced/`. The final route is under `clock-closed/physical/`.

The higher-accuracy compact candidate (Dice 0.65808) is preserved separately under `build/throughput-push/compact-recovered/`; it is not the model used for this 30-FPS result.
