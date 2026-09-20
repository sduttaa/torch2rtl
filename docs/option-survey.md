# Measured actor options and continued training

The requested full-model, fabric-only 30-FPS result remains incomplete. This
investigation broadens the measured hardware catalogue and tests whether more
training or teacher supervision closes the remaining accuracy gap.

## Hardware catalogue

The same four-bit-activation, INT8-weight graph was synthesized with **191
convolution configurations**. Output and reduction lane candidates are explicit
inputs. A necessary arithmetic period bound screens the list at six million
cycles; it does not account for window stalls or graph FIFO occupancy. Packed
line storage is selected throughout this particular catalogue.

`scripts/characterize-actors.py --options FILE` accepts an actor-to-option mapping
alongside the existing model/configuration input. It measures every supplied
option, records emitted RTL hashes and costs, and does not sum mutually exclusive
options as though they were one design. No board/model rules were added.

```sh
source ./env.sh
python scripts/characterize-actors.py \
  --configuration build/network/four-bit-lanes-4/configuration.json \
  --options build/network/four-bit-options/options.json \
  --target inputs/target.json --workers 2 \
  --output build/network/reproduced-options
```

- [Explicit options](../build/network/four-bit-options/options.json)
- [Screening inputs and scope](../build/network/four-bit-options/screening.json)
- [All synthesis measurements](../build/network/four-bit-options/measurements/report.json)
- [Combined actor/FIFO catalogue](../build/scheduling/four-bit-options/catalogue.json)

## Relaxations and numerical verification

Resource/arithmetic relaxations expose the tradeoff between parallelism and area:

| Relaxation | Arithmetic period | LUT equivalents | FFs | BRAM | DSP byte slots |
| --- | ---: | ---: | ---: | ---: | ---: |
| Minimize arithmetic period | 3,872,736 | 20,448 | 8,182 | 45 | 96 |
| Minimize LUTs + FFs at a five-million-cycle cap | 5,000,000 imposed | 17,490 | 6,561 | 44 | 87 |
| Minimize LUTs + FFs at a six-million-cycle cap | 6,000,000 imposed | 15,552 | 6,089 | 40 | 63 |

These costs include depth-one FIFOs selected by the relaxation. **FIFO occupancy,
window stalls and routing are omitted**, so none of these is a full schedule or
a deployable allocation. The imposed caps are exploration inputs, not achieved
frame periods. More expensive actors can sometimes reduce total logic by moving
parallelism from output channels into the reduction dimension.

The fastest selected actor configuration was numerically tested with full-frame
verification FIFOs. All **96,768 output pixels** match the same three reference
images with random source/sink stalls. Frame completions are 5,057,795,
9,040,482 and 13,023,168 cycles, yielding observed intervals of **3,982,687** and
**3,982,686 cycles**. The earlier configuration of this same graph had intervals
of 4,659,904 and 4,659,906 cycles: approximately **17% higher observed throughput**.
This is not a comparison against another compiler or a hardware FPS measurement.

The verification FIFOs exceed fabric memory. Three frames do not establish
asymptotic throughput, and a routed full-model clock is still missing. The graph's
validation Dice is 0.656095, so it also fails the accuracy requirement.

- [Arithmetic/resource relaxation](../build/scheduling/four-bit-options/relaxation.json)
- [Five-million-cycle area screen](../build/scheduling/four-bit-options/area-screen-5000000.json)
- [Six-million-cycle area screen](../build/scheduling/four-bit-options/area-screen-6000000.json)
- [Numerical-verification configuration](../build/network/four-bit-selected/configuration.json)
- [Full-model RTL simulation](../build/network/four-bit-selected/simulation/report.json)

## Accuracy investigation

The best full-range INT8 checkpoint scores 0.814375 Dice on the 197 training
images and 0.667115 on the 49 validation images. The supplied teacher scores
0.758736 and 0.676843, respectively. This gap motivates testing generalization
and decision calibration rather than assuming more fitting is sufficient.
These comparisons do not replace an independent test set, which is unavailable.

| Continuation from the best QAT checkpoint | Result |
| --- | --- |
| 120 epochs, original loss, learning rate 0.0001 | Best remained the starting checkpoint, Dice 0.667115 |
| 80 epochs, class-balanced teacher loss, learning rate 0.00003 | Best at the fixed zero threshold remained the starting checkpoint |
| 30 epochs, same teacher loss, training-only threshold calibration | Best Dice 0.661053; not adopted |

The calibrated candidate's exported integer decision threshold is six. QAT and
integer masks agree on all 246 images; the reloaded export agrees on all 49
validation images. The export has no floating tensor nodes. The best retained
research checkpoint remains unchanged, below the required accuracy. No candidate
has satisfied the complete deployment acceptance criteria.

- [Train/validation comparison](../build/training/short-requantizer/generalization.json)
- [Original-loss continuation](../build/training/continued-integer/report.json)
- [Teacher-loss continuation](../build/training/balanced-teacher/report.json)
- [Calibrated teacher report](../build/training/calibrated-teacher/report.json)
- [Calibrated teacher MLIR/workload report](../build/training/calibrated-teacher/inspection/analysis.json)

QAT continuation preserves calibrated scales and weights while explicitly
starting a new optimizer. Reports include the source checkpoint hash. Training
precision, loss, architecture and calibration settings remain experiment inputs.
