import torch

from training.train import make_model


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
