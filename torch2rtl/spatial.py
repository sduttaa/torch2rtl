"""Spatial stream actors with geometry taken only from graph types and operands."""

from pathlib import Path

import torch

from .convolution import packed


def wrapped(module, parameters, bits, sources):
    assignments = ", ".join(f".{key}({value})" for key, value in parameters.items())
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [{bits-1}:0] in_data, input wire in_valid, output wire in_ready,
  output wire [{bits-1}:0] out_data, output wire out_valid, input wire out_ready
);
  {module} #({assignments}) actor (.*);
endmodule
"""
    root = Path(__file__).parent / "templates"
    return wrapper + "".join((root / name).read_text() for name in sources)


def emit_pool(actor, lanes, memory="auto"):
    if actor.operation != "max_pool2d":
        raise ValueError("Expected a max_pool2d actor")
    data, kernel, stride, padding, dilation, ceil_mode = actor.args
    if ceil_mode:
        raise ValueError("Pooling with ceil_mode is not implemented")
    if (data.tensor.bits, data.tensor.signed) != (actor.tensor.bits, actor.tensor.signed):
        raise ValueError("Pooling cannot change element types")
    if len(data.tensor.shape) != 4 or data.tensor.shape[0] != 1 or lanes < 1:
        raise ValueError("Pooling requires batch-one NCHW and positive vector width")
    if memory not in ("auto", "block", "distributed"):
        raise ValueError("Unknown memory mapping option")
    if not stride:
        stride = kernel
    _, channels, height, width = data.tensor.shape
    expected = (1, channels, *((size+2*pad-(extent-1)*dil-1)//step+1
        for size, pad, extent, dil, step in zip((height, width), padding, kernel, dilation, stride)))
    if actor.tensor.shape != expected:
        raise ValueError("Pooling result shape disagrees with its geometry")
    parameters = {"HEIGHT": height, "WIDTH": width, "CHANNELS": channels,
                  "KERNEL_H": kernel[0], "KERNEL_W": kernel[1], "STRIDE_H": stride[0], "STRIDE_W": stride[1],
                  "DILATION_H": dilation[0], "DILATION_W": dilation[1], "PAD_H": padding[0], "PAD_W": padding[1],
                  "LANES": lanes, "BITS": data.tensor.bits, "SIGNED": int(data.tensor.signed)}
    parameters["MEMORY_STYLE"] = f'"{memory}"'
    return wrapped("integer_max_pool", parameters, lanes*data.tensor.bits, ("pool.sv", "window.sv"))


def emit_resize(actor, lanes, memory="auto"):
    if actor.operation != "__interpolate.size_list_scale_list":
        raise ValueError("Expected a static interpolation actor")
    data, size, scale, mode, align_corners, recompute, antialias = actor.args
    if mode not in ("nearest", "nearest-exact") or align_corners is not None or antialias:
        raise ValueError("Only nearest and nearest-exact resampling are implemented")
    if len(data.tensor.shape) != 4 or data.tensor.shape[0] != 1 or lanes < 1:
        raise ValueError("Resampling requires batch-one NCHW and positive vector width")
    if (data.tensor.bits, data.tensor.signed) != (actor.tensor.bits, actor.tensor.signed):
        raise ValueError("Resampling cannot change element types")
    if memory not in ("auto", "block", "distributed"):
        raise ValueError("Unknown memory mapping option")
    _, channels, height, width = data.tensor.shape
    if actor.tensor.shape[:2] != (1, channels):
        raise ValueError("Resampling cannot change batch or channels")
    output_height, output_width = actor.tensor.shape[2:]
    maps = []
    for axis, (length, output_length) in enumerate(zip((height, width), (output_height, output_width))):
        # Evaluate coordinate selection once at compile time. Passing the
        # original scale retains ATen's distinction from an explicit size.
        coordinates = torch.arange(length, dtype=torch.float64).reshape(1, 1, length)
        indices = torch.nn.functional.interpolate(
            coordinates, size=None if size is None else (size[axis],),
            scale_factor=None if scale is None else (scale[axis],), mode=mode,
            recompute_scale_factor=recompute).to(torch.int64).flatten().tolist()
        if len(indices) != output_length or indices != sorted(indices) or min(indices) < 0 or max(indices) >= length:
            raise ValueError("Resampling coordinate map disagrees with its static type")
        maps.append(packed(indices, max(1, (length-1).bit_length())))
    parameters = {"HEIGHT": height, "WIDTH": width, "CHANNELS": channels,
                  "OUTPUT_HEIGHT": output_height, "OUTPUT_WIDTH": output_width,
                  "LANES": lanes, "BITS": data.tensor.bits, "MEMORY_STYLE": f'"{memory}"',
                  "ROW_INDICES": maps[0], "COLUMN_INDICES": maps[1]}
    return wrapped("integer_nearest", parameters, lanes*data.tensor.bits, ("resize.sv",))
