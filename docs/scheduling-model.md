# Joint scheduling and FIFO occupancy — proposal for discussion

The user has chosen to put scheduling and FIFO occupancy directly into CP-SAT,
using ordered FIFO constraints, fixed-order self-timed actors, and one-inference
periodic schedules as the basis for the design discussion. This document details
that formulation for review before implementation.
It extends the [configuration/resource model](optimization-model.md).

## A. Schedule hardware events, not every arithmetic operation

An actor configuration supplies a deterministic event contract. Events represent
accepted input/output vector words and internal phase boundaries needed to
describe hazards and backpressure. Its implemented loop order fixes arbitration
and resource order. The solver selects configurations and event times; it does
not invent a new microarchitecture or instruction schedule inside an actor.

The contract includes:

- Data dependencies and minimum transport/compute delays.
- Maximum or exact delays where a pipeline cannot pause.
- Initiation intervals, input/output word order, and frame order.
- Internal buffer lifetimes, memory-port schedules, and accumulator reuse.
- Fork atomicity, join ordering, readiness latency, and pipeline capacity.
- Cross-frame reuse dependencies when actors process overlapping inferences.

Never model only input/output latency and assume all gaps are legal. A solver
could otherwise consume many inputs, hold them in nonexistent storage, and emit
them much later. Every live value needs either allocated actor storage or a
modeled FIFO slot. If fixed floating-point latency is assumed, the chosen
arithmetic implementation must actually provide it for all allowed values.

## B. Periodic event times

Let T >= 1 be cycles between inferences. For event a within one inference and
frame index n, write

    t(a,n) = s_a + n T

s_a is a nonnegative integer offset; it may exceed T. An inference can take many
periods to pass through the graph. Set the source frame-start offset to zero to
remove translation symmetry. Multiple inputs for a frame obey their supplied
arrival/transport contract. Sink service also obeys its supplied interface limit.

For a dependency from event a in frame n to b in frame n+delta with delay ell,

    s_b + delta T >= s_a + ell.

delta is a fixed integer from the actor contract, so this is linear even though
T is a variable. For an exact nonstallable delay, use equality; for a legal
bounded gap, add an upper bound. Configuration-dependent constraints are active
only when their option is selected.

Examples: output after its necessary inputs, successive issues separated by an
initiation interval, and the next frame not overwriting a previous accumulator
before its last read. Do not add a blanket non-overlap constraint to a pipelined
actor: it would forbid legitimate overlap. Explicit storage/reuse constraints
permit exactly the overlap implemented by the template.

One identical schedule per frame is a deliberate restriction. Some multirate
networks achieve better averages with a schedule repeating over several frames.
Begin with one frame per period for simplicity, state the restriction, and allow
a user-specified multi-frame superperiod later if evidence justifies it. In that
case throughput is frames_per_superperiod × f / superperiod_cycles.

## C. Match FIFO tokens explicitly

For a chosen edge option, the producer and consumer must agree on a sequence of
FIFO words per inference, including lane masks, element order, and frame tags.
Let N_e be that count. Width conversion has an explicit implementation and
matching relation; never match the j-th producer transfer to the j-th consumer
transfer when they contain different numbers/order of elements.

For word j of frame n, let w_ejn be its accepted write time and r_ejn its accepted
read time. Use one well-defined registered FIFO convention initially:

    r_ejn >= w_ejn + 1.

A word written on an edge is available no earlier than the next edge. Reads and
writes are individually ordered and respect actual port throughput. For a
single-word-per-cycle port, consecutive write/read events have a gap of at least
one, including the last word of frame n to the first word of frame n+1. In offset
form the wrap constraint is s_first + T >= s_last + 1. A read of
an old word and a write of a new word on the same edge may reuse a full slot only
if the RTL explicitly supports this. Registered output/read latency, prefetch
registers, and skid storage must be represented separately when present.

Each token is a half-open occupancy interval

    I_ejn = [w_ejn, r_ejn), demand = 1 FIFO word.

Then the joint depth constraint is

    sum(j,n) 1[t in I_ejn] <= D_e                 for every t.

This is exactly a cumulative scheduling constraint. D_e is an integer variable
linked to the selected physical FIFO option and its resource costs. It counts
actual slots, not bits; width/depth memory mapping belongs in the resource model.
Optional intervals are present only for their selected edge/interface option.
CP-SAT supports variable cumulative capacity. Do not assume its reservoir
constraint supports a variable maximum level in the same way.

Token-to-token matching and r>w prevent underflow. Cumulative capacity prevents
overflow. Word-order constraints prevent overtaking. None alone proves that the
actor's computation is legal: that comes from the event contracts in section A.

