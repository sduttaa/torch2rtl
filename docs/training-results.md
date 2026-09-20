# Fabric-only retraining results

The most accurate verified integer replacement now reaches **0.667590 Dice** versus
**0.676843** for the supplied export. It has **27,576 bytes** of constants and
**240,583,680 MACs per inference**. None of the candidates has met the requested
accuracy or complete 30-FPS deployment requirement.
Weights and activations must remain in FPGA fabric memory; SDRAM is excluded.

## Batch Dice experiment

The best verified full-range INT8 candidate now reaches **0.667590 Dice**,
still below the supplied model's **0.676843**. Continuing the earlier QAT
checkpoint for 80 epochs with batch-wide Dice loss selected epoch 52.
Preprocessing, the original split, graph, calibrated quantizers and fixed zero
decision threshold are unchanged. The loss combines BCE, batch Dice and teacher
logit supervision with weights 0.45, 0.45 and 0.10.

Its IoU is 0.501040, precision 0.632961 and recall 0.706227; TP/FP/FN are
964/559/401. Constants remain 27,576 bytes and direct work remains 240,583,680
MACs per image. It matches QAT on all 246 images and its saved integer export on
all 49 validation images. No floating tensor nodes remain, and torch-mlir
verification passes. The model SHA-256 is
`ce6102156eca515ecac4976210539a5fab9556490c853e593e7b27f36d735231`.
This small validation improvement does not establish better generalization.
The complete emitted RTL also matches 96,768 output words over three real
images with randomized source/sink stalls. That check uses oversized FIFOs and
does not establish fabric fit or a routed clock.

- [Verified integer model](../build/training/batch-dice-integer/model.pt2)
- [Verification report](../build/training/batch-dice-integer/report.json)
- [MLIR and workload inspection](../build/training/batch-dice-integer/inspection/analysis.json)
- [Explicit experiment input](../training/experiments/scratches-batch-dice.json)
- [Complete RTL numerical check](../build/network/batch-dice/simulation/report.json)

```sh
python training/quantize.py --checkpoint build/training/wide-stem/best.pt \
  --config training/experiments/scratches-batch-dice.json \
  --resume build/training/short-requantizer/qat.pt \
  --output build/training/batch-dice-integer --epochs 80 --learning-rate 0.00003 --shift 16
```

The previous 0.667115 model remains preserved. A diagnostic that predicted from
its final exact accumulator before byte requantization scored only 0.665781;
that numerical change was not adopted. The existing validation split is still
used for checkpoint selection, with no independent test set supplied.

A further 100-epoch QAT run raised batch Dice's loss weight to 0.80, with BCE and
teacher supervision at 0.10 each. It retained epoch zero as its best checkpoint
at 0.667590; no trained improvement was adopted. All 246 QAT/integer and 49
saved-export checks pass. Its [configuration](../training/experiments/scratches-overlap-loss.json),
[history](../build/training/overlap-loss-integer/history.json) and
[verification](../build/training/overlap-loss-integer/report.json) are preserved.

## Per-channel calibration investigation

Explicit per-channel activation scales did not close the accuracy gap. Both
experiments started from the preserved wider-stem floating checkpoint and kept
the original preprocessing, split and fixed zero prediction threshold:

| Activation contract | QAT epochs | Best validation Dice | Constants |
| --- | ---: | ---: | ---: |
| Full-range INT8/UINT8, per-channel scales | 40 | 0.663091 | 27,912 bytes |
| Four-bit hidden activations, per-channel scales | 80 | 0.656158 | 27,912 bytes |

Both use INT8 weights, a fixed requantization shift of 16 and 240,583,680 MACs per
inference. They match QAT on all 246 images and the saved integer export on all
49 validation images, contain no floating tensor nodes, and pass torch-mlir
verification. At the time, the best full-range model remained the 0.667115 candidate;
neither new model is adopted as satisfying the accuracy requirement. The tiny
change from 0.656095 to 0.656158 in the four-bit experiment is not a meaningful
demonstration of better generalization.

The generic training option folds input-channel scales into convolution weights
before weight quantization and uses explicit merge requantizers. Grouped
convolutions, ragged concatenation, signed outputs, quantization gradients and
saved-model-to-RTL execution have regression coverage. A saved-export test
exposed a PyTorch/torch-mlir metadata mismatch: a `Tensor[]` operator result
reloads with tuple metadata. The frontend now normalizes that metadata according
to the operator schema on its private import copy; genuine multiple-return
tuples and the caller's program remain unchanged.

- [INT8 report](../build/training/channel-int8/report.json)
- [INT8 MLIR/workload inspection](../build/training/channel-int8/inspection/analysis.json)
- [Four-bit report](../build/training/channel-four-bit/report.json)
- [Four-bit MLIR/workload inspection](../build/training/channel-four-bit/inspection/analysis.json)
- [INT8 experiment input](../training/experiments/scratches-channel-int8.json)
- [Four-bit experiment input](../training/experiments/scratches-channel-four-bit.json)

