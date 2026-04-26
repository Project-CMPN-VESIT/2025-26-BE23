import torch
import torch.nn as nn
import torch.nn.functional as F
import segmentation_models_pytorch as smp
import configs

class SegModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.register_buffer("mean", torch.tensor([0.5], dtype=torch.float32).view(1,1,1,1))  # or dataset stats
        self.register_buffer("std",  torch.tensor([0.5], dtype=torch.float32).view(1,1,1,1))

        self.net = smp.DeepLabV3Plus(
            encoder_name="timm-efficientnet-b4",
            encoder_weights="imagenet",
            in_channels=1,
            classes=configs.NUM_CLASSES,
            activation=None
        )
        self.expected_in_ch = 1

    def forward(self, x):
        assert x.shape[1] == self.expected_in_ch, f"Expected {self.expected_in_ch}-ch, got {x.shape}"
        x = (x - self.mean) / self.std     # stays [N,1,H,W]
        return self.net(x)


if __name__ == "__main__":
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model = SegModel().to(device).eval()
    dummy = torch.randn(2, 1, 540, 800, device=device)  # HC18-like
    with torch.no_grad():
        out = model(dummy)
    print("logits:", tuple(out.shape))  # (2, 1, 352, 352)
