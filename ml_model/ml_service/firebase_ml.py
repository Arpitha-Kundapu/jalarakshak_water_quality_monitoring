import os
import time
import warnings

import pandas as pd
import joblib
import firebase_admin

from firebase_admin import credentials
from firebase_admin import db


# ============================================================
# SUPPRESS ONLY THE SKLEARN VERSION WARNING
# ============================================================

warnings.filterwarnings(
    "ignore",
    category=UserWarning,
    module="sklearn"
)


# ============================================================
# PATHS
# ============================================================

BASE_DIR = os.path.dirname(
    os.path.abspath(__file__)
)

MODEL_PATH = os.path.join(
    BASE_DIR,
    "..",
    "jalrakshak_random_forest.pkl"
)

SERVICE_ACCOUNT_PATH = os.path.join(
    BASE_DIR,
    "firebase-service-account.json"
)


# ============================================================
# FIREBASE
# ============================================================

FIREBASE_DATABASE_URL = (
    "https://jalrakshak-app-26-default-rtdb."
    "asia-southeast1.firebasedatabase.app"
)


# ============================================================
# START
# ============================================================

print("=" * 50)
print("       JALRAKSHAK FIREBASE ML SERVICE")
print("=" * 50)


# ============================================================
# CONNECT TO FIREBASE
# ============================================================

if not firebase_admin._apps:

    cred = credentials.Certificate(
        SERVICE_ACCOUNT_PATH
    )

    firebase_admin.initialize_app(
        cred,
        {
            "databaseURL": FIREBASE_DATABASE_URL
        }
    )

print("Firebase connected successfully!")


# ============================================================
# LOAD RANDOM FOREST MODEL
# ============================================================

model = joblib.load(
    MODEL_PATH
)

print("Random Forest model loaded successfully!")

print("Model classes:")
print(model.classes_)


# ============================================================
# FIREBASE REFERENCES
# ============================================================

latest_ref = db.reference(
    "/devices/device_001/latest"
)

prediction_ref = db.reference(
    "/devices/device_001/prediction"
)


# ============================================================
# FUNCTION: MAKE PREDICTION
# ============================================================

def make_prediction(data):

    # --------------------------------------------------------
    # Check Firebase data
    # --------------------------------------------------------

    if not data:

        print("No sensor data found.")

        return


    # --------------------------------------------------------
    # Read sensor values
    # --------------------------------------------------------

    tds = float(
        data.get("tds_mg_L", 0)
    )

    turbidity = float(
        data.get("turbidity_NTU", 0)
    )


    # --------------------------------------------------------
    # Display sensor values
    # --------------------------------------------------------

    print()
    print("=" * 50)
    print("SENSOR DATA")
    print("=" * 50)

    print(
        f"TDS: {tds:.2f} mg/L"
    )

    print(
        f"Turbidity: {turbidity:.2f} NTU"
    )


    # --------------------------------------------------------
    # CREATE DATAFRAME
    #
    # This keeps the exact feature names used during training.
    # --------------------------------------------------------

    features = pd.DataFrame(
        {
            "TDS_mg_L": [tds],
            "Turbidity_NTU": [turbidity]
        }
    )


    # --------------------------------------------------------
    # RANDOM FOREST PREDICTION
    # --------------------------------------------------------

    prediction = model.predict(
        features
    )[0]


    # --------------------------------------------------------
    # PROBABILITIES
    # --------------------------------------------------------

    probabilities = {}

    if hasattr(model, "predict_proba"):

        probability_values = model.predict_proba(
            features
        )[0]

        for class_name, probability in zip(
            model.classes_,
            probability_values
        ):

            # Firebase keys cannot contain /
            safe_name = str(
                class_name
            ).replace(
                "/",
                "_"
            )

            probabilities[safe_name] = round(
                float(probability) * 100,
                2
            )


    # --------------------------------------------------------
    # DISPLAY RESULT
    # --------------------------------------------------------

    print()
    print("=" * 50)
    print("       JALRAKSHAK ML PREDICTION")
    print("=" * 50)

    print(
        "Classification:",
        prediction
    )

    print(
        "Probabilities:",
        probabilities
    )


    # --------------------------------------------------------
    # SAVE PREDICTION TO FIREBASE
    # --------------------------------------------------------

    prediction_data = {

        "classification":
            str(prediction),

        "tds_mg_L":
            tds,

        "turbidity_NTU":
            turbidity,

        "probabilities":
            probabilities,

        "timestamp":
            int(time.time() * 1000)
    }


    prediction_ref.set(
        prediction_data
    )


    print()
    print("=" * 50)
    print("Prediction saved to Firebase successfully!")
    print("=" * 50)

    print(
        "/devices/device_001/prediction"
    )


# ============================================================
# CONTINUOUS MONITORING
# ============================================================

print()
print("=" * 50)
print("ML SERVICE IS NOW MONITORING FIREBASE")
print("=" * 50)

print(
    "Waiting for new ESP32 sensor readings..."
)

print()


last_timestamp = None


while True:

    try:

        # ----------------------------------------------------
        # Read latest Firebase data
        # ----------------------------------------------------

        data = latest_ref.get()


        if data:

            current_timestamp = data.get(
                "timestamp"
            )


            # ------------------------------------------------
            # Only predict when a NEW reading arrives
            # ------------------------------------------------

            if current_timestamp != last_timestamp:

                last_timestamp = current_timestamp

                make_prediction(
                    data
                )

            else:

                print(
                    "Waiting for new sensor data...",
                    end="\r"
                )


        else:

            print(
                "Waiting for Firebase sensor data...",
                end="\r"
            )


        # ----------------------------------------------------
        # Check every 5 seconds
        # ----------------------------------------------------

        time.sleep(5)


    except KeyboardInterrupt:

        print()
        print()
        print(
            "ML service stopped."
        )

        break


    except Exception as e:

        print()
        print(
            "Error:",
            e
        )

        print(
            "Retrying in 5 seconds..."
        )

        time.sleep(5)