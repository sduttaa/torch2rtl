"""Integer dataflow read from verified torch-mlir, with explicit constant folding."""

from dataclasses import dataclass

import numpy as np
import torch

from .lower import Tensor, tensor_type
from .ranges import monotone_requantization


@dataclass(eq=False)
class Value:
    name: str
    operation: str
    args: tuple
    tensor: Tensor


@dataclass(frozen=True)
class Graph:
    input: Value
    output: Value
    values: tuple[Value, ...]


def references(argument):
    if isinstance(argument, Value):
        yield argument
    elif isinstance(argument, (tuple, list)):
        for child in argument:
            yield from references(child)


def mapped(argument, function):
    if isinstance(argument, Value):
        return function(argument)
    if isinstance(argument, (tuple, list)):
        return tuple(mapped(child, function) for child in argument)
    return argument


def reachable(output):
    result, visited = [], set()
    def visit(value):
        if value not in visited:
            visited.add(value)
            for parent in references(value.args):
                visit(parent)
            result.append(value)
    visit(output)
    return tuple(result)


def dtype(tensor):
    return torch.bool if tensor.bits == 1 else getattr(torch, ("int" if tensor.signed else "uint") + str(tensor.bits))


def operation(name, args, result_type):
    """ATen semantics for constant evaluation and independent lowering checks.

    Runtime calls to this reference are never emitted as a compiler fallback.
    """
    if name == "to.dtype":
        return args[0].to(dtype(result_type))
    if name == "view":
        # Value tensors have no observable storage alias/stride. Torch-mlir
        # removes copy operations around reshapes of permuted tensor values.
        return args[0].reshape(args[1])
    if name == "convolution":
        if not args[6] and result_type.signed and result_type.bits == 32:
            return integer_convolution(*args[:6], args[8])
        if not args[7]:
            args = (*args[:7], (0,) * len(args[3]), args[8])
    if name == "__interpolate.size_list_scale_list":
        return torch.nn.functional.interpolate(*args)
    operator, _, overload = name.partition(".")
    packet = getattr(torch.ops.aten, operator)
    function = getattr(packet, overload or "default")
    positional, keywords = [], {}
    for parameter, argument in zip(function._schema.arguments, args):
        if parameter.kwarg_only:
            keywords[parameter.name] = argument
        else:
            positional.append(argument)
    return function(*positional, **keywords)


def constant_argument(argument):
    if isinstance(argument, np.ndarray):
        return torch.from_numpy(argument.copy())
    if isinstance(argument, (list, tuple)):
        return tuple(constant_argument(child) for child in argument)
    return argument


def read(module):
    functions = [op for op in module.body.operations if op.operation.name == "func.func"]
    if len(functions) != 1 or len(functions[0].regions[0].blocks[0].arguments) != 1:
        raise ValueError("Exactly one inference function with one tensor input is required")
    block = functions[0].regions[0].blocks[0]
    source = Value("input", "input", (), tensor_type(block.arguments[0]))
    values = {block.arguments[0]: source}
    output = None
    for index, op in enumerate(block.operations):
        name = op.operation.name
        if name.startswith("torch.constant."):
            values[op.results[0]] = op.attributes["value"].value if "value" in op.attributes else None
            continue
        if name == "torch.vtensor.literal":
            tensor_type(op.results[0])
            array = np.array(op.attributes["value"], copy=True)
            if array.dtype == object:
                raise ValueError("Actor constants require frontend.import_program's inline integer attributes")
            values[op.results[0]] = array
            continue
        args = tuple(values[arg] for arg in op.operands)
        if name == "torch.prim.ListConstruct":
            values[op.results[0]] = args
            continue
        if name == "func.return":
            if len(args) != 1 or not isinstance(args[0], Value):
                raise ValueError("The actor graph requires one runtime tensor output")
            output = args[0]
            continue
        if not name.startswith("torch.aten.") or len(op.results) != 1:
            raise ValueError(f"Unsupported graph operation: {name}")
        name = name.removeprefix("torch.aten.")
        result_type = tensor_type(op.results[0])
        if not tuple(references(args)):
            folded = operation(name, constant_argument(args), result_type)
            if tuple(folded.shape) != result_type.shape or folded.dtype != dtype(result_type):
                raise ValueError(f"Constant evaluation type mismatch at {name}")
            values[op.results[0]] = folded.numpy().copy()
        else:
            values[op.results[0]] = Value(f"value_{index}", name, args, result_type)
    if output is None:
        raise ValueError("Inference function has no return")
    return Graph(source, output, reachable(output))


