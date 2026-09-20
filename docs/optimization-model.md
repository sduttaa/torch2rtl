# Optimization model — proposal for discussion

This is a proposed design, not an approved specification or implementation.
The first confirmed board is Sipeed Tang Nano 20K. Static shapes, batch size one,
integer or floating-point inputs, maximizing sustained throughput, fabric memory
only, and scheduling/FIFO occupancy directly in CP-SAT are confirmed. Ordered
FIFO constraints, fixed-order self-timed actors, and one-inference periodic
schedules are the agreed modeling basis. Initial FP32 support and reduction
reassociation are allowed; other arithmetic/precision rules remain explicit.
Quantized integer formats remain model inputs. Frozen weights, acyclic graphs,
and one clock domain are confirmed.

## 1. Execution contract

Confirmed scope: static shapes, batch size one, and quantized integer or
floating-point inference, frozen weights,
acyclic inference graphs, and a single clock. Distinct
inferences may overlap throughout the pipeline. Batch size one does not mean
only one inference may be in flight.

All weights, accumulators, line buffers, reordering storage, inter-actor FIFOs,
and control state must fit in FPGA fabric memory. Inputs may stream in and
outputs stream out; there is no off-chip intermediate or weight traffic during
inference. As confirmed by the user, exclude SDRAM from
on-chip inference, even when packaged with the FPGA. Board interface storage
and logic consume resources too.

Generic means a documented set of operator semantics over supported shapes and
dtypes, independent of model identity. Arbitrary PyTorch is not a realistic
initial coverage promise. Dynamic control flow, mutation, training, and unknown
operators need an explicit diagnostic. Do not silently compute unsupported
operations on the CPU.

Preserve numerical semantics in a contract: signedness, zero points, scales,
accumulator width, rounding, saturation/overflow, padding, layout, and reduction
order where it affects results. Precision is an input to optimization, not a
free performance knob. Floating-point actors must define format, rounding,
subnormal handling, NaN/infinity behavior, signed zero, and reduction order.
The user's latest instruction allows reduction reassociation. Parallel trees,
partial sums, and interleaved accumulation may therefore be actor configuration
choices. Each chosen topology remains deterministic and documented. This does
not authorize approximate arithmetic, intermediate precision changes, or implicit
multiply-add contraction. Floating-point accumulation has a real recurrence
latency; partial sums and independent outputs can help hide it. Numerical checks
for reassociated reductions use explicit user-supplied tolerances against a
documented deterministic reference. Floating-point
resources and service periods use the same option tables as integer actors;
some formats/models may not fit this small FPGA. Do not silently quantize them.
An accuracy constraint needs an independently supplied
calibration/evaluation policy; resource optimization cannot infer accuracy.

Proposed deterministic FP32 reference: visit reduction indices in lexicographic
order, round each explicit arithmetic operation to FP32 with round-to-nearest,
ties-to-even, preserve subnormals, and preserve graph-level bias/activation and
rounding boundaries. Reassociated implementations may use a different documented
sum topology while retaining the same precision. For finite results, a supplied
validation policy can use abs(actual-reference) <= atol + rtol*abs(reference);
handle NaNs and infinities explicitly rather than through that inequality.
The tolerances are inputs, not solver-controlled accuracy knobs. Passing a finite
test set is numerical validation, not a proof over every possible input.

## 2. Frontend and fusion

Use `torch.export.ExportedProgram`, imported through torch-mlir's FX importer.
Keep high-level operator structure long enough to recognize fusion candidates;
premature lowering into scalar loops makes this harder. Preserve high-level
linear/convolution/reduction patterns with a deliberate decomposition policy.
Extract one small typed actor graph from structured MLIR APIs, not text parsing.

Each edge describes element type, shape, traversal order, frame boundaries,
transfer width, tail masks, and readiness semantics. A reshape is free only if
it preserves traversal order; a transpose may require real buffering. Broadcast,
fork, join, and width conversion have explicit contracts and nonzero costs
when they require hardware.

Start with a short ordered fusion catalogue:

| Candidate | Conditions |
| --- | --- |
| Linear/conv + bias + clamp/ReLU | Exact dtype semantics; compatible traversal; epilogue can sustain producer rate; intermediate not needed elsewhere |
| Pointwise chains | Compatible indexing and broadcast; no hidden materialization; bounded pipeline/timing cost |
| Constant affine folding | Proven valid in the specified arithmetic; floating-point and quantized rewrites need particular care |
| Layout-only reshape | Stream order genuinely unchanged |

