"""Deployment arithmetic must match the QAT simulation, including rounding."""

import sys
from pathlib import Path

import pytest
import torch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "training"))
from quantize import Calibration, IntegerConv, IntegerPrediction, IntegerMerge, QuantizedMerge, QuantizedTrainingConv, fold, prepare, integer_model, integer_threshold, resume_qat, verify
from train import augment_batch, restore
from threshold import select_threshold


@pytest.mark.parametrize("dilation", [1, 2, 4])
@pytest.mark.parametrize("relu", [False, True])
@pytest.mark.parametrize("bits", [4, 6, 8])
@pytest.mark.parametrize("weight_bits", [6, 8])
def test_integer_conv_matches_simulation(dilation, relu, bits, weight_bits):
    torch.manual_seed(42)
    conv = torch.nn.Conv2d(3, 5, 3, padding=dilation, dilation=dilation)
    qat = QuantizedTrainingConv(conv, 1 / 255, 0.01, relu, 24, bits, weight_bits)
    inputs = torch.randint(0, 256, (2, 3, 9, 11), dtype=torch.uint8)
    simulated = qat(inputs.float() / 255)
    actual = IntegerConv(qat)(inputs)
    expected = torch.round(simulated / qat.output_scale).to(actual.dtype)
    assert torch.equal(actual, expected)
    assert int(actual.min()) >= qat.low and int(actual.max()) <= qat.high
    assert int(IntegerConv(qat).weight.abs().max()) <= (1 << (weight_bits-1))-1
    simulated.mean().backward()
    assert torch.isfinite(qat.weight.grad).all()


def test_rounding_negative_ties_and_saturation():
    conv = torch.nn.Conv2d(1, 1, 1)
    with torch.no_grad():
        conv.weight.fill_(-1)
        conv.bias.zero_()
    qat = QuantizedTrainingConv(conv, 1, 2, False, 24)
    integer = IntegerConv(qat)
    integer.weight.fill_(-1)
    integer.multiplier.fill_(1 << 23)
    actual = integer(torch.tensor([[[[1, 2, 3, 4, 255]]]], dtype=torch.uint8))
    assert actual.flatten().tolist() == [0, -1, -1, -2, -127]


def test_batch_norm_folding_preserves_eval():
    torch.manual_seed(12)
    model = torch.nn.Sequential(torch.nn.Conv2d(2, 3, 3, padding=1),
                                torch.nn.BatchNorm2d(3), torch.nn.ReLU()).eval()
    inputs = torch.randn(2, 2, 8, 11)
    assert torch.allclose(model(inputs), fold(model)(inputs), atol=1e-6)


def test_export_roundtrip_has_only_integer_tensors(tmp_path):
    conv = torch.nn.Conv2d(2, 3, 3, padding=2, dilation=2)
    model = IntegerPrediction([IntegerConv(QuantizedTrainingConv(conv, 1 / 255, 0.02, True, 24))])
    inputs = torch.randint(0, 256, (1, 2, 8, 11), dtype=torch.uint8)
    program = torch.export.export(model, (inputs,), strict=True)
    torch.export.save(program, tmp_path / "model.pt2")
    loaded = torch.export.load(tmp_path / "model.pt2").module()
    assert torch.equal(model(inputs), loaded(inputs))
    assert all(not value.is_floating_point() for value in program.state_dict.values())
    assert all(not isinstance(value := node.meta.get("val"), torch.Tensor) or not value.is_floating_point()
               for node in program.graph.nodes)


