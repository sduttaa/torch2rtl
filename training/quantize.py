"""Static INT8 QAT and an executable integer-only exported program.

Convolutions accumulate into INT32. Requantization uses an integer multiplier,
an explicitly specified right shift, and round-to-nearest with ties toward +inf.
No scale, maximum, division or floating-point tensor remains in deployment.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import operator
import random
import time
from pathlib import Path

import torch
from torch import nn
from torch.nn import functional as F

from train import read_data, make_model, metrics, predict, loss_function, training_batch, teacher_fingerprint


def round_ste(value):
    return value + (torch.round(value) - value).detach()


def fold(model):
    source = list(model.eval().children())
    layers = []
    index = 0
    while index < len(source):
        layer = copy.deepcopy(source[index])
        if isinstance(layer, nn.Conv2d) and index + 1 < len(source) and isinstance(source[index + 1], nn.BatchNorm2d):
            layer = nn.utils.fuse_conv_bn_eval(layer, source[index + 1])
            index += 1
        layers.append(layer)
        index += 1
    return nn.Sequential(*layers)


class QuantizedTrainingConv(nn.Module):
    def __init__(self, conv, input_scale, output_scale, relu, shift):
        super().__init__()
        self.weight = nn.Parameter(conv.weight.detach().clone())
        self.bias = nn.Parameter(conv.bias.detach().clone() if conv.bias is not None else torch.zeros(conv.out_channels))
        self.stride, self.padding, self.dilation, self.groups = conv.stride, conv.padding, conv.dilation, conv.groups
        self.relu = relu
        self.shift = shift
        self.register_buffer("input_scale", torch.tensor(float(input_scale)))
        self.register_buffer("output_scale", torch.tensor(float(output_scale)))

    def parameters_integer(self):
        scale = self.weight.detach().abs().flatten(1).amax(1).clamp_min(1e-8) / 127
        multiplier = torch.round(self.input_scale * scale / self.output_scale * (1 << self.shift)).to(torch.int64)
        bias_value = torch.round(self.bias.detach() / (self.input_scale * scale))
        if not torch.isfinite(bias_value).all() or (bias_value.double().abs() > (1 << 31) - 1).any():
            raise ValueError("Quantized bias does not fit INT32")
        bias = bias_value.to(torch.int32)
        weight = torch.round(self.weight.detach() / scale[:, None, None, None]).clamp(-127, 127).to(torch.int8)
        return weight, bias, multiplier, scale

    def forward(self, x):
        _, _, multiplier, scale = self.parameters_integer()
        weight = round_ste(self.weight / scale[:, None, None, None]).clamp(-127, 127)
        bias = round_ste(self.bias / (self.input_scale * scale))
        quantized = round_ste(x / self.input_scale)
        accumulator = F.conv2d(quantized, weight, bias, self.stride, self.padding, self.dilation, self.groups)
        # Integer products and sums are exactly representable in FP32 for the
        # checked bounds. FP64 preserves the requantization integer numerator.
        scaled = accumulator.double() * multiplier[None, :, None, None] / (1 << self.shift)
        rounded = scaled + (torch.floor(scaled + 0.5) - scaled).detach()
        return rounded.clamp(0 if self.relu else -128, 255 if self.relu else 127).float() * self.output_scale


class IntegerConv(nn.Module):
    def __init__(self, source):
        super().__init__()
        weight, bias, multiplier, _ = source.parameters_integer()
        bound = weight.to(torch.int64).abs().flatten(1).sum(1) * 255 + bias.to(torch.int64).abs()
        if int(bound.max()) >= 1 << 24:
            raise ValueError("The exact QAT accumulator requires a wider simulation dtype")
        if int((bound * multiplier.abs()).max()) + (1 << (source.shift - 1)) >= 1 << 53:
            raise ValueError("The exact QAT requantizer exceeds FP64's integer precision")
        if (multiplier <= 0).any():
            raise ValueError("Quantization multiplier underflow: increase the fixed-point shift")
        self.register_buffer("weight", weight)
        self.register_buffer("bias", bias)
        self.register_buffer("multiplier", multiplier)
        self.stride, self.padding, self.dilation, self.groups = source.stride, source.padding, source.dilation, source.groups
        self.shift, self.relu = source.shift, source.relu

    def forward(self, x):
        if self.dilation == (1, 1):
            accumulator = F.conv2d(x.to(torch.int32), self.weight.to(torch.int32), self.bias,
                                   self.stride, self.padding, self.dilation, self.groups)
        else:
            # ATen's CPU dilated convolution has no integer kernel. Express its
            # exact integer dot products with views and matmul for portability.
            if self.groups != 1:
                raise ValueError("Dilated integer reference currently requires groups=1")
            kh, kw = self.weight.shape[-2:]
            dh, dw = self.dilation
            ph, pw = self.padding
            padded = F.pad(x.to(torch.int32), (pw, pw, ph, ph))
            patches = padded.unfold(2, (kh - 1) * dh + 1, self.stride[0]).unfold(3, (kw - 1) * dw + 1, self.stride[1])
            patches = patches[..., ::dh, ::dw].permute(0, 2, 3, 1, 4, 5).flatten(3)
            products = patches @ self.weight.to(torch.int32).flatten(1).t()
            accumulator = products.permute(0, 3, 1, 2) + self.bias[None, :, None, None]
        numerator = accumulator.to(torch.int64) * self.multiplier[None, :, None, None]
        rounded = (numerator + (1 << (self.shift - 1))) >> self.shift
        return rounded.clamp(0 if self.relu else -128, 255 if self.relu else 127).to(torch.uint8 if self.relu else torch.int8)


class IntegerPrediction(nn.Module):
    def __init__(self, layers):
        super().__init__()
        self.layers = layers if isinstance(layers, nn.Module) else nn.Sequential(*layers)

    def forward(self, image):
        return (self.layers(image) > 0).to(torch.uint8)


class QuantizedMerge(nn.Module):
    """Static scale alignment for residual addition or channel concatenation."""
    def __init__(self, operation, input_scales, output_scale, relu, shift, dim=1):
        super().__init__()
        self.operation, self.relu, self.shift, self.dim = operation, relu, shift, dim
        self.register_buffer("input_scales", torch.tensor(input_scales))
        self.register_buffer("output_scale", torch.tensor(float(output_scale)))
        self.register_buffer("multipliers", torch.round(self.input_scales / self.output_scale * (1 << shift)).to(torch.int64))
        bound = 255 * sum(abs(int(value)) for value in self.multipliers) + (1 << (shift - 1))
        if bound >= 1 << 53:
            raise ValueError("The exact merge requantizer exceeds FP64's integer precision")

    def forward(self, *arguments):
        values = arguments[0] if self.operation == "cat" else arguments
        aligned = [round_ste(value / self.input_scales[index]).double() * self.multipliers[index]
                   for index, value in enumerate(values)]
        total = torch.cat(aligned, dim=self.dim) if self.operation == "cat" else sum(aligned)
        scaled = total / (1 << self.shift)
        rounded = scaled + (torch.floor(scaled + 0.5) - scaled).detach()
        return rounded.clamp(0 if self.relu else -128, 255 if self.relu else 127).float() * self.output_scale


class IntegerMerge(nn.Module):
    def __init__(self, source):
        super().__init__()
        self.operation, self.relu, self.shift, self.dim = source.operation, source.relu, source.shift, source.dim
        self.register_buffer("multipliers", source.multipliers.clone())

    def forward(self, *arguments):
        values = arguments[0] if self.operation == "cat" else arguments
        aligned = [value.to(torch.int64) * self.multipliers[index] for index, value in enumerate(values)]
        total = torch.cat(aligned, dim=self.dim) if self.operation == "cat" else sum(aligned)
        rounded = (total + (1 << (self.shift - 1))) >> self.shift
        return rounded.clamp(0 if self.relu else -128, 255 if self.relu else 127).to(torch.uint8 if self.relu else torch.int8)


@torch.no_grad()
def prepare_graph(model, images, train_indices, batch_size, shift):
    model = copy.deepcopy(model).eval()
    active = set(model.graph.nodes)
    for node in list(model.graph.nodes):
        if node not in active:
            continue
        if node.op != "call_module" or not isinstance(model.get_submodule(node.target), nn.Conv2d):
            continue
        users = list(node.users)
        if len(users) == 1 and users[0].op == "call_module":
            normalization = model.get_submodule(users[0].target)
            if isinstance(normalization, nn.BatchNorm2d):
                model.set_submodule(node.target, nn.utils.fuse_conv_bn_eval(model.get_submodule(node.target), normalization))
                users[0].replace_all_uses_with(node)
                model.delete_submodule(users[0].target)
                active.remove(users[0])
                model.graph.erase_node(users[0])
    model.recompile()
    maxima = {}
    class Observer(torch.fx.Interpreter):
        def run_node(self, node):
            value = super().run_node(node)
            if isinstance(value, torch.Tensor):
                maxima[node.name] = max(maxima.get(node.name, 0), float(value.abs().max()))
            return value
    observer = Observer(model)
    for start in range(0, len(train_indices), batch_size):
        observer.run(images[train_indices[start:start + batch_size]].float() / 255)
    scales, unsigned = {}, {}
    for node in list(model.graph.nodes):
        users = list(node.users)
        relu_user = (users[0] if len(users) == 1 and users[0].op == "call_function" and
                     users[0].target in (F.relu, torch.relu) else None)
        if node.op == "placeholder":
            scales[node] = 1 / 255
            unsigned[node] = True
        elif node.op == "call_module" and isinstance(model.get_submodule(node.target), nn.Conv2d):
            scale = max(maxima[(relu_user or node).name], 1e-8) / (255 if relu_user else 127)
            conv = QuantizedTrainingConv(model.get_submodule(node.target), scales[node.args[0]], scale, bool(relu_user), shift)
            model.set_submodule(node.target, conv)
            scales[node] = scale
            unsigned[node] = bool(relu_user)
        elif node.op == "call_function" and node.target in (operator.add, torch.add, torch.cat):
            is_cat = node.target is torch.cat
            parents = node.args[0] if is_cat else node.args
            nonnegative = bool(relu_user) or (is_cat and all(unsigned[parent] for parent in parents))
            scale = max(maxima[(relu_user or node).name], 1e-8) / (255 if nonnegative else 127)
            name = "quantize_" + node.name
            model.add_submodule(name, QuantizedMerge("cat" if is_cat else "add", [scales[parent] for parent in parents],
                                                     scale, nonnegative, shift, node.kwargs.get("dim", 1)))
            node.op, node.target, node.kwargs = "call_module", name, {}
            scales[node] = scale
            unsigned[node] = nonnegative
        else:
            parents = [parent for parent in node.all_input_nodes if parent in scales]
            if parents:
                scales[node] = scales[parents[0]]
                unsigned[node] = unsigned[parents[0]]
            continue
        if relu_user:
            relu_user.replace_all_uses_with(node)
            model.graph.erase_node(relu_user)
    model.graph.lint()
    model.recompile()
    return model


@torch.no_grad()
def prepare(model, images, train_indices, batch_size, shift):
    if isinstance(model, torch.fx.GraphModule):
        return prepare_graph(model, images, train_indices, batch_size, shift)
    model = fold(model)
    maxima, hooks = {}, []
    for index, layer in enumerate(model):
        if isinstance(layer, nn.Conv2d):
            relu = index + 1 < len(model) and isinstance(model[index + 1], nn.ReLU)
            def observe(module, inputs, output, key=index, positive=relu):
                magnitude = output.clamp_min(0).max() if positive else output.abs().max()
                maxima[key] = max(maxima.get(key, 0), float(magnitude))
            hooks.append(layer.register_forward_hook(observe))
    predict(model, images, train_indices, batch_size)
    for hook in hooks:
        hook.remove()
    layers = []
    input_scale = 1 / 255
    source = list(model.children())
    for index, layer in enumerate(source):
        if isinstance(layer, nn.Conv2d):
            relu = index + 1 < len(source) and isinstance(source[index + 1], nn.ReLU)
            output_scale = max(maxima[index], 1e-8) / (255 if relu else 127)
            layers.append(QuantizedTrainingConv(layer, input_scale, output_scale, relu, shift))
            input_scale = output_scale
        elif not isinstance(layer, nn.ReLU):
            layers.append(copy.deepcopy(layer))
    return nn.Sequential(*layers)


def integer_model(model):
    result = copy.deepcopy(model)
    for name, layer in list(result.named_modules()):
        if isinstance(layer, QuantizedTrainingConv):
            result.set_submodule(name, IntegerConv(layer))
        elif isinstance(layer, QuantizedMerge):
            result.set_submodule(name, IntegerMerge(layer))
    return IntegerPrediction(result).eval()


@torch.no_grad()
def verify(model, integer, images, indices, batch_size):
    predictions = []
    model.eval()
    for start in range(0, len(indices), batch_size):
        batch = images[indices[start:start + batch_size]]
        floating = model(batch.float() / 255) > 0
        exact = integer(batch)
        if not torch.equal(floating, exact.bool()):
            raise AssertionError(f"QAT/integer output mismatch in batch starting {start}")
        predictions.append(exact)
    return torch.cat(predictions)


def run(checkpoint_path, output, epochs, learning_rate, shift, config_path=None):
    checkpoint = torch.load(checkpoint_path, weights_only=True)
    config = json.loads(config_path.read_text()) if config_path else checkpoint["config"]
    torch.set_num_threads(config["threads"])
    torch.manual_seed(config["seed"])
    random.seed(config["seed"])
    images, masks, train_indices, validation_indices, manifest = read_data(config)
    floating = make_model(config)
    floating.load_state_dict(checkpoint["state"])
    model = prepare(floating, images, train_indices, config["batch_size"], shift)
    del floating
    cached_teacher = torch.load(config["teacher_cache"], weights_only=True)
    if cached_teacher["fingerprint"] != teacher_fingerprint(config, manifest):
        raise ValueError("Teacher cache does not match dataset and teacher")
    teacher_logits = cached_teacher["logits"]
    output.mkdir(parents=True, exist_ok=True)
    (output / "config.json").write_text(json.dumps(config, indent=2) + "\n")
    optimizer = torch.optim.AdamW(model.parameters(), lr=learning_rate, weight_decay=config["weight_decay"])
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, max(epochs, 1), eta_min=learning_rate / 20)
    best_dice, best_state, history = -1, None, []
    for epoch in range(epochs + 1):
        started = time.monotonic()
        loss_total = 0.0
        if epoch:
            model.train()
            order = torch.tensor(train_indices)[torch.randperm(len(train_indices))].tolist()
            for start in range(0, len(order), config["batch_size"]):
                indices = order[start:start + config["batch_size"]]
                image, target = images[indices].float() / 255, masks[indices].float()
                teacher = teacher_logits[indices]
                image, target, teacher = training_batch(image, target, teacher, config)
                optimizer.zero_grad(set_to_none=True)
                loss = loss_function(model(image), target, teacher, config["loss"])
                loss.backward()
                nn.utils.clip_grad_norm_(model.parameters(), 5)
                optimizer.step()
                loss_total += float(loss.detach()) * len(indices)
            scheduler.step()
        validation = metrics(predict(model, images, validation_indices, config["batch_size"]) > 0, masks[validation_indices])
        record = {"epoch": epoch, "loss": loss_total / len(train_indices), "validation": validation,
                  "seconds": time.monotonic() - started}
        print(json.dumps(record), flush=True)
        history.append(record)
        if validation["dice"] > best_dice:
            best_dice, best_state = validation["dice"], copy.deepcopy(model.state_dict())
            torch.save({"state": best_state, "config": config, "shift": shift, "validation": validation}, output / "qat.pt")
        (output / "history.json").write_text(json.dumps(history, indent=2) + "\n")
    model.load_state_dict(best_state)
    integer = integer_model(model)
    predicted = verify(model, integer, images, validation_indices, config["batch_size"])
    validation = metrics(predicted, masks[validation_indices])
    verify(model, integer, images, train_indices, config["batch_size"])
    program = torch.export.export(integer, (images[:1],), strict=True)
    program._example_inputs = None
    torch.export.save(program, output / "model.pt2")
    loaded = torch.export.load(output / "model.pt2").module()
    serialized_predictions = torch.cat([loaded(images[index:index + 1]) for index in validation_indices])
    if not torch.equal(predicted, serialized_predictions):
        raise AssertionError("Serialized integer model differs from eager integer inference")
    for node in program.graph.nodes:
        value = node.meta.get("val")
        if isinstance(value, torch.Tensor) and value.is_floating_point():
            raise AssertionError(f"Floating-point tensor remains at {node.name}")
    constants = sum(t.numel() * t.element_size() for t in program.state_dict.values())
    metadata = {"validation": validation, "constant_bytes": constants,
                "input": {"shape": list(images[:1].shape), "dtype": "uint8", "preprocessing": config["image_resize"]},
                "output": {"shape": list(predicted[:1].shape), "dtype": "uint8", "values": [0, 1]},
                "numerics": "INT8 weights, signed/unsigned 8-bit activations as declared by the graph, INT32 accumulation, INT64 fixed-point requantization",
                "rounding": "nearest, ties toward positive infinity", "shift": shift,
                "qat_integer_match_samples": len(train_indices) + len(validation_indices),
                "serialized_match_samples": len(validation_indices), "floating_tensor_nodes": 0,
                "baseline_report": config["split_report"], "checkpoint": str(checkpoint_path),
                "checkpoint_sha256": hashlib.sha256(checkpoint_path.read_bytes()).hexdigest(),
                "model_sha256": hashlib.sha256((output / "model.pt2").read_bytes()).hexdigest(),
                "teacher_cache_fingerprint": cached_teacher["fingerprint"],
                "test_caveat": "Existing validation split used for checkpoint selection; no independent test set supplied."}
    (output / "report.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print(json.dumps(metadata), flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--checkpoint", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--config", type=Path, help="Optional explicit QAT configuration; architecture must match checkpoint")
    parser.add_argument("--epochs", type=int, default=20)
    parser.add_argument("--learning-rate", type=float, default=0.0001)
    parser.add_argument("--shift", type=int, default=24)
    args = parser.parse_args()
    run(args.checkpoint, args.output, args.epochs, args.learning_rate, args.shift, args.config)
