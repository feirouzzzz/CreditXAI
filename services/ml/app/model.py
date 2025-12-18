import joblib
import numpy as np
import pandas as pd
from preprocessing import CreditDataPreprocessor

# Try to import SHAP, but make it optional
try:
    import shap
    SHAP_AVAILABLE = True
except ImportError:
    SHAP_AVAILABLE = False
    print("⚠ SHAP not available. Install with: pip install shap")



def load_model(model_path='../models/model.joblib'):
    """Load trained credit scoring model."""
    return joblib.load(model_path)


def load_preprocessor(preprocessor_path='../models/preprocessor.joblib'):
    """Load fitted preprocessor."""
    return joblib.load(preprocessor_path)


def predict_score(model, preprocessor, data):
    """
    Predict credit score for input data.
    
    Args:
        model: Trained ML model
        preprocessor: Fitted preprocessor
        data: Dict or DataFrame with feature values
    
    Returns:
        Dictionary with prediction results
    """
    # Convert dict to DataFrame if needed
    if isinstance(data, dict):
        df = pd.DataFrame([data])
    else:
        df = data
    
    # Preprocess data
    X = preprocessor.transform(df)
    if isinstance(X, tuple):
        X = X[0]  # Handle tuple return from transform
    
    # Get predictions
    prediction = model.predict(X)[0]
    probability = model.predict_proba(X)[0]
    
    return {
        'prediction': int(prediction),
        'prediction_label': 'Approved' if prediction == 1 else 'Rejected',
        'probability_rejected': float(probability[0]),
        'probability_approved': float(probability[1]),
        'confidence': float(max(probability)),
        'risk_score': float(1 - probability[1])  # Higher risk = lower approval probability
    }


def explain_prediction(model, preprocessor, data, top_n=5):
    """
    Generate SHAP explanations for prediction.
    
    Args:
        model: Trained ML model
        preprocessor: Fitted preprocessor
        data: Dict or DataFrame with feature values
        top_n: Number of top features to return
    
    Returns:
        Dictionary with SHAP explanation results
    """
    if not SHAP_AVAILABLE:
        # Return feature importances from the model instead
        return get_feature_importance_explanation(model, preprocessor, data, top_n)
    
    # Convert dict to DataFrame if needed
    if isinstance(data, dict):
        df = pd.DataFrame([data])
    else:
        df = data
    
    # Preprocess data
    X = preprocessor.transform(df)
    if isinstance(X, tuple):
        X = X[0]  # Handle tuple return from transform
    
    # Generate SHAP values
    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X)
    
    # For binary classification, get values for positive class (approved)
    if isinstance(shap_values, list):
        shap_vals = shap_values[1][0]  # Class 1 (approved)
    else:
        shap_vals = shap_values[0]
    
    # Get feature names
    feature_names = preprocessor.feature_columns
    
    # Create feature importance list
    feature_importance = []
    for idx, (feature, shap_val) in enumerate(zip(feature_names, shap_vals)):
        feature_importance.append({
            'feature': feature,
            'shap_value': float(shap_val),
            'impact': 'positive' if shap_val > 0 else 'negative',
            'abs_importance': float(abs(shap_val))
        })
    
    # Sort by absolute importance
    feature_importance.sort(key=lambda x: x['abs_importance'], reverse=True)
    
    # Get base value (expected value)
    base_value = float(explainer.expected_value[1] if isinstance(explainer.expected_value, list) 
                      else explainer.expected_value)
    
    # Calculate prediction value
    prediction_value = base_value + sum(shap_vals)
    
    return {
        'shap_values': [float(v) for v in shap_vals],
        'feature_names': feature_names,
        'base_value': base_value,
        'prediction_value': float(prediction_value),
        'top_features': feature_importance[:top_n],
        'all_features': feature_importance,
        'explanation_summary': generate_explanation_summary(feature_importance[:top_n])
    }


def get_feature_importance_explanation(model, preprocessor, data, top_n=5):
    """
    Fallback explanation using feature importances (when SHAP not available).
    
    Args:
        model: Trained ML model
        preprocessor: Fitted preprocessor
        data: Dict or DataFrame with feature values
        top_n: Number of top features to return
    
    Returns:
        Dictionary with feature importance explanation
    """
    # Convert dict to DataFrame if needed
    if isinstance(data, dict):
        df = pd.DataFrame([data])
    else:
        df = data
    
    # Preprocess data
    X = preprocessor.transform(df)
    if isinstance(X, tuple):
        X = X[0]
    
    # Get feature importances from model
    if hasattr(model, 'feature_importances_'):
        importances = model.feature_importances_
    else:
        importances = np.ones(X.shape[1]) / X.shape[1]  # Equal weights if not available
    
    feature_names = preprocessor.feature_columns
    
    # Create feature importance list
    feature_importance = []
    for idx, (feature, importance) in enumerate(zip(feature_names, importances)):
        feature_importance.append({
            'feature': feature,
            'shap_value': float(importance),  # Use importance as proxy
            'impact': 'positive',  # Simplified
            'abs_importance': float(abs(importance))
        })
    
    # Sort by importance
    feature_importance.sort(key=lambda x: x['abs_importance'], reverse=True)
    
    return {
        'shap_values': [float(v) for v in importances],
        'feature_names': feature_names,
        'base_value': 0.5,  # Neutral base
        'prediction_value': 0.5,
        'top_features': feature_importance[:top_n],
        'all_features': feature_importance,
        'explanation_summary': f"Top factors: {', '.join([f['feature'] for f in feature_importance[:top_n]])} (Note: Install SHAP for detailed explanations)"
    }


