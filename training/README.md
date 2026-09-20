# Hardware-constrained model training

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

The latest verified integer result has Dice **0.667115**, 27,576 bytes of constants
and 240,583,680 MACs per inference. Its full graph passes numerical RTL simulation
with oversized verification buffers, but it has not met the accuracy or hardware
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
  --output build/training/reproduced --epochs 40 --learning-rate 0.00003 --shift 16
```

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

The provided directory has no separate test set. The existing validation split
is used for checkpoint and architecture selection, as it was in the supplied
quantization report. This comparison does not establish performance on an
independent test set or a new camera sequence. Exact duplicate preprocessed
images were checked and none were found across the split; neighboring frames
may still be strongly correlated. The original model's earlier training split
is unknown.

## Integer contract

Calibration uses training images only. Batch normalization is folded into
convolution weights and biases before quantization-aware training. Deployment
uses INT8 weights, UINT8 activations after ReLU, signed INT8 values before
unfused additions, and INT32 convolution accumulators. Fixed input/output scales
are represented by integer multipliers and a declared binary shift. Residual
addition and concatenation explicitly align scales. There is no per-frame
maximum, floating-point convolution, or runtime floating-point scale.

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
