import torch

DEVICE = torch.device("mps" if torch.backends.mps.is_available() else "cpu")

ALLOWED_RACES = [
    "Non-Hispanic White",
    "Non-Hispanic Black",
    "Hispanic",
    "Asian & Pacific Islander",
]

PCT_COLS = [
    "3rd Percentile", "5th Percentile", "10th Percentile",
    "50th Percentile", "90th Percentile", "95th Percentile", "97th Percentile"
]

IMAGE_SIZE = 256
IMAGE_RESIZE_PRE_LEARANBLE_RESIZER = 512
NUM_EPOCHS = 100
PATIENCE = 5
LEARNING_RATE = 1e-4
LR_PATIENCE = 2
LR_FACTOR = 0.5
MODEL_INPUT_CHANNELS = 1
BATCH_SIZE = 8
NUM_CLASSES = 2
MAIN_DIR = 'data/'
BEST_MODEL_SAVE_PATH = "models/best.pt"
LATEST_MODEL_SAVE_PATH = "models/latest.pt"
PRED_PATH = "predictions" 
PERCENTILE_RANGE_PATH = "data/FGCalculatorPercentileRange.xlsx"
THRESHOLD = 0.5 
GA_UPPER_LIMIT = 42
GA_LOWER_LIMIT = 10
PIXEL_SIZE_MM = 0.15
SHEET_NAME = "Table 1"