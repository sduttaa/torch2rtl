# Hardware-constrained model training

An optional `photometric` training configuration supplies `brightness` and
`contrast` intervals. Brightness is an additive offset on normalized pixels;
contrast is a nonnegative gain around each image's mean. Per-image samples are
applied after cropping and clipped to `[0,1]`. Labels and cached teacher logits
remain spatially aligned and serve as invariant targets. This affects training
only and is disabled by `augment: false`; deployment preprocessing is unchanged.
The [lighting experiment](../docs/window-layouts.md) did not improve validation
accuracy.

These training experiments are separate from compiler lowering. Dataset paths,
preprocessing, architectures and numerical budgets are explicit JSON inputs.
They do not introduce model names or board-specific rules into the compiler.
Existing source models and annotations are preserved.

The requested replacement must satisfy three separate checks:

1. The serialized integer model matches or exceeds the existing INT8 export's
   validation Dice (0.6768431308866513) on the same 49 images. Precision, recall,
   IoU and confusion counts are also reported. Pixel accuracy alone is unsuitable
   for this dataset because nearly all pixels are background.
2. All constants, activations, line buffers, residual buffers and FIFOs fit FPGA
   fabric memory. Weight size and convolution line-buffer totals are preliminary
   screening values, not a physical memory-fit proof.
3. A routed implementation sustains at least 30 inferences/second, including
   backpressure. MAC counts and hypothetical clock rates are not measured FPS.

The latest verified integer result has Dice **0.667590**, 27,576 bytes of constants
and 240,583,680 MACs per inference. It passes exact integer/export checks,
torch-mlir verification and full-model RTL simulation with oversized verification
buffers. It does not meet the accuracy or hardware
deployment checks. The compact verified integer result has Dice **0.659503**, 26,988 bytes of
constants and 212,686,848 direct MACs per inference. A wider candidate reaches
**0.660307** with 37,644 bytes and 240,556,032 MACs. Neither has satisfied the
three acceptance checks. See [the current results](../docs/training-results.md)
and generated reports; an experiment file is not evidence that its architecture
has been successfully trained or implemented.

## Reproducibility

From the project root after sourcing `env.sh`:

The latest integer candidate can be reproduced from its preserved floating-point
checkpoint with:

```sh
python training/quantize.py --checkpoint build/training/wide-stem/best.pt \
  --config training/experiments/scratches-batch-dice.json \
  --resume build/training/short-requantizer/qat.pt \
  --output build/training/reproduced --epochs 80 --learning-rate 0.00003 --shift 16
```

`loss.dice_reduction` selects `sample` (the default mean of per-image Dice losses)
or `batch` (one Dice ratio across all batch pixels). This is an explicit training
choice; it does not change deployment arithmetic or the reported validation metric.

