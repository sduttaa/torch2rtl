"""Conservative integer bounds proved from graph semantics, never sample data."""

from .lower import integer_range


def monotone_requantization(value):
    """Prove a convolution's INT32-to-byte rescaling is nondecreasing."""
    if value.tensor.bits != 8:
        return False
    coefficients, offset, shift, low, high = value.args[7:12]
    floor, ceiling = integer_range(value.tensor)
    return (floor <= low <= high <= ceiling and 0 <= shift < 64 and
            all(int(coefficient) >= 0 and -(1 << 63) <= -(1 << 31)*int(coefficient)+int(offset)
                <= ((1 << 31)-1)*int(coefficient)+int(offset) < 1 << 63 for coefficient in coefficients))


def bounds(value):
    cache = {}

    def visit(node):
        if node in cache:
            return cache[node]
        full = integer_range(node.tensor)
        result = full
        if node.operation in ("quantized_convolution", "quantized_convolution_pool", "quantized_concat"):
            low, high = node.args[-3:-1] if node.operation == "quantized_convolution_pool" else node.args[-2:]
            # The fused cast follows the clamp. Out-of-container bounds may
            # wrap, so retaining the entire destination range is necessary.
            if full[0] <= low <= high <= full[1]:
                result = int(low), int(high)
        elif node.operation == "__interpolate.size_list_scale_list":
            result = visit(node.args[0])
        elif node.operation == "max_pool2d" and not any(node.args[3]):
            # With padding and dilation, a window can contain no real sample.
            # Preserve the full type range there, including the padding value.
            result = visit(node.args[0])
        elif node.operation == "byte_lookup":
            source, table = node.args
            low, high = visit(source)
            values = [int(table[index & 255]) & 255 for index in range(low, high+1)]
            if node.tensor.signed:
                values = [item if item < 128 else item-256 for item in values]
            result = min(values), max(values)
        cache[node] = result
        return result

    return visit(value)


def storage_bits(value):
    low, high = bounds(value)
    if value.tensor.signed:
        return max(1, max(-low-1, high, 0).bit_length()+1)
    return max(1, high.bit_length())


def lane_cast(source, destination, lanes, source_bits, destination_bits, signed=False):
    """Static lane wiring; sign extension is explicit when expanding storage."""
    lines = []
    for lane in range(lanes):
        item = f"{source}[{lane*source_bits} +: {source_bits}]"
        if signed:
            item = f"$signed({item})"
        lines.append(f"assign {destination}[{lane*destination_bits} +: {destination_bits}] = {destination_bits}'({item});")
    return "\n".join(lines)
