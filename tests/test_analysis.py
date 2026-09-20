import torch

from torch2rtl.analysis import analyze


def test_broadcast_matrix_product_accounting():
    class Product(torch.nn.Module):
        def __init__(self):
            super().__init__()
            self.register_buffer("weight", torch.ones(4, 5, dtype=torch.int32))

        def forward(self, data):
            return data @ self.weight

    program = torch.export.export(Product(), (torch.ones(1, 3, 2, 4, dtype=torch.int32),))
    report = analyze(program, requested_fps=30)
    assert report["summary"]["direct_convolution_macs_per_inference"] == 0
    assert report["summary"]["direct_matrix_macs_per_inference"] == 120
    assert report["summary"]["direct_macs_per_second"] == 3600