`loss.focal_gamma` optionally multiplies each supervised BCE pixel by
`(1 - p_t)**gamma`, where `p_t` is the probability of its target class. It retains
the configured positive-class weight; the focusing factor uses the unweighted
probability. A finite nonnegative gamma is required, and zero (the default)
retains ordinary BCE. Dice and teacher losses are unchanged. This follows the
[focal-loss formulation](https://arxiv.org/abs/1708.02002); it is a training option,
not a change to inference arithmetic.

`quantize.py --resume PATH_TO_QAT` continues saved QAT weights and calibrated
scales with a fresh AdamW optimizer and learning-rate schedule. The original
floating checkpoint is still supplied through `--checkpoint` to construct the
model. Graph, data and quantization contracts must match; explicit training
choices such as loss, crop, seed and batch size may change. Reports record the
continued checkpoint's hash. This does not restore an interrupted optimizer or
claim an identical training trajectory.

Optional `calibrate_prediction_threshold` chooses a strict decision threshold
from training predictions at each checkpoint evaluation. Validation labels are
not used to select that threshold. The export converts it to an exact integer
comparison by enumerating the final quantizer's representable byte values,
including floating multiplication rounding. Checkpoint selection still uses
the existing validation split. Calibration currently requires a final quantized
convolution or merge, and its float/integer thresholds are recorded explicitly.
All-positive and all-negative thresholds use representable comparison constants
so a scalar outside the byte range cannot wrap during deployment.

The checkpoint contains its architecture and preprocessing configuration. Other
training experiments use explicit JSON descriptions, for example:

```sh
python training/train.py --config training/experiments/scratches-encoder.json \
  --output build/training/encoder
python training/quantize.py --checkpoint build/training/encoder/best.pt \
  --output build/training/encoder-integer --epochs 30
```

The training configuration selects CPU or MPS. On this Mac the sandbox hides
MPS; accessing the local GPU requires running the training process outside the
sandbox. Export and exact integer verification use the CPU. Dependencies added
for dataset loading are Pillow and ONNX, installed in the existing local
environment. No data is uploaded and no cloud training is used.

Each run saves its configuration, dataset hashes, per-epoch history, best and
last checkpoints. `--resume` loads weights into a new run; it deliberately starts
a new optimizer and learning-rate schedule. Training uses the 197 remaining
images, keeps the original preprocessing and output resolution, and optionally
uses aligned crops during training only. Validation always uses full images.

Teacher logits can come from the original ONNX model through its supplied
Python reconstruction, or from a named logit node in an exported program. Both
the original FP32 baseline and the supplied weight-quantized baseline were
reproduced exactly. The newer runs use the latter teacher, identified explicitly
in their configurations. Cache fingerprints are checked against the preprocessed
dataset and source model. Teacher outputs are used only for training.

Optional training crops preserve configured input/output alignment. Augmentation
axes are explicit inputs: the later runs avoid horizontal flips because an odd
input width followed by pooling can shift alignment with the even-width mask.
Optional checkpoint tensor expansion initializes wider feature layers from a
smaller checkpoint. Its repeat factors, scales and symmetry-breaking noise are
configuration inputs; they do not change compiler rules.

Low-rank experiments retain the teacher's feature widths while factoring
convolution weights. Optional feature distillation uses training images only;
its FP16 cache is a training acceleration, not deployment precision. Cached
features require unaugmented, uncropped images.

For explicit graph descriptions, `initial_checkpoint` restores dense weights
before an optional `factor_rank` decomposition. Each selected convolution becomes
a depthwise spatial convolution followed by a pointwise convolution, initialized
with a separate truncated SVD for each input channel. `factor_exclude` lists
module names to retain unchanged. This changes the trained model and generally
introduces approximation error; it is not an exact compiler rewrite. Acceptance
still requires quantized accuracy, complete RTL verification, fabric fit and
physical throughput checks. `factor_rank` and `input_rank` select different
decompositions and cannot both be used for the same graph.

The provided directory has no separate test set. The existing validation split
is used for checkpoint and architecture selection, as it was in the supplied
quantization report. This comparison does not establish performance on an
independent test set or a new camera sequence. Exact duplicate preprocessed
images were checked and none were found across the split; neighboring frames
may still be strongly correlated. The original model's earlier training split
is unknown.

## Integer contract

Optional `activation_scale_axis: "channel"` calibrates a separate fixed scale
for each NCHW channel. The default remains `"tensor"`. Convolution input scales
are folded into its weights before per-output-channel INT8 weight quantization,
including grouped convolutions. Concatenation and addition use explicit integer
requantization coefficients. No runtime floating-point scale is introduced, and
the existing integer RTL actors implement the resulting graph.

For an unobserved all-zero channel, calibration uses the largest observed
channel magnitude, or unit magnitude if all channels are zero. This is a
declared training convention, not a proof that future activations remain zero.
Changing the scale axis requires a new calibration/training run; QAT continuation
rejects that contract change. Per-channel experiments and their accuracy limits
are recorded in [the training results](../docs/training-results.md).

Calibration uses training images only. Batch normalization is folded into
convolution weights and biases before quantization-aware training. Deployment
uses INT8 weights, UINT8 activations after ReLU, signed INT8 values before
unfused additions, and INT32 convolution accumulators. Fixed input/output scales
are represented by integer multipliers and a declared binary shift. Residual
addition and concatenation explicitly align scales. There is no per-frame
maximum, floating-point convolution, or runtime floating-point scale.

Optional `unsigned_activation_bits` and `signed_activation_bits` declare smaller
integer ranges within byte containers. They default to eight and are recorded
in the report and exported clamp operators; this is explicit mixed precision,
not an implicit compiler quantization. `activation_calibration_quantile` defaults
to 1 (training-set maxima). A smaller value selects an upper histogram-bin bound
from a second training-only pass with 2,048 magnitude bins per observed tensor.
The compiler derives storage widths from graph semantics, never calibration
samples. Six-bit and four-bit experiments are separate candidates and do not
replace the best full-range INT8 model automatically.

For accumulator `a`, multiplier `m` and shift `s`, requantization is:

```text
q = clamp((a * m + 2**(s - 1)) >> s, lower, upper)
```

The multiplication uses INT64 in the reference export. Rounding is nearest with
ties toward positive infinity, including negative ties. The training reference
uses integer-valued floating tensors with checked exact-representation bounds,
and the deployed graph uses integer tensors. Tests cover rounding, grouped and
dilated convolutions, residual scale alignment, batch-normalization folding and
export/reload. The full dataset is checked for QAT/integer mask agreement, and
the serialized export is independently evaluated on all validation images.

ATen's CPU dilated convolution lacks an integer kernel. The portable integer
reference expresses this case as window views and integer matrix products.
This is a generic mathematical representation; compiler support and a suitable
hardware template still need to be verified for any selected graph.

## Verified intermediate result

`build/training/deep-integer/model.pt2` is a serialized, genuinely integer model
with 26,316 bytes of tensor constants and 194,107,392 direct MACs per inference.
Its validation Dice is **0.638242**, below the required **0.676843**. QAT and
integer predictions match on all 246 images; the reloaded export matches on
all 49 validation images and has no floating-point tensor nodes. Import through
torch-mlir succeeds. This is an intermediate result, not an accepted replacement.
The `.pt2` archive also contains graph/serialization metadata; its file size is
not the hardware constant-storage requirement.

Reproduce its QAT from the saved floating checkpoint with:

```sh
python training/quantize.py --checkpoint build/training/deep/best.pt \
  --config training/experiments/scratches-deep-quantized.json \
  --output build/training/deep-integer-reproduction \
  --epochs 30 --learning-rate 0.0001
```

The first run's `qat-source.pt` retained an outdated FP32 teacher descriptor
after its cache and loss were changed. It actually trained against the verified
weight-quantized teacher cache. The explicit reproduction configuration above
corrects that metadata; its initial weights match the recorded run exactly.
The quantizer now verifies the cache fingerprint and saves its resolved config.

The spatial backend now emits the complete retrained graph from explicit actor
and FIFO choices. Full-model simulation matches its integer reference on three
validation images, including random stalls. There is no full-model routed design,
complete physical memory-fit proof, or measured 30-FPS result. The verification
buffers exceed fabric memory. See [the spatial backend](../docs/spatial-backend.md).

Graph experiments may supply `initial_checkpoint` to restore the unfactored graph
before `input_rank` factorization. All architecture, rank and checkpoint choices
remain experiment inputs. `augmentation_after_crop` applies spatial flips after
aligned cropping; this matters when the original image has an odd dimension.
