# Automatic fabric-only inference: 35 BRAM, 17,527 sites, 35 FPS

The compiler-generated result meets the supplied 35-BRAM, 18,000-site and
35-FPS target. All weights and activations stay in FPGA fabric memory.

| Metric | Result |
| --- | ---: |
| Scheduled FPS | 35.00000324074104 |
| Frame period | 3,085,714 cycles |
| Configured clock | 108 MHz |
| Reported routed setup limit | 110.5094528 MHz |
| BRAM blocks | 35 |
| Actual routed logic sites | 17,527 |
| Margin below 18,000-site cap | 473 |
| Free physical logic sites | 3,209 of 20,736 (15.5%) |
| Signed 9-by-9 multiplier slots | 96 |
| Validation Dice | 0.6500655307994757 |

FPS is configured clock divided by the verified periodic schedule. The first
frame completes at cycle 3,455,890; subsequent complete frames finish at
6,541,604 and 9,627,318. Startup latency therefore differs from steady throughput.

## Automatic architecture and provenance

The compiler chooses fusion candidates, actor implementations, lane counts,
resource placement, buffering and the complete periodic schedule from model,
target and search inputs. The final schedule reports no external configuration
seed and no external schedule seed. Finite FIFO occupancy and internal storage
reuse participate in CP-SAT and its independent schedule validator.

The final solve resumed a compiler-generated measured catalogue after a generic
hybrid-ROM template improvement. All 233 retained actor options and 196 FIFO
options were refreshed with the final templates. The supplied target was then
changed to 35 FPS at 108 MHz, and normal automatic selection and joint scheduling
ran again. No per-actor/FIFO override or hand-picked architecture was introduced.
This reuse avoided repeating synthesis merely for a clock-input change.
The final fixed proposal passed CP-SAT in 12.53 seconds; that is solve time,
not total compilation or development time.

[Resume provenance](resume-provenance.json),
[catalogue-refresh provenance](catalogue-refresh-provenance.json),
[search inputs](search.json), [target inputs](target.json),
[chosen configuration](configuration.json) and
[compiler source hashes](compiler-source-hashes.json) record the process.
This is bounded heuristic architecture search; no global-optimum claim is made.

## Validation and deliverables

All 18 acceptance gates in [result.json](result.json) pass:

- The model hash matches the unchanged accuracy evidence and reference vectors.
- All 2,384,445 schedule events and 5,203,923 actor dependencies are independently
  validated; all three complete RTL frames are bit-exact, with 96,768 output
  words and every scheduled transfer deadline checked.
- All 20 distinct mapped modules pass equivalence checks.
- Whole-design capacity and actual placed-site counts satisfy the input budget.
- Routing passes the 108-MHz clock constraint; all 96 multiplier configurations
  pass their timing guard, and the structural used-pin audit has no missing pins.
- The bitstream is packed successfully.

[Generated RTL](inference.sv), [bitstream](harness.fs),
[simulation report](simulation-report.json), [mapping proofs](mapping-proofs.json),
[route summary](toolflow-summary.json), [capacity](capacity.json) and
[timing-database comparison](timing-database-identity.json) are retained here.
The result manifest hashes source evidence, including full netlists and logs
retained under `build/automatic-throughput/clock-margin`.

The timing audit uses the corrected generator and configuration-scoped DSP data.
All decoded cell timing and indexed pip/node timing classes match those in the
archived database source. Assembling that original source reproduces the binary
used for routing byte-for-byte. The regenerated routing-graph serialization
itself differs; whole regenerated databases are not claimed identical.
The audit is structural coverage plus configuration-scoped delay evidence, not
independent timing signoff. IO/PLL/global routing retain their tool handling.

**Physical-board FPS has not been measured.** The packed design uses a counter
source and checksum sink, not a camera/host interface. Inputs to the inference
core must already satisfy the model's input contract. Accuracy is inherited
from the unchanged model's supplied validation evidence; no independent new
test set was evaluated. All 96 multiplier slots are occupied.

## Resource attribution

| BRAM purpose | Blocks |
| --- | ---: |
| Weight ROMs | 13 |
| Convolution windows | 13 |
| Fused branch/source buffers | 8 |
| Standalone pooling | 1 |
| Total | 35 |

Some weights also occupy logic ROMs. Inter-actor FIFOs use registers/distributed
memory and require no BRAM. Of 17,527 actual logic sites, 16,807 belong only to
neural actors, 436 only to FIFOs, 193 are shared by actor/FIFO cells and 91 serve
the harness/other logic. About 99.5% therefore serves the network and its internal
data movement. The final byte-decision actor touches eight sites; external
pre/postprocessing is not a large part of this design.
[Full measured attribution](resource-breakdown.json).

## Reproduction

From the repository root, using the installed tools and retained input evidence:

```sh
source ./env.sh
python scripts/compile-and-verify.py --job inputs/automatic-job.json \
  --build build/automatic-throughput/reproduce \
  --output results/automatic-throughput-reproduce --seconds 600 --workers 1
```

This runs automatic selection, schedule export, three-frame RTL verification,
mapping proofs, routing, timing audits and gated packaging. It can reuse the
characterization cache but supplies no chosen architecture. Bounded solver and
placement searches can produce another legal configuration; exact architecture
identity across fresh runs is not promised. The accepted build above reused the
recorded catalogue rather than rerunning the initial planning pass.

To repackage the existing verified build without rerunning synthesis or routing:

```sh
source ./env.sh
python scripts/package-network-result.py \
  --build build/automatic-throughput/clock-margin \
  --vectors build/throughput-push/compact-balanced/vectors \
  --accuracy-evidence results/bram-reduction/result.json --minimum-accuracy 0.65 \
  --clock-rtl inputs/throughput-pll.sv \
  --constraints results/on-chip-inference/constraints.cst \
  --clock-net clock_source.clock_out --bram-resource BSRAM --dsp-resource MULT9X9 \
  --output results/automatic-throughput
```

The earlier [30.70-FPS result](../bram-reduction/README.md) remains intact.
Compared with its 19,596 actual sites, this result uses 2,069 fewer sites and
provides 14.0% higher scheduled throughput with the same model and BRAM count.
