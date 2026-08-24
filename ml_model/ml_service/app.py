from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import os

app = Flask(__name__)
CORS(app)

# --------------------------------------------------
# MODEL LOCATION
# --------------------------------------------------

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

MODEL_PATH = os.path.join(
    BASE_DIR,
    "jalrakshak_random_forest.pkl"
)

# Load trained Random Forest model
model = joblib.load(MODEL_PATH)

print("==============================================")
print("JalRakshak ML Service")
print("==============================================")
print("Random Forest model loaded successfully")
print(f"Model path: {MODEL_PATH}")


# --------------------------------------------------
# HEALTH CHECK
# --------------------------------------------------

@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "JalRakshak ML Service is running",
        "model": "Random Forest",
        "features": [
            "TDS_mg_L",
            "Turbidity_NTU"
        ]
    })


# --------------------------------------------------
# PREDICTION API
# --------------------------------------------------

@app.route("/predict", methods=["POST"])
def predict():

    try:
        # Get JSON data
        data = request.get_json()

        if data is None:
            return jsonify({
                "error": "Request body must contain JSON data"
            }), 400

        # Check required fields
        if "tds" not in data or "turbidity" not in data:
            return jsonify({
                "error": "Both 'tds' and 'turbidity' are required"
            }), 400

        # Convert values to numbers
        tds = float(data["tds"])
        turbidity = float(data["turbidity"])

        # Basic validation
        if tds < 0:
            return jsonify({
                "error": "TDS cannot be negative"
            }), 400

        if turbidity < 0:
            return jsonify({
                "error": "Turbidity cannot be negative"
            }), 400

        # --------------------------------------------------
        # RANDOM FOREST PREDICTION
        # --------------------------------------------------

        features = [[tds, turbidity]]

        prediction = model.predict(features)[0]

        # Get prediction probability if available
        probabilities = {}

        if hasattr(model, "predict_proba"):
            probability_values = model.predict_proba(features)[0]

            for class_name, probability in zip(
                model.classes_,
                probability_values
            ):
                probabilities[str(class_name)] = round(
                    float(probability) * 100,
                    2
                )

        # --------------------------------------------------
        # RESPONSE
        # --------------------------------------------------

        return jsonify({
            "success": True,
            "sensor_data": {
                "tds": tds,
                "turbidity": turbidity
            },
            "classification": str(prediction),
            "probabilities": probabilities
        })

    except ValueError:
        return jsonify({
            "error": "TDS and turbidity must be numeric values"
        }), 400

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500


# --------------------------------------------------
# START SERVER
# --------------------------------------------------

if __name__ == "__main__":

    app.run(
        host="127.0.0.1",
        port=5001,
        debug=False
    )