@pytest.mark.parametrize("scale_axis", ["tensor", "channel"])
def test_residual_concat_quantization_and_export(scale_axis):
    class Residual(torch.nn.Module):
        def __init__(self):
            super().__init__()
            self.input = torch.nn.Conv2d(1, 4, 3, padding=1)
            self.normalization = torch.nn.BatchNorm2d(4)
            self.hidden = torch.nn.Conv2d(4, 4, 3, padding=1)
            self.output = torch.nn.Conv2d(8, 1, 1)

        def forward(self, image):
            encoded = torch.relu(self.normalization(self.input(image)))
            residual = torch.relu(self.hidden(encoded) + encoded)
            return self.output(torch.cat((encoded, residual), dim=1))

    torch.manual_seed(7)
    model = torch.fx.symbolic_trace(Residual()).eval()
    images = torch.randint(0, 256, (3, 1, 8, 10), dtype=torch.uint8)
    qat = prepare(model, images, [0, 1, 2], 1, 24, scale_axis=scale_axis)
    integer = integer_model(qat)
    verify(qat, integer, images, [0, 1, 2], 1)
    program = torch.export.export(integer, (images[:1],), strict=True)
    assert torch.equal(program.module()(images[:1]), integer(images[:1]))


@pytest.mark.parametrize("operation", ["add", "cat"])
@pytest.mark.parametrize("relu", [False, True])
@pytest.mark.parametrize("bits", [4, 6, 8])
def test_merge_scale_alignment(operation, relu, bits):
    torch.manual_seed(19)
    inputs = [torch.randint(-128, 128, (2, 3, 7, 9), dtype=torch.int8) for _ in range(2)]
    qat = QuantizedMerge(operation, [0.03, 0.07], 0.02, relu, 24, bits=bits)
    floating = [value.float() * scale for value, scale in zip(inputs, qat.input_scales)]
    expected = qat(floating) if operation == "cat" else qat(*floating)
    integer = IntegerMerge(qat)
    actual = integer(inputs) if operation == "cat" else integer(*inputs)
    assert torch.equal(torch.round(expected / qat.output_scale).to(actual.dtype), actual)
    assert int(actual.min()) >= qat.low and int(actual.max()) <= qat.high


def test_declared_activation_precision_survives_export(tmp_path):
    model = torch.nn.Sequential(torch.nn.Conv2d(1, 3, 1), torch.nn.ReLU(), torch.nn.Conv2d(3, 1, 1)).eval()
    images = torch.randint(0, 256, (2, 1, 3, 5), dtype=torch.uint8)
    qat = prepare(model, images, [0, 1], 1, 24, unsigned_bits=6, signed_bits=4)
    assert (qat[0].low, qat[0].high) == (0, 63)
    assert (qat[1].low, qat[1].high) == (-8, 7)
    integer = integer_model(qat)
    verify(qat, integer, images, [0, 1], 1)
    program = torch.export.export(integer, (images[:1],), strict=True)
    torch.export.save(program, tmp_path / "model.pt2")
    loaded = torch.export.load(tmp_path / "model.pt2")
    clamps = [tuple(node.args[1:]) for node in loaded.graph.nodes if node.target == torch.ops.aten.clamp.default]
    assert clamps == [(0, 63), (-8, 7)]
    assert torch.equal(loaded.module()(images[:1]), integer(images[:1]))


def test_training_quantile_calibration_bounds_outliers():
    calibration = Calibration(0.99)
    values = torch.cat((torch.ones(999), torch.tensor([100.])))
    calibration.observe("hidden", values)
    calibration.observe("zero", torch.zeros(3))
    calibration.histogram_mode = True
    calibration.observe("hidden", values)
    calibration.observe("zero", torch.zeros(3))
    assert 1 <= calibration.limits()["hidden"] < 1.05
    assert calibration.limits()["zero"] == 0


def test_quantile_prepare_preserves_integer_reference():
    model = torch.nn.Sequential(torch.nn.Conv2d(1, 2, 1), torch.nn.ReLU(), torch.nn.Conv2d(2, 1, 1)).eval()
    images = torch.randint(0, 256, (2, 1, 8, 9), dtype=torch.uint8)
    qat = prepare(model, images, [0, 1], 1, 24, unsigned_bits=4, quantile=0.99)
    verify(qat, integer_model(qat), images, [0, 1], 1)


