import math
import numpy as np
import pandas as pd

from inference import run_inference
import configs
from age_cal import compute_hc_mm_from_mask, ga_weeks_from_hc_intergrowth 


# ---------------- Excel helpers ----------------

def _find_header_row(df_raw: pd.DataFrame) -> int:
    """Find the row that contains GA/Race/Measure headers."""
    targets = {"Gestational Age (weeks)", "Race", "Measure"}
    for i in range(min(len(df_raw), 25)):
        vals = df_raw.iloc[i].astype(str).str.replace("\n", " ").str.strip().tolist()
        if targets.issubset(set(vals)):
            return i
    return 0  # fallback

def _canon_colname(s: str) -> str:
    s = (s or "").replace("\n", " ").strip()
    remap = {
        "Gestational Age (weeks)": "GA",
        "Race": "Race",
        "Measure": "Measure",
        "3rd Percentile": "3rd Percentile",
        "5th Percentile": "5th Percentile",
        "10th Percentile": "10th Percentile",
        "50th Percentile": "50th Percentile",
        "90th Percentile": "90th Percentile",
        "95th Percentile": "95th Percentile",
        "97th Percentile": "97th Percentile",
    }
    return remap.get(s, s)

def load_headcirc_table(excel_path: str, sheet_name: str = "Table 1") -> pd.DataFrame:
    """Load the Excel and return only Head Circ. rows with clean numeric columns."""
    df_raw = pd.read_excel(excel_path, sheet_name=sheet_name, header=None)
    hdr = _find_header_row(df_raw)
    header = df_raw.iloc[hdr].astype(str).map(lambda x: x.replace("\n", " ").strip())
    df = df_raw.iloc[hdr+1:].copy()
    df.columns = [_canon_colname(c) for c in header]

    # keep necessary columns
    cols = ["GA", "Race", "Measure"] + [c for c in configs.PCT_COLS if c in df.columns]
    df = df[[c for c in cols if c in df.columns]].copy()

    # filter Head Circ.
    df["Measure"] = df["Measure"].astype(str)
    m = df["Measure"].str.lower().str.contains("head") & df["Measure"].str.lower().str.contains("circ")
    hc_df = df[m].copy()
    if hc_df.empty:
        raise ValueError("No 'Head Circ.' rows found in Excel (Measure column).")

    # types
    hc_df["GA"] = pd.to_numeric(hc_df["GA"], errors="coerce")
    for c in configs.PCT_COLS:
        if c in hc_df.columns:
            hc_df[c] = pd.to_numeric(hc_df[c], errors="coerce")
    hc_df = hc_df.dropna(subset=["GA"]).sort_values("GA").reset_index(drop=True)

    # clean Race
    hc_df["Race"] = hc_df["Race"].astype(str).str.strip()
    return hc_df

def cutoffs_exact_at_nearest_ga(hc_df: pd.DataFrame, race: str, ga_weeks: float) -> tuple[dict, float]:
    """
    Select the nearest GA row for the exact 'Race' and return the exact cutoffs.
    Raises ValueError if race not one of the 4 allowed options.
    """
    if race not in configs.ALLOWED_RACES:
        raise ValueError(f"Invalid race '{race}'. Allowed: {sorted(configs.ALLOWED_RACES)}")

    sub = hc_df[hc_df["Race"].eq(race)].sort_values("GA")
    if sub.empty:
        raise ValueError(f"No rows for race '{race}' in Excel.")

    ga_vals = sub["GA"].values.astype(float)
    idx = int(np.abs(ga_vals - ga_weeks).argmin())
    row = sub.iloc[idx]
    used_ga = float(row["GA"])

    cut = {}
    for c in configs.PCT_COLS:
        if c in sub.columns:
            cut[c] = float(row[c])
    return cut, used_ga

# ---------------- percentile band + classification ----------------