## D. A smaller exact formulation for ordered FIFOs

For strictly ordered writes and reads, an alternative avoids cumulative interval
replication. Flatten all frame words into index k=n N_e+j. A FIFO with depth d
can accept word k only once word k-d has been read:

    w_k >= r_(k-d)                               when k >= d.

Together with token matching, order, and port constraints, this enforces capacity.
If full-slot same-cycle replacement is unsupported, add the required cycle gap.

For periodic operation with fixed candidate depth d, use Euclidean division

    j-d = q N_e + h,      0 <= h < N_e
    s_write,j >= s_read,h + q T.

This is a linear constraint activated by selecting that depth/interface option.
q can be negative: it refers to a token from an earlier frame. Depths larger
than a frame are handled by the same formula. Zero-depth bypass is excluded
from this FIFO formulation and would require a separate combinational contract.

This ordered formulation is my preferred starting point: it is mathematically
equivalent to occupancy bounds under the stated FIFO protocol, directly models
period wraparound, and requires no per-cycle occupancy variables. Keep cumulative
intervals as an independent formulation/check on small generic cases, or for
resource lifetimes without FIFO ordering.

For edge/interface choices that change N_e, expand the equations conditionally
per option. This adds solver variables/constraints only for implemented choices.
No symbolic division of decision variables is needed: N_e, d, q, and h are
constants within each optional configuration, while T and offsets are variables.

The dependency-cycle interpretation explains why this balances the whole graph.
Summing precedence constraints around a directed cycle gives

    T × sum(delta on cycle) >= sum(ell on cycle).

Actor recurrences and FIFO reuse edges create these cycles. Their ratios bound
the sustainable period; the bottleneck is not necessarily an individual actor.
A positive-delay cycle with no frame advance is infeasible. CP-SAT can select
configurations and depths that change these dependencies, while the offset
constraints enforce them without a separate cycle-enumeration algorithm.

A small exhaustive algebra check compared the finite ordered-FIFO inequalities
with direct occupancy counting for 4,816 valid trace/depth combinations, with no
mismatch. A second check covered 4,872 bounded periodic schedule/depth choices,
including capacities spanning frame boundaries, and matched explicit occupancy
counting in every case. These check the FIFO identities only, not all actor
protocols, their reset states, or the full compiler.

## E. Startup and repeatability

A cyclic steady-state schedule must have a legal finite startup. Initially all
ordinary data FIFOs are empty; weights and known control/reset state may be
initialized. No negative-frame data is assumed to exist.

For the repeated frame schedule above, instantiate frames n>=0. Data edges
consume only words produced by those frames. For FIFO capacity, omit k-d<0
dependencies during startup because those initial slots are empty. Periodic
constraints for k-d>=0 remain satisfied. Removing fictitious negative-frame
occupancy only frees capacity. Likewise, cross-frame reuse dependencies into
negative frames are replaced by the actual initialized-free storage condition.

This constructs a feasible startup **only if** all actor state and readiness
contracts admit that initialization and the same schedule can actually execute.
If an actor requires a different startup phase, model it explicitly rather than
asserting steady-state feasibility implies it. Delays and state tags must not
accidentally mix data from different frames.

If using cumulative intervals instead of the ordered formulation, include every
replica that can overlap a reference period. For offsets bounded by L_bound and
T>=T_min>0, a conservative replica count derives from ceil(L_bound/T_min)+1,
not an arbitrary “simulate three frames.” Validate the actual interval bounds
when deriving that count.

For the preferred lower-bound event model, finite bounds can be derived instead
of guessing a latency cap. Suppose all dependencies have ell>=0 and delta>=0,
there is a common frame-start event, and there are no other upper timing bounds.
Let V bound the selected event count including that start, and E bound every
edge delay ell across the option catalogue. For a fixed selection, a cycle with
sum(delta)=0 and sum(ell)>0 is infeasible at every period. Every other cycle's
required period is at most V E, since its simple-cycle delay is at most V E and
its positive integer frame advance is at least one. Thus max(1,V E) is a safe
period upper bound for this restricted difference-constraint model. Once no
positive-weight cycle remains, longest-path offsets from the common start can
be chosen within V E as well (add zero-delay start edges for nonnegative offsets).

Use these bounds only when their assumptions hold and the start-event anchoring
is consistent; extra deadlines, phase equalities, negative frame advances, or
non-monotone scheduling constraints require a separately derived bound. A
smaller imposed latency/search bound must be reported as a restriction, and
expanded before treating failure under that bound as architectural infeasibility.

## F. How does the RTL execute the selected schedule?

