import torch
import pytest

from training.train import make_model, loss_function


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
