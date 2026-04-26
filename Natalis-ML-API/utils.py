import os
import numpy as np
from PIL import Image
import configs
import torch
import matplotlib.pyplot as plt
import random
from typing import Optional

def visualize_label_map(label_map):
    plt.imshow(label_map, cmap='gray', vmin=0, vmax=np.max(label_map) if np.max(label_map) > 0 else 1)
    plt.axis('off')
    plt.show()

def _mask_to_uint8(arr: np.ndarray) -> np.ndarray:
    """
    Convert a 2D mask (values 0/1 or small integers) to uint8 image space safely.
    - If max==0 -> zeros
    - If max<=1 -> scale by 255
    - Else if max<=255 -> cast to uint8
    - Else -> normalize to 0..255
    """
    arr = np.asarray(arr)
    if arr.ndim != 2:
        raise ValueError(f"Expected 2D mask, got shape {arr.shape}")
    m = arr.max()
    if m == 0:
        return np.zeros_like(arr, dtype=np.uint8)
    if m <= 1:
        return (arr * 255).astype(np.uint8)
    if m <= 255:
        return arr.astype(np.uint8)
    return (arr * (255.0 / float(m))).astype(np.uint8)

def _prepare_targets_for_vis(targets: torch.Tensor) -> torch.Tensor:
    """
    Make targets suitable for visualization:
    - squeeze channel if [N,1,H,W]
    - if float labels (BCE-style), threshold at 0.5 and cast to uint8
    - if long/int labels (CE-style), cast to uint8
    """
    t = targets
    if t.ndim == 4 and t.shape[1] == 1:
        t = t.squeeze(1)
    if t.dtype.is_floating_point:
        t = (t > 0.5).to(torch.uint8)
    else:
        t = t.to(torch.uint8)
    return t

def inference_after_epoch(val_loader,
                          model: torch.nn.Module,
                          epoch: int,
                          num_samples: int = 5,
                          device: Optional[torch.device] = None) -> int:
    """
    Run inference on val_loader and save up to `num_samples` (pred, gt) PNG pairs to configs.PRED_PATH.
    Works with:
      - CE model: outputs [N, C>=2, H, W] -> argmax
      - BCE model: outputs [N, 1, H, W] -> sigmoid > 0.5
    Returns the number of sample pairs saved.
    """
    os.makedirs(configs.PRED_PATH, exist_ok=True)

    if device is None:
        try:
            device = next(model.parameters()).device
        except StopIteration:
            # Fallback if model has no parameters (rare)
            device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    model.eval()
    saved = 0

    with torch.no_grad():
        for i, (inputs, targets) in enumerate(val_loader):
            inputs = inputs.to(device)
            targets = targets.to(device)

            logits = model(inputs)
            # Branch on # of channels
            if logits.ndim != 4:
                raise RuntimeError(f"Model output must be 4D [N,C,H,W], got shape {tuple(logits.shape)}")

            if logits.shape[1] == 1:
                # BCE path
                preds_t = (torch.sigmoid(logits) > 0.5).to(torch.uint8).squeeze(1)   # [N,H,W] in {0,1}
            else:
                # CE path
                preds_t = torch.argmax(logits, dim=1).to(torch.uint8)                # [N,H,W] in {0..C-1}

            # Debug uniques (tensor, not numpy)
            uniq = torch.unique(preds_t).tolist()
            print(f"[Epoch {epoch}] Batch {i} unique pred labels: {uniq}")

            # How many more do we need overall?
            remaining = num_samples - saved
            if remaining <= 0:
                break

            preds_np  = preds_t.cpu().numpy()
            targs_vis = _prepare_targets_for_vis(targets).cpu().numpy()

            batch_size = preds_np.shape[0]
            k = min(remaining, batch_size)
            # random selection within this batch
            idxs = random.sample(range(batch_size), k) if k < batch_size else list(range(batch_size))

            for j in idxs:
                pred_path = os.path.join(configs.PRED_PATH, f"epoch_{epoch}_sample_{saved}_pred.png")
                gt_path   = os.path.join(configs.PRED_PATH, f"epoch_{epoch}_sample_{saved}_gt.png")

                pred_img = Image.fromarray(_mask_to_uint8(preds_np[j]))
                gt_img   = Image.fromarray(_mask_to_uint8(targs_vis[j]))

                pred_img.save(pred_path)
                gt_img.save(gt_path)

                print(f"Saved: {pred_path}")
                print(f"Saved: {gt_path}")

                saved += 1
                if saved >= num_samples:
                    break

    return saved
