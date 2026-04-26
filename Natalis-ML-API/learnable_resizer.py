# learnable_resizer.py
import torch
import torch.nn as nn
import torch.nn.functional as F

class _ResBlock(nn.Module):
    def __init__(self, n: int):
        super().__init__()
        self.c1 = nn.Conv2d(n, n, 3, padding=1, bias=False)
        self.b1 = nn.BatchNorm2d(n)
        self.c2 = nn.Conv2d(n, n, 3, padding=1, bias=False)
        self.b2 = nn.BatchNorm2d(n)
        self.act = nn.LeakyReLU(0.2, inplace=True)

    def forward(self, x):
        y = self.act(self.b1(self.c1(x)))
        y = self.b2(self.c2(y))
        return self.act(x + y)

class LearnableResizer(nn.Module):
    """
    CNN resizer with bilinear skip connection.
    Jointly train this with your backbone; do NOT use a pixel loss on the output.
    Paper: 'Learning to Resize Images for Computer Vision Tasks' (ICCV'21).
    """
    def __init__(self, in_ch=3, out_ch=3, out_size=(224, 224), n=16, r=1):
        super().__init__()
        self.out_size = tuple(out_size)

        self.head = nn.Sequential(
            nn.Conv2d(in_ch, n, 7, padding=3, bias=False),
            nn.BatchNorm2d(n),
            nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(n, n, 1, bias=False),
            nn.BatchNorm2d(n),
            nn.LeakyReLU(0.2, inplace=True),
        )
        self.blocks = nn.Sequential(*[_ResBlock(n) for _ in range(r)])
        self.tail = nn.Sequential(
            nn.Conv2d(n, n, 3, padding=1, bias=False),
            nn.BatchNorm2d(n),
            nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(n, out_ch, 7, padding=3, bias=True),
        )

    def forward(self, x):
        # Skip path: bilinear resize of the raw input
        skip = F.interpolate(x, size=self.out_size, mode="bilinear", align_corners=False)

        # Feature path: process at native res, then bilinear to target, then project
        y = self.head(x)
        y = self.blocks(y)
        y = F.interpolate(y, size=self.out_size, mode="bilinear", align_corners=False)
        y = self.tail(y)

        return y + skip


# Example usage:
# if __name__ == "__main__":
    # model = LearnableResizer(in_ch=1, out_ch=1, out_size=(224, 224), n=16, r=1)
    # print(model)
    # tmp = torch.randn(1, 1, 640, 480)  # Example input tensor
    # out = model(tmp)
    # print(out.shape)  # Should be [1, 1, 224,