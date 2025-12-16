# main.py
from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import os
import numpy as np

# ----------------------------
# MODELE SIMPLIFIE (à remplacer)
# ----------------------------
MODEL_FILE = "model.joblib"

# Si le fichier n'existe pas, on crée un modèle factice
if not os.path.exists(MODEL_FILE):
    from sklearn.linear_model import LinearRegression
    X = np.array([[1], [2], [3], [4]])
    y = np.array([2, 4, 6, 8])
    model = LinearRegression()
    model.fit(X, y)
    joblib.dump(model, MODEL_FILE)
else:
    model = joblib.load(MODEL_FILE)

# ----------------------------
# FASTAPI
# ----------------------------
app = FastAPI(title="ML Service Local")

# Structure des données d'entrée
class InputData(BaseModel):
    feature: float

# Endpoint de test
@app.get("/")
def root():
    return {"message": "ML Service is running!"}

# Endpoint de prédiction
@app.post("/predict")
def predict(data: InputData):
    prediction = model.predict([[data.feature]])
    return {"feature": data.feature, "prediction": float(prediction[0])}

