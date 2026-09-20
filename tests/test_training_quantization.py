"""Deployment arithmetic must match the QAT simulation, including rounding."""

import sys
from pathlib import Path

import pytest
import torch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "training"))
from quantize import Calibration, IntegerConv, IntegerPrediction, IntegerMerge, QuantizedMerge, QuantizedTrainingConv, fold, prepare, integer_model, verify
from train import augment_batch, restore
from threshold import select_threshold


@pytest.mark.parametrize("dilation", [1, 2, 4])
@pytest.mark.parametrize("relu", [False, True])
@pytest.mark.parametrize("bits", [4, 6, 8])
def test_integer_conv_matches_simulation(dilation, relu, bits):
    torch.manual_seed(42)
    conv = torch.nn.Conv2d(3, 5, 3, padding=dilation, dilation=dilation)
    qat = QuantizedTrainingConv(conv, 1 / 255, 0.01, relu, 24, bits)
    inputs = torch.randint(0, 256, (2, 3, 9, 11), dtype=torch.uint8)
    simulated = qat(inputs.float() / 255)
    actual = IntegerConv(qat)(inputs)
    expected = torch.round(simulated / qat.output_scale).to(actual.dtype)
    assert torch.equal(actual, expected)
    assert int(actual.min()) >= qat.low and int(actual.max()) <= qat.high
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


def test_residual_concat_quantization_and_export():
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
    qat = prepare(model, images, [0, 1, 2], 1, 24)
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
