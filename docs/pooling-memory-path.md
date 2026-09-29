# Pooling memory address path

Nonoverlapping max pooling accumulates one reduced output row in memory. The
input raster previously generated each read address by adding a column base to
the channel-word index, then selecting zero for excluded trailing pixels. That
put arithmetic and validity selection in front of the memory read.

The template now holds the read address in a register. For channel-word count
`C`, each accepted input advances the address by one, except that the last
channel word of an unfinished horizontal pooling block rewinds by `C - 1`.
The address resets at the end of each input row. On included pixels this equals
`floor(column / kernel_width) * C + channel_word`. Excluded trailing pixels do
not read or write memory, so their wrapped address values are irrelevant.

The register advances only on an accepted input. Pending write addresses,
same-address forwarding, output backpressure and reset behavior retain their
existing contracts. No memory, compute or output pipeline stage was added;
the CP-SAT event model and initiation interval are unchanged. Geometry and
memory placement continue to come from the model and compiler search inputs.

Validation covers 40 pooling simulations and exact schedule checks: signed and
unsigned values, ragged channels and spatial dimensions, degenerate kernels,
consecutive frames, backpressure and midstream reset. Characterization of both
pooling actors in the current model confirms that distributed-RAM read-address
pins are driven directly by flip-flops, where the previous implementation used
LUT outputs. Area is essentially unchanged; whole-design routing is required to
establish a throughput benefit.

Local characterization and source identity evidence are recorded in
`build/pool-template-improvement/`. The uncapped model experiment uses
`inputs/demo-clock-job.json`, which supplies the clock choices and the search
budget explicitly.

## Large-model scheduling

The first uncapped scheduling attempt was killed with signal 9 while solving
the expanded joint model. Its exact cause was not reported. The scheduler now
releases the earlier proposal's event model and optimizes the period of that
automatically selected proposal before attempting the larger joint search.
Reaching the catalogue's resource lower bound proves that a shorter period is
unavailable in that catalogue; otherwise the proposal's optimum is not a global
bound.

The supplied search inputs also set `joint_event_limit` to bound expansion into
the joint CP-SAT backend. Above that budget, a verified automatic proposal is
retained after its period search, with `joint_search_limited` in the report.
The complete event model still independently validates its schedule. There is
no FPS stopping threshold and no manual selection of actors or buffers. This
is a bounded search, not a promise of a globally optimal architecture.

## Verified model result

The recovered automatic run reached **36.1125 FPS at 108 MHz**, with **35 BRAMs**,
**17,668 routed logic sites** and 96 signed 9-by-9 multiplier slots. Routed Fmax
was 109.0156 MHz, so timing passed with about 0.94% frequency headroom. The
inference period is 2,990,652 cycles. The unchanged model retains validation Dice
0.650066. Three complete reference frames were bit exact, and schedule, mapping,
resource and timing checks passed; the harness bitstream was generated.

This is 3.18% above the previous 35-FPS fast build and 4.19% above the last
34.66-FPS build. It combines the template change with uncapped automatic search;
it does not isolate the template's contribution to FPS. The selected architecture
uses block memory for both pooling actors. The worst routed path is now the
fused view's source-row lifetime limit update, rather than pooling.

The supplied event budget limited the joint alternative search. The chosen
proposal's period is optimal for its fixed choices; the broader catalogue's
resource lower bound remains 2,774,016 cycles. No global architecture optimum or
physical-board FPS is claimed. The bitstream is the counter-source/checksum
harness, without camera or host transport.

The full evidence and comparison are in
`build/pool-throughput-i21Bh1/result/comparison.md`. The initial interrupted run
and recovery provenance are preserved alongside the final result. Recovery
reused the compiler's existing candidate catalogue; it did not supply an external
architecture or schedule seed.
