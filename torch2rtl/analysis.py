"""Shape-based workload accounting. These are diagnostics, not hardware costs."""

from collections import Counter
from math import prod

import torch


def tensor_info(value):
    return {
        "shape": list(value.shape),
        "dtype": str(value.dtype).removeprefix("torch."),
        "elements": value.numel(),
        "bytes": value.numel() * value.element_size(),
    }


def _depends(node, ancestor, memo):
    if node is ancestor:
        return True
    if node not in memo:
        memo[node] = any(_depends(arg, ancestor, memo) for arg in node.all_input_nodes)
    return memo[node]


def analyze(program, target=None, requested_fps=None):
    """Account actual graph dtypes and reduction barriers without model-name rules.

    A reduction used to normalize the tensor it reduces is a replay barrier.
    The retained byte count describes direct, single-pass actor execution. It is
    not a lower bound over arbitrary recomputation or lossless coding algorithms.
    """
    signatures = {spec.arg.name: spec for spec in program.graph_signature.input_specs}
    constants, inputs, reductions, convolutions = [], [], [], []
    ops = Counter()
    for node in program.graph.nodes:
        value = node.meta.get("val")
        if node.op == "placeholder":
            spec = signatures[node.name]
            if spec.kind.name == "USER_INPUT" and isinstance(value, torch.Tensor):
                inputs.append({"name": node.name, **tensor_info(value)})
            elif spec.kind.name in ("BUFFER", "PARAMETER", "CONSTANT_TENSOR"):
                actual = (program.state_dict if spec.kind.name != "CONSTANT_TENSOR"
                          else program.constants)[spec.target]
                if isinstance(actual, torch.Tensor):
                    constants.append({"name": spec.target, **tensor_info(actual)})
        if node.op != "call_function":
            continue
        op = str(node.target)
        ops[op] += 1
        if op in ("aten.conv2d.default", "aten.convolution.default"):
            data, weight = [arg.meta["val"] for arg in node.args[:2]]
            convolutions.append({
                "name": node.name, "input": tensor_info(data),
                "weight": tensor_info(weight), "output": tensor_info(value),
                "direct_macs": value.numel() * prod(weight.shape[1:]),
            })
        if op.startswith(("aten.amax.", "aten.amin.", "aten.sum.", "aten.mean.")):
            source = node.args[0]
            data = source.meta.get("val")
            if not isinstance(data, torch.Tensor):
                continue
            # A consumer of the source that also depends on its reduction needs
            # retained data. Do not traverse backward through unrelated tensors.
            joins = []
            for user in source.users:
                if user is not node and _depends(user, node, {}):
                    joins.append(user.name)
            reductions.append({
                "name": node.name, "operator": op, "input": tensor_info(data),
                "output": tensor_info(value), "replay_consumers": joins,
                "direct_replay_bytes": data.numel() * data.element_size() if joins else 0,
            })
    constant_bytes = sum(item["bytes"] for item in constants)
    largest_replay = max((item["direct_replay_bytes"] for item in reductions), default=0)
    macs = sum(item["direct_macs"] for item in convolutions)
    findings = []
    floating_convs = [c for c in convolutions if c["input"]["dtype"].startswith("float")]
    if floating_convs:
        findings.append({
            "code": "FLOATING_CONVOLUTION", "severity": "information",
            "message": f"{len(floating_convs)} convolutions operate on floating-point tensors. "
                       "Integer weight storage does not change those operation semantics.",
        })
    if largest_replay:
        findings.append({
            "code": "REDUCTION_REPLAY", "severity": "architecture_requirement",
            "message": "A tensor feeds both a reduction and an operation depending on that "
                       "reduction. Direct execution must retain or explicitly recompute it.",
            "largest_direct_replay_bytes": largest_replay,
        })
    memory_bytes = None
    if target is not None:
        memory_bytes = sum(target.get("fabric_memory_bits", {}).values()) // 8
        if not memory_bytes:
            raise ValueError("Target must supply positive fabric_memory_bits by memory kind")
        for code, needed in (("CONSTANT_STORAGE_EXCEEDS_FABRIC_MEMORY", constant_bytes),
                             ("DIRECT_REPLAY_EXCEEDS_FABRIC_MEMORY", largest_replay)):
            if needed > memory_bytes:
                findings.append({
                    "code": code, "severity": "architecture_blocker",
                    "required_bytes": needed, "available_bytes": memory_bytes,
                    "message": "Does not fit even before physical packing, replication, "
                               "other live tensors, and FIFO overhead. This rules out direct "
                               "stored-tensor execution, not every possible compression or "
                               "recomputation architecture.",
                })
    return {
        "inputs": inputs, "constants": constants, "operators": dict(sorted(ops.items())),
        "convolutions": convolutions, "reductions": reductions,
        "summary": {
            "constant_bytes": constant_bytes,
            "integer_constant_bytes": sum(c["bytes"] for c in constants
                                          if c["dtype"].startswith(("int", "uint"))),
            "largest_direct_replay_bytes": largest_replay,
            "direct_convolution_macs_per_inference": macs,
            "requested_fps": requested_fps,
            "direct_convolution_macs_per_second": macs * requested_fps if requested_fps else None,
            "fabric_memory_bytes": memory_bytes,
            "measured_fps": None,
        },
        "findings": findings,
        "limitations": [
            "MAC count assumes direct convolution; it is not an algorithm-independent bound.",
            "Constants use their exported storage dtype, without compression or deduplication.",
            "Replay sizes are per barrier, not summed; memory sharing needs a schedule.",
            "This analysis does not establish routing feasibility or achieved throughput.",
        ],
    }
