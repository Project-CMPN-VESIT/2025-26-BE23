import streamlit as st
import numpy as np
import torch
from PIL import Image
import io
from pathlib import Path
import math
import pandas as pd
import plotly.graph_objects as go
import plotly.express as px

from inference import run_inference, plot_results
import configs

# ---------------- Imports for HC / GA ----------------
from overlay import draw_head_analysis
from age_cal import compute_hc_mm_from_mask, ga_weeks_from_hc_intergrowth
from abnormality import load_headcirc_table, cutoffs_exact_at_nearest_ga, percentile_band_from_cutoffs, classify_hc
from datetime import datetime, timedelta

# -------------------- Page Configuration --------------------
st.set_page_config(
    page_title="Natalis",

    layout="wide",
    initial_sidebar_state="expanded"
)

# -------------------- Custom CSS --------------------
st.markdown("""
    <style>
    /* Main background and colors */
    .main {
        background: linear-gradient(135deg, #f5f7fa 0%, #e8eef5 100%);
    }

    /* Header styling */
    .main-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        margin-bottom: 2rem;
        text-align: center;
    }

    .main-header h1 {
        color: white;
        font-size: 2.5rem;
        margin: 0;
        font-weight: 700;
    }

    .main-header p {
        color: rgba(255,255,255,0.9);
        font-size: 1.1rem;
        margin-top: 0.5rem;
    }

    /* Metric cards */
    .metric-card {
        background: white;
        padding: 1.5rem;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        border-left: 4px solid #667eea;
        margin-bottom: 1rem;
        transition: transform 0.2s;
    }

    .metric-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.12);
    }

    .metric-label {
        color: #666;
        font-size: 0.9rem;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .metric-value {
        color: #333;
        font-size: 2rem;
        font-weight: 700;
        margin-top: 0.3rem;
    }

    /* Status badges */
    .status-badge {
        display: inline-block;
        padding: 0.4rem 1rem;
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.9rem;
        margin-top: 0.5rem;
    }

    .status-normal {
        background: #d4edda;
        color: #155724;
    }

    .status-warning {
        background: #fff3cd;
        color: #856404;
    }

    .status-alert {
        background: #f8d7da;
        color: #721c24;
    }

    /* Upload section */
    .upload-section {
        background: white;
        padding: 2rem;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        text-align: center;
        border: 2px dashed #667eea;
    }

    /* Image containers */
    .image-container {
        background: white;
        padding: 1rem;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        margin-bottom: 1rem;
    }

    .image-title {
        color: #667eea;
        font-weight: 600;
        font-size: 1.1rem;
        margin-bottom: 0.5rem;
        text-align: center;
    }

    /* Sidebar styling */
    .css-1d391kg {
        background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
    }

    /* Info boxes */
    .info-box {
        background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
        padding: 1.5rem;
        border-radius: 12px;
        border-left: 4px solid #667eea;
        margin: 1rem 0;
    }

    /* Download button enhancement */
    .stDownloadButton button {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 0.75rem 2rem;
        border-radius: 8px;
        font-weight: 600;
        width: 100%;
    }

    .stDownloadButton button:hover {
        box-shadow: 0 6px 20px rgba(102,126,234,0.4);
    }
    </style>
""", unsafe_allow_html=True)

# -------------------- Header --------------------
st.markdown("""
    <div class="main-header">
        <h1>Natalis</h1>
        <p>Advanced Fetal Head Biometry & Gestational Age Assessment</p>
    </div>
""", unsafe_allow_html=True)

# -------------------- Sidebar --------------------
with st.sidebar:






    st.markdown("---")
    st.markdown("### 📅 Scan Information")
    scan_date = st.date_input(
        "Date of Ultrasound Scan",
        value=datetime.now(),
        help="Enter the date when the ultrasound was performed"
    )





# -------------------- Model Setup --------------------
project_root = Path(__file__).resolve().parents[1]
model_path = project_root / "models" / "best.pt"

