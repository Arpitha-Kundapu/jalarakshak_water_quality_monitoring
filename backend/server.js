const express = require("express");
const cors = require("cors");
const axios = require("axios");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const USERS_FILE = path.join(__dirname, "users.json");

// Helper to read users
function readUsers() {
  try {
    if (!fs.existsSync(USERS_FILE)) {
      return [];
    }
    const data = fs.readFileSync(USERS_FILE, "utf8");
    return JSON.parse(data || "[]");
  } catch (error) {
    console.error("Error reading users file:", error.message);
    return [];
  }
}

// Helper to write users
function writeUsers(users) {
  try {
    fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2), "utf8");
  } catch (error) {
    console.error("Error writing users file:", error.message);
  }
}

// Password hashing function using built-in crypto
function hashPassword(password) {
  const salt = "jalrakshak_salt_value";
  const hash = crypto.pbkdf2Sync(password, salt, 1000, 64, "sha512").toString("hex");
  return hash;
}

// Initialize database with default user if empty
const users = readUsers();
if (users.length === 0) {
  users.push({
    name: "JalRakshak User",
    email: "test@jalrakshak.com",
    passwordHash: hashPassword("123456"),
    createdAt: new Date().toISOString(),
  });
  writeUsers(users);
}

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

    const trimmedEmail = email.trim().toLowerCase();
    const usersList = readUsers();
    const user = usersList.find((u) => u.email.toLowerCase() === trimmedEmail);

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password",
      });
    }

    const calculatedHash = hashPassword(password);
    if (user.passwordHash !== calculatedHash) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password",
      });
    }

    return res.json({
      success: true,
      message: "Login successful",
      user: {
        email: user.email,
        name: user.name,
      },
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
// REGISTER ROUTE
// --------------------------------------------------

app.post("/api/register", (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: "Name, email, and password are required",
      });
    }

    const trimmedEmail = email.trim().toLowerCase();

    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        message: "Password must be at least 6 characters long",
      });
    }

    const usersList = readUsers();
    const userExists = usersList.some((u) => u.email.toLowerCase() === trimmedEmail);

    if (userExists) {
      return res.status(409).json({
        success: false,
        message: "An account with this email address already exists",
      });
    }

    const newUser = {
      name: name.trim(),
      email: trimmedEmail,
      passwordHash: hashPassword(password),
      createdAt: new Date().toISOString(),
    };

    usersList.push(newUser);
    writeUsers(usersList);

    return res.status(201).json({
      success: true,
      message: "User registered successfully",
      user: {
        email: newUser.email,
        name: newUser.name,
      },
    });

  } catch (error) {
    console.error("Registration Error:", error.message);

    return res.status(500).json({
      success: false,
      message: "Server error during registration",
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