def test_qat_continuation_preserves_scales_and_rejects_semantic_changes():
    images = torch.randint(0, 256, (2, 1, 3, 5), dtype=torch.uint8)
    config = {"layers": [{"channels": 2}], "seed": 9}
    source = prepare(torch.nn.Sequential(torch.nn.Conv2d(1, 2, 1)), images, [0, 1], 1, 16)
    target = prepare(torch.nn.Sequential(torch.nn.Conv2d(1, 2, 1)), images, [0, 1], 1, 16)
    checkpoint = {"config": config, "shift": 16, "state": source.state_dict()}
    resume_qat(target, checkpoint, {**config, "seed": 12, "unsigned_activation_bits": 8}, 16)
    assert all(torch.equal(value, target.state_dict()[name]) for name, value in source.state_dict().items())
    assert torch.equal(integer_model(source)(images), integer_model(target)(images))
    for changed, shift in (({**config, "signed_activation_bits": 4}, 16),
                           ({**config, "activation_scale_axis": "channel"}, 16),
                           ({**config, "layers": [{"channels": 3}]}, 16), (config, 24)):
        with pytest.raises(ValueError, match="same graph, data and quantization contract"):
            resume_qat(target, checkpoint, changed, shift)


def test_explicit_weight_precision_initialization_preserves_learned_state():
    images = torch.randint(0, 256, (2, 1, 3, 5), dtype=torch.uint8)
    floating = torch.nn.Sequential(torch.nn.Conv2d(1, 2, 1), torch.nn.ReLU(), torch.nn.Conv2d(2, 1, 1)).eval()
    config = {"layers": [{"channels": 2}, {"channels": 1}]}
    source = prepare(floating, images, [0, 1], 1, 16)
    precision = {"0": 6}
    target = prepare(floating, images, [0, 1], 1, 16, weight_bits=precision)
    checkpoint = {"config": config, "shift": 16, "state": source.state_dict()}
    changed = {**config, "weight_bits": precision}
    with pytest.raises(ValueError, match="same graph, data and quantization contract"):
        resume_qat(target, checkpoint, changed, 16)
    resume_qat(target, checkpoint, changed, 16, initialize_precision=True)
    assert all(torch.equal(value, target.state_dict()[name]) for name, value in source.state_dict().items())
    assert (target[0].weight_high, target[1].weight_high) == (31, 127)
    verify(target, integer_model(target), images, [0, 1], 1)
    with pytest.raises(ValueError, match="same graph, data and quantization contract"):
        resume_qat(target, checkpoint, {**changed, "unsigned_activation_bits": 4}, 16, initialize_precision=True)


@pytest.mark.parametrize("relu", [False, True])
def test_prediction_threshold_preserves_every_representable_score(relu):
    layer = QuantizedTrainingConv(torch.nn.Conv2d(1, 1, 1), 1/255, 0.017, relu, 16, bits=6)
    model = torch.nn.Sequential(layer)
    codes = torch.arange(layer.low, layer.high+1)
    scores = codes.float()*layer.output_scale
    thresholds = [float(torch.nextafter(scores[0], scores.new_tensor(float('-inf')))),
                  *scores.tolist(), float(scores[-1]+1)]
    for threshold in thresholds:
        assert torch.equal(scores > threshold, codes > integer_threshold(model, threshold))


@pytest.mark.parametrize("dtype", [torch.int8, torch.uint8])
def test_extreme_prediction_thresholds_do_not_wrap_byte_scalars(dtype):
    limits = torch.iinfo(dtype)
    values = torch.arange(limits.min, limits.max+1).to(dtype)
    for threshold in (limits.min-1, limits.max+1):
        model = IntegerPrediction(torch.nn.Identity(), threshold)
        expected = (values.to(torch.int64) > threshold).to(torch.uint8)
        assert torch.equal(model(values), expected)
        exported = torch.export.export(model, (values,), strict=True)
        assert torch.equal(exported.module()(values), expected)


