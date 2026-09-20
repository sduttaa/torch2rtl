"""Import frozen exported programs using the upstream torch-mlir frontend."""

from pathlib import Path
from copy import deepcopy

import torch
from torch_mlir import fx


def load(path: str | Path):
    program = torch.export.load(path)
    if program.range_constraints:
        raise ValueError("Dynamic dimensions are not supported; export static shapes.")
    for spec in program.graph_signature.output_specs:
        if spec.kind.name != "USER_OUTPUT":
            raise ValueError(f"Frozen inference cannot mutate state: {spec.kind.name}")
    for node in program.graph.nodes:
        value = node.meta.get("val")
        if isinstance(value, torch.Tensor):
            if any(type(dim) is not int for dim in value.shape):
                raise ValueError(f"Symbolic shape at {node.name}")
    # Preserve structured operators; arbitrary decompositions can hide quantization
    # boundaries and introduce expensive broadcasts before hardware selection.
    # The frozen importer rewrites lifted constants in its ExportedProgram.
    # Preserve the user's graph for independent accounting and reference runs.
    module = fx.export_and_import(deepcopy(program), output_type="torch", decomposition_table={})
    if not module.operation.verify():
        raise ValueError("torch-mlir verification failed")
    return program, module
