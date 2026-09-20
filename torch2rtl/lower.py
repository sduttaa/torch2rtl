"""A deliberately small integer actor subset, read from verified torch-mlir IR."""

from dataclasses import dataclass
from math import prod
import re


@dataclass(frozen=True)
class Tensor:
    shape: tuple[int, ...]
    bits: int
    signed: bool

    @property
    def elements(self):
        return prod(self.shape)


@dataclass(frozen=True)
class Step:
    name: str
    operation: str
    args: tuple
    tensor: Tensor


@dataclass(frozen=True)
class Kernel:
    input: Tensor
    steps: tuple[Step, ...]
    mapped: str
    mapped_type: Tensor
    output: Tensor
    reduction: bool


def tensor_type(value):
    spelling = str(value.type)
    match = re.fullmatch(r"!torch.vtensor<\[([\d,]*)\],(si|ui|i)(\d+)>", spelling)
    if not match:
        raise ValueError(f"RTL subset requires a static integer tensor; got {spelling}")
    shape, kind, bits = match.groups()
    width = int(bits)
    if width not in (1, 8, 16, 32, 64):
        raise ValueError(f"Unsupported integer width: {width}")
    return Tensor(tuple(int(d) for d in shape.split(",") if d), width, kind == "si")


def integer_range(tensor):
    return (-(1 << (tensor.bits - 1)), (1 << (tensor.bits - 1)) - 1) if tensor.signed else (0, (1 << tensor.bits) - 1)


def step_range(operation, args, ranges, result):
    def bounds(arg):
        return ranges[arg] if isinstance(arg, str) else (int(arg), int(arg))
    low, high = bounds(args[0])
    if operation == "clamp":
        floor, ceiling = args[1:]
        if floor is not None:
            low, high = max(low, floor), max(high, floor)
        if ceiling is not None:
            low, high = min(low, ceiling), min(high, ceiling)
    elif operation in ("add", "sub", "mul"):
        other_low, other_high = bounds(args[1])
        scale = args[2] if len(args) == 3 else 1
        other_low, other_high = sorted((other_low * scale, other_high * scale))
        if operation == "add":
            low, high = low + other_low, high + other_high
        elif operation == "sub":
            low, high = low - other_high, high - other_low
        else:
            products = (low * other_low, low * other_high, high * other_low, high * other_high)
            low, high = min(products), max(products)
    floor, ceiling = integer_range(result)
    # An overflowing operation can wrap anywhere. Preserve the original-width
    # arithmetic; only narrow storage when the whole result interval is proven.
    return (low, high) if floor <= low <= high <= ceiling else (floor, ceiling)


def lower(module):
    functions = [op for op in module.body.operations if op.operation.name == "func.func"]
    if len(functions) != 1:
        raise ValueError("Exactly one exported inference function is required")
    block = functions[0].regions[0].blocks[0]
    if len(block.arguments) != 1:
        raise ValueError("The current RTL subset has one tensor input")
    data = tensor_type(block.arguments[0])
    if data.elements < 1 or (data.shape and data.shape[0] != 1):
        raise ValueError("Nonempty tensors with static batch size one are required")
    values = {block.arguments[0]: "input_value"}
    types = {"input_value": data}
    ranges = {"input_value": integer_range(data)}
    steps = []
    reduction = False
    mapped = "input_value"
    output = None
    returned = None
    binary = {"torch.aten.add.Scalar": "add", "torch.aten.add.Tensor": "add",
              "torch.aten.sub.Scalar": "sub", "torch.aten.sub.Tensor": "sub",
              "torch.aten.mul.Scalar": "mul", "torch.aten.mul.Tensor": "mul"}
    for op in block.operations:
        name = op.operation.name
        if name.startswith("torch.constant."):
            values[op.results[0]] = op.attributes["value"].value if "value" in op.attributes else None
            continue
        args = tuple(values[arg] for arg in op.operands)
        if name == "torch.prim.ListConstruct":
            values[op.results[0]] = args
            continue
        if name == "func.return":
            if len(args) != 1:
                raise ValueError("The current RTL subset has one tensor output")
            returned = args[0]
            continue
        if reduction:
            raise ValueError("The current RTL subset requires sum to be the final operation")
        result = tensor_type(op.results[0]) if op.results else None
        if name in ("torch.aten.sum", "torch.aten.sum.dim_IntList"):
            if name.endswith("dim_IntList"):
                axes = tuple(range(len(data.shape))) if args[1] is None else args[1]
                if axes and {a % len(data.shape) for a in axes} != set(range(len(data.shape))):
                    raise ValueError("The current sum actor reduces the complete tensor")
            if result.elements != 1:
                raise ValueError("The current sum actor produces one scalar")
            mapped, output, reduction = args[0], result, True
            values[op.results[0]] = "reduced"
            continue
        if result is None or result.elements != data.elements:
            raise ValueError(f"Unsupported shape change in {name}")
        operation = binary.get(name)
        if name == "torch.aten.to.dtype":
            operation, args = "cast", args[:1]
        elif name == "torch.aten.relu":
            operation, args = "clamp", (args[0], 0, None)
        elif name == "torch.aten.clamp":
            operation = "clamp"
        elif name in ("torch.aten.view", "torch.aten.reshape"):
            operation, args = "cast", args[:1]
        if operation is None:
            raise ValueError(f"No RTL actor for {name}; no CPU fallback is permitted")
        if result.bits == 1 and operation != "cast":
            raise ValueError("Boolean arithmetic needs an explicit logical actor")
        if any(isinstance(arg, float) for arg in args):
            raise ValueError("Floating-point scalar arithmetic needs an FP actor")
        if not isinstance(args[0], str) or args[0] not in types:
            raise ValueError(f"Unsupported tensor operand in {name}")
        if operation in ("add", "sub") and len(args) == 3 and type(args[2]) is not int:
            raise ValueError("Add/sub alpha must be a constant integer")
        step_name = f"value_{len(steps)}"
        steps.append(Step(step_name, operation, args, result))
        types[step_name] = result
        ranges[step_name] = step_range(operation, args, ranges, result)
        values[op.results[0]] = step_name
        mapped, output = step_name, result
    if returned != ("reduced" if reduction else mapped):
        raise ValueError("Unsupported return value or disconnected computation")
    mapped_type = types[mapped]
    if reduction:
        low, high = ranges[mapped]
        signed = low < 0
        bits = max(1, max(-low - 1, high).bit_length() + 1) if signed else max(1, high.bit_length())
        mapped_type = Tensor(mapped_type.shape, bits, signed)
    return Kernel(data, tuple(steps), mapped, mapped_type, output or data, reduction)
