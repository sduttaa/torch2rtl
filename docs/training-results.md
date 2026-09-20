# Fabric-only retraining results

The most accurate verified integer replacement now reaches **0.667115 Dice** versus
**0.676843** for the supplied export. It has **27,576 bytes** of constants and
**240,583,680 MACs per inference**. None of the candidates has met the requested
accuracy or complete 30-FPS deployment requirement.
Weights and activations must remain in FPGA fabric memory; SDRAM is excluded.

The newest candidate retains the wider input stage and uses an explicitly trained
fixed-point right shift of 16 for requantization, reducing multiplier magnitudes.
It preserves input/output resolution, preprocessing and the original split.
Its IoU is 0.500504, precision 0.616005 and recall 0.727473;
TP/FP/FN are 993/619/372. QAT/integer masks match on all 246 images, and the
reloaded export matches on all 49 validation images. It contains no floating
tensor nodes and passes torch-mlir import. Its SHA-256 is
`0e45449076070d202642d263ec06f6300aa99d46ea364c94406c742e12d4d31d`.

- [Latest integer model](../build/training/short-requantizer/model.pt2)
- [Latest verification report](../build/training/short-requantizer/report.json)
- [Latest MLIR and workload accounting](../build/training/short-requantizer/inspection/analysis.json)
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

The current compiler emits the complete retrained graph from explicit hardware
parameters, and full-model RTL simulation matches three real images with stalls.
The verification buffers exceed fabric memory. The spatial actors now have joint schedule/FIFO contracts and a catalogue CLI,
validated against repeated-frame RTL deadlines in smaller graphs. The full
per-word model hit the bounded solver/memory experiment limits, and the measured
catalogue is resource-infeasible. Resource-feasible option selection and
whole-design place-and-route remain incomplete. No board has been programmed with this model.
Neither the small integration kernel's nor the isolated stem's routed clock
can establish the full model's FPS.

Architecture descriptions, preprocessing, dataset paths and budgets remain
explicit experiment inputs. Compiler changes recognize operators, shapes and
integer arithmetic contracts; there are no model-name or board-name rules.
