import joblib
import shap  # type: ignore
import numpy as np

def load_model():
    return joblib.load("model.joblib")

def predict_score(model, data):
    X = np.array([list(data.values())])
    return float(model.predict_proba(X)[0][1])

def explain_prediction(model, data):
    X = np.array([list(data.values())])
    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X)
    return {"shap_values": shap_values[0].tolist()}
