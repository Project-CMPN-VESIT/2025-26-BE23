import numpy as np
import torch
from pathlib import Path
from typing import Dict, Tuple, Optional
from PIL import Image
import matplotlib.pyplot as plt
    
import configs
from model import SegModel
from learnable_resizer import LearnableResizer

from postprocess_functions import (
    logits_to_prob, tta_mean_prob_on_resized,
    largest_component, morph_clean,
    densecrf_refine,
    fit_ellipse_with_contours,
    to_uint8_from_01
)

# ===== simple ON/OFF switches =====
USE_TTA: bool     = True
USE_LCC: bool     = True
USE_MORPH: bool   = True
USE_CRF: bool     = True
USE_ELLIPSE: bool = True

THRESHOLD: float = getattr(configs, "THRESHOLD", 0.5)  # tuned on val


def run_inference(model_path: str, img_path: str) -> Dict[str, object]:
    """
    Run the full inference pipeline (no visualization).

    Returns a dictionary with:
        - input_image: (H_pre, W_pre) float32 in [0,1], pre-learnable-resizer
        - prediction: (H_model, W_model) uint8 {0,1}, final post-processed mask
        - probability_map: (H_model, W_model) float32 in [0,1]
        - pre_resize_size: Tuple[int, int]  (pre-learnable-resizer size)
        - model_input_size: Tuple[int, int] (model's working size)

    Notes:
        * Uses feature toggles above for post-processing steps.
        * Model and resizer weights are loaded from `model_path`. If the checkpoint
          is a dict with keys {"model", "resizer"}, both are restored.
    """
    device = configs.DEVICE

    # --- load model / resizer ---
    ckpt = torch.load(model_path, map_location=device)
    model = SegModel()
    resizer = LearnableResizer(
        in_ch=configs.MODEL_INPUT_CHANNELS,
        out_ch=configs.MODEL_INPUT_CHANNELS,
        out_size=(configs.IMAGE_SIZE, configs.IMAGE_SIZE)
    )

    if isinstance(ckpt, dict) and "model" in ckpt:
        model.load_state_dict(ckpt["model"])
        if "resizer" in ckpt and ckpt.get("resizer") is not None:
            resizer.load_state_dict(ckpt["resizer"])
    else:
        # backwards compatibility: checkpoint directly contains model state_dict
        model.load_state_dict(ckpt)

    model.to(device).eval()
    resizer.to(device).eval()

    # --- sizes ---
    pre_resize_size: Tuple[int, int] = (
        configs.IMAGE_RESIZE_PRE_LEARANBLE_RESIZER,
        configs.IMAGE_RESIZE_PRE_LEARANBLE_RESIZER,
    )
    model_input_size: Tuple[int, int] = (configs.IMAGE_SIZE, configs.IMAGE_SIZE)

    # --- load & normalize image (pre-resizer) ---
    img_pil_pre = Image.open(img_path).convert("L").resize(
        pre_resize_size, Image.Resampling.BILINEAR
    )
    input_image = np.asarray(img_pil_pre, dtype=np.float32) / 255.0  # (H_pre, W_pre)
    img_t_pre = torch.from_numpy(input_image).unsqueeze(0).unsqueeze(0).to(device)

    # --- learnable resizer + model forward (w/ or w/o TTA) ---
    with torch.no_grad():
        img_resized_t = resizer(img_t_pre)  # [1,1,H_model,W_model]
        if USE_TTA:
            prob_t = tta_mean_prob_on_resized(model, img_resized_t)  # [1,1,H,W]
        else:
            logits = model(img_resized_t)                             # [1,C,H,W]
            prob_t = logits_to_prob(logits)                          # [1,1,H,W]

    probability_map = prob_t.squeeze().cpu().numpy()                 # (H,W) float [0,1]
    prediction = (probability_map >= THRESHOLD).astype(np.uint8)     # (H,W) uint8 {0,1}

    # --- boundary-aware post-processing needs a guidance gray image ---
    img_resized_np = img_resized_t.squeeze().cpu().numpy()           # (H,W) float
    if img_resized_np.min() < 0 or img_resized_np.max() > 1:
        mn, mx = img_resized_np.min(), img_resized_np.max()
        img_resized_np = (img_resized_np - mn) / (mx - mn + 1e-8)
    gray_u8 = to_uint8_from_01(img_resized_np)                        # (H,W) uint8

    # ---- POST-PROCESSING (toggle by flags) ----
    if USE_LCC:
        prediction = largest_component(prediction)
    if USE_MORPH:
        prediction = morph_clean(prediction, min_size=200, close=3, open_=2, fill_holes=True)
    if USE_CRF:
        prediction = densecrf_refine(gray_u8, probability_map, iters=5, sxy=50, srgb=3, compat=4)
    if USE_ELLIPSE:
        prediction = fit_ellipse_with_contours(prediction).astype(np.uint8)

    # Optional logs (comment out if noisy)
    print("Pre-Resizer input shape:", input_image.shape)
    print("Model input shape (after Resizer):", tuple(img_resized_t.shape))
    print("Prediction unique labels:", np.unique(prediction))

    return {
        "input_image": input_image,
        "prediction": prediction,
        "probability_map": probability_map,
        "pre_resize_size": pre_resize_size,
        "model_input_size": model_input_size,
    }