def generate_explanation_summary(top_features):
    """
    Generate human-readable explanation from SHAP features.
    
    Args:
        top_features: List of top feature importance dicts
    
    Returns:
        String with explanation summary
    """
    if not top_features:
        return "No significant features identified."
    
    summary_parts = []
    
    for feature in top_features[:3]:  # Top 3 features
        feature_name = feature['feature']
        impact = feature['impact']
        strength = abs(feature['shap_value'])
        
        if strength > 0.5:
            strength_word = "strongly"
        elif strength > 0.2:
            strength_word = "moderately"
        else:
            strength_word = "slightly"
        
        direction = "increases" if impact == "positive" else "decreases"
        
        summary_parts.append(
            f"{feature_name} {strength_word} {direction} approval probability"
        )
    
    return ". ".join(summary_parts) + "."


def predict_and_explain(model, preprocessor, data, top_n=5):
    """
    Combined prediction and explanation.
    
    Args:
        model: Trained ML model
        preprocessor: Fitted preprocessor
        data: Dict or DataFrame with feature values
        top_n: Number of top features to return
    
    Returns:
        Dictionary with prediction and explanation
    """
    prediction_result = predict_score(model, preprocessor, data)
    explanation_result = explain_prediction(model, preprocessor, data, top_n)
    
    return {
        'prediction': prediction_result,
        'explanation': explanation_result
    }


if __name__ == "__main__":
    # Test prediction and explanation
    print("=" * 60)
    print("TESTING CREDIT SCORING MODEL")
    print("=" * 60)
    
    # Load model and preprocessor
    model = load_model()
    preprocessor = load_preprocessor()
    
    # Test case 1: Good credit profile
    print("\n" + "-" * 60)
    print("Test Case 1: Good Credit Profile")
    print("-" * 60)
    
    test_data_good = {
        'Age': 45,
        'Sex': 'male',
        'Job': 2,
        'Housing': 'own',
        'Saving accounts': 'rich',
        'Checking account': 'moderate',
        'Credit amount': 3000,
        'Duration': 12,
        'Purpose': 'car'
    }
    
    result_good = predict_and_explain(model, preprocessor, test_data_good)
    
    print(f"Prediction: {result_good['prediction']['prediction_label']}")
    print(f"Confidence: {result_good['prediction']['confidence']:.2%}")
    print(f"Risk Score: {result_good['prediction']['risk_score']:.2%}")
    print(f"\nTop Influencing Features:")
    for feat in result_good['explanation']['top_features']:
        print(f"  • {feat['feature']}: {feat['impact']} (SHAP: {feat['shap_value']:.4f})")
    print(f"\nExplanation: {result_good['explanation']['explanation_summary']}")
    
    # Test case 2: Poor credit profile
    print("\n" + "-" * 60)
    print("Test Case 2: Risky Credit Profile")
    print("-" * 60)
    
    test_data_poor = {
        'Age': 22,
        'Sex': 'female',
        'Job': 1,
        'Housing': 'rent',
        'Saving accounts': 'little',
        'Checking account': 'little',
        'Credit amount': 8000,
        'Duration': 48,
        'Purpose': 'business'
    }
    
    result_poor = predict_and_explain(model, preprocessor, test_data_poor)
    
    print(f"Prediction: {result_poor['prediction']['prediction_label']}")
    print(f"Confidence: {result_poor['prediction']['confidence']:.2%}")
    print(f"Risk Score: {result_poor['prediction']['risk_score']:.2%}")
    print(f"\nTop Influencing Features:")
    for feat in result_poor['explanation']['top_features']:
        print(f"  • {feat['feature']}: {feat['impact']} (SHAP: {feat['shap_value']:.4f})")
    print(f"\nExplanation: {result_poor['explanation']['explanation_summary']}")
    
    print("\n" + "=" * 60)
    print("✓ MODEL TESTING COMPLETE")
    print("=" * 60)