def replace(graph, replacements):
    cache = {}
    def visit(value):
        if value not in cache:
            selected = replacements.get(value, value)
            cache[value] = Value(selected.name, selected.operation, mapped(selected.args, visit), selected.tensor)
        return cache[value]
    output = visit(graph.output)
    return Graph(visit(graph.input), output, reachable(output))


def widening_source(value, bits):
    if value.operation == "to.dtype" and value.tensor.signed and value.tensor.bits == bits:
        parent = value.args[0]
        if parent.tensor.bits < bits or (parent.tensor.bits == bits and parent.tensor.signed):
            return parent
    return value


def channel_constant(value, channels):
    array = np.asarray(value)
    try:
        return np.broadcast_to(array, (1, channels, 1, 1)).reshape(channels).copy()
    except ValueError as error:
        raise ValueError("Expected a scalar or per-channel constant") from error


def window_convolutions(graph):
    """Recover convolution from a complete integer sliding-window matrix product.

    This recognizes axis/shape semantics, including sampled window coordinates.
    Partial windows, asymmetric padding and observable intermediate branches are
    retained unchanged. No tensor, layer or model names participate in matching.
    """
    users = {value: 0 for value in graph.values}
    for value in graph.values:
        for parent in references(value.args):
            users[parent] += 1
    replacements = {}
    for result in graph.values:
        last = result
        bias = None
        if result.operation == "add.Tensor" and result.args[2] == 1 and isinstance(result.args[1], np.ndarray):
            last, bias = result.args[:2]
        if last.operation != "permute" or tuple(last.args[1]) != (0, 3, 1, 2):
            continue
        matrix = last.args[0]
        if matrix.operation != "matmul" or not isinstance(matrix.args[1], np.ndarray) or matrix.args[1].ndim != 2:
            continue
        view, weight = matrix.args
        if view.operation != "view" or view.args[0].operation != "permute":
            continue
        permutation = view.args[0]
        if tuple(permutation.args[1]) != (0, 2, 3, 1, 4, 5):
            continue
        sampled = permutation.args[0]
        if len(sampled.tensor.shape) != 6:
            continue
        kh, kw = sampled.tensor.shape[-2:]
        parent, dilation = sampled, [1, 1]
        path = [last, matrix, view, permutation]
        valid = True
        while parent.operation == "slice.Tensor":
            original, axis, start, end, step = parent.args
            if axis not in (4, 5) or start != 0 or end < original.tensor.shape[axis] or step < 1:
                valid = False
                break
            dilation[axis-4] *= step
            path.append(parent)
            parent = original
        if not valid or parent.operation != "unfold" or parent.args[1] != 3:
            continue
        width_window = parent
        height_window = parent.args[0]
        if height_window.operation != "unfold" or height_window.args[1] != 2:
            continue
        if (height_window.args[2], width_window.args[2]) != ((kh-1)*dilation[0]+1, (kw-1)*dilation[1]+1):
            continue
        path.extend((width_window, height_window))
        source = height_window.args[0]
        padding = (0, 0)
        if source.operation == "constant_pad_nd":
            original, pads, fill = source.args
            if len(pads) != 4 or fill != 0 or pads[0] != pads[1] or pads[2] != pads[3] or min(pads) < 0:
                continue
            padding = (pads[2], pads[0])
            path.append(source)
            source = original
        if len(source.tensor.shape) != 4 or not source.tensor.signed or source.tensor.bits != 32:
            continue
        if any(not value.tensor.signed or value.tensor.bits != 32 for value in path):
            continue
        batch, channels, height, width = source.tensor.shape
        stride = (height_window.args[3], width_window.args[3])
        oh = (height + 2*padding[0] - (kh-1)*dilation[0]-1) // stride[0] + 1
        ow = (width + 2*padding[1] - (kw-1)*dilation[1]-1) // stride[1] + 1
        outputs = weight.shape[1]
        if weight.shape[0] != channels*kh*kw or view.tensor.shape != (batch, oh, ow, channels*kh*kw):
            continue
        if result.tensor.shape != (batch, outputs, oh, ow) or any(users[value] != 1 for value in path if value is not result):
            continue
        # When the product has a sole per-channel bias user, fuse at that user.
        if bias is None and users[last] == 1:
            following = [value for value in graph.values if last in tuple(references(value.args))]
            if following[0].operation == "add.Tensor" and isinstance(following[0].args[1], np.ndarray):
                continue
        try:
            bias = np.zeros(outputs, dtype=np.int32) if bias is None else channel_constant(bias, outputs)
        except ValueError:
            continue
        args = (source, weight.T.reshape(outputs, channels, kh, kw).copy(), bias, stride,
                padding, tuple(dilation), False, (0, 0), 1)
        replacements[result] = Value(result.name, "convolution", args, result.tensor)
    return replace(graph, replacements)