if not model_path.exists():
    st.error("❌ Model file not found. Please check your installation.")
    st.stop()

excel_path = project_root / "data" / "FGCalculatorPercentileRange.xlsx"

# -------------------- Upload Section --------------------
uploaded_file = st.file_uploader(
    "Upload Fetal Ultrasound Image",
    type=["png", "jpg", "jpeg"],
    help="Supported formats: PNG, JPG, JPEG"
)

if uploaded_file is not None:
    # Create tabs for different views
    tab1, tab2, tab3, tab4 = st.tabs(["📸 Analysis", "📈 Growth Charts", "📋 Detailed Report", "💾 Export"])

    with tab1:
        # Read and process image
        image = Image.open(uploaded_file).convert("L")

        # Display original image in a nice container
        col_upload = st.columns([1, 2, 1])
        with col_upload[1]:

            st.markdown('<p class="image-title">📷 Uploaded Ultrasound Image</p>', unsafe_allow_html=True)
            st.image(image, use_container_width=True)
            st.markdown('</div>', unsafe_allow_html=True)

        # Save temporarily
        temp_path = project_root / "temp_input.png"
        image.save(temp_path)

        # Run inference with progress
        progress_bar = st.progress(0)
        status_text = st.empty()

        status_text.text("🔄 Initializing AI model...")
        progress_bar.progress(25)

        result = run_inference(str(model_path), str(temp_path))
        prediction = result["prediction"]
        input_image = result["input_image"]

        progress_bar.progress(75)
        status_text.text("🧮 Computing measurements...")

        # Compute HC
        pixel_size_mm = configs.PIXEL_SIZE_MM
        hc_mm = compute_hc_mm_from_mask(prediction, pixel_size_mm)

        progress_bar.progress(100)
        status_text.text("✅ Analysis Complete!")



        # Display images in columns
        st.markdown("---")
        col1, col2, col3 = st.columns(3)

        with col1:

            st.markdown('<p class="image-title">🔍 Preprocessed Image</p>', unsafe_allow_html=True)
            st.image(input_image, use_container_width=True, clamp=True)
            st.markdown('</div>', unsafe_allow_html=True)

        with col2:

            st.markdown('<p class="image-title">🎯 Segmentation Mask</p>', unsafe_allow_html=True)
            st.image(prediction * 255, use_container_width=True, clamp=True)
            st.markdown('</div>', unsafe_allow_html=True)

        with col3:
            annotated_img = draw_head_analysis(input_image, prediction, hc_mm, pixel_size_mm)

            st.markdown('<p class="image-title">📐 Annotated Analysis</p>', unsafe_allow_html=True)
            st.image(annotated_img, use_container_width=True)
            st.markdown('</div>', unsafe_allow_html=True)

        # Compute GA and percentiles
        ga_weeks = ga_weeks_from_hc_intergrowth(hc_mm)
        race = st.selectbox("Select Race", options=configs.ALLOWED_RACES)

        # Calculate EDD (Estimated Due Date)
        edd = None
        weeks_remaining = None
        days_remaining = None
        trimester = None

        if ga_weeks is not None:
            # EDD = Scan Date - GA + 280 days (40 weeks)
            ga_days = ga_weeks * 7
            conception_date = scan_date - timedelta(days=ga_days)
            edd = conception_date + timedelta(days=280)

            # Calculate remaining time
            total_days_remaining = (edd - scan_date).days
            weeks_remaining = total_days_remaining // 7
            days_remaining = total_days_remaining % 7

            # Determine trimester
            if ga_weeks < 13:
                trimester = "First Trimester"
            elif ga_weeks < 27:
                trimester = "Second Trimester"
            else:
                trimester = "Third Trimester"

        if ga_weeks is None:
            st.warning("⚠️ Computed GA is outside valid range. Cannot determine percentiles.")
            percentile_band = "Unknown"
            classification = "Unknown"
            cut_mm = {}
            ga_used = None
        else:
            hc_table = load_headcirc_table(excel_path)
            cut_mm, ga_used = cutoffs_exact_at_nearest_ga(hc_table, race=race, ga_weeks=ga_weeks)
            percentile_band = percentile_band_from_cutoffs(hc_mm, cut_mm)
            classification = classify_hc(hc_mm, cut_mm)

        # Display metrics in cards
        st.markdown("---")
        st.markdown("## 📊 Biometric Measurements")

        metric_col1, metric_col2, metric_col3, metric_col4, metric_col5 = st.columns(5)

        with metric_col1:
            st.markdown(f"""
                <div class="metric-card">
                    <div class="metric-label">Head Circumference</div>
                    <div class="metric-value">{hc_mm:.1f} <span style="font-size:1.2rem;">mm</span></div>
                </div>
            """, unsafe_allow_html=True)

        with metric_col2:
            ga_display = f"{ga_weeks:.1f}" if ga_weeks else "N/A"
            st.markdown(f"""
                <div class="metric-card">
                    <div class="metric-label">Gestational Age</div>
                    <div class="metric-value">{ga_display} <span style="font-size:1.2rem;">weeks</span></div>
                </div>
            """, unsafe_allow_html=True)

        with metric_col3:
            edd_display = edd.strftime("%b %d, %Y") if edd else "N/A"
            st.markdown(f"""
                <div class="metric-card">
                    <div class="metric-label">Estimated Due Date</div>
                    <div class="metric-value" style="font-size:1.3rem;">{edd_display}</div>
                </div>
            """, unsafe_allow_html=True)

        with metric_col4:
            st.markdown(f"""
                <div class="metric-card">
                    <div class="metric-label">Percentile Band</div>
                    <div class="metric-value" style="font-size:1.5rem;">{percentile_band}</div>
                </div>
            """, unsafe_allow_html=True)

        with metric_col5:
            status_class = "status-normal" if classification == "Normal" else "status-warning" if "Small" in classification or "Large" in classification else "status-alert"
            st.markdown(f"""
                <div class="metric-card">
                    <div class="metric-label">Classification</div>
                    <div class="status-badge {status_class}">{classification}</div>
                </div>
            """, unsafe_allow_html=True)

        # Add EDD information box
        if edd:
            st.markdown("---")
            col_edd1, col_edd2, col_edd3 = st.columns(3)

            with col_edd1:
                st.markdown(f"""
                    <div class="info-box">
                        <h3>🗓️ Time to Due Date</h3>
                        <p style="font-size:2rem; font-weight:700; color:#667eea; margin:0.5rem 0;">
                            {weeks_remaining} weeks {days_remaining} days
                        </p>
                        <p style="color:#666;">Approximately {total_days_remaining} days remaining</p>
                    </div>
                """, unsafe_allow_html=True)

            with col_edd2:
                st.markdown(f"""
                    <div class="info-box">
                        <h3>📆 Current Status</h3>
                        <p style="font-size:1.5rem; font-weight:700; color:#667eea; margin:0.5rem 0;">
                            Week {int(ga_weeks)} Day {int((ga_weeks % 1) * 7)}
                        </p>
                        <p style="color:#666;">{trimester}</p>
                    </div>
                """, unsafe_allow_html=True)

            with col_edd3:
                # Calculate percentage of pregnancy completed
                pregnancy_progress = (ga_weeks / 40) * 100
                st.markdown(f"""
                    <div class="info-box">
                        <h3>📈 Pregnancy Progress</h3>
                        <p style="font-size:2rem; font-weight:700; color:#667eea; margin:0.5rem 0;">
                            {pregnancy_progress:.1f}%
                        </p>
                        <p style="color:#666;">of 40 weeks completed</p>
                    </div>
                """, unsafe_allow_html=True)

    with tab2:
        st.markdown("## 📈 Fetal Growth Tracking")

        if ga_weeks is not None:
            # Create growth chart
            ga_range = np.linspace(max(12, ga_weeks - 8), min(42, ga_weeks + 8), 50)

            # Sample percentile curves (you should load actual data)
            fig = go.Figure()

            # Add percentile curves (example data - replace with actual percentile data)
            percentiles = [5, 10, 50, 90, 95]
            colors = ['#fee5d9', '#fcae91', '#fb6a4a', '#fcae91', '#fee5d9']

            for p, color in zip(percentiles, colors):
                # This is example data - replace with actual percentile calculations
                hc_curve = 80 + (ga_range - 14) * 8 + (p - 50) * 0.3
                fig.add_trace(go.Scatter(
                    x=ga_range,
                    y=hc_curve,
                    mode='lines',
                    name=f'{p}th percentile',
                    line=dict(color=color, width=2),
                    opacity=0.6
                ))

            # Add current measurement
            fig.add_trace(go.Scatter(
                x=[ga_weeks],
                y=[hc_mm],
                mode='markers',
                name='Current Measurement',
                marker=dict(size=15, color='#667eea', symbol='diamond'),
            ))

            fig.update_layout(
                title='Head Circumference Growth Chart',
                xaxis_title='Gestational Age (weeks)',
                yaxis_title='Head Circumference (mm)',
                hovermode='x unified',
                template='plotly_white',
                height=500
            )

            st.plotly_chart(fig, use_container_width=True)

            # Additional metrics visualization
            col1, col2 = st.columns(2)

            with col1:
                # Gauge chart for percentile
                if percentile_band != "Unknown":
                    # Extract numeric percentile for gauge (simplified)
                    percentile_val = 50  # Default, should parse from percentile_band

                    fig_gauge = go.Figure(go.Indicator(
                        mode="gauge+number",
                        value=percentile_val,
                        domain={'x': [0, 1], 'y': [0, 1]},
                        title={'text': "Percentile Position"},
                        gauge={
                            'axis': {'range': [None, 100]},
                            'bar': {'color': "#667eea"},
                            'steps': [
                                {'range': [0, 10], 'color': "#fee5d9"},
                                {'range': [10, 90], 'color': "#d4edda"},
                                {'range': [90, 100], 'color': "#fee5d9"}
                            ],
                            'threshold': {
                                'line': {'color': "red", 'width': 4},
                                'thickness': 0.75,
                                'value': percentile_val
                            }
                        }
                    ))

                    fig_gauge.update_layout(height=300)
                    st.plotly_chart(fig_gauge, use_container_width=True)

            with col2:
                st.markdown("### Developmental Milestones")

                if ga_weeks is not None and trimester:
                    stage_info = {
                        "First Trimester": {
                            "emoji": "🌱",
                            "desc": "Early development phase - Major organs forming",
                            "milestones": ["Neural tube development", "Heart begins beating", "Limb buds appear"]
                        },
                        "Second Trimester": {
                            "emoji": "🌿",
                            "desc": "Rapid growth phase - Baby becomes more active",
                            "milestones": ["Movement felt by mother", "Hearing develops", "Fingerprints form"]
                        },
                        "Third Trimester": {
                            "emoji": "🌳",
                            "desc": "Final maturation phase - Preparing for birth",
                            "milestones": ["Lungs mature", "Brain develops rapidly", "Weight gain accelerates"]
                        }
                    }

                    if trimester in stage_info:
                        info = stage_info[trimester]
                        st.markdown(f"""
                            <div class="info-box">
                                <h3>{info['emoji']} {trimester}</h3>
                                <p style="font-size:1.1rem;">{info['desc']}</p>
                                <p><strong>Week {int(ga_weeks)}</strong> of pregnancy</p>
                            </div>
                        """, unsafe_allow_html=True)

                        st.markdown("**Key Milestones:**")
                        for milestone in info['milestones']:
                            st.markdown(f"• {milestone}")
                else:
                    st.info("Developmental information requires valid GA measurement.")
        else:
            st.warning("Growth charts require valid GA measurement.")

    with tab3:
        st.markdown("## 📋 Comprehensive Analysis Report")

        # Create detailed report
        report_col1, report_col2 = st.columns(2)

        with report_col1:
            st.markdown("### Measurement Details")

            data = {
                "Parameter": [
                    "Head Circumference",
                    "Gestational Age",
                    "Reference GA",
                    "Scan Date",
                    "Estimated Due Date",
                    "Weeks Remaining",
                    "Trimester",
                    "Percentile Band",
                    "Classification"
                ],
                "Value": [
                    f"{hc_mm:.2f} mm",
                    f"{ga_weeks:.2f} weeks" if ga_weeks else "N/A",
                    f"{ga_used:.2f} weeks" if ga_used else "N/A",
                    scan_date.strftime("%B %d, %Y"),
                    edd.strftime("%B %d, %Y") if edd else "N/A",
                    f"{weeks_remaining} weeks {days_remaining} days" if weeks_remaining is not None else "N/A",
                    trimester if trimester else "N/A",
                    percentile_band,
                    classification
                ]
            }

            df = pd.DataFrame(data)
            st.dataframe(df, use_container_width=True, hide_index=True)

            st.markdown("###  Reference Ranges")
            if cut_mm:
                ref_data = {
                    "Percentile": list(cut_mm.keys()),
                    "HC Value (mm)": [f"{v:.2f}" for v in cut_mm.values()]
                }
                ref_df = pd.DataFrame(ref_data)
                st.dataframe(ref_df, use_container_width=True, hide_index=True)

        with report_col2:
            st.markdown("### Clinical Interpretation")

            if classification == "normal":
                st.success("""
                ✅ **Normal Development**

                The fetal head circumference is within normal limits for the estimated gestational age.
                This indicates appropriate fetal growth.
                """)
            elif "small" in classification:
                st.warning("""
                ⚠️ **Below Average**

                The head circumference is below the expected range. This may warrant follow-up
                ultrasounds to monitor growth trends.
                """)
            elif "large" in classification:
                st.warning("""
                ⚠️ **Above Average**

                The head circumference is above the expected range. Clinical correlation
                is recommended.
                """)
            else:
                st.info("Classification requires valid measurements.")

            if edd:
                st.markdown("### Due Date Information")
                st.markdown(f"""
                <div class="info-box">
                    <h4>Estimated Due Date (EDD)</h4>
                    <p style="font-size:1.3rem; font-weight:700; color:#667eea;">
                        {edd.strftime("%A, %B %d, %Y")}
                    </p>
                    <p><strong>Important Notes:</strong></p>
                    <ul>
                        <li>Only 5% of babies are born on their exact due date</li>
                        <li>Normal term delivery: 37-42 weeks</li>
                        <li>Due date is an estimate, not a deadline</li>
                    </ul>
                </div>
                """, unsafe_allow_html=True)

            st.markdown("### Recommendations")
            st.markdown("""
            - Continue routine prenatal care
            - Follow-up ultrasound as scheduled
            - Discuss results with healthcare provider
            - Maintain healthy pregnancy lifestyle
            - Track fetal movements (after 28 weeks)
            """)

    with tab4:
        st.markdown("## 💾 Export Results")

        col1, col2 = st.columns(2)

        with col1:
            # Download mask
            buf_mask = io.BytesIO()
            out_img = Image.fromarray((prediction * 255).astype(np.uint8))
            out_img.save(buf_mask, format="PNG")

            st.download_button(
                label="📥 Download Segmentation Mask",
                data=buf_mask.getvalue(),
                file_name="fetal_head_mask.png",
                mime="image/png",
            )

        with col2:
            # Download annotated image
            buf_annotated = io.BytesIO()
            annotated_pil = Image.fromarray(annotated_img.astype(np.uint8))
            annotated_pil.save(buf_annotated, format="PNG")

            st.download_button(
                label="📥 Download Annotated Image",
                data=buf_annotated.getvalue(),
                file_name="fetal_head_annotated.png",
                mime="image/png",
            )

        # Generate report data
        report_text = f"""
"""