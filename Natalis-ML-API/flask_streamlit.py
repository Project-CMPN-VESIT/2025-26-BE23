import streamlit as st
import requests
from PIL import Image
import io
import datetime
import base64

# --- Configuration ---
FLASK_API_URL = "http://127.0.0.1:5003"

st.set_page_config(page_title="Natalis API Tester", layout="wide")

st.title("🔬 Natalis Backend API Tester")
st.markdown(
    "Send an ultrasound image to the Flask API and visualize results (JSON + annotated image)."
)

# --- Sidebar Inputs ---
with st.sidebar:
    st.header("API Parameters")
    ALLOWED_RACES = ["Asian & Pacific Islander", "Black", "White", "Hispanic"]
    race = st.selectbox("Race", ALLOWED_RACES)
    scan_date = st.date_input("Scan Date", value=datetime.date.today())
    pixel_size_mm = st.slider("Pixel Size (mm/pixel)", 0.01, 0.50, 0.17, 0.01, format="%.2f")
    uploaded_file = st.file_uploader("Upload Ultrasound Image", type=["png", "jpg", "jpeg"])

# --- Main Logic ---
if uploaded_file is not None:
    st.subheader("Image uploaded. Sending to Flask API...")

    # Prepare files and form data
    files = {"image": (uploaded_file.name, uploaded_file.getvalue(), uploaded_file.type)}
    form_data = {
        "race": race,
        "scan_date": scan_date.strftime("%Y-%m-%d"),
        "pixel_size_mm": str(pixel_size_mm)
    }

    try:
        # --- Step 1: Analyze image ---
        with st.spinner("Sending image to /api/analyze_image ..."):
            response = requests.post(f"{FLASK_API_URL}/api/analyze_image", files=files, data=form_data)
            response.raise_for_status()
            analysis_data = response.json()

        if analysis_data.get("status") != "success":
            st.error(f"API Error: {analysis_data.get('error', 'Unknown Error')}")
            st.json(analysis_data)
            st.stop()

        st.success("✅ Analysis completed!")

        annotated_image_id = analysis_data["annotated_image_id"]

        # --- Step 2: Get Base64 Annotated Image ---
        with st.spinner("Retrieving annotated image ..."):
            image_response = requests.get(f"{FLASK_API_URL}/api/get_annotated_image/{annotated_image_id}")
            image_response.raise_for_status()
            image_json = image_response.json()

        b64_str = image_json["image_base64"].split(",")[1]  # remove "data:image/png;base64,"
        annotated_image = Image.open(io.BytesIO(base64.b64decode(b64_str)))

        # --- Display JSON + Image side by side ---
        col_json, col_image = st.columns(2)
        with col_json:
            st.subheader("Analysis JSON Output")
            st.json(analysis_data)

        with col_image:
            st.subheader("Annotated Image")
            st.image(annotated_image, caption="Annotated Image from Flask API", use_container_width=True)

        # --- Display Key Metrics ---
        st.markdown("---")
        st.subheader("Key Biometry Results")
        metrics_col1, metrics_col2, metrics_col3 = st.columns(3)
        metrics_col1.metric("Head Circumference (HC)", f"{analysis_data.get('hc_mm', 'N/A')} mm")
        metrics_col2.metric("Gestational Age (GA)", f"{analysis_data.get('ga_weeks', 'N/A')} weeks")
        metrics_col3.metric("Classification", analysis_data.get('classification', 'N/A'))

    except requests.exceptions.RequestException as e:
        st.error(f"❌ Connection Error: Could not reach the Flask API at {FLASK_API_URL}.")
        st.warning("Ensure your Flask server is running!")
        st.exception(e)