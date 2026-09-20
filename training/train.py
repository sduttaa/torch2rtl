"""Train a small segmentation network from an explicit experiment description.

Dataset paths, architecture, preprocessing and deployment budgets are inputs.
This module is independent of the compiler and does not change its lowering rules.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import importlib.util
import json
import math
import random
import operator
import sys
import time
from pathlib import Path

import numpy as np
from PIL import Image
import torch
from torch import nn
from torch.nn import functional as F


def read_data(config):
    root = Path(config["dataset"])
    validation_names = set(json.loads(Path(config["split_report"]).read_text())["validation_filenames"])
    names = sorted(p.name for p in root.glob("*.png") if not p.stem.endswith(config["mask_suffix"]))
    missing = validation_names - set(names)
    if missing:
        raise ValueError(f"Validation images missing: {missing}")
    images, masks, hashes = [], [], {}
    for name in names:
        image = Image.open(root / name).convert("RGB")
        for size in config["image_resize"]:
            image = image.resize(tuple(size), Image.Resampling.BILINEAR)
        image = np.array(image, copy=True)[..., config["image_channels"]].transpose(2, 0, 1)
        mask_path = root / (Path(name).stem + config["mask_suffix"] + ".png")
        if mask_path.exists():
            mask = Image.open(mask_path).getchannel(config["mask_channel"])
            for size in config["mask_resize"]:
                mask = mask.resize(tuple(size), Image.Resampling.NEAREST)
            mask = np.array(mask, copy=True) > 0
        elif config["missing_mask_is_background"]:
            mask = np.zeros(tuple(reversed(config["mask_resize"][-1])), dtype=bool)
        else:
            raise FileNotFoundError(mask_path)
        images.append(torch.from_numpy(image.copy()))
        masks.append(torch.from_numpy(mask[None].copy()))
        hashes[name] = hashlib.sha256(image.tobytes() + mask.tobytes()).hexdigest()
    train = [i for i, name in enumerate(names) if name not in validation_names]
    validation = [i for i, name in enumerate(names) if name in validation_names]
    train_hashes = {hashes[names[i]] for i in train}
    duplicate_validation = [names[i] for i in validation if hashes[names[i]] in train_hashes]
    if duplicate_validation:
        raise ValueError(f"Exact train/validation duplicates: {duplicate_validation}")
    return torch.stack(images), torch.stack(masks), train, validation, {"names": names, "sha256": hashes}


def make_model(config):
    if "graph" in config:
        model = make_graph(config)
        if "initial_checkpoint" in config:
            restore(model, torch.load(config["initial_checkpoint"], weights_only=True)["state"], config)
        if "factor_rank" in config:
            if "input_rank" in config:
                raise ValueError("Choose one convolution factorization")
            return factor_convolutions(model, config["factor_rank"], config.get("factor_exclude", ()))
        return factor_inputs(model, config) if "input_rank" in config else model
    if "prune_channels" in config:
        model = prune_channels(load_teacher(config.get("initializer", config["teacher"])), config)
        if "input_rank" in config:
            return factor_inputs(model, config)
        return factor_convolutions(model, config["factor_rank"], config.get("factor_exclude", ())) if "factor_rank" in config else model
    layers = []
    channels = len(config["image_channels"])
    for spec in config["layers"]:
        if spec["op"] == "conv":
            layers.append(nn.Conv2d(channels, spec["channels"], spec["kernel"],
                                    padding=spec.get("padding", 0), stride=spec.get("stride", 1),
                                    dilation=spec.get("dilation", 1)))
            channels = spec["channels"]
            if spec.get("batch_norm", False):
                layers.append(nn.BatchNorm2d(channels))
            if spec.get("relu", False):
                layers.append(nn.ReLU())
        elif spec["op"] == "max_pool":
            layers.append(nn.MaxPool2d(spec["kernel"], spec["stride"]))
        else:
            raise ValueError(f"Unsupported layer: {spec}")
    return nn.Sequential(*layers)


def make_graph(config):
    """Build a static image network from explicit, named graph nodes."""
    root = nn.Module()
    graph = torch.fx.Graph()
    nodes = {"image": graph.placeholder("image")}
    channels = {"image": len(config["image_channels"])}
    for spec in config["graph"]:
        name, operation = spec["name"], spec["op"]
        inputs = spec["inputs"]
        arguments = [nodes[key] for key in inputs]
        if operation == "conv":
            layer = nn.Conv2d(channels[inputs[0]], spec["channels"], spec["kernel"],
                              stride=spec.get("stride", 1), padding=spec.get("padding", 0),
                              dilation=spec.get("dilation", 1))
            if spec.get("identity_init", False):
                nn.init.dirac_(layer.weight)
                nn.init.zeros_(layer.bias)
            root.add_module(name, layer)
            node = graph.call_module(name, (arguments[0],))
            channels[name] = spec["channels"]
            if spec.get("batch_norm", False):
                root.add_module(name + "_norm", nn.BatchNorm2d(spec["channels"]))
                node = graph.call_module(name + "_norm", (node,))
            if spec.get("relu", False):
                node = graph.call_function(F.relu, (node,))
        elif operation == "max_pool":
            node = graph.call_function(F.max_pool2d, (arguments[0], spec["kernel"], spec["stride"]))
            channels[name] = channels[inputs[0]]
        elif operation == "upsample":
            node = graph.call_function(F.interpolate, (arguments[0],), {"scale_factor": spec["scale"], "mode": "nearest"})
            channels[name] = channels[inputs[0]]
        elif operation == "cat":
            node = graph.call_function(torch.cat, (tuple(arguments),), {"dim": 1})
            channels[name] = sum(channels[key] for key in inputs)
        elif operation == "add":
            node = graph.call_function(operator.add, tuple(arguments))
            channels[name] = channels[inputs[0]]
            if spec.get("relu", False):
                node = graph.call_function(F.relu, (node,))
        else:
            raise ValueError(f"Unsupported graph operation: {operation}")
        nodes[name] = node
    graph.output(nodes[config["graph_output"]])
    return torch.fx.GraphModule(root, graph)


def prune_channels(model, config):
    """Prune channel groups consistently through residual adds and concatenation.