Batch normalization folding requires inference statistics and a declared
numerical equivalence/tolerance policy. Quantized rounding boundaries must not
be erased. Residual adds require aligned inputs and buffering. Conv→conv,
conv→pool, large reductions, and fan-out crossings are not automatically good.

“Definitely good” should mean legal and conservatively non-worsening in the
relevant throughput/resource/timing contract, for each retained configuration.
If that cannot be established, retain the unfused form initially. Fusion can
increase critical path, replication, or storage and remove useful parallelism.
Do not make fusion a second graph search in version one. Use deterministic
local rules with clear preconditions and record why every fusion occurred.

## 3. Finite actor configurations

For actor i, enumerate a small set K_i of legal configurations. A configuration
can select lane counts, reduction parallelism, tiling, memory banking, pipeline
stages, and supported DSP/LUT implementations. Expose only parameters actually
implemented by that actor template. Avoid a Cartesian product of unnecessary
knobs. Prune dominated options only when port, timing, and scheduling contracts
are compatible; equal LUT counts alone do not establish dominance.

Each configuration k supplies:

- C_ik: minimum sustainable cycles per complete inference with adequate input
  and output service. This is not first-output latency.
- L_ik and a compact phase description: input consumption and output production,
  pipeline fill/drain, stalls, and internal state availability.
- R_ikr: integer usage of each target resource r, including internal memories,
  replicated weights, accumulators, control, and memory-port implementation.
- Port contracts and legal neighbor/adapter combinations.
- Timing eligibility at a chosen target clock and confidence/provenance of costs.

For a regular M×K by K×N multiply, a starting compute bound is

    ceil(M/P_m) × ceil(N/P_n) × ceil(K/P_k)

cycles per inference when the corresponding P_m×P_n×P_k work is issued each
cycle. The real C additionally accounts for initiation interval, accumulation
recurrences, memory service, loop changes, tails, and non-overlapped setup/drain.
Use a maximum for services that truly overlap and a sum for serial phases.
This expression is a bound/example, not a universal actor cost formula.

For every memory, required reads/writes per cycle must be served by its actual
banking/ports. More multipliers do not help when weights cannot feed them.
Memory replication for bandwidth consumes real capacity. Accumulator widths
come from numerical range, including zero-point corrections, bias, and any
intermediate arithmetic, not just the input element width.

Analytic formulas are seeded by small generic synthesis sweeps over template
parameters, widths, and shapes. Calibrate template behavior, never particular
model identities. Full-design synthesis and routing remain the acceptance test.

## 4. Core integer optimization

Fix the graph after conservative fusion and fix a target frequency f for one
solve. Let x_ik be Boolean: actor i selects configuration k. Let T be integer
cycles between complete inferences in steady state.

    sum(k in K_i) x_ik = 1                         for each actor i
    C_i = sum(k in K_i) C_ik x_ik
    T >= C_i                                      for each actor i

This normalizes all actors to the same unit. In a synchronous dataflow view,
if an actor fires q_i times per inference with non-overlapping firing cost c_i,
its corresponding demand is q_i c_i. Repetition counts satisfy

    q_u p_e = q_v c_e

for every edge e, where p_e/c_e are elements produced/consumed per firing.
Do not count vector transfers as scalar elements or assume different tensor
shapes imply different inference rates. Pipelined firings need their actual
initiation/overlap contract rather than q_i times first-result latency.

For each edge e, select one legal interface/FIFO option h with Boolean z_eh:

    sum(h) z_eh = 1
    (selected producer, consumer, edge option) is an allowed tuple

The tuple specifies any adapter, FIFO width W_eh, physical depth D_eh,
memory implementation, resource cost F_ehr, and service demand A_eh. Adapters
may instead be explicit actors; choose one representation and count once.

    T >= sum(h) A_eh z_eh
    sum(i,k) R_ikr x_ik + sum(e,h) F_ehr z_eh + R_shell,r <= B_r
                                                    for every resource r

B_r is the usable target budget after any deliberate routing reserve. R_shell
is measured interface/clock/reset overhead; do not hide it in an arbitrary
percentage. Reserve policy is configurable and reported. No universal reserve
percentage guarantees routing success.

Use separate constraints for distinct physical resource types: LUTs, FFs,
BRAM modes/blocks, DSP capacities, distributed memory where applicable, etc.
DSP mode sharing and LUT/FF slice packing can require additional target-local
constraints or conservative mapping. A sum of normalized resource fractions
is not a feasibility test. Timing/routability also cannot be proved by totals.