def integer_convolution(data, weight, bias, stride, padding, dilation, groups):
    """Exact CPU reference, also for dilated kernels absent from ATen's integer path."""
    if tuple(dilation) == (1, 1):
        return torch.nn.functional.conv2d(data, weight, bias, stride, padding, dilation, groups)
    kh, kw = weight.shape[-2:]
    dh, dw = dilation
    ph, pw = padding
    padded = torch.nn.functional.pad(data, (pw, pw, ph, ph))
    windows = padded.unfold(2, (kh-1)*dh+1, stride[0]).unfold(3, (kw-1)*dw+1, stride[1])
    windows = windows[..., ::dh, ::dw]
    pieces = []
    ci, co = data.shape[1] // groups, weight.shape[0] // groups
    for group in range(groups):
        patches = windows[:, group*ci:(group+1)*ci].permute(0, 2, 3, 1, 4, 5).flatten(3)
        products = patches @ weight[group*co:(group+1)*co].flatten(1).t()
        pieces.append(products.permute(0, 3, 1, 2))
    result = torch.cat(pieces, dim=1)
    return result if bias is None else result + bias[None, :, None, None]


def quantized_convolutions(graph):
    """Fuse single-use convolution, widening, multiply/add/shift/clamp/cast.

    Accumulation remains INT32, followed by the original signed INT64 operations.
    No rounding boundary is moved or removed. Branches from intermediate values
    prevent fusion; constants are obtained from the graph, never module names.
    """
    users = {value: [] for value in graph.values}
    for value in graph.values:
        for parent in references(value.args):
            users[parent].append(value)
    replacements = {}
    sequence = ("to.dtype", "mul.Tensor", "add.Scalar", "__rshift__.Scalar", "clamp", "to.dtype")
    for conv in graph.values:
        if conv.operation != "convolution" or not (conv.tensor.signed and conv.tensor.bits == 32):
            continue
        chain = [conv]
        for expected in sequence:
            following = users[chain[-1]]
            if len(following) != 1 or following[0].operation != expected:
                break
            chain.append(following[0])
        if len(chain) != len(sequence) + 1:
            continue
        _, wide, multiply, addition, shift, clamp, narrow = chain
        if any(value.args[0] is not parent for parent, value in zip(chain, chain[1:])):
            continue
        if any(not value.tensor.signed or value.tensor.bits != 64 for value in chain[1:-1]):
            continue
        if narrow.tensor.bits not in (8, 16) or narrow.tensor.shape != conv.tensor.shape:
            continue
        if not isinstance(multiply.args[1], np.ndarray) or any(isinstance(arg, Value) for arg in addition.args[1:]):
            continue
        if addition.args[2] != 1 or not 0 <= shift.args[1] < 64:
            continue
        data, weight, bias, stride, padding, dilation, transposed, output_padding, groups = conv.args
        if transposed or any(output_padding) or not isinstance(weight, np.ndarray):
            continue
        channels = conv.tensor.shape[1]
        if weight.ndim != 4 or len(stride) != 2 or len(padding) != 2 or len(dilation) != 2:
            continue
        if bias is None:
            bias = np.zeros(channels, dtype=np.int32)
        if not isinstance(bias, np.ndarray) or bias.shape != (channels,):
            continue
        multiplier = channel_constant(multiply.args[1], channels)
        lower, upper = clamp.args[1:]
        floor = -(1 << (narrow.tensor.bits - 1)) if narrow.tensor.signed else 0
        ceiling = (1 << (narrow.tensor.bits - int(narrow.tensor.signed))) - 1
        if lower is None or upper is None or not floor <= lower <= upper <= ceiling:
            continue
        args = (widening_source(data, 32), weight, bias, stride, padding, dilation, groups,
                multiplier, addition.args[1], shift.args[1], lower, upper)
        replacements[narrow] = Value(narrow.name, "quantized_convolution", args, narrow.tensor)
    return replace(graph, replacements)