Requested widths are experiment inputs. Shared channel counts use a common
importance ranking; the FX graph propagates selections to each consumer.
    """
    class Tracer(torch.fx.Tracer):
        def is_leaf_module(self, module, name):
            return isinstance(module, nn.Conv2d) or super().is_leaf_module(module, name)

    graph = torch.fx.GraphModule(model, Tracer().trace(model))
    width, height = config["image_resize"][-1]
    from torch.fx.passes.shape_prop import ShapeProp
    ShapeProp(graph).propagate(torch.zeros(1, len(config["image_channels"]), height, width))
    scores = {}
    for module in graph.modules():
        if isinstance(module, nn.Conv2d):
            if module.groups != 1:
                raise ValueError("Channel pruning currently requires dense convolutions")
            importance = module.weight.detach().square().flatten(1).mean(1)
            scores[module.out_channels] = scores.get(module.out_channels, 0) + importance
    selections = {}
    for channels, importance in scores.items():
        keep = config["prune_channels"].get(str(channels), channels)
        if not 0 < keep <= channels:
            raise ValueError(f"Invalid retained width {keep} for {channels}")
        selections[channels] = importance.topk(keep).indices.sort().values
    indices = {}
    original_channels = {}
    for node in graph.graph.nodes:
        meta = node.meta.get("tensor_meta")
        if not meta or not hasattr(meta, "shape") or len(meta.shape) != 4:
            continue
        original_channels[node] = meta.shape[1]
        if node.op == "placeholder":
            indices[node] = torch.arange(meta.shape[1])
        elif node.op == "call_module" and isinstance(graph.get_submodule(node.target), nn.Conv2d):
            source = graph.get_submodule(node.target)
            selected_input = indices[node.args[0]]
            selected_output = selections[source.out_channels]
            retained = config.get("channel_overrides", {}).get(node.target)
            if retained is not None:
                if not 0 < retained <= source.out_channels:
                    raise ValueError(f"Invalid retained width for {node.target}: {retained}")
                selected_output = source.weight.detach().square().flatten(1).mean(1).topk(retained).indices.sort().values
            conv = nn.Conv2d(len(selected_input), len(selected_output), source.kernel_size,
                             stride=source.stride, padding=source.padding, dilation=source.dilation,
                             bias=source.bias is not None)
            with torch.no_grad():
                conv.weight.copy_(source.weight[selected_output][:, selected_input])
                if source.bias is not None:
                    conv.bias.copy_(source.bias[selected_output])
            graph.set_submodule(node.target, conv)
            indices[node] = selected_output
        elif node.op == "call_function" and node.target is torch.cat:
            if node.kwargs.get("dim", 0) != 1:
                raise ValueError("Pruning supports channel concatenation only")
            offset, parts = 0, []
            for argument in node.args[0]:
                parts.append(indices[argument] + offset)
                offset += original_channels[argument]
            indices[node] = torch.cat(parts)
        elif node.op == "call_function" and node.target in (operator.add, torch.add):
            if not torch.equal(indices[node.args[0]], indices[node.args[1]]):
                raise ValueError("Residual branches require matching retained channels")
            indices[node] = indices[node.args[0]]
        elif node.op == "call_function" and node.target is operator.getitem:
            selected = indices[node.args[0]][node.args[1][1]]
            if len(selected) != meta.shape[1]:
                raise ValueError("Channel slices across pruned features require an explicit rewrite")
            indices[node] = selected
        else:
            parents = [parent for parent in node.all_input_nodes if parent in indices]
            if not parents:
                continue
            if original_channels[parents[0]] != meta.shape[1]:
                raise ValueError(f"Unsupported channel-changing operation: {node.format_node()}")
            indices[node] = indices[parents[0]]
    return graph


def factor_convolutions(model, rank, exclude=()):
    """Initialize depthwise/pointwise factors with independent kernel SVDs."""
    if type(rank) is not int or rank < 1:
        raise ValueError("Convolution factor rank must be a positive integer")
    if set(exclude) - dict(model.named_modules()).keys():
        raise ValueError("Excluded convolution module was not found")
    for name, conv in list(model.named_modules()):
        if name in exclude or not isinstance(conv, nn.Conv2d) or conv.groups != 1 or conv.in_channels == 1:
            continue
        kh, kw = conv.kernel_size
        if min(conv.out_channels, kh * kw) <= rank:
            continue
        depthwise = nn.Conv2d(conv.in_channels, conv.in_channels * rank, conv.kernel_size,
                              stride=conv.stride, padding=conv.padding, dilation=conv.dilation,
                              groups=conv.in_channels, bias=False)
        pointwise = nn.Conv2d(conv.in_channels * rank, conv.out_channels, 1, bias=conv.bias is not None)
        with torch.no_grad():
            for channel in range(conv.in_channels):
                left, singular, right = torch.linalg.svd(conv.weight[:, channel].flatten(1), full_matrices=False)
                depthwise.weight[channel * rank:(channel + 1) * rank, 0].copy_(right[:rank].reshape(rank, kh, kw))
                pointwise.weight[:, channel * rank:(channel + 1) * rank, 0, 0].copy_(left[:, :rank] * singular[:rank])
            if conv.bias is not None:
                pointwise.bias.copy_(conv.bias)
        model.set_submodule(name, nn.Sequential(depthwise, pointwise))
    return torch.fx.symbolic_trace(model)


def factor_inputs(model, config):
    """Compress spatial-channel mixing while retaining nonlinear output widths."""
    statistics = torch.load(config["input_statistics"], weights_only=True)["moments"] if "input_statistics" in config else {}
    for name, conv in list(model.named_modules()):
        if not isinstance(conv, nn.Conv2d) or conv.groups != 1:
            continue
        rank = config.get("input_rank_by_channels", {}).get(str(conv.in_channels), config["input_rank"])
        kh, kw = conv.kernel_size
        if rank >= min(conv.in_channels, conv.out_channels * kh * kw):
            continue
        if rank * (conv.in_channels + conv.out_channels * kh * kw) >= conv.weight.numel():
            continue
        matrix = conv.weight.detach().permute(0, 2, 3, 1).reshape(-1, conv.in_channels).double()
        root = inverse = torch.eye(conv.in_channels, dtype=torch.float64)
        if name in statistics:
            moment = statistics[name].double()
            values, vectors = torch.linalg.eigh((moment + moment.t()) / 2)
            values = values.clamp_min(max(float(values.max()) * 1e-6, 1e-12))
            root = (vectors * values.sqrt()) @ vectors.t()
            inverse = (vectors * values.rsqrt()) @ vectors.t()
        left, singular, right = torch.linalg.svd(matrix @ root, full_matrices=False)
        projection = nn.Conv2d(conv.in_channels, rank, 1, bias=False)
        spatial = nn.Conv2d(rank, conv.out_channels, conv.kernel_size, stride=conv.stride,
                            padding=conv.padding, dilation=conv.dilation, bias=conv.bias is not None)
        with torch.no_grad():
            projection.weight.copy_((right[:rank] @ inverse).float()[:, :, None, None])
            spatial.weight.copy_((left[:, :rank] * singular[:rank]).reshape(conv.out_channels, kh, kw, rank).permute(0, 3, 1, 2).float())
            if conv.bias is not None:
                spatial.bias.copy_(conv.bias)
        model.set_submodule(name, nn.Sequential(projection, spatial))
    return torch.fx.symbolic_trace(model)


def accounting(model, shape):
    rows, hooks = [], []
    def record(module, inputs, output):
        kh, kw = module.kernel_size
        macs = output.numel() * module.in_channels * kh * kw // module.groups
        # Line storage only; physical BRAM packing, windows, accumulators and
        # concurrent-frame FIFO occupancy must be added by hardware scheduling.
        line_bytes = inputs[0].shape[-1] * module.in_channels * (kh - 1) * module.dilation[0]
        rows.append({"input": list(inputs[0].shape), "output": list(output.shape),
                     "weights": module.weight.numel(), "macs": macs, "line_bytes": line_bytes})
    for layer in model.modules():
        if isinstance(layer, nn.Conv2d):
            hooks.append(layer.register_forward_hook(record))
    with torch.no_grad():
        model.eval()(torch.zeros(shape))
    for hook in hooks:
        hook.remove()
    return {"layers": rows, "macs": sum(row["macs"] for row in rows),
            "int8_weight_bytes": sum(row["weights"] for row in rows),
            "conv_line_bytes": sum(row["line_bytes"] for row in rows)}


def metrics(prediction, target):
    prediction, target = prediction.bool(), target.bool()
    tp = int((prediction & target).sum())
    fp = int((prediction & ~target).sum())
    fn = int((~prediction & target).sum())
    tn = int((~prediction & ~target).sum())
    return {"dice": 2 * tp / max(2 * tp + fp + fn, 1), "iou": tp / max(tp + fp + fn, 1),
            "precision": tp / max(tp + fp, 1), "recall": tp / max(tp + fn, 1),
            "pixel_accuracy": (tp + tn) / (tp + fp + fn + tn),
            "true_positive": tp, "false_positive": fp, "false_negative": fn, "true_negative": tn,
            "samples": len(target)}


@torch.no_grad()
def predict(model, images, indices, batch_size):
    model.eval()
    return torch.cat([model(images[indices[start:start + batch_size]].float() / 255)
                      for start in range(0, len(indices), batch_size)])


def load_teacher(config):
    if "export" in config:
        class ExportTeacher(nn.Module):
            def __init__(self):
                super().__init__()
                self.program = torch.export.load(config["export"]).module()
                nodes = {node.name: node for node in self.program.graph.nodes}
                output = next(node for node in self.program.graph.nodes if node.op == "output")
                output.args = ((nodes[config["output_node"]],),)
                self.program.recompile()

            def train(self, mode=True):
                return self

            def forward(self, images):
                if images.shape[1] != config["input_channels"]:
                    if images.shape[1] != 1:
                        raise ValueError("Teacher input channel mapping must be supplied")
                    images = images.repeat(1, config["input_channels"], 1, 1)
                return torch.cat([self.program(image[None]) for image in images])
        return ExportTeacher()
    spec = importlib.util.spec_from_file_location("training_teacher", config["script"])
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    teacher = getattr(module, config["factory"])()
    getattr(module, config["loader"])(teacher, Path(config["weights"]))
    return teacher.eval()


def loss_function(logits, target, teacher, config):
    positive_weight = logits.new_tensor(config["positive_weight"])
    bce = F.binary_cross_entropy_with_logits(logits, target, pos_weight=positive_weight)
    probability = logits.sigmoid()
    reduction = config.get("dice_reduction", "sample")
    if reduction not in ("sample", "batch"):
        raise ValueError("Dice reduction must be sample or batch")
    dims = (1, 2, 3) if reduction == "sample" else (0, 1, 2, 3)
    dice = 1 - ((2 * (probability * target).sum(dims) + 1) /
                (probability.sum(dims) + target.sum(dims) + 1)).mean()
    if config.get("distillation_loss", "bce") == "logit":
        temperature = config["temperature"]
        distillation = F.binary_cross_entropy_with_logits(logits / temperature, (teacher / temperature).sigmoid()) * temperature**2
    elif config.get("distillation_loss", "bce") == "mse":
        distillation = F.mse_loss(probability, teacher.sigmoid())
    else:
        distillation = F.binary_cross_entropy_with_logits(logits, teacher.sigmoid(), pos_weight=positive_weight)
    return config["bce"] * bce + config["dice"] * dice + config["distillation"] * distillation


def augment_batch(image, target, teacher, config):
    for axis in config.get("augmentation_axes", (-1, -2)):
        if axis not in (-1, -2):
            raise ValueError("Image augmentation axes must be spatial")
        if config.get("augment", True) and torch.rand(()) < 0.5:
            image, target, teacher = image.flip(axis), target.flip(axis), teacher.flip(axis)
    return image, target, teacher


def teacher_fingerprint(config, manifest):
    source = config["teacher"].get("weights", config["teacher"].get("export"))
    return hashlib.sha256(json.dumps(manifest, sort_keys=True).encode() + Path(source).read_bytes()).hexdigest()


def restore(model, state, config):
    """Optionally initialize wider tensors using explicit checkpoint transforms."""
    state = dict(state)
    expected = model.state_dict()
    for name, spec in config.get("resume_expansions", {}).items():
        if state[name].shape == expected[name].shape:
            continue
        value = state[name]
        if "repeat" in spec:
            value = value.repeat(*spec["repeat"]) * spec.get("scale", 1)
        for selection in spec.get("axes", []):
            axis = selection["axis"]
            indices = torch.tensor(selection["indices"], dtype=torch.int64)
            value = value.index_select(axis, indices)
            if selection.get("divide_repeats", False):
                shape = [1] * value.ndim
                shape[axis] = len(indices)
                value = value / indices.bincount()[indices].reshape(shape)
        if value.shape != expected[name].shape:
            raise ValueError(f"Checkpoint expansion has the wrong shape at {name}")
        if spec.get("noise_std", 0):
            value = value + torch.randn_like(value) * spec["noise_std"]
        state[name] = value
    result = model.load_state_dict(state, strict=not config.get("allow_new_modules", False))
    if result.unexpected_keys:
        raise ValueError(f"Resume checkpoint contains removed modules: {result.unexpected_keys}")


def crop_batch(image, target, teacher, config):
    """Optional aligned training crops; full resolution is retained for evaluation."""
    height, width = config["size"]
    stride_y, stride_x = config["output_stride"]
    align_y, align_x = config["alignment"]
    result = [[], [], []]
    for sample in range(len(image)):
        top = random.randrange((image.shape[-2] - height) // align_y + 1) * align_y
        left = random.randrange((image.shape[-1] - width) // align_x + 1) * align_x
        positives = target[sample, 0].nonzero().cpu()
        if len(positives) and random.random() < config["positive_probability"]:
            cy, cx = positives[random.randrange(len(positives))].tolist()
            top = min(max(cy * stride_y - height // 2, 0), image.shape[-2] - height) // align_y * align_y
            left = min(max(cx * stride_x - width // 2, 0), image.shape[-1] - width) // align_x * align_x
        result[0].append(image[sample, :, top:top + height, left:left + width])
        for destination, source in ((1, target), (2, teacher)):
            result[destination].append(source[sample, :, top // stride_y:(top + height) // stride_y,
                                                left // stride_x:(left + width) // stride_x])
    return tuple(torch.stack(values) for values in result)


def training_batch(image, target, teacher, config):
    after_crop = config.get("augmentation_after_crop", False)
    if not after_crop:
        image, target, teacher = augment_batch(image, target, teacher, config)
    if "crop" in config:
        image, target, teacher = crop_batch(image, target, teacher, config["crop"])
    if after_crop:
        image, target, teacher = augment_batch(image, target, teacher, config)
    if config.get("augment", True) and "photometric" in config:
        # Per-image lighting variation is a training-only invariance target.
        # Spatial labels and cached teacher predictions remain aligned.
        spec = config["photometric"]
        if set(spec) != {"brightness", "contrast"}:
            raise ValueError("Photometric augmentation requires brightness and contrast intervals")
        factors = {}
        for name, interval in spec.items():
            if len(interval) != 2 or not all(math.isfinite(value) for value in interval) or interval[0] > interval[1]:
                raise ValueError("Photometric intervals must be finite and ordered")
            if name == "contrast" and interval[0] < 0:
                raise ValueError("Contrast must be nonnegative")
            factors[name] = torch.empty((len(image), 1, 1, 1), device=image.device, dtype=image.dtype).uniform_(*interval)
        center = image.mean(dim=(1, 2, 3), keepdim=True)
        image = ((image-center)*factors["contrast"] + center + factors["brightness"]).clamp(0, 1)
    return image, target, teacher


def train(config, output, resume=None):
    output.mkdir(parents=True, exist_ok=True)
    (output / "config.json").write_text(json.dumps(config, indent=2) + "\n")
    torch.set_num_threads(config["threads"])
    torch.manual_seed(config["seed"])
    random.seed(config["seed"])
    np.random.seed(config["seed"])
    images, masks, train_indices, validation_indices, manifest = read_data(config)
    (output / "dataset.json").write_text(json.dumps(manifest, indent=2) + "\n")
    cache = Path(config["teacher_cache"])
    fingerprint = teacher_fingerprint(config, manifest)
    if cache.exists():
        saved = torch.load(cache, weights_only=True)
        if saved["fingerprint"] != fingerprint:
            raise ValueError("Teacher cache does not match dataset and teacher")
        teacher_logits = saved["logits"]
    else:
        teacher = load_teacher(config["teacher"])
        teacher_logits = predict(teacher, images, list(range(len(images))), config["batch_size"])
        cache.parent.mkdir(parents=True, exist_ok=True)
        torch.save({"fingerprint": fingerprint, "logits": teacher_logits}, cache)
        del teacher
    baseline = metrics(teacher_logits[validation_indices] > 0, masks[validation_indices])
    model = make_model(config)
    if resume:
        restore(model, torch.load(resume, weights_only=True)["state"], config)
    resources = accounting(model, (1, *images.shape[1:]))
    if resources["macs"] > config["max_macs"] or resources["int8_weight_bytes"] > config["max_weight_bytes"]:
        raise ValueError(f"Architecture exceeds input budgets: {resources}")
    print(json.dumps({"teacher": baseline, "resources": resources,
                      "train": len(train_indices), "validation": len(validation_indices)}), flush=True)
    device = torch.device(config.get("device", "cpu"))
    model.to(device)
    images, masks, teacher_logits = images.to(device), masks.to(device), teacher_logits.to(device)
    feature_teacher = None
    teacher_features, student_features = {}, {}
    feature_cache = {}
    train_positions = {index: position for position, index in enumerate(train_indices)}
    class FeaturesReady(Exception):
        pass
    if "feature_distillation" in config:
        feature_teacher = load_teacher(config["feature_distillation"]["teacher"]).to(device).eval()
        feature_teacher.requires_grad_(False)
        selected = config["feature_distillation"].get("targets")
        matched = []
        for name, module in feature_teacher.named_modules():
            if not isinstance(module, nn.Conv2d) or (selected is not None and name not in selected):
                continue
            counterpart = model.get_submodule(name)
            if not isinstance(counterpart, nn.Conv2d):
                counterpart = [child for child in counterpart.modules() if isinstance(child, nn.Conv2d)][-1]
            if counterpart.out_channels != module.out_channels:
                raise ValueError(f"Feature distillation requires matching output channels at {name}")
            matched.append(name)
            def capture(module, inputs, value, key=name):
                teacher_features[key] = value.detach()
                if selected is not None and len(teacher_features) == len(selected):
                    raise FeaturesReady()
            module.register_forward_hook(capture)
            counterpart.register_forward_hook(lambda module, inputs, value, key=name: student_features.__setitem__(key, value))
        if selected is not None and set(matched) != set(selected):
            raise ValueError("Feature-distillation targets were not found in the teacher")
        if config["feature_distillation"].get("cache", False):
            if config.get("augment", True) or "crop" in config:
                raise ValueError("Cached feature distillation requires unaugmented full images")
            with torch.no_grad():
                for start in range(0, len(train_indices), config["batch_size"]):
                    indices = train_indices[start:start + config["batch_size"]]
                    teacher_features.clear()
                    try:
                        feature_teacher(images[indices].float() / 255)
                    except FeaturesReady:
                        pass
                    for name, value in teacher_features.items():
                        if name not in feature_cache:
                            feature_cache[name] = torch.empty((len(train_indices), *value.shape[1:]), dtype=torch.float16, device=device)
                        compressed = value.half()
                        if not torch.isfinite(compressed).all():
                            raise ValueError("Teacher feature cache overflows FP16")
                        feature_cache[name][start:start + len(indices)] = compressed
            teacher_features.clear()
            feature_teacher.cpu()
            print(json.dumps({"feature_cache_bytes": sum(value.numel() * value.element_size() for value in feature_cache.values()),
                              "feature_cache_samples": len(train_indices), "feature_cache_dtype": "float16"}), flush=True)
    optimizer = torch.optim.AdamW(model.parameters(), lr=config["learning_rate"], weight_decay=config["weight_decay"])
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, config["epochs"], eta_min=config["learning_rate"] / 20)
    best_dice = -1.0
    history = []
    for epoch in range(1, config["epochs"] + 1):
        started = time.monotonic()
        model.train()
        order = torch.tensor(train_indices)[torch.randperm(len(train_indices))].tolist()
        loss_total = 0.0
        for start in range(0, len(order), config["batch_size"]):
            indices = order[start:start + config["batch_size"]]
            image = images[indices].float() / 255
            target = masks[indices].float()
            soft_target = teacher_logits[indices]
            image, target, soft_target = training_batch(image, target, soft_target, config)
            optimizer.zero_grad(set_to_none=True)
            if feature_teacher is not None:
                teacher_features.clear()
                if feature_cache:
                    positions = [train_positions[index] for index in indices]
                    teacher_features.update({name: value[positions].float() for name, value in feature_cache.items()})
                else:
                    with torch.no_grad():
                        try:
                            feature_teacher(image)
                        except FeaturesReady:
                            pass
            logits = model(image)
            loss = loss_function(logits, target, soft_target, config["loss"])
            if feature_teacher is not None:
                reconstruction = torch.stack([
                    F.mse_loss(student_features[key], value) / value.square().mean().clamp_min(1e-6)
                    for key, value in teacher_features.items()
                ]).mean()
                loss = loss + config["feature_distillation"]["weight"] * reconstruction
            loss.backward()
            nn.utils.clip_grad_norm_(model.parameters(), 5)
            optimizer.step()
            loss_total += float(loss.detach()) * len(indices)
        scheduler.step()
        validation = metrics(predict(model, images, validation_indices, config["batch_size"]) > 0,
                             masks[validation_indices])
        record = {"epoch": epoch, "loss": loss_total / len(train_indices),
                  "seconds": time.monotonic() - started, "validation": validation}
        history.append(record)
        print(json.dumps(record), flush=True)
        checkpoint = {"state": {name: tensor.detach().cpu().clone() for name, tensor in model.state_dict().items()}, "epoch": epoch,
                      "validation": validation, "config": config}
        if validation["dice"] > best_dice:
            best_dice = validation["dice"]
            torch.save(checkpoint, output / "best.pt")
        torch.save(checkpoint, output / "last.pt")
        (output / "report.json").write_text(json.dumps({"baseline": baseline, "resources": resources,
            "best_dice": best_dice, "history": history}, indent=2) + "\n")
    return model


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--resume", type=Path)
    args = parser.parse_args()
    train(json.loads(args.config.read_text()), args.output, args.resume)
