"""Import frozen exported programs using the upstream torch-mlir frontend."""

from pathlib import Path
from copy import deepcopy

import torch
import numpy as np
from torch_mlir import fx, ir
from torch_mlir.extras.fx_importer import FxImporterHooks, create_mlir_tensor_type


class IntegerLiterals(FxImporterHooks):
    def resolve_literal(self, importer, literal, info):
        if not isinstance(literal, torch.Tensor) or literal.is_floating_point() or literal.is_complex():
            return None
        # Upstream's resource attributes have no Python read-buffer API. Inline
        # integer attributes expose their typed data to the actor frontend.
        shaped = create_mlir_tensor_type(literal)
        array = np.array(literal.tolist(), dtype=str(literal.dtype).removeprefix("torch."))
        attribute = ir.DenseElementsAttr.get(array=array, type=shaped.element_type, shape=literal.shape)
        tensor = ir.Type.parse(f"!torch.vtensor<{list(literal.shape)},{shaped.element_type}>")
        return ir.Operation.create("torch.vtensor.literal", results=[tensor], attributes={"value": attribute}).result


def import_program(program):
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
    imported = deepcopy(program)
    for node in imported.graph.nodes:
        schema = getattr(node.target, "_schema", None)
        # Serialized exports store Tensor[] metadata as tuples, while the
        # torch-mlir importer expects a list. Follow the operator schema so
        # genuine multiple-return tuples retain their meaning.
        if (schema is not None and len(schema.returns) == 1
                and schema.returns[0].type.kind() == "ListType"
                and schema.returns[0].type.getElementType().kind() == "TensorType"
                and isinstance(node.meta.get("val"), tuple)):
            node.meta["val"] = list(node.meta["val"])
    module = fx.export_and_import(imported, output_type="torch", decomposition_table={}, hooks=IntegerLiterals())
    if not module.operation.verify():
        raise ValueError("torch-mlir verification failed")
    return module


def load(path: str | Path):
    program = torch.export.load(path)
    return program, import_program(program)
