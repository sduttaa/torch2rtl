"""Choose a segmentation threshold on training data and fold it into final bias."""

import argparse
import json
from pathlib import Path

import torch
from torch import nn

from train import read_data, make_model, predict, metrics


def select_threshold(logits, target):
    scores, order = logits.flatten().sort(descending=True)
    labels = target.flatten()[order].to(torch.int64)
    if not torch.isfinite(scores).all() or not labels.sum():
        raise ValueError("Threshold calibration needs finite logits and positive labels")
    counts = torch.arange(1, len(scores) + 1)
    dice = 2 * labels.cumsum(0) / (counts + labels.sum())
    boundary = torch.cat((scores[:-1] != scores[1:], torch.tensor([True])))
    dice[~boundary] = -1
    index = int(dice.argmax())
    if index + 1 == len(scores):
        return float(torch.nextafter(scores[index], scores.new_tensor(float('-inf'))))
    # Using the next group's score preserves a strict comparison at float precision.
    return float(scores[index + 1])


def calibrate(checkpoint_path, output, device):
    checkpoint = torch.load(checkpoint_path, weights_only=True)
    config = checkpoint["config"]
    torch.set_num_threads(config["threads"])
    images, masks, training, validation, _ = read_data(config)
    model = make_model(config)
    model.load_state_dict(checkpoint["state"])
    model.to(device).eval()
    images = images.to(device)
    logits = predict(model, images, training, config["batch_size"]).cpu()
    threshold = select_threshold(logits, masks[training])
    if isinstance(model, torch.fx.GraphModule):
        returned = next(node for node in model.graph.nodes if node.op == "output").args[0]
        if returned.op != "call_module":
            raise ValueError("Threshold folding requires a final convolution")
        final = model.get_submodule(returned.target)
    else:
        final = list(model.children())[-1]
    if not isinstance(final, nn.Conv2d) or final.out_channels != 1 or final.bias is None:
        raise ValueError("Threshold folding requires a final single-channel convolution with bias")
    with torch.no_grad():
        final.bias.sub_(threshold)
    training_after = metrics(predict(model, images, training, config["batch_size"]).cpu() > 0, masks[training])
    measured = metrics(predict(model, images, validation, config["batch_size"]).cpu() > 0, masks[validation])
    report = {"threshold": threshold, "selection_split": "training only", "selection_samples": len(training),
              "training_before": metrics(logits > 0, masks[training]),
              "training_after": training_after,
              "validation_before": checkpoint["validation"], "validation": measured,
              "checkpoint": str(checkpoint_path)}
    checkpoint.update(state={name: value.detach().cpu().clone() for name, value in model.state_dict().items()},
                      validation=measured, threshold_calibration=report)
    output.mkdir(parents=True, exist_ok=True)
    torch.save(checkpoint, output / "best.pt")
    (output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report), flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--checkpoint", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--device", default="cpu")
    args = parser.parse_args()
    calibrate(args.checkpoint, args.output, args.device)
