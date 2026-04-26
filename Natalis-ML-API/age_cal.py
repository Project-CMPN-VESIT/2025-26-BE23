from typing import Optional

import numpy as np
import cv2
import math

from inference import run_inference
import configs

def compute_hc_mm_from_mask(mask_01: np.ndarray, pixel_size_mm: float) -> float:
    """
    Compute head circumference (HC) in millimeters from a binary head mask.

    Parameters
    ----------
    mask_01 : np.ndarray
        (H, W) array with {0,1} foreground.
        Works whether it’s your raw prediction or the ellipse-filled mask.
    pixel_size_mm : float
        Millimeters per pixel (e.g., 0.12 for 0.12 mm/pixel).

    Returns
    -------
    float
        Head circumference in millimeters.
    """
    if mask_01.dtype != np.uint8:
        mask_01 = mask_01.astype(np.uint8)
    mask_u8 = (mask_01 * 255).astype(np.uint8)

    cnts, _ = cv2.findContours(mask_u8, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    if not cnts:
        raise ValueError("No contours found in mask.")

    largest = max(cnts, key=cv2.contourArea)
    if len(largest) < 5:
        raise ValueError("Not enough points to fit an ellipse (need >=5).")

    # fitEllipse returns: ((cx, cy), (major_axis_px, minor_axis_px), angle_deg)
    (_, _), (major_px, minor_px), _ = cv2.fitEllipse(largest)

    # Convert to semi-axes in mm
    a_mm = (major_px * pixel_size_mm) / 2.0  # semi-major
    b_mm = (minor_px * pixel_size_mm) / 2.0  # semi-minor

    # Ramanujan II approximation for ellipse circumference:
    # C ≈ π * [3(a+b) - sqrt((3a+b)(a+3b))]
    hc_mm = np.pi * (3.0 * (a_mm + b_mm) - np.sqrt((3.0 * a_mm + b_mm) * (a_mm + 3.0 * b_mm)))
    return float(hc_mm)
def ga_weeks_from_hc_intergrowth(hc_mm: float) -> Optional[float]:
    """Return GA in weeks or None if HC outside valid range."""
    if hc_mm <= 0:
        return None
    ga_days = math.exp(0.05970 * (math.log(hc_mm))**2 + 6.409e-9 * (hc_mm**3) + 3.3258)
    ga_weeks = ga_days / 7.0
    if ga_weeks < configs.GA_LOWER_LIMIT or ga_weeks > configs.GA_UPPER_LIMIT:
        return None
    return ga_weeks


# if __name__ == "__main__":
#     # ---- Run your existing inference pipeline ----
#     pack = run_inference(
#         configs.BEST_MODEL_SAVE_PATH,
#         "data/validation_set/718_2HC.png"
#     )
#     pred_mask = pack["prediction"]  # (H,W) uint8 {0,1}

#     # ---- Set the correct pixel spacing (mm/pixel) ----
#     # Replace this with your actual value from metadata.
#     pixel_size_mm = configs.PIXEL_SIZE_MM

#     hc_mm = compute_hc_mm_from_mask(pred_mask, pixel_size_mm)
#     print(f"Head Circumference (HC): {hc_mm:.2f} mm ({hc_mm/10:.2f} cm)")
#     ga_days = ga_weeks_from_hc_intergrowth(hc_mm=hc_mm)
#     print(f"Gestational Age (GA) {ga_days:.2f} weeks")
