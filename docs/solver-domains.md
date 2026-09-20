# Full-model periodic scheduling without offset branching

CP-SAT now returns a schedule for the complete retained INT8 model's
**4,091,235 events**, and full RTL simulation meets the returned input/output
transfer times over three frames. Every original model constraint is checked
independently before a feasible solution is returned.

This is a scheduling result with **oversized verification FIFOs and no resource
budgets**. The period was fixed at five million cycles for comparison with the
previous failed probes. It is neither an optimized throughput result nor a
fabric-fit certificate. Accuracy and the requested physical 30-FPS result remain
unmet.

## Exact implementation changes

For unconditional within-frame dependencies `t[b] >= t[a] + d`, existing lower
and upper bounds imply:

```text
lower[b] >= lower[a] + d
upper[a] <= upper[b] - d
```

`precedence.py` collects those implications in compact adjacency arrays and
propagates through their acyclic portion. It includes unconditional FIFO order,
the minimum forward latency across FIFO choices, and slot reuse when every
choice has the same depth. Conditional constraints and frame wrap stay in
CP-SAT. Cycles left by this inexpensive pass also stay in CP-SAT. Every original
constraint is retained; no feasible schedule is excluded.

Once the period and all finite actor/FIFO choices are fixed, the remaining
constraints are difference inequalities. At a propagation fixed point,
assigning every event its lower bound satisfies every such inequality. There
is consequently no need to branch on event offsets. The adapter gives CP-SAT
a search strategy over the period and option variables, and sets
`instantiate_all_variables=False`. CP-SAT performs the propagation and returns
the event values; this is not an external scheduler or a FIFO simulation loop.
Its installed `CpModelProto.search_strategy` and `SatParameters` documentation
explicitly describe this lower-bound completion behavior.

The independent `schedule.validate_solution` checks the original offset bounds,
anchor, choices, resource totals, guarded actor dependencies, FIFO availability,
transfer order, slot reuse, and frame wrap. A bad returned schedule fails
explicitly. Tests also compare optimal periods with and without implied domains,
enumerate small feasible schedules, and check cyclic and infeasible cases.
The existing measured line-layout/resource relaxations were also rerun under
the adapter's default settings. Both returned the same optimal periods and
resource totals as before: 3,875,676 cycles for separate actors and 3,807,732
for the fused graph. These checks exercise finite actor/FIFO choices, but still
omit inter-actor timing/occupancy as stated in their original scope.

## Full-model evidence

All three probes below use the same full-range INT8 export, fixed hardware
choices, full-frame FIFOs, `T=5,000,000`, and a ten-million-cycle offset cap.
They disable CP-SAT presolve, probing and LP linearization in their diagnostic
scripts; these settings have not replaced the adapter's defaults. The earlier
production-default full-size probe was unsuccessful. A successful full-size
run under production defaults and a resource-constrained catalogue remain to
be demonstrated.

| Probe | Result | CP-SAT wall time | Integer propagations | Branches |
| --- | --- | ---: | ---: | ---: |
| Window-path bounds, ordinary offset search | UNKNOWN | 216.7 s | 721,829,009 | 0 |
| Implied event domains, ordinary offset search | UNKNOWN | 296.9 s | 5,854,627 | 24,466 |
| Implied domains, period/option search only | Feasible fixed-period point | 19.1 s | 9,467 | 0 |

The final probe reports `OPTIMAL` because its period was fixed; that status does
not establish the minimum possible period. The complete monitored run, including
model construction, independent checking and saving all event offsets, took
about 115 seconds and peaked at approximately 6.92 GB sampled RSS. It completed
normally under the eight-GiB memory ceiling.

The model SHA-256 is
`0e45449076070d202642d263ec06f6300aa99d46ea364c94406c742e12d4d31d`.
It retains validation Dice 0.667115 versus the required 0.676843. The chosen
actors already exceed the target's LUT/BRAM budget before graph FIFOs.

## RTL deadline verification

The saved schedule was converted to external input/output transfer cycles and
applied to newly emitted full-model RTL. Three real reference images supplied
387,840 input words and 96,768 output words. Every input was accepted at its
specified cycle, and every bit-exact output was available at its specified
cycle. Output completion cycles were:

```text
5,815,872; 10,815,872; 15,815,872
```

The scheduled interval is exactly five million cycles. A 150-MHz clock would
therefore be required for 30 FPS at this point, but neither that full-model
clock nor fabric-feasible storage has been established. The verification
buffers exceed the fabric-memory limit; SDRAM remains excluded from deployment.

`scripts/simulate-rtl.py` now accepts paired `--input-cycles` and
`--output-cycles` hex files. It checks deadlines as well as values and output
stability. Its test deliberately supplies late input and output schedules and
confirms that both are rejected. The complete suite passes **329 tests**.

- [Domain-only probe](../build/scheduling/domain-probe/result.json)
- [Decision-search result](../build/scheduling/decision-probe/result.json)
- [CP-SAT log](../build/scheduling/decision-probe/solve.log)
- [Memory/time monitor](../build/scheduling/decision-probe/monitor.json)
- [External schedule summary](../build/scheduling/decision-probe/io-schedule.json)
- [Full-model RTL deadline check](../build/scheduling/decision-probe/simulation/report.json)
- [Reproduction script](../build/scheduling/decision-probe/solve.py)
- [Repeated separate-actor relaxation](../build/scheduling/decision-search-layouts/unfused/relaxation.json)
- [Repeated fused relaxation](../build/scheduling/decision-search-layouts/fused/relaxation.json)
