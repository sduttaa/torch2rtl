"""Periodic event contracts for the spatial RTL, independent of any solver.

Every stream word retains its own transfer event. There is no dense-burst
assumption or simulation-driven FIFO sizing in this translation.
"""

from dataclasses import dataclass, field
from math import ceil, prod

import torch

from .convolution import configuration
from .graph import references
from .network import edges
from .schedule import ChoiceDelay, Dependency, Fifo, Option, Problem


@dataclass(frozen=True)
class ActorConfig:
    output_lanes: int | None = None
    reduction_lanes: int | None = None
    line_layout: str = "parallel"
    resources: dict[str, int] = field(default_factory=dict)
    row_buffers: int = 1
    extra_rows: int | tuple[int, ...] = 0
    requantization: str = "auto"


@dataclass(frozen=True)
class FifoConfig:
    depth: int
    resources: dict[str, int] = field(default_factory=dict)


def words(tensor, lanes):
    return prod(tensor.shape[2:]) * ceil(tensor.shape[1] / lanes)


class Events:
    def __init__(self):
        self.names = []
        self.dependencies = []
        self.when = ()
        self.series_cache = {}
        self.alternatives = None

    def series(self, prefix, count):
        if prefix in self.series_cache:
            result = self.series_cache[prefix]
            if len(result) != count:
                raise ValueError("Alternative actor contracts disagree on event count")
            return result
        result = tuple(f"{prefix}.{index}" for index in range(count))
        self.names.extend(result)
        self.series_cache[prefix] = result
        return result

    def link(self, before, after, delay=0, frames=0):
        if self.alternatives is not None:
            key=(before,after,delay,frames)
            self.shared[key]=self.shared.get(key,0) | (1 << self.alternatives[self.when[0][1]])
            return
        self.dependencies.append(Dependency(before, after, delay, frames, self.when))

    def begin_options(self,choice,names):
        self.choice=choice
        self.alternatives={name:index for index,name in enumerate(names)}
        self.shared={}

    def end_options(self):
        complete=(1 << len(self.alternatives))-1
        grouped={}
        for (before,after,delay,frames),mask in self.shared.items():
            if mask == complete:
                self.dependencies.append(Dependency(before,after,delay,frames))
            else:
                values=grouped.setdefault((before,after,frames),{})
                for name,index in self.alternatives.items():
                    if mask & (1 << index):
                        values[name]=max(values.get(name,0),delay)
        delays={}
        for (before,after,frames),values in grouped.items():
            key=tuple(sorted(values.items()))
            selected_delay=delays.setdefault(key,ChoiceDelay(self.choice,key))
            self.dependencies.append(Dependency(before,after,selected_delay,frames))
        self.alternatives=None
        self.shared={}
        self.when=()

    def order(self, events, delay=1):
        for before, after in zip(events, events[1:]):
            self.link(before, after, delay)
        self.link(events[-1], events[0], delay, 1)
        self.period_bound(events[0], len(events)*delay)

    def period_bound(self, event, cycles):
        # Summing a complete one-frame dependency cycle cancels event offsets.
        # State the implied bound directly so presolve need not traverse every
        # word before learning it. This does not restrict the schedule family.
        self.implied(event, event, cycles, 1)

    def implied(self, before, after, delay, frames=0):
        """A redundant path summary; independently removable for model checks."""
        self.link(before, after, delay, frames)


