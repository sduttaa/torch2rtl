import torch

from torch2rtl.analysis import analyze
from torch2rtl.frontend import load


class DynamicQuant(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.register_buffer("weight", torch.ones((2, 1, 3, 3), dtype=torch.int8))

    def forward(self, x):
        scale = (x.amax() / 255).clamp(min=1e-8)
        y = (x / scale).round().clamp(0, 255).to(torch.uint8).float() * scale
        return torch.nn.functional.conv2d(y, self.weight.float())


def test_import_preserves_reference_and_detects_real_dtypes(tmp_path):
    model = DynamicQuant()
    data = torch.rand(1, 1, 5, 7)
    path = tmp_path / "program.pt2"
    torch.export.save(torch.export.export(model, (data,)), path)
    program, module = load(path)
    assert module.operation.verify()
    torch.testing.assert_close(program.module()(data), model(data))
    report = analyze(program, {"fabric_memory_bits": {"ram": 64}}, 30)
    assert report["summary"]["constant_bytes"] == 18
    assert report["summary"]["largest_direct_replay_bytes"] == data.numel() * 4
    assert report["convolutions"][0]["input"]["dtype"] == "float32"
    assert report["summary"]["direct_convolution_macs_per_inference"] == 2 * 3 * 5 * 9
    assert {f["code"] for f in report["findings"]} >= {
        "CONSTANT_STORAGE_EXCEEDS_FABRIC_MEMORY", "FLOATING_CONVOLUTION",
        "DIRECT_REPLAY_EXCEEDS_FABRIC_MEMORY"}
