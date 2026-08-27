from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import os

app = Flask(__name__)
CORS(app)


# ============================================================
# MODEL LOCATION
# ============================================================

BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

MODEL_PATH = os.path.join(
    BASE_DIR,
    "jalrakshak_random_forest.pkl"
)


# ============================================================
# LOAD MODEL
# ============================================================

try:

    model = joblib.load(MODEL_PATH)

    print("==============================================")
    print("        JALRAKSHAK ML SERVICE")
    print("==============================================")
    print("Random Forest model loaded successfully!")
    print("Model path:")
    print(MODEL_PATH)

    print()
    print("Model classes:")
    print(model.classes_)

except Exception as e:

    print("ERROR: Could not load Random Forest model")
    print(e)

    model = None


# ============================================================
# HOME / HEALTH CHECK
# ============================================================

@app.route("/", methods=["GET"])
def home():

    return jsonify({

        "message":
            "JalRakshak ML Service is running",

        "model":
            "Random Forest",

        "features": [
            "TDS_mg_L",
            "Turbidity_NTU"
        ],

        "model_loaded":
            model is not None

    })


# ============================================================
# PREDICTION API
# ============================================================

@app.route("/predict", methods=["POST"])
def predict():

    try:

        # ----------------------------------------------------
        # Check model
        # ----------------------------------------------------

        if model is None:

            return jsonify({
                "error":
                    "ML model is not loaded"
            }), 500


        # ----------------------------------------------------
        # Get JSON
        # ----------------------------------------------------

        data = request.get_json()


        if data is None:

            return jsonify({
                "error":
                    "Request body must contain JSON"
            }), 400


        print()
        print("Received data:")
        print(data)


        # ----------------------------------------------------
        # Get Firebase-compatible fields
        # ----------------------------------------------------

        if (
            "tds_mg_L" not in data
            or
            "turbidity_NTU" not in data
        ):

            return jsonify({

                "error":
                    "Required fields are missing",

                "required": [
                    "tds_mg_L",
                    "turbidity_NTU"
                ],

                "received":
                    list(data.keys())

            }), 400


        # ----------------------------------------------------
        # Convert to numbers
        # ----------------------------------------------------

        tds = float(
            data["tds_mg_L"]
        )

        turbidity = float(
            data["turbidity_NTU"]
        )


        # ----------------------------------------------------
        # Validate values
        # ----------------------------------------------------

        if tds < 0:

            return jsonify({
                "error":
                    "TDS cannot be negative"
            }), 400


        if turbidity < 0:

            return jsonify({
                "error":
                    "Turbidity cannot be negative"
            }), 400


        # ----------------------------------------------------
        # CREATE MODEL INPUT
        # ----------------------------------------------------

        features = [[
            tds,
            turbidity
        ]]


        print()
        print("==============================================")
        print("MODEL INPUT")
        print("==============================================")

        print(
            "TDS_mg_L:",
            tds
        )

        print(
            "Turbidity_NTU:",
            turbidity
        )


        # ----------------------------------------------------
        # RANDOM FOREST PREDICTION
        # ----------------------------------------------------

        prediction = model.predict(
            features
        )[0]


        # ----------------------------------------------------
        # PREDICTION PROBABILITY
        # ----------------------------------------------------

        probabilities = {}


        if hasattr(
            model,
            "predict_proba"
        ):

            probability_values = (
                model.predict_proba(
                    features
                )[0]
            )


            for class_name, probability in zip(

                model.classes_,

                probability_values

            ):

                probabilities[
                    str(class_name)
                ] = round(

                    float(probability) * 100,

                    2

                )


        # ----------------------------------------------------
        # PRINT RESULT
        # ----------------------------------------------------

        print()
        print("PREDICTION:")
        print(prediction)

        print()
        print("PROBABILITIES:")
        print(probabilities)

        print("==============================================")


        # ----------------------------------------------------
        # RETURN RESPONSE
        # ----------------------------------------------------

        return jsonify({

            "success":
                True,

            "sensor_data": {

                "TDS_mg_L":
                    tds,

                "Turbidity_NTU":
                    turbidity

            },

            "classification":
                str(prediction),

            "probabilities":
                probabilities

        })


    # ========================================================
    # VALUE ERROR
    # ========================================================

    except ValueError:

        return jsonify({

            "error":
                "TDS_mg_L and Turbidity_NTU must be numeric"

        }), 400


    # ========================================================
    # OTHER ERROR
    # ========================================================

    except Exception as e:

        print("Prediction error:")
        print(e)

        return jsonify({

            "error":
                str(e)

        }), 500


# ============================================================
# START SERVER
# ============================================================

if __name__ == "__main__":

    app.run(

        host="0.0.0.0",

        port=5001,

        debug=False

    )