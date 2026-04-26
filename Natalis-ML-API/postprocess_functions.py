import warnings
import numpy as np
import torch

# Optional deps (safe if missing)
try:
    import pydensecrf.densecrf as dcrf
    from pydensecrf.utils import unary_from_softmax, create_pairwise_bilateral
    _HAS_CRF = True
except Exception:
    _HAS_CRF = False


from skimage import morphology, measure
from scipy import ndimage as ndi


# -------- logits -> prob --------
def logits_to_prob(logits: torch.Tensor) -> torch.Tensor:
    """[B,2,H,W] -> softmax class-1; [B,1,H,W] -> sigmoid. Returns [B,1,H,W]."""
    if logits.shape[1] == 2:
        return torch.softmax(logits, dim=1)[:, 1:2]
    return torch.sigmoid(logits)


# -------- TTA (flips/rot90) --------
@torch.no_grad()
def tta_mean_prob_on_resized(model: torch.nn.Module, img_resized_t: torch.Tensor) -> torch.Tensor:
    """Return mean prob [1,1,S,S] using flips+rot90."""
    def views(x):
        return [x,
                torch.flip(x, [-1]),
                torch.flip(x, [-2]),
                torch.rot90(x, 1, (-2, -1)),
                torch.rot90(x, 2, (-2, -1)),
                torch.rot90(x, 3, (-2, -1))]
    def invert(i, y):
        return [y,
                torch.flip(y, [-1]),
                torch.flip(y, [-2]),
                torch.rot90(y, 3, (-2, -1)),
                torch.rot90(y, 2, (-2, -1)),
                torch.rot90(y, 1, (-2, -1))][i]
    outs = []
    for i, v in enumerate(views(img_resized_t)):
        p = logits_to_prob(model(v))
        outs.append(invert(i, p))
    return torch.stack(outs, 0).mean(0)


# -------- simple helpers --------
def largest_component(mask_np: np.ndarray) -> np.ndarray:
    if mask_np.sum() == 0: return mask_np
    lab = measure.label(mask_np, connectivity=2)
    ids, cnt = np.unique(lab[lab > 0], return_counts=True)
    return (lab == ids[np.argmax(cnt)]).astype(np.uint8)

def morph_clean(mask_np: np.ndarray, min_size=200, close=3, open_=2, fill_holes=True) -> np.ndarray:
    m = morphology.remove_small_objects(mask_np.astype(bool), min_size=min_size)
    if close > 0: m = morphology.binary_closing(m, morphology.disk(close))
    if open_ > 0: m = morphology.binary_opening(m, morphology.disk(open_))
    if fill_holes: m = ndi.binary_fill_holes(m)
    return m.astype(np.uint8)

def to_uint8_from_01(arr01: np.ndarray) -> np.ndarray:
    arr01 = np.clip(arr01, 0.0, 1.0)
    return (arr01 * 255.0).round().astype(np.uint8)


# -------- CRF --------
def densecrf_refine(gray_u8: np.ndarray, prob_fg: np.ndarray,
                    iters=5, sxy=50, srgb=3, compat=4) -> np.ndarray:
    """DenseCRF guided by grayscale image -> uint8 binary."""
    if not _HAS_CRF:
        warnings.warn("pydensecrf not installed; skipping CRF.")
        return (prob_fg >= 0.5).astype(np.uint8)
    H, W = gray_u8.shape
    probs = np.stack([1.0 - prob_fg, prob_fg], axis=0).astype(np.float32)
    d = dcrf.DenseCRF2D(W, H, 2)
    d.setUnaryEnergy(unary_from_softmax(probs))
    rgb = np.repeat(gray_u8[..., None], 3, axis=2)
    pair = create_pairwise_bilateral(sdims=(sxy, sxy), schan=(srgb, srgb, srgb), img=rgb, chdim=2)
    d.addPairwiseEnergy(pair, compat=compat)
    Q = np.array(d.inference(iters)).reshape(2, H, W)
    return (Q[1] > Q[0]).astype(np.uint8)


# -------- Ellipse (your exact version, with small safety) --------
def fit_ellipse_with_contours(predicted_mask):
    try:
        import cv2
    except Exception:
        print("OpenCV not installed; skipping ellipse fit.")
        return predicted_mask
    binary_mask = (predicted_mask.astype(np.uint8)) * 255
    contours, _ = cv2.findContours(binary_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    if len(contours) == 0:
        print("No contours found in the mask.")
        return predicted_mask
    largest_contour = max(contours, key=cv2.contourArea)
    if len(largest_contour) >= 5:
        ellipse = cv2.fitEllipse(largest_contour)
        ellipse_mask = np.zeros_like(binary_mask)
        cv2.ellipse(ellipse_mask, ellipse, (255, 255, 255), thickness=-1)
        return ellipse_mask > 0
    else:
        print("Not enough points to fit an ellipse.")
        return predicted_mask


__all__ = [
    "logits_to_prob", "tta_mean_prob_on_resized",
    "largest_component", "morph_clean",
    "watershed_split", "keep_largest_label", "to_uint8_from_01",
    "densecrf_refine", "chan_vese_refine_safe", "fit_ellipse_with_contours",
]