The agreed basis is fixed-order self-timed actors. The model-to-RTL correspondence
is an implementation obligation for every template.

Templates have fixed local ordering and work as soon
as their operands, state, and downstream capacity allow. The event contract must
be a monotone precedence model of that exact blocking implementation. Under that
condition, a feasible periodic schedule is a throughput witness: the earliest
legal execution cannot be later than the witness. Capacity constraints become
read-before-reuse dependencies, and data constraints become write-before-read
dependencies. Forks and joins must use the same atomicity as the template.

For this approach, prefer elastic actor contracts expressible with lower-bound
precedence constraints. Nonstallable pipelines with exact output deadlines need
explicit reservation/credit handling or a different execution proof; the generic
earliest-event argument does not automatically cover upper-bound constraints.

This claim requires proof for each actor contract; it is not true for arbitrary
data-dependent controllers or arbitration. Conditional floating-point fast paths,
speculative reads, or unmodeled arbitration can invalidate it. Initially use
fixed-latency arithmetic/control and static local loop order.

Alternative: explicitly gate actor launches/transfers to the chosen schedule.
That makes the solver's chosen timings executable but adds counters/enables,
their resource cost, and rules for pausing/restarting after external stalls.
A free-running global timetable cannot silently assume inputs always arrive on
time. Avoid that controller unless the simple self-timed contract is insufficient.

External backpressure may reduce throughput; it must never corrupt results.
Claim f/T only under the documented source/sink service contract. Correctness
under stalls and throughput under continuously sufficient I/O are separate tests.

## G. Model size and objective

Keep the outer objective from the main proposal: minimize T at a chosen clock,
then minimize resources at that T. Joint schedule constraints turn the bare
max(C_i) relaxation into a scheduled design model. Local C_i bounds remain useful
to strengthen propagation. Measure actual routed throughput afterwards.

Use vector-word events and compress regular event runs only when the compression
preserves all relevant capacity/availability extrema and legal stall points.
Treating an entire tile as an atomic token is valid only if storage reservation
and transfer timing implement that contract; it can overestimate buffers or
reduce streaming performance. Do not silently change granularity for large models.

The event count can still be large for large feature maps. Expose solver limits
and report best feasible period, bound, event count, and search restrictions.
Start with exact word events and the ordered FIFO inequalities, then compress
only a measured bottleneck. This keeps source code small without pretending
that problem size is independent of model size.

One exact compression opportunity is a run of word events with an affine timing
formula. Within an overlap of a write run and the read run shifted by candidate
depth d, the slot-reuse inequality is affine in word index. Checking both ends
of that overlap suffices. Split at every run/frame boundary. This compression is
valid only when the run's fixed-stride timing is part of the selected schedule
contract; it must not erase independently stallable timing choices. General
bursty runs need all relevant extrema or the uncompressed word formulation.

All hardware timing values, resources, shapes, and target bounds come from user
inputs or generic template characterization. Nothing here introduces board or
model lookup tables. Core data types describe event/dependency tables and option
IDs; only the CP-SAT adapter uses solver-specific classes.

## Agreed basis and remaining details

- Ordered-FIFO precedence is the agreed primary occupancy formulation.
- Fixed-order self-timed actor contracts and one-frame periodic schedules are
  agreed. Exact vector-word events are the proposed initial representation;
  compression requires proof that it preserves the chosen timing contract.
- FP32 initially, a deterministic numerical reference, and reduction reassociation
  are confirmed. The chosen reduction topology is deterministic; numerical
  tolerances are explicit inputs for validating reassociated results.
- Frozen weights, acyclic graphs, and one clock domain are confirmed.

PyTorch export does not generally encode the internal summation order of a
backend's matrix multiplication kernel. Define
the reference operation semantics explicitly; do not promise bit-for-bit
agreement with every CPU/GPU PyTorch implementation from an ATen graph alone.
The user permits changing reduction order. Record that order/topology and compare
with the deterministic reference under supplied numerical tolerances. Preserve
other explicit arithmetic and rounding boundaries; reduction reassociation does
not by itself permit implicit fused multiply-add or reduced precision.
PyTorch also documents that operation ordering and platforms can change results;
see [its numerical accuracy notes](https://docs.pytorch.org/docs/2.14/notes/numerical_accuracy.html).

## Sources

- [OR-Tools scheduling constraints](https://github.com/google/or-tools/blob/stable/ortools/sat/docs/scheduling.md)
- [CP-SAT Python API implementation](https://github.com/google/or-tools/blob/stable/ortools/sat/python/cp_model.py)

The periodic FIFO and execution-contract formulation is a project proposal to
review and validate, not a correctness guarantee supplied by these tool docs.