def load_gt_mask(gt_mask_path: str, model_input_size: Tuple[int, int]) -> np.ndarray:
    """
    Load a ground-truth mask, resize to model_input_size, and binarize to {0,1}.
    Returns (H_model, W_model) uint8.
    """
    gt_pil = Image.open(gt_mask_path).convert("L").resize(
        model_input_size, Image.Resampling.NEAREST
    )
    gt_np = np.asarray(gt_pil, dtype=np.uint8)
    if gt_np.max() == 255:
        gt_np = (gt_np > 127).astype(np.uint8)
    return gt_np


def plot_results(
    input_image: np.ndarray,
    prediction: np.ndarray,
    gt_mask: Optional[np.ndarray] = None,
    pre_resize_size: Optional[Tuple[int, int]] = None,
    save_path: Optional[str] = None,
) -> None:
    """
    Standalone visualization. Safe to skip if you only need inference.

    Args:
        input_image: (H_pre, W_pre) float32 in [0,1]
        prediction: (H_model, W_model) uint8 {0,1}
        gt_mask:    (H_model, W_model) uint8 {0,1} or None
        pre_resize_size: Optional label for display
        save_path:  If provided, figure is saved there
    """
    if save_path:
        Path(save_path).parent.mkdir(parents=True, exist_ok=True)

    show_gt = gt_mask is not None
    ncols = 3 if show_gt else 2

    fig, axs = plt.subplots(1, ncols, figsize=(12, 4))
    axs = np.atleast_1d(axs)

    axs[0].imshow(input_image, cmap="gray")
    title = f"Input (pre-resizer {pre_resize_size})" if pre_resize_size else "Input"
    axs[0].set_title(title)
    axs[0].axis("off")

    axs[1].imshow(prediction, cmap="gray", interpolation="nearest")
    axs[1].set_title("Prediction")
    axs[1].axis("off")

    if show_gt:
        axs[2].imshow(gt_mask, cmap="gray", interpolation="nearest")
        axs[2].set_title("Ground Truth")
        axs[2].axis("off")

    plt.tight_layout()
    if save_path:
        plt.savefig(save_path, dpi=200, bbox_inches="tight")
    plt.show()
    plt.close(fig)


# ---------------- Example usage ----------------
# Keep this block or remove it—your choice. Nothing will be plotted unless you call `plot_results`.
if __name__ == "__main__":
    # Inference only (no visualization):
    pack = run_inference(
        configs.BEST_MODEL_SAVE_PATH,
        "data/validation_set/805_HC.png"
    )

    # If you want visualization, load GT (optional) and plot:
    gt = load_gt_mask(
        "data/validation_set/805_HC_Mask.png",
        pack["model_input_size"]
    )
    plot_results(
        input_image=pack["input_image"],
        prediction=pack["prediction"],
        gt_mask=gt,
        pre_resize_size=pack["pre_resize_size"],
        save_path="sample_inferences/viz_666_2HC.png"
    )