def window(events, prefix, inputs, shape, lanes, kernel, stride, padding, dilation, releases, layout):
    _, channels, height, width = shape
    kh, kw = kernel
    sh, sw = stride
    ph, pw = padding
    dh, dw = dilation
    effective_h, effective_w = (kh-1)*dh+1, (kw-1)*dw+1
    channel_words = ceil(channels / lanes)
    packed = layout == "packed" and effective_h > 1
    issues, columns, readiness, completed = [], [], [], []
    real_word = 0
    for y in range(height + 2*ph):
        for x in range(width + 2*pw):
            column_padding = not pw <= x < pw+width
            is_padding = column_padding or not ph <= y < ph+height
            output = (y >= effective_h-1 and x >= effective_w-1 and
                      (y-effective_h+1) % sh == 0 and (x-effective_w+1) % sw == 0)
            for channel in range(channel_words):
                if is_padding:
                    event = events.series(f"{prefix}.pad{len(issues)}", 1)[0]
                else:
                    event = inputs[real_word]
                    real_word += 1
                issues.append(event)
                columns.append(column_padding)
                readiness.append(effective_h if packed and not column_padding else 2)
                if output and channel == channel_words-1:
                    completed.append(len(issues)-1)
    if real_word != len(inputs) or len(completed) != len(releases):
        raise ValueError("Window geometry disagrees with actor streams")
    cumulative = [0]
    for index, event in enumerate(issues):
        following = (index+1) % len(issues)
        if packed:
            delay = readiness[index]
        else:
            delay = 2 if width*channel_words == 1 and not columns[index] and not columns[following] else 1
        events.link(event, issues[following], delay, int(following == 0))
        cumulative.append(cumulative[-1]+delay)
    events.period_bound(issues[0], cumulative[-1])
    for index, (release, release_delay) in zip(completed, releases):
        following = (index+1) % len(issues)
        events.link(release, issues[following], release_delay, int(following == 0))
    # Once a window is released, all issues up to the next completed window
    # form an ordered path. Summarize that path without restricting transfers.
    gaps = [cumulative[index] - cumulative[completed[position-1]+1] + readiness[index]
            + (cumulative[-1] if position == 0 else 0) for position, index in enumerate(completed)]
    return [(issues[index], readiness[index]) for index in completed], gaps