def percentile_band_from_cutoffs(hc_mm: float, cut: dict) -> str:
    """
    Return a discrete band label using exact cutoffs:
    <3rd, 3rd–5th, 5th–10th, 10th–50th, 50th–90th, 90th–95th, 95th–97th, >=97th
    """
    c3  = cut.get("3rd Percentile")
    c5  = cut.get("5th Percentile")
    c10 = cut.get("10th Percentile")
    c50 = cut.get("50th Percentile")
    c90 = cut.get("90th Percentile")
    c95 = cut.get("95th Percentile")
    c97 = cut.get("97th Percentile")

    if any(v is None or math.isnan(v) for v in [c3, c5, c10, c50, c90, c95, c97]):
        return "unknown"

    if hc_mm < c3:          return "<3rd"
    if hc_mm < c5:          return "3rd–5th"
    if hc_mm < c10:         return "5th–10th"
    if hc_mm < c50:         return "10th–50th"
    if hc_mm < c90:         return "50th–90th"
    if hc_mm < c95:         return "90th–95th"
    if hc_mm < c97:         return "95th–97th"
    return ">=97th"

def classify_hc(hc_mm: float, cut: dict) -> str:
    """microcephaly (<3rd), macrocephaly (>97th), else normal."""
    c3  = cut.get("3rd Percentile")
    c97 = cut.get("97th Percentile")
    if c3 is None or c97 is None or math.isnan(c3) or math.isnan(c97):
        return "unknown"
    if hc_mm < c3:
        return "microcephaly"
    if hc_mm > c97:
        return "macrocephaly"
    return "normal"

# ---------------- main utility (no argparse) ----------------

def hc_abnormality_from_image_exact(
    image_path: str,
    pixel_size_mm: float,
    model_path: str,
    race: str,
    excel_path: str = "/mnt/data/FGCalculatorPercentileRange.xlsx",
    sheet_name: str = "Table 1",
):
    """
    1) Segment head -> HC (mm)
    2) GA (weeks) from HC (your function)
    3) Pick nearest GA row for the exact 'race'
    4) Use exact percentile cutoffs from that row
    5) Return band + classification
    """
    # 1) segmentation
    pack = run_inference(model_path, image_path)
    mask = pack["prediction"]  # (H,W) uint8 {0,1}

    # 2) HC + GA
    hc_mm = compute_hc_mm_from_mask(mask, pixel_size_mm)
    ga_weeks = ga_weeks_from_hc_intergrowth(hc_mm)

    # 3) Excel -> exact cutoffs at nearest GA
    hc_table = load_headcirc_table(excel_path, sheet_name=sheet_name)
    cut_mm, ga_used = cutoffs_exact_at_nearest_ga(hc_table, race=race, ga_weeks=ga_weeks)

    # 4) band + classification
    band = percentile_band_from_cutoffs(hc_mm, cut_mm)
    label = classify_hc(hc_mm, cut_mm)

    return {
        "image_path": image_path,
        "race": race,
        "pixel_size_mm": float(pixel_size_mm),
        "hc_mm": float(hc_mm),
        "ga_weeks_from_hc": float(ga_weeks),
        "ga_used_from_table": float(ga_used),   # the GA row we used (exact from sheet)
        "percentile_band": band,                # e.g., "90th–95th"
        "classification": label,                # normal / microcephaly / macrocephaly
        "cutoffs_mm_at_ga": cut_mm,            # exact numbers from the sheet
    }

# ---------- example (edit and run) ----------
if __name__ == "__main__":
    image_path    = "data/validation_set/805_HC.png"
    pixel_size_mm = configs.PIXEL_SIZE_MM  # <-- real spacing
    model_path    = configs.BEST_MODEL_SAVE_PATH
    race          = "Asian & Pacific Islander"  # <-- must be one of ALLOWED_RACES
    excel_path    = configs.PERCENTILE_RANGE_PATH

    result = hc_abnormality_from_image_exact(
        image_path=image_path,
        pixel_size_mm=pixel_size_mm,
        model_path=model_path,
        race=race,
        excel_path=excel_path,
        sheet_name= configs.SHEET_NAME,
    )

    # pretty print with exact (no interpolation) values; rounded only for display
    cut_disp = {k: round(v, 2) for k, v in result["cutoffs_mm_at_ga"].items()}
    print(
        f"[HC Abnormality — Exact Sheet Values]\n"
        f"  Image: {result['image_path']}\n"
        f"  Race: {result['race']}\n"
        f"  HC: {result['hc_mm']:.2f} mm\n"
        f"  GA (from HC): {result['ga_weeks_from_hc']:.2f} weeks\n"
        f"  GA row used from sheet: {result['ga_used_from_table']:.2f} weeks\n"
        f"  Percentile band: {result['percentile_band']}\n"
        f"  Classification: {result['classification']}\n"
        f"  Cutoffs (mm) @ GA: {cut_disp}\n"
    )
