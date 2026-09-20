import torch
import pytest

from training.train import make_model, loss_function, factor_convolutions


def test_focal_bce_weights_hard_pixels_without_changing_positive_weight():
    # These logits give probabilities 3/4 and 1/4, in easy/hard pairs.
    logits = torch.tensor(
        [[[[1.0986122886681098, -1.0986122886681098, 1.0986122886681098, -1.0986122886681098]]]],
        dtype=torch.float64, requires_grad=True)
    target = torch.tensor([[[[1., 1., 0., 0.]]]], dtype=torch.float64)
    config = {"positive_weight": 3, "bce": 1, "dice": 0, "distillation": 0}
    expected_bce = torch.nn.functional.binary_cross_entropy_with_logits(
        logits, target, pos_weight=logits.new_tensor(3), reduction="none")
    ordinary = loss_function(logits, target, logits.detach(), config)
    torch.testing.assert_close(ordinary, expected_bce.mean(), rtol=0, atol=0)
    focal = loss_function(logits, target, logits.detach(), {**config, "focal_gamma": 2})
    torch.testing.assert_close(focal, (expected_bce * logits.new_tensor([1/16, 9/16, 9/16, 1/16])).mean())
    focal.backward()
    assert torch.isfinite(logits.grad).all()
    assert (logits.grad[target.bool()] < 0).all() and (logits.grad[~target.bool()] > 0).all()
    assert logits.grad[0, 0, 0, 1].abs() > logits.grad[0, 0, 0, 0].abs()


def test_focal_bce_is_finite_for_extreme_logits():
    logits = torch.tensor([[[[-1000., 1000., -1000., 1000.]]]], requires_grad=True)
    target = torch.tensor([[[[1., 0., 0., 1.]]]])
    config = {"positive_weight": 3, "bce": 1, "dice": 0, "distillation": 0, "focal_gamma": 2}
    loss = loss_function(logits, target, logits.detach(), config)
    torch.testing.assert_close(loss, torch.tensor(1000.))
    loss.backward()
    assert torch.isfinite(logits.grad).all()


@pytest.mark.parametrize("gamma", [-1, float("nan"), float("inf"), "2", True])
def test_invalid_focal_gamma(gamma):
    logits = torch.zeros(1, 1, 1, 1)
    config = {"positive_weight": 1, "bce": 1, "dice": 0, "distillation": 0, "focal_gamma": gamma}
    with pytest.raises(ValueError, match="Focal gamma"):
        loss_function(logits, logits, logits, config)


def test_factorization_starts_from_supplied_checkpoint(tmp_path):
    config = {"image_channels": [0, 1, 2], "graph_output": "output", "graph": [
        {"name": "output", "op": "conv", "inputs": ["image"], "channels": 4, "kernel": 3, "padding": 1}]}
    torch.manual_seed(47)
    source = make_model(config)
    # An exactly rank-two input-channel mixing matrix admits an exact factor.
    matrix = torch.randn(36, 2) @ torch.randn(2, 3)
    source.output.weight.data.copy_(matrix.reshape(4, 3, 3, 3).permute(0, 3, 1, 2))
    path = tmp_path / "initial.pt"
    torch.save({"state": source.state_dict()}, path)
    config.update(initial_checkpoint=str(path), input_rank=2)
    factored = make_model(config)
    image = torch.randn(2, 3, 9, 11)
    torch.testing.assert_close(factored(image), source(image), rtol=1e-4, atol=1e-5)
    assert factored.get_submodule("output.0").out_channels == 2
    assert factored.get_submodule("output.1").in_channels == 2


def test_batch_dice_aggregates_pixels_instead_of_weighting_each_image_equally():
    logits = torch.zeros(2, 1, 2, 2, requires_grad=True)
    target = torch.tensor([[[[1., 1.], [1., 1.]]], [[[0., 0.], [0., 0.]]]])
    config = {"positive_weight": 1, "bce": 0, "dice": 1, "distillation": 0}
    sample = loss_function(logits, target, logits.detach(), config)
    batch = loss_function(logits, target, logits.detach(), {**config, "dice_reduction": "batch"})
    torch.testing.assert_close(sample, torch.tensor(1-(5/7+1/3)/2))
    torch.testing.assert_close(batch, torch.tensor(1-5/9))
    batch.backward()
    assert torch.isfinite(logits.grad).all()
    assert (logits.grad[target.bool()] < 0).all() and (logits.grad[~target.bool()] > 0).all()
    with pytest.raises(ValueError, match="Dice reduction"):
        loss_function(logits, target, logits.detach(), {**config, "dice_reduction": "unknown"})


def test_graph_factorization_restores_weights_before_svd_and_honors_exclusions(tmp_path):
    config = {"image_channels": [0, 1, 2], "graph": [
        {"name": "spatial", "op": "conv", "inputs": ["image"], "channels": 6, "kernel": 3, "padding": 1},
        {"name": "retained", "op": "conv", "inputs": ["spatial"], "channels": 4, "kernel": 3, "padding": 1},
    ], "graph_output": "retained"}
    torch.manual_seed(17)
    source = make_model(config).eval()
    # Construct a known rank-two kernel for every input channel, so this tests
    # exact reconstructability rather than accepting an arbitrary SVD error.
    with torch.no_grad():
        for channel in range(3):
            source.spatial.weight[:, channel] = (torch.randn(6, 2) @ torch.randn(2, 9)).reshape(6, 3, 3)
    checkpoint = tmp_path / "source.pt"
    torch.save({"state": source.state_dict()}, checkpoint)
    options = {**config, "initial_checkpoint": str(checkpoint), "factor_rank": 2, "factor_exclude": ["retained"]}
    factored = make_model(options).eval()
    image = torch.randn(2, 3, 7, 9)
    torch.testing.assert_close(factored(image), source(image), rtol=1e-4, atol=1e-5)
    assert factored.get_submodule("spatial.0").groups == 3
    assert factored.get_submodule("spatial.0").out_channels == 6
    assert isinstance(factored.retained, torch.nn.Conv2d)
    torch.testing.assert_close(factored.retained.weight, source.retained.weight)
    with pytest.raises(ValueError, match="one convolution factorization"):
        make_model({**options, "input_rank": 1})
    with pytest.raises(ValueError, match="not found"):
        factor_convolutions(source, 2, ["absent"])
    with pytest.raises(ValueError, match="positive integer"):
        factor_convolutions(source, 0)
