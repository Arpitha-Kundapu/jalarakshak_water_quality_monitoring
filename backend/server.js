const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
const PORT = 5000;

// Python ML service
const ML_SERVICE_URL = "http://127.0.0.1:5001";

// --------------------------------------------------
// MIDDLEWARE
// --------------------------------------------------

app.use(cors());
app.use(express.json());

// --------------------------------------------------
// TEST ROUTE
// --------------------------------------------------

app.get("/", (req, res) => {
  res.json({
    message: "JalRakshak Backend is running successfully",
  });
});

// --------------------------------------------------
// LOGIN ROUTE
// --------------------------------------------------

app.post("/api/login", (req, res) => {
  try {
    const { email, password } = req.body;

    // Check whether credentials are provided
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email and password are required",
      });
    }

    // Temporary demo credentials
    // Replace with database authentication later.
    const DEMO_EMAIL = "test@jalrakshak.com";
    const DEMO_PASSWORD = "123456";

    if (email === DEMO_EMAIL && password === DEMO_PASSWORD) {
      return res.json({
        success: true,
        message: "Login successful",
        user: {
          email: email,
          name: "JalRakshak User",
        },
      });
    }

    return res.status(401).json({
      success: false,
      message: "Invalid email or password",
    });

  } catch (error) {
    console.error("Login Error:", error.message);

    return res.status(500).json({
      success: false,
      message: "Server error during login",
    });
  }
});

// --------------------------------------------------
// ML PREDICTION ROUTE
// --------------------------------------------------

app.post("/api/predict", async (req, res) => {
  try {
    const { tds, turbidity } = req.body;

    // Check whether both sensor values are provided
    if (tds === undefined || turbidity === undefined) {
      return res.status(400).json({
        success: false,
        error: "Both tds and turbidity are required",
      });
    }

    // Convert values to numbers
    const tdsValue = Number(tds);
    const turbidityValue = Number(turbidity);

    // Check whether values are numeric
    if (
      Number.isNaN(tdsValue) ||
      Number.isNaN(turbidityValue)
    ) {
      return res.status(400).json({
        success: false,
        error: "TDS and turbidity must be numeric values",
      });
    }

    // Basic validation
    if (tdsValue < 0 || turbidityValue < 0) {
      return res.status(400).json({
        success: false,
        error: "TDS and turbidity cannot be negative",
      });
    }

    // Send sensor data to Python ML service
    const mlResponse = await axios.post(
      `${ML_SERVICE_URL}/predict`,
      {
        tds: tdsValue,
        turbidity: turbidityValue,
      }
    );

    // Return ML result
    return res.json({
      success: true,

      sensor_data: {
        tds: tdsValue,
        turbidity: turbidityValue,
      },

      classification: mlResponse.data.classification,

      probabilities: mlResponse.data.probabilities,
    });

  } catch (error) {
    console.error("ML Service Error:", error.message);

    return res.status(500).json({
      success: false,
      error: "Unable to connect to the JalRakshak ML service",
      details: error.message,
    });
  }
});

// --------------------------------------------------
// START SERVER
// --------------------------------------------------

app.listen(PORT, () => {
  console.log(
    `JalRakshak Backend running on http://localhost:${PORT}`
  );
});