def test_grouped_biasless_conv_matches_simulation():
    conv = torch.nn.Conv2d(3, 6, 3, padding=1, groups=3, bias=False)
    qat = QuantizedTrainingConv(conv, 1 / 255, 0.02, False, 24)
    inputs = torch.randint(0, 256, (2, 3, 8, 10), dtype=torch.uint8)
    actual = IntegerConv(qat)(inputs)
    assert torch.equal(torch.round(qat(inputs.float() / 255) / qat.output_scale).to(torch.int8), actual)


def test_unrepresentable_bias_is_rejected():
    conv = torch.nn.Conv2d(1, 1, 1)
    with torch.no_grad():
        conv.weight.zero_()
        conv.bias.fill_(1e6)
    qat = QuantizedTrainingConv(conv, 1 / 255, 0.02, False, 24)
    with pytest.raises(ValueError, match="bias does not fit INT32"):
        IntegerConv(qat)


def test_augmentation_respects_spatial_axes(monkeypatch):
    monkeypatch.setattr(torch, "rand", lambda *args, **kwargs: torch.tensor(0.0))
    image = torch.arange(30).reshape(1, 1, 6, 5)
    mask = torch.arange(6).reshape(1, 1, 3, 2)
    teacher = mask.float()
    result = augment_batch(image, mask, teacher, {"augmentation_axes": [-2]})
    for actual, original in zip(result, (image, mask, teacher)):
        assert torch.equal(actual, original.flip(-2))
    result = augment_batch(image, mask, teacher, {"augment": False})
    assert all(torch.equal(actual, original) for actual, original in zip(result, (image, mask, teacher)))


def test_checkpoint_feature_expansion_preserves_function():
    original = torch.nn.Sequential(torch.nn.Conv2d(2, 3, 3, padding=1), torch.nn.ReLU(), torch.nn.Conv2d(3, 1, 1))
    widened = torch.nn.Sequential(torch.nn.Conv2d(2, 6, 3, padding=1), torch.nn.ReLU(), torch.nn.Conv2d(6, 1, 1))
    config = {"resume_expansions": {
        "0.weight": {"repeat": [2, 1, 1, 1]}, "0.bias": {"repeat": [2]},
        "2.weight": {"repeat": [1, 2, 1, 1], "scale": 0.5}}}
    restore(widened, original.state_dict(), config)
    inputs = torch.randn(2, 2, 9, 11)
    assert torch.allclose(original(inputs), widened(inputs), atol=1e-6)
    state = {name: value.clone() for name, value in widened.state_dict().items()}
    restore(widened, state, config)
    assert all(torch.equal(value, state[name]) for name, value in widened.state_dict().items())


def test_checkpoint_nonuniform_feature_expansion():
    original = torch.nn.Sequential(torch.nn.Conv2d(2, 3, 1), torch.nn.ReLU(), torch.nn.Conv2d(3, 1, 1))
    widened = torch.nn.Sequential(torch.nn.Conv2d(2, 5, 1), torch.nn.ReLU(), torch.nn.Conv2d(5, 1, 1))
    selection = [0, 1, 2, 0, 1]
    config = {"resume_expansions": {
        "0.weight": {"axes": [{"axis": 0, "indices": selection}]},
        "0.bias": {"axes": [{"axis": 0, "indices": selection}]},
        "2.weight": {"axes": [{"axis": 1, "indices": selection, "divide_repeats": True}]}}}
    restore(widened, original.state_dict(), config)
    inputs = torch.randn(2, 2, 7, 9)
    assert torch.allclose(original(inputs), widened(inputs), atol=1e-6)


@pytest.mark.parametrize("labels", [[False, False, True, True], [True, False, True, True]])
def test_threshold_selection_handles_ties_and_all_positive_predictions(labels):
    scores = torch.tensor([0., 0., 1., 2.])
    target = torch.tensor(labels)
    threshold = select_threshold(scores, target)
    def dice(value):
        prediction = scores > value
        return float(2 * (prediction & target).sum() / (prediction.sum() + target.sum()))
    assert dice(threshold) == max(dice(value) for value in [-1., 0., 0.5, 1., 1.5, 2., 3.])