def quantized_concatenations(graph):
    """Fuse channel concatenation with its explicit integer scale alignment."""
    users = {value: [] for value in graph.values}
    for value in graph.values:
        for parent in references(value.args):
            users[parent].append(value)
    replacements = {}
    for join in graph.values:
        if join.operation != "cat" or join.args[1] != 1 or len(join.tensor.shape) != 4:
            continue
        chain = [join]
        for operation_name in ("add.Scalar", "__rshift__.Scalar", "clamp", "to.dtype"):
            following = users[chain[-1]]
            if len(following) != 1 or following[0].operation != operation_name or following[0].args[0] is not chain[-1]:
                break
            chain.append(following[0])
        if len(chain) != 5 or any(not value.tensor.signed or value.tensor.bits != 64 for value in chain[:-1]):
            continue
        _, addition, shift, clamp, result = chain
        if result.tensor.bits != 8 or result.tensor.shape != join.tensor.shape or addition.args[2] != 1:
            continue
        offset, amount = addition.args[1], shift.args[1]
        low, high = clamp.args[1:]
        floor, ceiling = (-128, 127) if result.tensor.signed else (0, 255)
        if not isinstance(offset, int) or not isinstance(amount, int) or not 0 <= amount < 64:
            continue
        if low is None or high is None or not floor <= low <= high <= ceiling:
            continue
        inputs, multipliers = [], []
        for scaled in join.args[0]:
            if scaled.operation != "mul.Tensor" or len(users[scaled]) != 1 or not isinstance(scaled.args[1], np.ndarray):
                break
            wide = scaled.args[0]
            source = widening_source(wide, 64)
            if not scaled.tensor.signed or scaled.tensor.bits != 64 or source.tensor.bits != 8:
                break
            if wide is not source and len(users[wide]) != 1:
                break
            if len(source.tensor.shape) != 4 or source.tensor.shape[0::2] != join.tensor.shape[0::2] or source.tensor.shape[3] != join.tensor.shape[3]:
                break
            try:
                coefficient = channel_constant(scaled.args[1], source.tensor.shape[1])
            except ValueError:
                break
            inputs.append(source)
            multipliers.append(coefficient)
        if len(inputs) != len(join.args[0]) or sum(value.tensor.shape[1] for value in inputs) != join.tensor.shape[1]:
            continue
        replacements[result] = Value(result.name, "quantized_concat",
                                     (tuple(inputs), tuple(multipliers), offset, amount, low, high), result.tensor)
    return replace(graph, replacements)


