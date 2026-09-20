# Explicit activation precision and exact storage narrowing

The compiler now derives conservative value bounds from fused clamp/cast
operations, byte lookups, unpadded max pooling and nearest resampling. It uses
those bounds to narrow convolution line/window storage, output banks, pooling
and resampling memory, and graph FIFOs. Sign extension restores the declared
byte values at actor interfaces. Known input bits also simplify concatenation
lookup tables. Convolution accumulator bounds include zero padding.

This transformation is exact for the exported graph. It does not choose a
quantization range or use observed training values as a correctness proof.
Clamps that can wrap when cast retain the full destination range. Padded pooling
also retains the full range because dilation can produce a padding-only window.
Tensor containers, graph semantics and the periodic scheduling formulation are
unchanged. Smaller accumulator widths can change the number of requantization
steps; the schedule builder obtains those widths from the same configuration
function as the RTL emitter.

## Training experiments

Both experiments retain INT8 weights, an eight-bit image input, signed eight-bit
final logits, INT32 accumulation and INT64 fixed-point requantization. Their
unsigned hidden activations have explicitly exported smaller clamp ranges.
They are mixed-precision candidates, not full-range eight-bit activation models.

| Candidate | Hidden range | Validation Dice | QAT epochs | Calibration |
| --- | --- | ---: | ---: | --- |
| Best full-range candidate | 0–255 | 0.667115 | 40 | Training maxima |
| Six-bit candidate | 0–63 | 0.660259 | 60 | Training maxima |
| Four-bit candidate | 0–15 | 0.656095 | 80 | Training magnitude quantile 0.999 |
| Supplied accuracy target | — | 0.676843 | — | Supplied export |

Both new candidates have 27,576 bytes of constants and 240,583,680 MACs per
frame. QAT/integer masks match on all 246 images, serialized exports match on
all 49 validation images, and both pass torch-mlir verification with no floating
tensor nodes. Neither meets the accuracy requirement, so the best full-range
candidate remains unchanged. The validation split has been used repeatedly for
model and checkpoint selection; no independent test set is available.

- [Six-bit training report](../build/training/six-bit-activations/report.json)
- [Four-bit training report](../build/training/four-bit-calibrated/report.json)
- [Six-bit experiment input](../training/experiments/scratches-six-bit-activations.json)
- [Four-bit experiment input](../training/experiments/scratches-four-bit-calibrated.json)

Reproduce from the preserved floating checkpoint after sourcing `env.sh`:

```sh
python training/quantize.py --checkpoint build/training/wide-stem/best.pt \
  --config training/experiments/scratches-six-bit-activations.json \
  --output build/training/reproduced-six-bit \
  --epochs 60 --learning-rate 0.00003 --shift 16
python training/quantize.py --checkpoint build/training/wide-stem/best.pt \
  --config training/experiments/scratches-four-bit-calibrated.json \
  --output build/training/reproduced-four-bit \
  --epochs 80 --learning-rate 0.0001 --shift 16
```

## Measured storage and logic

These configurations use packed row storage. Parameters were screened using
an arithmetic-only five-million-cycle per-actor limit, then individually
synthesized. They are exploration inputs, not joint CP-SAT solutions.

| Configuration | LUT equivalents | FFs | DSP byte slots | BRAM blocks | LUTRAM bits |
| --- | ---: | ---: | ---: | ---: | ---: |
| Six-bit, three stream lanes | 23,463 | 8,847 | 69 | 47 | 18,112 |
| Six-bit, six stream lanes | 23,466 | 9,667 | 69 | 47 | 21,312 |
| Four-bit, four stream lanes | 20,300 | 8,486 | 75 | 44 | 11,648 |
| Supplied target capacity | 20,736 | 15,552 | 96 | 46 | 41,472 |

**All rows exclude graph FIFOs and interconnect.** The four-bit actors leave
only 436 LUT equivalents and two BRAM blocks. This is not a complete fabric-fit
or timing result. The six-bit configurations already exceed LUT and BRAM
budgets. The four-bit total includes input-bound simplification in concatenation;
the earlier archived measurement without that simplification used 20,419 LUTs.
Actor records include emitted RTL hashes and output range/storage widths.

- [Six-bit three-lane measurements](../build/network/six-bit-lanes-3/actors/report.json)
- [Six-bit six-lane measurements](../build/network/six-bit-lanes-6/actors/report.json)
- [Four-bit measurements](../build/network/four-bit-bounded-inputs/actors/report.json)
- [Four-bit hardware configuration](../build/network/four-bit-lanes-4/configuration.json)
- [Explicit actor/FIFO cost catalogue](../build/scheduling/four-bit/catalogue.json)
- [Resource-only relaxation](../build/scheduling/four-bit/resource-only.json)

The resource-only relaxation does not constrain FIFO occupancy or execution
timing and must not be treated as a schedule. It passes the necessary budget
check by selecting depth one everywhere: 20,369 LUT equivalents, 8,909 FFs,
44 BRAM blocks and 75 byte-multiplier slots. That choice has no scheduling or
startup certificate, and its reported dummy period is not an inference period.
The earlier full per-word solver
scale limit remains unresolved. No restricted pixel-group schedule has been
implemented while that mathematical change awaits the user's decision.

## Numerical RTL verification

Each new graph matches all 96,768 output pixels across the same three validation
images, with random source and sink stalls. Full-frame FIFOs on every edge make
these numerical tests exceed fabric capacity; they are not deployment layouts.

| Graph/configuration | Observed frame completion cycles | Observed intervals |
| --- | --- | --- |
| Six-bit, three lanes | 6,351,198; 11,440,662; 16,530,126 | 5,089,464; 5,089,464 |
| Four-bit, four lanes | 5,851,487; 10,511,391; 15,171,297 | 4,659,904; 4,659,906 |

These short simulations establish numerical agreement for those images, not
an asymptotic throughput certificate. No full-model routed clock or measured
30-FPS result exists.

- [Six-bit simulation](../build/network/six-bit-verification/simulation/report.json)
- [Four-bit simulation](../build/network/four-bit-verification/simulation/report.json)

Regression tests cover signed/unsigned narrow storage, cast wrapping, padding
minima, incomplete vectors, multiple frames and backpressure. A narrow-activation
branched graph also meets CP-SAT-selected transfer deadlines and FIFO depths.
