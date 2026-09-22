# Project requirements

- Keep compiler code simple and minimal while pursuing high measured throughput.
- Discuss the optimization mathematics with the user before implementing it.
- Keep project installations, environments, caches, and outputs under Documents.
- Board and model information must be explicit user input. Do not hardcode board
  names, parts, resource budgets, pinouts, clocks, or model-specific details in
  compiler code. Generic target-family mechanisms are allowed.
- Do not use version suffixes such as `v1` or `v2` in variable names. Use meaningful
  descriptive names.
- Preserve integer or floating-point numerical contracts; never silently quantize.
- Reduction reassociation is allowed. Keep each chosen reduction topology
  deterministic; validate against a documented reference using explicit tolerances.
  Preserve other floating-point rules; do not implicitly contract multiply-adds.
- Initial floating-point support is FP32; quantized integer formats are model inputs.
- Use frozen weights, acyclic inference graphs, and one clock domain initially.
- Put scheduling and FIFO occupancy directly into the CP-SAT problem.
- Use ordered FIFO slot-reuse constraints, fixed-order self-timed actor contracts,
  and one-inference periodic schedules as the agreed modeling basis.
- Keep weights and working storage in FPGA fabric memory; exclude SDRAM.
- Keep the optimization problem independent of its initial CP-SAT backend.
- Do not tune rules for particular models. Measure generic template behavior.

- Current user acceptance threshold is validation Dice >= 0.65. Prior baseline-matching accuracy requirements are superseded. Keep weights and activations in fabric memory.
- Batch expensive tests, synthesis and routing after substantive changes. Use cached resource data, schedule analysis and focused checks between builds; do not repeat full validation for minor edits. Prioritize useful measured progress within hours.
- The current hard resource requirement is at most 35 BRAM blocks, at most 18,000 actual routed logic sites, and at least 35 sustained scheduled FPS, retaining validation Dice >= 0.65. Architecture and buffering choices must be produced automatically from model/target/search inputs, without an externally supplied architecture or schedule seed. The prior 35-BRAM/30.70-FPS result is the baseline.

- Pursue structural improvements with meaningful placement headroom. Near-capacity logic use (20,618 of 20,736 sites) is unacceptable; do not route it merely because it passes a numerical capacity check. Current working input budget reserves roughly 13% of logic sites.