FIFO bit capacity W×D is a logical quantity. BRAM use is determined by legal
width/depth modes, banking, ports, and fragmentation. For a supported mode
(w_b,d_b), a simple mapping is ceil(W/w_b)×ceil(D/d_b) blocks; the backend must
enumerate modes that actually implement the required FIFO. Count controller,
output registers, and skid storage. Do not approximate everything by dividing
total bits by BRAM block size.

If an input carries N elements of b bits and the interface delivers s payload
bits/cycle, then T >= ceil(Nb/s); account for protocol efficiency and shared
input/output service. Without a board transport choice, distinguish compute
throughput from end-to-end board throughput.

## 5. Objective and balancing

Proposed lexicographic objective:

1. Minimize T: maximize estimated steady-state throughput f/T.
2. At the best T, minimize a documented weighted resource cost.
3. Optionally minimize latency or buffering among remaining ties.

Solve successive objectives instead of using an arbitrary huge multiplier.
Resource weights in step two are a preference, not resource feasibility.
Keep the weights explicit; there is no uniquely correct scalar “area” across
heterogeneous FPGA resources.

Balancing is primarily a consequence of the bottleneck objective and removing
unnecessary resources from faster stages. Report utilization u_i=C_i/T and
slack T-C_i. Do not force C_i≈T or minimize rate variance: that can slow cheap
actors without improving the bottleneck. A faster small epilogue is harmless.

For a strict latency limit, measure/derive frame latency from the schedule and
require L_graph <= L_max. The sum of all actor latencies is not generally the
graph latency: branches overlap, and buffering and blocking change arrivals.

Frequency is physical too. First use one attainable clock; later solve for a
small list of target clocks and compare feasible f/T. Exclude locally ineligible
configurations, then route the assembled design. A solution at a requested
frequency is only accepted if timing closes at that frequency. Do not call
pre-route clock estimates achieved performance.

## 6. FIFOs: rate balance is necessary, not sufficient

The core inequalities above are a throughput relaxation until scheduling and
buffer feasibility are checked. A FIFO absorbs burst and phase differences;
it cannot repair a permanently lower consumer inference rate.

For edge e, let P_e(t) and C_e(t) be cumulative transfers actually written and
read by time t, in the same FIFO-word unit. Then

    O_e(t) = O_e(0) + P_e(t) - C_e(t)
    0 <= O_e(t) <= D_e                              for all relevant t

At startup O_e(0)=0 for ordinary data FIFOs. Never invent initial data tokens to
make a schedule feasible. Define simultaneous read/write, registered readiness,
and fall-through behavior precisely; occupancy checks must respect those cycle
semantics, not merely cumulative counts after each cycle.

Given a legal repeated schedule, capacity must cover the maximum occupancy,
including startup. If choosing phases for an ideal periodic schedule, the
range max(P-C)-min(P-C) gives an occupancy range, but it does not alone prove
that a realizable startup can reach the assumed occupancy. Equal totals over
a period do not establish ordering, data availability, or deadlock freedom.

Reconvergent branches are particularly important. An atomic fork can block a
long branch because the short branch has filled up before a join can consume.
Even an acyclic compute graph can stall forever with bounded channels and
blocking actor protocols. For example, suppose a fork sends every input to a
reduction and also to a short bypass. The reduction needs eight inputs before
producing; a join waits for that output before reading the bypass. If the bypass
can hold only four inputs and the fork blocks on either output, the whole graph
can stop after four inputs. Equal average frame rates cannot resolve this.
These numbers illustrate a protocol problem; they are not compiler constants.
Some actors must buffer a full window or tensor before
they can produce; that storage belongs in the actor contract.

The user selected **joint scheduling and FIFO occupancy in CP-SAT**. Add the
event-level scheduling constraints in [the scheduling model](scheduling-model.md)
to the configuration/resource model above. Actor options activate their event
contracts. The preferred compact formulation requires read k-d to free a slot
before write k, conditional on candidate depth d, with periodic wraparound.
Equivalently, tokens occupy intervals between writes and reads, and cumulative
overlap cannot exceed the selected depth. The scheduling document derives both.

Include periodic cross-frame constraints and a realizable empty-FIFO startup.
The schedule must describe the actual actor FSM and storage lifetimes, not an
ideal actor that can arbitrarily delay events while retaining unlimited state.
RTL simulation is validation of the solved model, not a substitute for FIFO
constraints in the optimization problem.

