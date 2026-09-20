import random

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
