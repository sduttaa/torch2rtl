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

- Current user acceptance threshold is validation Dice >= 0.65. Prior baseline-matching accuracy requirements are superseded. Prioritize the still-required 30 sustained FPS with fabric-only weights and activations.
- Batch expensive tests, synthesis and routing after substantive changes. Use cached resource data, schedule analysis and focused checks between builds; do not repeat full validation for minor edits. The current priority is a credible 30-FPS result within hours.
- The current hard resource requirement is at most 35 BRAM blocks while retaining at least 30 sustained scheduled FPS and validation Dice >= 0.65. The prior 44-BRAM result is a baseline, not completion of this requirement.