def pooled_convolutions(graph):
    """Fuse a single-use convolution with a monotone, nonoverlapping max pool.

    Nonnegative rescaling, a nonwrapping INT64 result over the full INT32
    accumulator range, and an in-range clamp make rescaling monotone. Thus
    max(requantize(accumulators)) equals requantize(max(accumulators)), including
    convolutions whose INT32 accumulation wraps. Reject unproved cases.
    """
    users = {value: 0 for value in graph.values}
    for value in graph.values:
        for parent in references(value.args):
            users[parent] += 1
    replacements = {}
    for pool in graph.values:
        if pool.operation != "max_pool2d":
            continue
        conv, kernel, stride, padding, dilation, ceil_mode = pool.args
        if conv.operation != "quantized_convolution" or users[conv] != 1:
            continue
        if (len(kernel) != 2 or min(kernel) < 1 or tuple(stride or kernel) != tuple(kernel)
                or tuple(padding) != (0, 0) or tuple(dilation) != (1, 1) or ceil_mode):
            continue
        if conv.tensor.bits != 8 or (pool.tensor.bits, pool.tensor.signed) != (8, conv.tensor.signed):
            continue
        if not monotone_requantization(conv):
            continue
        expected = (*conv.tensor.shape[:2], *(size//extent for size, extent in zip(conv.tensor.shape[2:], kernel)))
        if pool.tensor.shape != expected or min(expected) < 1:
            continue
        replacements[pool] = Value(pool.name, "quantized_convolution_pool", (*conv.args, tuple(kernel)), pool.tensor)
    return replace(graph, replacements)


def actors(graph, fusions=()):
    if set(fusions) - {"convolution_pool"}:
        raise ValueError("Unknown optional fusion")
    result = byte_comparisons(quantized_concatenations(quantized_convolutions(window_convolutions(graph))))
    return pooled_convolutions(result) if "convolution_pool" in fusions else result


def byte_comparisons(graph):
    users = {value: 0 for value in graph.values}
    for value in graph.values:
        for parent in references(value.args):
            users[parent] += 1
    replacements = {}
    for result in graph.values:
        if result.operation != "to.dtype" or result.tensor.bits != 8:
            continue
        comparison = result.args[0]
        if comparison.operation not in ("gt.Scalar", "ge.Scalar", "lt.Scalar", "le.Scalar", "eq.Scalar", "ne.Scalar"):
            continue
        source, scalar = comparison.args
        if source.tensor.bits != 8 or users[comparison] != 1 or not isinstance(scalar, (int, float)):
            continue
        values = torch.arange(256, dtype=torch.int64).to(dtype(source.tensor))
        table = operation(comparison.operation, (values, scalar), comparison.tensor).to(torch.uint8).numpy()
        replacements[result] = Value(result.name, "byte_lookup", (source, table), result.tensor)
    return replace(graph, replacements)


def evaluate(graph, image, trace=None):
    """Development reference used to check graph transformations, not RTL."""
    values = {graph.input: image}
    for value in graph.values:
        if value is graph.input:
            continue
        args = constant_argument(mapped(value.args, lambda parent: values[parent]))
        if value.operation in ("quantized_convolution", "quantized_convolution_pool"):
            data, weight, bias, stride, padding, dilation, groups, multiplier, offset, shift, low, high = args[:12]
            accumulator = integer_convolution(data.to(torch.int32), weight, bias, stride, padding, dilation, groups)
            result = ((accumulator.to(torch.int64) * multiplier[None, :, None, None] + offset) >> shift).clamp(low, high).to(dtype(value.tensor))
            if value.operation == "quantized_convolution_pool":
                # Keep the unfused operation order as the independent reference.
                result = torch.nn.functional.max_pool2d(result, args[12])
        elif value.operation == "quantized_concat":
            inputs, multipliers, offset, shift, low, high = args
            scaled = torch.cat([data.to(torch.int64) * multiplier[None, :, None, None]
                                for data, multiplier in zip(inputs, multipliers)], dim=1)
            result = ((scaled + offset) >> shift).clamp(low, high).to(dtype(value.tensor))
        elif value.operation == "byte_lookup":
            data, table = args
            result = table[data.to(torch.int64) & 255].to(dtype(value.tensor))
        else:
            result = operation(value.operation, args, value.tensor)
        values[value] = result
        if trace is not None:
            trace[value.name] = result
    return values[graph.output]
