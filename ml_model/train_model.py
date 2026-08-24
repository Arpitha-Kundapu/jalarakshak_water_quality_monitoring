import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import joblib

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix
)


# ============================================================
# 1. LOAD DATASET
# ============================================================

file_path = "Jalrakshak.csv"

df = pd.read_csv(
    file_path
)

print("=" * 60)
print("JALRAKSHAK DATASET")
print("=" * 60)

print("Rows:", len(df))
print("Columns:", len(df.columns))

print("\nFirst 5 rows:")
print(df.head())


# ============================================================
# 2. CHECK REQUIRED COLUMNS
# ============================================================

required_columns = [
    "TDS_mg_L",
    "Turbidity_NTU",
    "Usage_Class"
]

for column in required_columns:

    if column not in df.columns:
        raise ValueError(
            f"Column '{column}' not found in dataset."
        )

print("\nRequired columns found successfully.")


# ============================================================
# 3. CHECK MISSING VALUES
# ============================================================

print("\nMissing values:")

print(
    df[
        [
            "TDS_mg_L",
            "Turbidity_NTU",
            "Usage_Class"
        ]
    ].isnull().sum()
)


# Remove rows with missing ML values
df = df.dropna(
    subset=[
        "TDS_mg_L",
        "Turbidity_NTU",
        "Usage_Class"
    ]
)


# ============================================================
# 4. CHECK CLASS DISTRIBUTION
# ============================================================

print("\nClass distribution:")

print(
    df["Usage_Class"].value_counts()
)


# ============================================================
# 5. SELECT INPUT FEATURES
# ============================================================

# These are the two sensors actually available
# in the JalRakshak hardware.

X = df[
    [
        "TDS_mg_L",
        "Turbidity_NTU"
    ]
]


# ============================================================
# 6. SELECT TARGET
# ============================================================

# The model will predict the type of water.

y = df["Usage_Class"]


print("\nInput features:")
print(X.columns.tolist())

print("\nTarget:")
print("Usage_Class")


# ============================================================
# 7. SPLIT DATA
# ============================================================

# 80% → Training
# 20% → Testing

X_train, X_test, y_train, y_test = train_test_split(

    X,
    y,

    test_size=0.20,

    random_state=42,

    stratify=y
)


print("\nTraining records:", len(X_train))
print("Testing records:", len(X_test))


# ============================================================
# 8. CREATE RANDOM FOREST MODEL
# ============================================================

model = RandomForestClassifier(

    n_estimators=200,

    # Helps with our imbalanced classes
    class_weight="balanced",

    random_state=42,

    n_jobs=-1
)


# ============================================================
# 9. TRAIN MODEL
# ============================================================

print("\n" + "=" * 60)
print("TRAINING RANDOM FOREST")
print("=" * 60)

model.fit(
    X_train,
    y_train
)

print("Training completed successfully!")


# ============================================================
# 10. MAKE PREDICTIONS
# ============================================================

y_pred = model.predict(
    X_test
)


# ============================================================
# 11. CALCULATE ACCURACY
# ============================================================

accuracy = accuracy_score(
    y_test,
    y_pred
)


print("\n" + "=" * 60)
print("MODEL ACCURACY")
print("=" * 60)

print(
    f"Accuracy: {accuracy * 100:.2f}%"
)


# ============================================================
# 12. CLASSIFICATION REPORT
# ============================================================

print("\n" + "=" * 60)
print("CLASSIFICATION REPORT")
print("=" * 60)

print(
    classification_report(
        y_test,
        y_pred,
        zero_division=0
    )
)


# ============================================================
# 13. CONFUSION MATRIX
# ============================================================

cm = confusion_matrix(
    y_test,
    y_pred,
    labels=model.classes_
)


plt.figure(
    figsize=(8, 6)
)


sns.heatmap(
    cm,
    annot=True,
    fmt="d",
    cmap="Blues",
    xticklabels=model.classes_,
    yticklabels=model.classes_
)


plt.title(
    "JalRakshak Random Forest Confusion Matrix"
)

plt.xlabel(
    "Predicted Class"
)

plt.ylabel(
    "Actual Class"
)

plt.tight_layout()


plt.savefig(
    "confusion_matrix.png",
    dpi=300
)


plt.show()


# ============================================================
# 14. FEATURE IMPORTANCE
# ============================================================

importance = pd.DataFrame({

    "Feature": X.columns,

    "Importance":
        model.feature_importances_

})


importance = importance.sort_values(

    by="Importance",

    ascending=False
)


print("\n" + "=" * 60)
print("FEATURE IMPORTANCE")
print("=" * 60)

print(
    importance
)


# ============================================================
# 15. FEATURE IMPORTANCE GRAPH
# ============================================================

plt.figure(
    figsize=(8, 5)
)


sns.barplot(

    data=importance,

    x="Importance",

    y="Feature"
)


plt.title(
    "JalRakshak Feature Importance"
)

plt.xlabel(
    "Importance"
)

plt.ylabel(
    "Sensor Feature"
)

plt.tight_layout()


plt.savefig(
    "feature_importance.png",
    dpi=300
)


plt.show()


# ============================================================
# 16. TEST CUSTOM SENSOR VALUES
# ============================================================

# These simulate readings coming from the ESP32.

test_values = pd.DataFrame({

    "TDS_mg_L": [
        250,
        700,
        1500,
        2500
    ],

    "Turbidity_NTU": [
        0.5,
        2.0,
        4.0,
        8.0
    ]

})


predictions = model.predict(
    test_values
)


print("\n" + "=" * 60)
print("CUSTOM SENSOR TEST")
print("=" * 60)


for i in range(
    len(test_values)
):

    print(
        f"TDS = {test_values.iloc[i]['TDS_mg_L']} mg/L"
    )

    print(
        f"Turbidity = "
        f"{test_values.iloc[i]['Turbidity_NTU']} NTU"
    )

    print(
        "Predicted:",
        predictions[i]
    )

    print(
        "-" * 40
    )


# ============================================================
# 17. SAVE TRAINED MODEL
# ============================================================

joblib.dump(

    model,

    "jalrakshak_random_forest.pkl"

)


print("\nModel saved as:")

print(
    "jalrakshak_random_forest.pkl"
)


# ============================================================
# 18. SAVE MODEL METADATA
# ============================================================

metadata = {

    "model":
        "Random Forest",

    "features": [
        "TDS_mg_L",
        "Turbidity_NTU"
    ],

    "target":
        "Usage_Class",

    "classes":
        model.classes_.tolist(),

    "n_estimators":
        200,

    "random_state":
        42
}


joblib.dump(

    metadata,

    "model_metadata.pkl"

)


print(
    "Metadata saved as:"
)

print(
    "model_metadata.pkl"
)


# ============================================================
# 19. FINAL MESSAGE
# ============================================================

print("\n" + "=" * 60)
print("JALRAKSHAK MODEL TRAINING COMPLETED")
print("=" * 60)