Reproduction from the repository root after sourcing `env.sh`:

```sh
python training/quantize.py --checkpoint build/training/wide-stem/best.pt \
  --config training/experiments/scratches-channel-int8.json \
  --output build/training/channel-int8 --epochs 40 --learning-rate 0.0001 --shift 16
python training/quantize.py --checkpoint build/training/wide-stem/best.pt \
  --config training/experiments/scratches-channel-four-bit.json \
  --output build/training/channel-four-bit --epochs 80 --learning-rate 0.0001 --shift 16
```

These runs also use the existing validation split for checkpoint selection.
They do not provide independent test-set evidence or a complete physical fit.

## Earlier precision and training experiments

Explicit six-bit and four-bit hidden-activation experiments reached 0.660259 and
0.656095 Dice, respectively, and were not adopted. Their integer exports and
full-graph RTL checks pass. Proven storage narrowing brings one four-bit actor
configuration to 44 BRAM blocks and 20,300 LUT equivalents before graph FIFOs;
complete fit and timing remain unproven. See [the precision/storage results](narrow-storage.md).

Further QAT continuation (120 epochs) and class-balanced teacher supervision
(80 epochs) retained the starting checkpoint as their best result at the fixed
zero threshold. Combining teacher supervision with a decision threshold chosen
on training images reached only 0.661053 Dice. The best checkpoint remains
unchanged. The [option/training investigation](option-survey.md) includes the
train/validation gap, exact integer verification and reproducible artifacts.

The earlier 0.667115 candidate retains the wider input stage and uses an explicitly trained
fixed-point right shift of 16 for requantization, reducing multiplier magnitudes.
It preserves input/output resolution, preprocessing and the original split.
Its IoU is 0.500504, precision 0.616005 and recall 0.727473;
TP/FP/FN are 993/619/372. QAT/integer masks match on all 246 images, and the
reloaded export matches on all 49 validation images. It contains no floating
tensor nodes and passes torch-mlir import. Its SHA-256 is
`0e45449076070d202642d263ec06f6300aa99d46ea364c94406c742e12d4d31d`.

- [Earlier integer model](../build/training/short-requantizer/model.pt2)
- [Earlier verification report](../build/training/short-requantizer/report.json)
- [Earlier MLIR and workload accounting](../build/training/short-requantizer/inspection/analysis.json)
- [Full-model RTL evidence and limits](spatial-backend.md)

The earlier wider-stem model with a shift of 24 reached 0.663747 Dice. Its
artifacts remain in `build/training/wide-stem-integer`. Aligned crop flips
(0.639923), stronger teacher-logit loss (0.659151), and input-rank factorization
(0.637018) did not improve floating-point validation accuracy and were not
adopted. Factorization reduced raw convolution weights to 14,948 bytes and
line-buffer screening storage to 31,758 bytes, but failed the accuracy criterion.
A training-only threshold probe also failed to improve the previous integer model.
A separate rank-one color projection retained only 0.647021 floating-point
Dice after fine-tuning and was not adopted.
Increasing the positive-class loss weight from 15 to 30 during the new QAT run
raised recall but reduced Dice to 0.661634, so that candidate was not adopted.

An additional full-image fine-tuning experiment reached 0.661219 in floating
point and 0.658210 after QAT. It did not improve on the compact integer model.
The earlier candidates are retained below for comparison.

| Measurement | Supplied export | Compact integer | Wider integer |
| --- | ---: | ---: | ---: |
| Validation Dice | 0.676843 | 0.659503 | 0.660307 |
| Validation IoU | 0.511537 | 0.491984 | 0.492879 |
| Precision | 0.607935 | 0.608803 | 0.617197 |
| Recall | 0.763370 | 0.719414 | 0.709890 |
| True positives / false positives / false negatives | 1042 / 672 / 323 | 982 / 631 / 383 | 969 / 601 / 396 |
| Tensor constants | 291,240 bytes | 26,988 bytes | 37,644 bytes |
| Direct MACs per inference | 2,558,324,736 | 212,686,848 | 240,556,032 |
| Convolution arithmetic | FP32 after dequantization | INT8 weights, INT32 accumulation | INT8 weights, INT32 accumulation |
| Runtime activation scales | Per-frame dynamic maxima | Fixed integer multipliers and shifts | Fixed integer multipliers and shifts |
| Full-model routed FPS | Unmeasured | Unmeasured | Unmeasured |

The compact replacement has 10.8× smaller constants and requires 12.0× fewer direct MACs.
Neither ratio is a measured hardware speedup. Its UINT8 input is RGB
`[1,3,256,505]`; its UINT8 binary output is `[1,1,128,252]`. It retains the supplied
image/mask preprocessing and input resolution.

## Artifacts and verification

