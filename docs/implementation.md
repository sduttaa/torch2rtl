# Implemented compiler path

The current implementation is a bounded, working foundation for the agreed
architecture. It does not yet implement the full model or the requested FP32 and
convolution coverage. The [workload analysis](workload-feasibility.md) explains
why the original export exceeds the tested storage budget. The user has since
authorized retraining a smaller integer replacement, with all working storage
still in fabric memory; see the [training notes](../training/README.md).

## Pipeline

1. Load a static, frozen `torch.export.ExportedProgram` and import a copy through
   upstream torch-mlir. Keeping a copy matters: the frozen importer rewrites
   lifted constants. Verify the resulting Torch backend-contract module.
2. Read MLIR operators/types into a small integer kernel description. Compatible
   pointwise operations share an actor. Every original integer rounding/overflow
   boundary remains present; no arbitrary graph is sent to a CPU fallback.
3. Prove conservative value ranges and narrow internal FIFO words where lossless.
   For example, an INT32 value clamped to [-100,100] needs only eight storage bits.
4. Emit and synthesize candidate lane counts and FIFO depths supplied by the
   caller. Costs come from actual Yosys cells and external target cost rules.
   Unknown or ambiguous primitive costs fail explicitly.
5. Build a solver-independent event problem. CP-SAT chooses the configuration,
   period and event offsets while enforcing ordered FIFO reuse and actor state
   recurrences. Minimize period first; when proven optimal, optionally minimize
   explicit weighted resources at that period using remaining solve time.
6. Save selected RTL, synthesis netlist, every candidate's costs, the complete
   scheduling problem, solution/bound, domains and status.

For this small map/reduction chain, configurations share a vector interface and
are characterized as complete kernels. This avoids guessing composition costs.
The solver data structures already support independent actor/edge option groups
and compatibility guards; general graph lowering has not been implemented.

## Numerical and interface contract

- One static batch-one integer tensor input and one output. Shapes are supplied
  by the exported graph. Supported types are signed 8/16/32/64-bit integers,
  unsigned integer casts, and boolean casts; boolean arithmetic is rejected.
- Add/subtract (including constant alpha), multiply, casts, clamp/ReLU, and
  contiguous reshape are fused when supported. Scalar arithmetic must be integer.
- An optional full-tensor sum is a separate stateful actor. Partial-axis reductions
  and operations after the sum currently fail with a diagnostic.
- Packed lanes are in flattened logical tensor order; lane zero occupies the
  least significant bits. The final partial word has zero padding after the map;
  padding is not passed through nonlinear arithmetic. Output padding is ignored.
- `in_valid/in_ready` and `out_valid/out_ready` accept transfers on rising edges.
  Producers hold data stable under backpressure. Reset flushes partial frames.
  Shape metadata determines frame boundaries; no board-specific framing is built in.
- The FIFO is registered for availability: a write can first be read on the next
  clock. A full FIFO supports simultaneous pop/push replacement, including depth
  one. Its storage uses synthesis-inferred registers/distributed RAM.
- The reduction blocks input while its result is waiting for acceptance. Its next
  frame starts no earlier than the cycle after that acceptance. These exact
  recurrences are in CP-SAT, including periodic wraparound.

Under a continuously available source and accepting sink, a map with N vector
words per frame has period N; the current sum actor has period N+1. These formulas
are independent checks, not the compiler's optimization objective implementation.
The tests compare them with both solved schedules and observed simulation.

## Current evidence

The suite checks imports without mutating the reference model, accounting of
actual graph dtypes/constants, ordered occupancy equivalence, periodic startup,
depths larger than a frame, deadlock at a reduction/bypass join, resource-constrained
actor choices, and bit-accurate PyTorch-versus-RTL results. Numerical cases include
negative values, overflow before casts, signed/unsigned conversion, boolean
conversion, reversed clamp bounds, wide accumulation, partial vector words and
single-word frames. Random input gaps and output stalls check protocol behavior.

The integration workload is a small exported integer activation/sum expression,
not a substitute for the full Scratches model. For its 13 input elements, the
solver selects four lanes and FIFO depth one from the supplied choices, reducing
period from 14 cycles (one lane) to five cycles. RTL simulation independently
confirms those periods. Synthesis reports 397 LUT-equivalents and 135 FFs for the
selected core under the supplied primitive accounting. These are kernel results,
not full-model inference performance or evidence of superiority over other
compilers. The 37 compiler tests pass; additional training tests check integer
export arithmetic. Verilator lint passes with only filename
and deliberately unused signal-bit checks disabled; width conversions are explicit.

The generated kernel in its routing harness meets the supplied 27-MHz target;
nextpnr reports an estimated maximum of 172.71 MHz for that routed harness.
Bitstream packing succeeds. This is static timing evidence, not a measured
operating frequency or an inference result for the full model.

`scripts/route-smoke.py` wraps an already compiled core with an observable
source/sink for Gowin placement, routing and packing using explicit target and
pin-constraint inputs. It checks internal timing; it does not implement a user
transport or measure a physical board. Never flash a routing harness as a model
deployment. The earlier direct core route attempt correctly rejected missing
pin constraints; no unconstrained design was accepted as board-ready.

To reproduce the small integration input (a test fixture, not a compiler rule):

```sh
source ./env.sh
mkdir -p build/acceptance
python - <<'PY'
import torch
class ActivationSum(torch.nn.Module):
    def forward(self, x):
        return (x.to(torch.int32) * 3 - 10).clamp(-100, 100).sum(dtype=torch.int32)
program = torch.export.export(ActivationSum(), (torch.zeros((1, 13), dtype=torch.int8),))
torch.export.save(program, "build/acceptance/input.pt2")
PY
python -m torch2rtl compile build/acceptance/input.pt2 \
  --target inputs/target.json --lanes 1 2 4 --depths 1 2 \
  --output build/acceptance/compiled
python scripts/route-smoke.py --compiled build/acceptance/compiled \
  --target inputs/target.json --constraints inputs/smoke.cst \
  --output build/acceptance/physical
```

## Remaining work

The full inference compiler still needs convolution/other actor families,
floating-point arithmetic and numerical tolerances, general graph fusion and
interface matching, scalable event compression with equivalent constraints,
latency/I/O contracts, calibrated physical resource composition, and representative
end-to-end workloads. Candidate synthesis is presently repeated per invocation;
there is no model-specific cache or lookup table. Resource packing/site and timing
constraints ultimately require place-and-route; a CP-SAT optimum does not prove
physical optimality.

The separate inspector includes a generic lossless constant-encoding catalogue
and a storage-only CP-SAT relaxation, plus source-retention candidates for replaying
index-only tensor views. These are full-model feasibility analyses; hardware
decoders and replay actors are not implemented or claimed to have been measured.