@pytest.mark.parametrize("groups", [1, 2, 4])
@pytest.mark.parametrize("relu", [False, True])
@pytest.mark.parametrize("bits", [4, 8])
def test_channel_scales_fold_into_grouped_integer_weights(groups, relu, bits):
    from quantize import channel_scale
    torch.manual_seed(73)
    conv = torch.nn.Conv2d(4, 8, 3, padding=1, groups=groups)
    input_scale = torch.tensor([0.003, 0.02, 0.17, 0.009])
    output_scale = torch.linspace(0.02, 0.2, 8)
    qat = QuantizedTrainingConv(conv, input_scale, output_scale, relu, 24, bits)
    inputs = torch.randint(0, 256, (2, 4, 7, 9), dtype=torch.uint8)
    floating = inputs.float()*channel_scale(input_scale)
    folded, unit = qat.scaled_weight()
    assert unit == 1
    assert torch.allclose(torch.nn.functional.conv2d(inputs.float(), folded, qat.bias, padding=1, groups=groups),
                          conv(floating), atol=1e-5)
    simulated = qat(floating)
    actual = IntegerConv(qat)(inputs)
    assert torch.equal(torch.round(simulated/channel_scale(output_scale)).to(actual.dtype), actual)
    simulated.mean().backward()
    assert torch.isfinite(qat.weight.grad).all()


@pytest.mark.parametrize("operation", ["add", "cat"])
@pytest.mark.parametrize("relu", [False, True])
def test_channel_merge_preserves_ragged_concat_and_integer_export(operation, relu):
    from quantize import channel_scale
    channels = [2, 3] if operation == "cat" else [3, 3]
    scales = [torch.linspace(0.01, 0.05, count) for count in channels]
    output_scale = torch.linspace(0.03, 0.09, sum(channels) if operation == "cat" else channels[0])
    qat = QuantizedMerge(operation, scales, output_scale, relu, 24, bits=4)
    inputs = [torch.randint(-128, 128, (2, count, 3, 5), dtype=torch.int8) for count in channels]
    floating = [value.float()*channel_scale(scale) for value, scale in zip(inputs, scales)]
    simulated = qat(floating) if operation == "cat" else qat(*floating)
    integer = IntegerMerge(qat)
    arguments = (inputs,) if operation == "cat" else tuple(inputs)
    actual = integer(*arguments)
    assert torch.equal(torch.round(simulated/channel_scale(output_scale)).to(actual.dtype), actual)
    program = torch.export.export(integer, arguments, strict=True)
    assert torch.equal(program.module()(*arguments), actual)
    assert all(not value.is_floating_point() for value in program.state_dict.values())


def test_channel_quantiles_keep_small_and_zero_channels_separate():
    calibration = Calibration(0.99, "channel")
    values = torch.ones(1, 3, 1, 1000)
    values[:, 0, :, -1] = 100
    values[:, 1] = 0.25
    values[:, 2] = 0
    calibration.observe("hidden", values)
    calibration.histogram_mode = True
    calibration.observe("hidden", values)
    limits = calibration.limits()["hidden"]
    assert 1 <= limits[0] < 1.05
    assert limits[1] == 0.25 and limits[2] == 0


def test_unobserved_channel_scale_uses_a_finite_calibrated_fallback():
    from quantize import calibrated_scale
    assert torch.equal(calibrated_scale(torch.tensor([3.0, 0.25, 0.0]), True, 4),
                       torch.tensor([3.0, 0.25, 3.0])/15)
    assert torch.equal(calibrated_scale(torch.zeros(3), True, 4), torch.ones(3)/15)