The following artifacts are for the compact candidate:

- [Serialized integer model](../build/training/cropped-integer/model.pt2)
- [Exact integer report](../build/training/cropped-integer/report.json)
- [QAT checkpoint](../build/training/cropped-integer/qat.pt)
- [Resolved QAT configuration](../build/training/cropped-integer/config.json)
- [Per-epoch QAT history](../build/training/cropped-integer/history.json)
- [Verified torch-mlir module](../build/training/cropped-integer/inspection/model.mlir)
- [Generic workload accounting](../build/training/cropped-integer/inspection/analysis.json)

The wider candidate's [integer model](../build/training/wide-context-integer/model.pt2),
[verification report](../build/training/wide-context-integer/report.json) and
[MLIR module](../build/training/wide-context-integer/inspection/model.mlir) are
also preserved. It gains 0.000804 Dice for 10,656 additional bytes of constants.

QAT and integer predictions match on all 246 supplied images. Reloading the
serialized export preserves outputs on all 49 validation images. Its graph has
no floating-point tensor nodes. Its model SHA-256 is
`2942974bf7b0ee10959b91a4e14fe6883bfab1963751326b8a6c2d76378f9474`.
The archive includes graph/serialization metadata; file size is not RAM usage.
Both candidates passed the same 246-image QAT/integer and 49-image serialized
checks. The wider candidate also has no floating-point tensor nodes.

The compact architecture's raw convolution line-buffer estimate is 49,398 bytes.
Adding constants gives 76,386 bytes before pooling state, residual buffers,
FIFOs, windows, accumulators, banking, replication and physical memory packing.
The external target description supplies 111,168 bytes of fabric RAM. This is
screening arithmetic, not a complete fit proof. At 30 FPS the direct workload
would require 6.381 billion MACs per second; no clock/utilization assumption is
being presented as achieved throughput.
The wider candidate has a 54,438-byte convolution line-buffer estimate, making
its constants-plus-line-buffer subtotal 92,082 bytes before the same omitted
storage and physical packing costs. Its complete fabric-memory fit is also unproven.

## Training and evaluation

Training uses the original split: 197 training images and 49 validation images.
The original FP32 score (0.664338) and supplied weight-quantized score (0.676843)
were reproduced exactly. The source model, annotations and split were preserved.
Static quantization calibration uses training images only. Later distillation
runs use logits from the supplied weight-quantized export, with cache provenance
checked against the dataset and source model.

| Floating-point experiment | Best validation Dice |
| --- | ---: |
| Compact convolution stack | 0.560789 |
| Channel-pruned original architecture | 0.521158 |
| RGB dilated stack | 0.603531 |
| Small encoder/decoder | 0.615880 |
| Deeper encoder/decoder | 0.638353 |
| Additional final refinement | 0.644357 |
| Aligned augmentation | 0.649509 |
| Aligned training crops | 0.657631 |
| Wider final decoder | 0.648501 |
| Wider low-resolution context | 0.656834 |
| Low-rank model with cached teacher features | 0.614919 |
| Full-image fine-tuning | 0.661219 |
| Wider input feature stage | 0.662390 |

The low-rank experiment was stopped with checkpoints preserved after it fell
behind the smaller encoder/decoder. Training-only threshold calibration did not
improve validation Dice. A separate diagnostic found that even the validation-
optimal threshold for the best floating candidate reached only 0.660334; that
diagnostic used validation labels and was not adopted as independent evidence.

The supplied folder has no independent test set. Validation was used to select
architectures and checkpoints across these experiments. Consequently these
scores do not establish performance on new camera sequences. Exact duplicate
preprocessed images were checked and none crossed the split; nearby frames may
still be correlated. The original model's earlier training split is unknown.

## Remaining deployment work

A later 50-epoch QAT continuation with explicit mild brightness/contrast
augmentation retained its starting checkpoint as best (Dice 0.667115). It did
not close the accuracy gap and was not adopted. See the
[experiment and verification evidence](window-layouts.md).

The current compiler emits the complete retrained graph from explicit hardware
parameters, and full-model RTL simulation matches three real images with stalls.
The verification buffers exceed fabric memory. The spatial actors now have joint schedule/FIFO contracts and a catalogue CLI,
validated against repeated-frame RTL deadlines in smaller graphs. The full
per-word model now has optimized fixed-configuration schedules and complete
RTL deadline checks. A finite fabric-budget candidate still fails physical
placement. Resource-feasible option selection and whole-design place-and-route
remain incomplete; see [the current scheduling evidence](direct-scheduling.md).
No board has been programmed with this model.
Neither the small integration kernel's nor the isolated stem's routed clock
can establish the full model's FPS.

Architecture descriptions, preprocessing, dataset paths and budgets remain
explicit experiment inputs. Compiler changes recognize operators, shapes and
integer arithmetic contracts; there are no model-name or board-name rules.