All domains need finite, explicit bounds. Report the best feasible solution and
solver bound for the selected event granularity and bounds. It must not claim
global optimality of physical hardware based on the CP-SAT optimum. A timeout
is not infeasibility. Routing and numerical/RTL checks remain acceptance tests.

## 7. Solver boundary and implementation size

The core problem is plain data: actor option tables, edge option/compatibility
tables, event precedence/interval contracts, resource budgets, period bounds,
and objective priorities. CP-SAT types
stay in one adapter. Its output is selected option IDs, period, objective/bound,
status, and diagnostics. A backend interface can be as small as

    solve(problem, limits) -> solution

Use standard integer expressions, exactly-one constraints, and allowed tuples.
Do not build a general symbolic optimization framework. OR-Tools CP-SAT uses
integer coefficients; precompute rounded-up cycle and physical-resource costs.
When choosing time scales or integer weights, bound every expression to avoid
64-bit overflow. Save solver seed, time limit, workers, best bound, and status.

The intended compiler has five responsibilities: import/canonicalize, fuse and
enumerate options, solve/check, emit templates, and run/measure the target flow.
They can begin as a few Python modules. Board names, parts, resource budgets,
pinouts, clocks, transport limits, and model details are explicit user inputs,
never hardcoded lookup tables in compiler code. Generic family mechanisms and
primitive mappings may live in target backends; board-specific capacities and
constraints come from supplied data. Do not use variable-name version suffixes
such as `v1` or `v2`. Avoid a custom MLIR
dialect, plugin framework, and secondary scheduler unless a concrete need
justifies them.

## 8. What “superior performance” must mean

Streaming actors, layer folding, and global scheduling already appear in
[FINN](https://arxiv.org/abs/1612.07119) and
[Stream-HLS](https://arxiv.org/abs/2501.09118). Our combination of a small RTL
template library, explicit numerical contracts, and joint configuration/FIFO
scheduling is a proposed engineering approach, not an established performance
advantage. The solver can only select among implementations we actually provide.

Choose a baseline and a representative held-out workload suite before tuning.
Compare on the same FPGA, precision/accuracy, batch, timing constraints, I/O
assumptions, and on-chip memory rules. Include chains, branches/residual joins,
convolutions, dense layers, reductions, and different tensor shapes within the
documented operator coverage. A model suite tests generality; individual
microbenchmarks characterize templates.

Report routed clock, sustained inference rate, first-frame and steady-state
latency, LUT/FF/BRAM/DSP usage, numerical correctness/accuracy, compile time,
solver gap, FIFO high-water marks, and unsupported/not-fitting models. State
whether figures are simulated, post-route estimates, or measured on a board.
Report all cases, not just wins. No performance superiority is established yet.

Use controlled ablations on the same RTL templates to isolate the contribution
of fusion, joint scheduling/depth selection, and resource allocation. Compare
against uniform/minimum parallelism and a simple greedy bottleneck allocator.
Those establish internal improvements, not superiority over external compilers.
External comparisons require a compatible flow or a clearly separated platform
comparison: hls4ml's documented synthesis flows use vendor HLS tools, so do not
assume its published results are a drop-in Gowin baseline.
See [hls4ml tool requirements](https://fastmachinelearning.org/hls4ml/intro/setup.html).

## 9. Decisions for consultation

1. Static shapes, batch one, frozen weights, acyclic graphs, and one clock are
   confirmed. Initial FP32 support and reduction reassociation are allowed.
   Integer quantization parameters and numerical tolerances come from user inputs.
2. Throughput-first objective is confirmed; report latency as a secondary metric.
3. BRAM/distributed fabric memory only is confirmed.
4. Agree on conservative fusion rules and finite actor configuration tables.
5. Scheduling and FIFO occupancy directly in CP-SAT, using ordered FIFO
   constraints, fixed-order self-timed actors, and one-inference periodic schedules,
   is the agreed modeling basis. Each template still needs a precise event contract.
6. Choose first operator coverage, transport assumptions, and fair baselines.

## Sources

- [torch-mlir FX importer](https://github.com/llvm/torch-mlir/blob/main/python/torch_mlir/extras/fx_importer.py)
- [torch-mlir development guide](https://github.com/llvm/torch-mlir/blob/main/docs/development.md)
- [CP-SAT integer modeling](https://developers.google.com/optimization/cp/cp_example)
- [nextpnr target families](https://github.com/YosysHQ/nextpnr)
- [Apicula and supported Gowin boards](https://github.com/YosysHQ/apicula)

The formulation and architectural recommendations above are this project's
proposal; the sources document the underlying tools, not a proof of the model.
