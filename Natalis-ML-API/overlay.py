import cv2
import numpy as np


def draw_head_analysis(image: np.ndarray, mask: np.ndarray, hc_mm: float, pixel_size_mm: float) -> np.ndarray:
    """
    Draw fetal head ellipse, diameters, endpoints, and labels on the original image.
    """

    # Resize mask to original image size
    orig_h, orig_w = image.shape[:2]
    mask_resized = cv2.resize((mask * 255).astype(np.uint8), (orig_w, orig_h), interpolation=cv2.INTER_NEAREST)

    # Convert image to BGR
    if image.max() <= 1.0:
        img_disp = (image * 255).astype(np.uint8)
    else:
        img_disp = image.astype(np.uint8)
    img_disp = cv2.cvtColor(img_disp, cv2.COLOR_GRAY2BGR)

    # Find largest contour
    cnts, _ = cv2.findContours(mask_resized, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    if not cnts:
        return img_disp
    largest = max(cnts, key=cv2.contourArea)
    if len(largest) < 5:
        return img_disp

    # Fit ellipse
    (cx, cy), (major_px, minor_px), angle = cv2.fitEllipse(largest)

    # Draw ellipse
    cv2.ellipse(img_disp, ((int(cx), int(cy)), (int(major_px), int(minor_px)), angle), (0, 255, 0), 2)

    # Compute axes endpoints
    angle_rad = np.deg2rad(angle)
    dx_major = (major_px / 2) * np.cos(angle_rad)
    dy_major = (major_px / 2) * np.sin(angle_rad)
    dx_minor = (minor_px / 2) * np.sin(angle_rad)
    dy_minor = (minor_px / 2) * np.cos(angle_rad)

    # Major axis
    pt1 = (int(cx - dx_major), int(cy - dy_major))
    pt2 = (int(cx + dx_major), int(cy + dy_major))
    cv2.line(img_disp, pt1, pt2, (0, 0, 255), 2)  # Red line
    cv2.circle(img_disp, pt1, 3, (0, 0, 255), -1)
    cv2.circle(img_disp, pt2, 3, (0, 0, 255), -1)
    cv2.putText(img_disp, f"{major_px*pixel_size_mm:.1f} mm", (pt2[0]+5, pt2[1]),
                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1)

    # Minor axis
    pt3 = (int(cx - dx_minor), int(cy + dy_minor))
    pt4 = (int(cx + dx_minor), int(cy - dy_minor))
    cv2.line(img_disp, pt3, pt4, (255, 0, 0), 2)  # Blue line
    cv2.circle(img_disp, pt3, 3, (255, 0, 0), -1)
    cv2.circle(img_disp, pt4, 3, (255, 0, 0), -1)
    cv2.putText(img_disp, f"{minor_px*pixel_size_mm:.1f} mm", (pt4[0]+5, pt4[1]),
                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 1)

    # Head circumference
    cv2.putText(img_disp, f"HC: {hc_mm:.1f} mm", (max(int(cx-50),0), max(int(cy-10),0)),
                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

    return img_disp
