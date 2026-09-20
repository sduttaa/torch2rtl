import random

import pytest
import torch
from torch.nn import functional as F

from training.train import training_batch


def test_flip_after_crop_preserves_pooled_mask_alignment():
    target = torch.arange(32).reshape(1, 1, 4, 8).float()
    image = target.repeat_interleave(2, dim=2).repeat_interleave(2, dim=3)
    image = F.pad(image, (0, 1, 0, 0), mode="replicate")
    config = {"augmentation_axes": [-1], "augmentation_after_crop": True,
              "crop": {"size": [4, 8], "output_stride": [2, 2], "alignment": [2, 2], "positive_probability": 0}}
    random.seed(31)
    torch.manual_seed(0)
    cropped, labels, teacher = training_batch(image, target, target*3, config)
    assert torch.equal(F.max_pool2d(cropped, 2), labels)
    assert torch.equal(teacher, labels*3)


def test_lighting_augmentation_preserves_spatial_targets():
    image = torch.tensor([0., 0.25, 0.75, 1.]).reshape(1, 1, 2, 2)
    target = torch.tensor([0., 1., 1., 0.]).reshape_as(image)
    teacher = target*3-1
    config = {"augmentation_axes": [], "photometric": {"brightness": [0.1, 0.1], "contrast": [0.5, 0.5]}}
    changed, labels, soft = training_batch(image, target, teacher, config)
    torch.testing.assert_close(changed, torch.tensor([0.35, 0.475, 0.725, 0.85]).reshape_as(image))
    assert torch.equal(labels, target) and torch.equal(soft, teacher)
    assert torch.equal(image, torch.tensor([0., 0.25, 0.75, 1.]).reshape_as(image))
    unchanged, _, _ = training_batch(image, target, teacher, {**config, "augment": False})
    assert torch.equal(unchanged, image)


@pytest.mark.parametrize("spec", [
    {"brightness": [0, 1]},
    {"brightness": [1, 0], "contrast": [1, 1]},
    {"brightness": [0, float("inf")], "contrast": [1, 1]},
    {"brightness": [0, 0], "contrast": [-1, 1]},
])
def test_invalid_lighting_ranges_fail(spec):
    image = torch.zeros(1, 1, 2, 2)
    with pytest.raises(ValueError, match="Photometric|Contrast"):
        training_batch(image, image, image, {"augmentation_axes": [], "photometric": spec})
