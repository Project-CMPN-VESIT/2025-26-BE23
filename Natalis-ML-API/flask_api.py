import os
import sys
import io
import base64
import logging
from datetime import timedelta, datetime
from pathlib import Path

from flask import Flask, request, jsonify
from PIL import Image
import numpy as np

# ---------------- LOGGING ----------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)

app = Flask(__name__)

# ---------------- CONFIG ----------------
PROJECT_ROOT = Path(__file__).resolve().parent
MODEL_PATH = PROJECT_ROOT / "models" / "best.pt"
EXCEL_PATH = PROJECT_ROOT / "data" / "FGCalculatorPercentileRange.xlsx"
TEMP_DIR = Path("/tmp/natalis_uploads")
TEMP_DIR.mkdir(exist_ok=True)

# ---------------- LAZY GLOBALS ----------------
INITIALIZED = False
run_inference = None
draw_head_analysis = None
compute_hc_mm_from_mask = None
ga_weeks_from_hc_intergrowth = None
load_headcirc_table = None
cutoffs_exact_at_nearest_ga = None
percentile_band_from_cutoffs = None
classify_hc = None
HC_TABLE = None
configs = None


def initialize():
    """
    Lazy-load all heavy ML modules only AFTER
    Gunicorn has already bound the port.
    """
    global INITIALIZED
    global run_inference, draw_head_analysis
    global compute_hc_mm_from_mask, ga_weeks_from_hc_intergrowth
    global load_headcirc_table, cutoffs_exact_at_nearest_ga
    global percentile_band_from_cutoffs, classify_hc
    global HC_TABLE, configs

    if INITIALIZED:
        return

    logging.info("Initializing ML resources...")

    # Heavy imports moved inside function
    from inference import run_inference as ri
    from overlay import draw_head_analysis as dha
    from age_cal import compute_hc_mm_from_mask as ch
    from age_cal import ga_weeks_from_hc_intergrowth as ga_calc
    from abnormality import (
        load_headcirc_table as lht,
        cutoffs_exact_at_nearest_ga as cut_fn,
        percentile_band_from_cutoffs as band_fn,
        classify_hc as cls_fn
    )
    import configs as cfg

    run_inference = ri
    draw_head_analysis = dha
    compute_hc_mm_from_mask = ch
    ga_weeks_from_hc_intergrowth = ga_calc
    load_headcirc_table = lht
    cutoffs_exact_at_nearest_ga = cut_fn
    percentile_band_from_cutoffs = band_fn
    classify_hc = cls_fn
    configs = cfg

    HC_TABLE = load_headcirc_table(str(EXCEL_PATH))

    INITIALIZED = True
    logging.info("ML resources initialized successfully")


# ---------------- HEALTH ROUTE ----------------
@app.route("/")
def home():
    return "Natalis API Running", 200


# ---------------- CLINICAL CAL ----------------
def calculate_edd_info(ga_weeks, scan_date_str):
    if ga_weeks is None:
        return {"edd": None, "trimester": "N/A", "weeks_remaining": None}

    scan_date = datetime.strptime(scan_date_str, "%Y-%m-%d")
    conception_date = scan_date - timedelta(days=int(ga_weeks * 7))
    edd = conception_date + timedelta(days=280)

    remaining_days = (edd - scan_date).days
    weeks = remaining_days // 7
    days = remaining_days % 7

    trimester = (
        "First Trimester" if ga_weeks < 13 else
        "Second Trimester" if ga_weeks < 27 else
        "Third Trimester"
    )

    return {
        "edd": edd.strftime("%Y-%m-%d"),
        "trimester": trimester,
        "weeks_remaining": f"{weeks} weeks {days} days"
    }


# ---------------- MAIN API ----------------
@app.route("/api/analyze_image", methods=["POST"])
def analyze_image():

    try:
        initialize()  # 🔥 ML loads here, not at startup

        if "image" not in request.files:
            return jsonify({"error": "No image file provided"}), 400

        race = request.form.get("race", configs.ALLOWED_RACES[0])
        scan_date_str = request.form.get("scan_date", datetime.now().strftime("%Y-%m-%d"))

        pixel_size_mm = float(request.form.get("pixel_size_mm", configs.PIXEL_SIZE_MM))

        image_file = request.files["image"]
        img_pil = Image.open(io.BytesIO(image_file.read())).convert("L")

        temp_input_path = TEMP_DIR / "temp.png"
        img_pil.save(temp_input_path)

        result = run_inference(str(MODEL_PATH), str(temp_input_path))

        prediction = result["prediction"]
        input_image_np = result["input_image"]

        hc_mm = compute_hc_mm_from_mask(prediction, pixel_size_mm)
        ga_weeks = ga_weeks_from_hc_intergrowth(hc_mm)

        cut_mm, _ = cutoffs_exact_at_nearest_ga(HC_TABLE, race=race, ga_weeks=ga_weeks)
        percentile_band = percentile_band_from_cutoffs(hc_mm, cut_mm)
        classification = classify_hc(hc_mm, cut_mm)

        clinical_info = calculate_edd_info(ga_weeks, scan_date_str)

        annotated_img_np = draw_head_analysis(
            input_image_np, prediction, hc_mm, pixel_size_mm
        )

        annotated_pil = Image.fromarray(annotated_img_np.astype(np.uint8))

        buffer = io.BytesIO()
        annotated_pil.save(buffer, format="PNG")
        buffer.seek(0)

        encoded_str = base64.b64encode(buffer.read()).decode("utf-8")
        data_uri = f"data:image/png;base64,{encoded_str}"

        return jsonify({
            "status": "success",
            "hc_mm": round(hc_mm, 2),
            "ga_weeks": round(ga_weeks, 2),
            "classification": classification,
            "percentile_band": percentile_band,
            "edd": clinical_info["edd"],
            "trimester": clinical_info["trimester"],
            "weeks_remaining": clinical_info["weeks_remaining"],
            "annotated_image_base64": data_uri
        })

    except Exception as e:
        logging.exception("Unhandled error")
        return jsonify({"error": str(e)}), 500

# ---------- IMAGE RETRIEVAL ----------


#
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5003))
    app.run(
        debug=True,
        host="0.0.0.0",
        port=port,
        # use_reloader=False
    )