def test_channel_quantized_branches_import_and_match_full_rtl(tmp_path):
    from torch2rtl.frontend import load
    from torch2rtl.graph import actors, evaluate, read
    from torch2rtl.network import edges, emit
    from rtl_check import pack, simulate

    class Branches(torch.nn.Module):
        def __init__(self):
            super().__init__()
            self.stem = torch.nn.Conv2d(2, 3, 3, padding=1)
            self.narrow = torch.nn.Conv2d(3, 2, 1)
            self.wide = torch.nn.Conv2d(3, 5, 3, padding=1)
            self.head = torch.nn.Conv2d(7, 1, 1)

        def forward(self, image):
            stem = torch.relu(self.stem(image))
            return self.head(torch.cat((torch.relu(self.narrow(stem)), torch.relu(self.wide(stem))), dim=1))

    torch.manual_seed(51)
    images = torch.randint(0, 256, (3, 2, 7, 9), dtype=torch.uint8)
    qat = prepare(torch.fx.symbolic_trace(Branches()).eval(), images, [0, 1], 1, 24,
                  unsigned_bits=4, quantile=0.99, scale_axis="channel")
    integer = integer_model(qat)
    verify(qat, integer, images, [0, 1, 2], 1)
    program = torch.export.export(integer.layers, (images[:1],), strict=True)
    path = tmp_path / "quantized.pt2"
    torch.export.save(program, path)
    _, module = load(path)
    graph = actors(read(module))
    assert "quantized_concat" in {value.operation for value in graph.values}
    lanes = 4
    output_lanes = {value.name: min(2, value.tensor.shape[1]) for value in graph.values
                    if value.operation == "quantized_convolution"}
    rtl = emit(graph, lanes, output_lanes, {name: 128 for name, *_ in edges(graph)})
    inputs, expected = [], []
    for image in images.split(1):
        reference = integer.layers(image)
        assert torch.equal(evaluate(graph, image), reference)
        inputs.extend(word for pixel in image.permute(0, 2, 3, 1).reshape(-1, 2) for word in pack(pixel, 8, lanes))
        expected.extend(word for pixel in reference.permute(0, 2, 3, 1).reshape(-1, 1) for word in pack(pixel, 8, lanes))
    simulate(tmp_path, rtl, 8*lanes, 8*lanes, inputs, expected, True)


def test_separable_checkpoint_quantizes_imports_and_matches_rtl(tmp_path):
    from train import factor_convolutions
    from torch2rtl.frontend import load
    from torch2rtl.graph import actors, evaluate, read
    from torch2rtl.network import edges, emit
    from rtl_check import pack, simulate

    torch.manual_seed(83)
    floating = torch.nn.Sequential(torch.nn.Conv2d(2, 4, 3, padding=1),
                                   torch.nn.BatchNorm2d(4), torch.nn.ReLU(),
                                   torch.nn.Conv2d(4, 2, 1)).eval()
    factored = factor_convolutions(floating, 2)
    images = torch.randint(0, 256, (3, 2, 5, 7), dtype=torch.uint8)
    qat = prepare(factored, images, [0, 1], 1, 16)
    integer = integer_model(qat)
    verify(qat, integer, images, [0, 1, 2], 1)
    path = tmp_path / "separable.pt2"
    torch.export.save(torch.export.export(integer.layers, (images[:1],), strict=True), path)
    _, module = load(path)
    graph = actors(read(module))
    convolutions = [value for value in graph.values if value.operation == "quantized_convolution"]
    assert any(value.args[6] == 2 for value in convolutions)
    output_lanes = {value.name: min(2, value.tensor.shape[1] // value.args[6]) for value in convolutions}
    rtl = emit(graph, 1, output_lanes, {name: 128 for name, *_ in edges(graph)})
    inputs, expected = [], []
    for image in images.split(1):
        reference = integer.layers(image)
        assert torch.equal(evaluate(graph, image), reference)
        inputs.extend(word for pixel in image.permute(0, 2, 3, 1).reshape(-1, 2) for word in pack(pixel, 8, 1))
        expected.extend(word for pixel in reference.permute(0, 2, 3, 1).reshape(-1, 2) for word in pack(pixel, 8, 1))
    simulate(tmp_path, rtl, 8, 8, inputs, expected, True)
