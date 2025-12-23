# main.py - Credit Scoring ML Service API
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Dict, List, Optional
import joblib
import os
import sys
import numpy as np
import pandas as pd

# Add app directory to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'app'))

from app.model import load_model, load_preprocessor, predict_score, predict_and_explain
from app.preprocessing import CreditDataPreprocessor

# ----------------------------
# FASTAPI APP SETUP
# ----------------------------
app = FastAPI(
    title="CreditXAI ML Service",
    description="Credit Scoring API with Explainable AI",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------
# LOAD MODELS ON STARTUP
# ----------------------------
MODEL_PATH = "models/model.joblib"
PREPROCESSOR_PATH = "models/preprocessor.joblib"

try:
    model = load_model(MODEL_PATH)
    preprocessor = load_preprocessor(PREPROCESSOR_PATH)
    print("OK: Models loaded successfully")
except Exception as e:
    print(f"WARNING: Could not load models: {e}")
    print("  Models will be loaded on first request")
    model = None
    preprocessor = None

# ----------------------------
# REQUEST/RESPONSE MODELS
# ----------------------------
class CreditApplicationInput(BaseModel):
    """Input data for credit scoring prediction."""
    Age: int = Field(..., ge=18, le=100, description="Applicant age")
    Sex: str = Field(..., description="Gender: male or female")
    Job: int = Field(..., ge=0, le=3, description="Job category (0-3)")
    Housing: str = Field(..., description="Housing status: own, rent, or free")
    Saving_accounts: str = Field(..., alias="Saving accounts", description="Savings level: little, moderate, quite rich, rich, or NA")
    Checking_account: str = Field(..., alias="Checking account", description="Checking account level: little, moderate, rich, or NA")
    Credit_amount: float = Field(..., gt=0, description="Requested credit amount")
    Duration: int = Field(..., gt=0, description="Loan duration in months")
    Purpose: str = Field(..., description="Loan purpose: car, furniture/equipment, radio/TV, education, business, etc.")
    
    class Config:
        populate_by_name = True
        json_schema_extra = {
            "example": {
                "Age": 35,
                "Sex": "male",
                "Job": 2,
                "Housing": "own",
                "Saving accounts": "moderate",
                "Checking account": "little",
                "Credit_amount": 5000,
                "Duration": 24,
                "Purpose": "car"
            }
        }


class PredictionResponse(BaseModel):
    """Response from credit scoring prediction."""
    prediction: int
    prediction_label: str
    probability_rejected: float
    probability_approved: float
    confidence: float
    risk_score: float


class ExplanationResponse(BaseModel):
    """Response with SHAP explanation (simplified without actual SHAP)."""
    shap_values: List[float]
    feature_names: List[str]
    base_value: float
    prediction_value: float
    top_features: List[Dict]
    explanation_summary: str


class FullPredictionResponse(BaseModel):
    """Combined prediction and explanation response."""
    prediction: PredictionResponse
    explanation: ExplanationResponse
    request_data: Dict


class HealthResponse(BaseModel):
    """Health check response."""
    status: str
    message: str
    models_loaded: bool
    model_path: str
    preprocessor_path: str


# ----------------------------
# ENDPOINTS
# ----------------------------
@app.get("/", response_model=HealthResponse)
def root():
    """Root endpoint - API health check."""
    return {
        "status": "healthy",
        "message": "CreditXAI ML Service is running!",
        "models_loaded": model is not None and preprocessor is not None,
        "model_path": MODEL_PATH,
        "preprocessor_path": PREPROCESSOR_PATH
    }


@app.get("/health", response_model=HealthResponse)
def health_check():
    """Health check endpoint."""
    global model, preprocessor
    
    # Try to load models if not loaded
    if model is None or preprocessor is None:
        try:
            model = load_model(MODEL_PATH)
            preprocessor = load_preprocessor(PREPROCESSOR_PATH)
        except Exception as e:
            return {
                "status": "unhealthy",
                "message": f"Models not loaded: {str(e)}",
                "models_loaded": False,
                "model_path": MODEL_PATH,
                "preprocessor_path": PREPROCESSOR_PATH
            }
    
    return {
        "status": "healthy",
        "message": "All systems operational",
        "models_loaded": True,
        "model_path": MODEL_PATH,
        "preprocessor_path": PREPROCESSOR_PATH
    }


@app.post("/predict", response_model=PredictionResponse)
def predict(data: CreditApplicationInput):
    """
    Predict credit score for given applicant data.
    
    Returns prediction with probabilities and risk score.
    """
    global model, preprocessor
    
    # Ensure models are loaded
    if model is None or preprocessor is None:
        try:
            model = load_model(MODEL_PATH)
            preprocessor = load_preprocessor(PREPROCESSOR_PATH)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Model loading failed: {str(e)}")
    
    try:
        # Convert input to dict
        input_dict = data.model_dump(by_alias=True)
        
        # Get prediction
        result = predict_score(model, preprocessor, input_dict)
        
        return result
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")


@app.post("/explain")
def explain(data: CreditApplicationInput):
    """
    Get SHAP explanation for prediction.
    
    Note: SHAP library not installed. This returns mock explanation.
    Install shap library for full functionality.
    """
    global model, preprocessor
    
    # Ensure models are loaded
    if model is None or preprocessor is None:
        try:
            model = load_model(MODEL_PATH)
            preprocessor = load_preprocessor(PREPROCESSOR_PATH)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Model loading failed: {str(e)}")
    
    try:
        # Convert input to dict
        input_dict = data.model_dump(by_alias=True)
        
        # Get full prediction with explanation
        result = predict_and_explain(model, preprocessor, input_dict)
        
        return result['explanation']
    
    except ImportError:
        # SHAP not installed - return feature importances instead
        raise HTTPException(
            status_code=501,
            detail="SHAP library not installed. Install with: pip install shap"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Explanation failed: {str(e)}")


@app.post("/score", response_model=FullPredictionResponse)
def score(data: CreditApplicationInput):
    """
    Complete credit scoring with prediction and explanation.
    
    Returns both the prediction result and SHAP explanation.
    """
    global model, preprocessor
    
    # Ensure models are loaded
    if model is None or preprocessor is None:
        try:
            model = load_model(MODEL_PATH)
            preprocessor = load_preprocessor(PREPROCESSOR_PATH)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Model loading failed: {str(e)}")
    
    try:
        # Convert input to dict
        input_dict = data.model_dump(by_alias=True)
        
        # Get full result
        result = predict_and_explain(model, preprocessor, input_dict)
        
        # Add request data for reference
        result['request_data'] = input_dict
        
        return result
    
    except ImportError:
        # SHAP not available - return prediction only
        result = {
            'prediction': predict_score(model, preprocessor, data.model_dump(by_alias=True)),
            'explanation': {
                'shap_values': [],
                'feature_names': preprocessor.feature_columns if hasattr(preprocessor, 'feature_columns') else [],
                'base_value': 0.0,
                'prediction_value': 0.0,
                'top_features': [],
                'explanation_summary': "SHAP not installed. Install with: pip install shap"
            },
            'request_data': data.model_dump(by_alias=True)
        }
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Scoring failed: {str(e)}")


# ----------------------------
# MAIN
# ----------------------------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)