def convolution(events, prefix, value, inputs, outputs, lanes, config):
    view_value = value if value.operation == "quantized_view_convolution" else None
    if view_value is not None:
        from .fusion import materialized
        value = materialized(value)
    parameters = configuration(value, lanes, config.output_lanes, config.reduction_lanes, config.requantization)
    pixels = prod(value.tensor.shape[2:])
    output_words = ceil(value.tensor.shape[1] / lanes)
    blocks = parameters["GROUPS"] * ceil((parameters["OUTPUT_CHANNELS"] // parameters["GROUPS"]) / parameters["OUTPUT_LANES"])
    dot = parameters["KERNEL_H"]*parameters["KERNEL_W"]*ceil(
        (parameters["INPUT_CHANNELS"] // parameters["GROUPS"]) / parameters["REDUCTION_LANES"])
    requant = parameters["ACCUMULATOR_BYTES"]*ceil(parameters["MULTIPLIER_BYTES"] / parameters["REDUCTION_LANES"])
    pool = (parameters["POOL_H"], parameters["POOL_W"])
    reduction_stage = int(parameters["REDUCTION_LANES"] > 1)
    quantizer_cycles = parameters["THRESHOLD_BITS"]+1 if parameters.get("THRESHOLD_BITS") else requant+3
    tile_cycles = prod(pool)*(dot+2+reduction_stage) + quantizer_cycles + int(prod(pool) > 1)
    release_delay = prod(pool)*(dot+2) + (prod(pool)-1)*reduction_stage - 2
    starts = events.series(prefix+".start", pixels)
    posts = events.series(prefix+".post", pixels)
    # Only the first tile can wait for the previous output pixel. Subsequent
    # tile commits have fixed offsets from it, and window release is fixed
    # relative to the last tile's start. Eliminate those events exactly.
    releases = [(starts[pixel], release_delay) if blocks == 1 else (posts[pixel], (blocks-2)*tile_cycles+release_delay)
                for pixel in range(pixels)]
    data, weight, _, stride, padding, dilation, *_ = value.args
    kernel = weight.shape[2:]
    if prod(pool) > 1:
        kernel = tuple((size-1)*dil+1+(extent-1)*step for size, dil, extent, step in zip(kernel, dilation, pool, stride))
        stride = tuple(step*extent for step, extent in zip(stride, pool))
        dilation = (1, 1)
    if view_value is not None:
        view_window(events, prefix, view_value, inputs, starts, releases, lanes, config.extra_rows)
        events.period_bound(starts[0], pixels*(blocks*tile_cycles+1))
        ready, gaps = [], []
    else:
        ready, gaps = window(events, prefix, inputs, data.tensor.shape, lanes, kernel,
                       stride, padding, dilation, releases, config.line_layout)
    # Combine each compute path with the corresponding window-refill path.
    # Summing the longer implied path for every pixel gives a stronger cycle
    # bound than summing compute and window traffic separately.
    if blocks == 1:
        cycle_bound = sum(max(tile_cycles+1, release_delay+gap) for gap in gaps)
    else:
        cycle_bound = sum(tile_cycles + max((blocks-1)*tile_cycles+1,
                          (blocks-2)*tile_cycles+release_delay+gap) for gap in gaps)
    if gaps:
        events.period_bound(starts[0], cycle_bound)
    for pixel in range(pixels):
        if gaps:
            release, delay = releases[pixel-1]
            events.implied(release, starts[pixel], delay+gaps[pixel], int(pixel == 0))
            events.link(ready[pixel][0], starts[pixel], ready[pixel][1])
        events.link(starts[pixel], posts[pixel], tile_cycles)
        events.link(outputs[(pixel*output_words-1) % len(outputs)], posts[pixel], frames=int(pixel == 0))
        events.link(posts[pixel], starts[(pixel+1) % pixels], (blocks-1)*tile_cycles+1, int(pixel == pixels-1))
        events.link(posts[pixel], outputs[pixel*output_words], (blocks-1)*tile_cycles+1)
        for word in range(pixel*output_words+1, (pixel+1)*output_words):
            events.link(outputs[word-1], outputs[word], 1)


def view_window(events, prefix, value, inputs, starts, releases, lanes, extra_rows):
    from .fusion import geometry
    height, width = value.tensor.shape[2:]
    advance = events.series(prefix+".advance", 1)[0]
    last, delay = releases[-1]
    events.link(last, advance, delay+1)
    events.link(advance, starts[0], 3, 1)
    for pixel in range(1, len(starts)):
        before, delay = releases[pixel-1]
        events.link(before, starts[pixel], delay+3)
    for stream, g in zip(inputs, geometry(value, lanes, extra_rows)):
        events.order(stream)
        events.link(stream[-1], advance, 1)
        if not g["rolling"]:
            events.link(advance, stream[0], 3, 1)
        elif g["limits"][0] > g["depth"]:
            frame,word=divmod(g["depth"],len(stream))
            events.link(advance,stream[word],4,frame+1)
        for row,base in enumerate(g["required_rows"]):
            for column,end in enumerate(g["required_columns"]):
                if g["valid_rows"][row] and g["valid_columns"][column]:
                    events.link(stream[base+end-1],starts[row*width+column],1)
        # Ordered writes need one dependency at each changed live-word limit.
        # A word retires only after the last window that may read its old row.
        for pixel in range(1, height*width):
            previous, following = g["limits"][pixel-1:pixel+1]
            if following > previous:
                before, delay = releases[pixel-1]
                frame,word=divmod(previous,len(stream))
                events.link(before, stream[word], delay+3,frame)
        final_limit=len(stream)+g["depth"] if g["rolling"] else len(stream)
        if g["limits"][-1] < final_limit:
            before, delay = releases[-1]
            frame,word=divmod(g["limits"][-1],len(stream))
            events.link(before, stream[word], delay+(3 if g["rolling"] else 1),frame)


def pool(events, prefix, value, inputs, outputs, lanes):
    data, kernel, stride, padding, dilation, ceil_mode = value.args
    if ceil_mode:
        raise ValueError("Pooling with ceil_mode is not implemented")
    stride = stride or kernel
    _, channels, height, width = data.tensor.shape
    channel_words = ceil(channels / lanes)
    commits = events.series(prefix+".commit", len(outputs))
    events.period_bound(commits[0], len(outputs))
    for index, (commit, output) in enumerate(zip(commits, outputs)):
        events.link(commit, output, 1)
        events.link(outputs[index-1], commit, frames=int(index == 0))
    if tuple(kernel) == tuple(stride) and tuple(padding) == (0, 0) and tuple(dilation) == (1, 1):
        events.order(inputs)
        index = 0
        for y in range(kernel[0]-1, height, kernel[0]):
            for x in range(kernel[1]-1, width, kernel[1]):
                for channel in range(channel_words):
                    last = (y*width+x)*channel_words+channel
                    events.link(inputs[last], commits[index], 1)
                    events.link(commits[index], inputs[(last+1) % len(inputs)], frames=int(last == len(inputs)-1))
                    index += 1
        if index != len(outputs):
            raise ValueError("Block-pool geometry disagrees with its output")
    else:
        pixels = len(outputs) // channel_words
        starts = events.series(prefix+".start", pixels)
        events.period_bound(starts[0], pixels*(channel_words*prod(kernel)+1))
        releases = commits[channel_words-1::channel_words]
        ready, gaps = window(events, prefix, inputs, data.tensor.shape, lanes, kernel, stride, padding, dilation,
                       [(event, 0) for event in releases], "parallel")
        events.period_bound(starts[0], pixels*channel_words*prod(kernel) + sum(max(1, gap) for gap in gaps))
        for pixel in range(pixels):
            events.implied(releases[pixel-1], starts[pixel], gaps[pixel], int(pixel == 0))
            events.link(ready[pixel][0], starts[pixel], ready[pixel][1])
            events.link(starts[pixel], commits[pixel*channel_words], prod(kernel))
            for word in range(pixel*channel_words+1, (pixel+1)*channel_words):
                events.link(commits[word-1], commits[word], prod(kernel))
            events.link(releases[pixel], starts[(pixel+1) % pixels], 1, int(pixel == pixels-1))


def resize(events, prefix, value, inputs, outputs, lanes, row_buffers=1):
    data, size, scale, mode, align_corners, recompute, antialias = value.args
    if mode not in ("nearest", "nearest-exact") or align_corners is not None or antialias:
        raise ValueError("Only nearest and nearest-exact resampling are implemented")
    if type(row_buffers) is not int or row_buffers < 1:
        raise ValueError("Row buffer count must be a positive integer")
    _, channels, height, width = data.tensor.shape
    channel_words = ceil(channels / lanes)
    output_height, output_width = value.tensor.shape[2:]
    rows = torch.nn.functional.interpolate(torch.arange(height, dtype=torch.float64).reshape(1, 1, height),
        size=None if size is None else (size[0],), scale_factor=None if scale is None else (scale[0],),
        mode=mode, recompute_scale_factor=recompute).to(torch.int64).flatten().tolist()
    if len(rows) != output_height:
        raise ValueError("Resampling map disagrees with its output shape")
    reads = events.series(prefix+".read", len(outputs))
    events.period_bound(reads[0], len(outputs))
    events.order(inputs)
    releases = {}
    for index, (read, output) in enumerate(zip(reads, outputs)):
        events.link(read, output, 1)
        events.link(outputs[index-1], read, frames=int(index == 0))
        source_row = rows[index // (output_width*channel_words)]
        events.link(inputs[(source_row+1)*width*channel_words-1], read, 1)
        if index == len(reads)-1 or rows[(index+1) // (output_width*channel_words)] != source_row:
            releases[source_row] = read
            if row_buffers == 1:
                following = (source_row+1)*width*channel_words
                events.link(read, inputs[following % len(inputs)], 1, int(following == len(inputs)))
    if row_buffers > 1:
        used = list(releases)
        for index, source_row in enumerate(used):
            frame, following = divmod(index+row_buffers, len(used))
            events.link(releases[source_row], inputs[used[following]*width*channel_words], 1, frame)


def concatenate(events, value, inputs, outputs, lanes):
    counts = [ceil(source.tensor.shape[1] / lanes) for source in references(value.args)]
    output_words = ceil(value.tensor.shape[1] / lanes)
    events.period_bound(outputs[0], prod(value.tensor.shape[2:])*(sum(counts)+output_words))
    for pixel in range(prod(value.tensor.shape[2:])):
        transfers = [event for stream, count in zip(inputs, counts) for event in stream[pixel*count:(pixel+1)*count]]
        for before, after in zip(transfers, transfers[1:]):
            events.link(before, after, 1)
        events.link(transfers[-1], outputs[pixel*output_words], 1)
        events.link(outputs[(pixel*output_words-1) % len(outputs)], transfers[0], 1, int(pixel == 0))
        for index in range(pixel*output_words+1, (pixel+1)*output_words):
            events.link(outputs[index-1], outputs[index], 1)


def problem(graph, lanes, actor_options, fifo_options, budgets, period_limit, offset_limit, resource_weights=None, fixed_resources=None):
    if lanes < 1 or any(value.tensor.bits != 8 or len(value.tensor.shape) != 4 or value.tensor.shape[0] != 1
                        or min(value.tensor.shape) < 1 for value in graph.values):
        raise ValueError("Spatial schedules require positive batch-one byte NCHW streams")
    if set(actor_options) != {value.name for value in graph.values if value is not graph.input}:
        raise ValueError("Supply an option catalogue for every actor")
    channels = edges(graph)
    if set(fifo_options) != {name for name, *_ in channels}:
        raise ValueError("Supply a FIFO option catalogue for every edge")
    events = Events()
    anchor = events.series("epoch", 1)[0]
    incoming, outgoing, choices, fifos = {}, {}, {}, []
    for value in graph.values:
        outgoing[value] = events.series(value.name+".out", words(value.tensor, lanes))
        incoming[value] = tuple(events.series(f"{value.name}.in{port}", words(source.tensor, lanes))
                                for port, source in enumerate(references(value.args)))
        if value is graph.input:
            events.order(outgoing[value])
            continue
        choice = "actor:"+value.name
        choices[choice] = tuple(Option(name, config.resources) for name, config in actor_options[value.name].items())
        events.begin_options(choice,actor_options[value.name])
        for name, config in actor_options[value.name].items():
            if config.line_layout not in ("parallel", "packed"):
                raise ValueError("Unknown line memory layout")
            events.when = ((choice, name),)
            # Exactly one alternative is active. Reuse its internal event
            # variables instead of multiplying event count by option count.
            prefix = f"{value.name}.actor"
            inputs, outputs = incoming[value], outgoing[value]
            if value.operation == "quantized_view_convolution":
                convolution(events, prefix, value, inputs, outputs, lanes, config)
            elif value.operation in ("quantized_convolution", "quantized_convolution_pool"):
                convolution(events, prefix, value, inputs[0], outputs, lanes, config)
            elif value.operation == "max_pool2d":
                pool(events, prefix, value, inputs[0], outputs, lanes)
            elif value.operation == "__interpolate.size_list_scale_list":
                resize(events, prefix, value, inputs[0], outputs, lanes, config.row_buffers)
            elif value.operation == "quantized_concat":
                concatenate(events, value, inputs, outputs, lanes)
            elif value.operation == "byte_lookup":
                events.period_bound(outputs[0], len(outputs))
                for index, (before, after) in enumerate(zip(inputs[0], outputs)):
                    events.link(before, after, 1)
                    events.link(outputs[index-1], before, frames=int(index == 0))
            else:
                raise ValueError(f"No spatial event contract for {value.operation}")
        events.end_options()
    for name, source, destination, port in channels:
        choice = "fifo:"+name
        options = fifo_options[name]
        choices[choice] = tuple(Option(key, config.resources) for key, config in options.items())
        fifos.append(Fifo(outgoing[source], incoming[destination][port], choice,
                          {key: config.depth for key, config in options.items()},
                          forward_delays={key: 1 if config.depth == 1 else 2 for key, config in options.items()},
                          replacement_delay=1, order_transfers=False))
    return Problem(tuple(events.names), choices, tuple(events.dependencies), tuple(fifos), budgets,
                   period_limit, offset_limit, anchor, fixed_resources=fixed_resources or {}, resource_weights=resource_weights or {})
