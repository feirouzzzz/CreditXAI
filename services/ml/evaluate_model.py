#!/usr/bin/env python3
"""
Model Evaluation Script - Direct Model Testing
Tests the model directly without API calls
"""

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), 'app'))

import pandas as pd
import numpy as np
from app.model import load_model, load_preprocessor, predict_score, predict_and_explain
from app.preprocessing import CreditDataPreprocessor
from app.train import train_credit_scoring_model
import joblib

def print_header(text):
    print("\n" + "=" * 70)
    print(text.center(70))
    print("=" * 70)

def print_section(text):
    print("\n" + "-" * 70)
    print(text)
    print("-" * 70)

def test_model_loading():
    """Test model and preprocessor loading"""
    print_section("1. MODEL LOADING TEST")
    try:
        model = load_model('models/model.joblib')
        preprocessor = load_preprocessor('models/preprocessor.joblib')
        print("✓ Model loaded successfully")
        print(f"✓ Model type: {type(model).__name__}")
        print(f"✓ Preprocessor type: {type(preprocessor).__name__}")
        print(f"✓ Number of features: {len(preprocessor.feature_columns)}")
        print(f"✓ Feature names: {preprocessor.feature_columns}")
        return model, preprocessor
    except Exception as e:
        print(f"✗ Error loading models: {e}")
        return None, None

def test_predictions(model, preprocessor):
    """Test predictions on various profiles"""
    print_section("2. PREDICTION TESTS")
    
    test_cases = [
        {
            'name': 'Excellent Credit - Senior Professional',
            'data': {
                'Age': 55,
                'Sex': 'male',
                'Job': 3,
                'Housing': 'own',
                'Saving accounts': 'rich',
                'Checking account': 'rich',
                'Credit_amount': 2000,
                'Duration': 12,
                'Purpose': 'car'
            }
        },
        {
            'name': 'Good Credit - Middle-Age Stable',
            'data': {
                'Age': 40,
                'Sex': 'female',
                'Job': 2,
                'Housing': 'own',
                'Saving accounts': 'moderate',
                'Checking account': 'moderate',
                'Credit_amount': 5000,
                'Duration': 24,
                'Purpose': 'furniture/equipment'
            }
        },
        {
            'name': 'Moderate Risk - Young Professional',
            'data': {
                'Age': 28,
                'Sex': 'male',
                'Job': 2,
                'Housing': 'rent',
                'Saving accounts': 'little',
                'Checking account': 'moderate',
                'Credit_amount': 6000,
                'Duration': 36,
                'Purpose': 'car'
            }
        },
        {
            'name': 'High Risk - Young High Amount',
            'data': {
                'Age': 23,
                'Sex': 'female',
                'Job': 1,
                'Housing': 'rent',
                'Saving accounts': 'little',
                'Checking account': 'little',
                'Credit_amount': 9000,
                'Duration': 48,
                'Purpose': 'business'
            }
        },
        {
            'name': 'Very High Risk - Extended Duration',
            'data': {
                'Age': 22,
                'Sex': 'male',
                'Job': 0,
                'Housing': 'free',
                'Saving accounts': 'NA',
                'Checking account': 'little',
                'Credit_amount': 12000,
                'Duration': 60,
                'Purpose': 'business'
            }
        }
    ]
    
    results = []
    for i, test_case in enumerate(test_cases, 1):
        print(f"\n[Test {i}/{len(test_cases)}] {test_case['name']}")
        try:
            result = predict_score(model, preprocessor, test_case['data'])
            
            print(f"  Decision: {result['prediction_label']}")
            print(f"  Confidence: {result['confidence']:.2%}")
            print(f"  Risk Score: {result['risk_score']:.2%}")
            print(f"  P(Approved): {result['probability_approved']:.2%}")
            print(f"  P(Rejected): {result['probability_rejected']:.2%}")
            
            results.append({
                'name': test_case['name'],
                'decision': result['prediction_label'],
                'confidence': result['confidence'],
                'risk_score': result['risk_score']
            })
            
        except Exception as e:
            print(f"  ✗ Error: {e}")
    
    return results

def test_with_explanations(model, preprocessor):
    """Test predictions with explanations"""
    print_section("3. PREDICTIONS WITH EXPLANATIONS")
    
    test_cases = [
        {
            'name': 'Low Risk Profile',
            'data': {
                'Age': 45,
                'Sex': 'male',
                'Job': 2,
                'Housing': 'own',
                'Saving accounts': 'rich',
                'Checking account': 'moderate',
                'Credit_amount': 3000,
                'Duration': 12,
                'Purpose': 'car'
            }
        },
        {
            'name': 'High Risk Profile',
            'data': {
                'Age': 22,
                'Sex': 'female',
                'Job': 1,
                'Housing': 'rent',
                'Saving accounts': 'little',
                'Checking account': 'little',
                'Credit_amount': 8000,
                'Duration': 48,
                'Purpose': 'business'
            }
        }
    ]
    
    for i, test_case in enumerate(test_cases, 1):
        print(f"\n[Case {i}] {test_case['name']}")
        print(f"Input: {test_case['data']}")
        
        try:
            result = predict_and_explain(model, preprocessor, test_case['data'], top_n=5)
            
            pred = result['prediction']
            print(f"\n  Decision: {pred['prediction_label']}")
            print(f"  Confidence: {pred['confidence']:.2%}")
            print(f"  Risk Score: {pred['risk_score']:.2%}")
            
            exp = result['explanation']
            print(f"\n  Top Influencing Features:")
            for feat in exp['top_features']:
                impact_symbol = "↑" if feat['impact'] == 'positive' else "↓"
                print(f"    {impact_symbol} {feat['feature']:20s}: {feat['abs_importance']:.4f}")
            
            if 'explanation_summary' in exp:
                print(f"\n  Explanation: {exp['explanation_summary']}")
                
        except Exception as e:
            print(f"  ✗ Error: {e}")

def test_on_dataset(model, preprocessor):
    """Test model on full dataset"""
    print_section("4. FULL DATASET EVALUATION")
    
    try:
        # Load dataset
        df = pd.read_csv('app/dataset.csv')
        print(f"✓ Loaded dataset: {len(df)} records")
        
        # Preprocess
        X = preprocessor.transform(df)
        if isinstance(X, tuple):
            X, y_true = X
        else:
            y_true = df['target'] if 'target' in df.columns else None
        
        # Predict
        y_pred = model.predict(X)
        y_proba = model.predict_proba(X)
        
        # Calculate metrics
        from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score, confusion_matrix
        
        accuracy = accuracy_score(y_true, y_pred)
        precision = precision_score(y_true, y_pred)
        recall = recall_score(y_true, y_pred)
        f1 = f1_score(y_true, y_pred)
        roc_auc = roc_auc_score(y_true, y_proba[:, 1])
        cm = confusion_matrix(y_true, y_pred)
        
        print(f"\nModel Performance Metrics:")
        print(f"  Accuracy:  {accuracy:.4f} ({accuracy*100:.2f}%)")
        print(f"  Precision: {precision:.4f} ({precision*100:.2f}%)")
        print(f"  Recall:    {recall:.4f} ({recall*100:.2f}%)")
        print(f"  F1 Score:  {f1:.4f} ({f1*100:.2f}%)")
        print(f"  ROC-AUC:   {roc_auc:.4f} ({roc_auc*100:.2f}%)")
        
        print(f"\nConfusion Matrix:")
        print(f"                 Predicted")
        print(f"               Rej    App")
        print(f"  Actual Rej  {cm[0][0]:4d}  {cm[0][1]:4d}")
        print(f"         App  {cm[1][0]:4d}  {cm[1][1]:4d}")
        
        # Prediction distribution
        approved = sum(y_pred)
        rejected = len(y_pred) - approved
        print(f"\nPrediction Distribution:")
        print(f"  Approved: {approved} ({approved/len(y_pred)*100:.1f}%)")
        print(f"  Rejected: {rejected} ({rejected/len(y_pred)*100:.1f}%)")
        
    except Exception as e:
        print(f"✗ Error evaluating on dataset: {e}")

def show_feature_importance(model, preprocessor):
    """Show feature importance"""
    print_section("5. FEATURE IMPORTANCE ANALYSIS")
    
    if hasattr(model, 'feature_importances_'):
        importances = model.feature_importances_
        features = preprocessor.feature_columns
        
        # Sort by importance
        indices = np.argsort(importances)[::-1]
        
        print("\nFeature Importance Ranking:")
        for i, idx in enumerate(indices, 1):
            print(f"  {i}. {features[idx]:20s}: {importances[idx]:.4f} ({importances[idx]*100:.2f}%)")
    else:
        print("  Model does not have feature_importances_ attribute")

def main():
    print_header("CREDITXAI MODEL EVALUATION")
    print(f"\nWorking Directory: {os.getcwd()}")
    
    # Load models
    model, preprocessor = test_model_loading()
    if model is None or preprocessor is None:
        print("\n✗ Failed to load models. Exiting.")
        return
    
    # Run tests
    test_predictions(model, preprocessor)
    test_with_explanations(model, preprocessor)
    test_on_dataset(model, preprocessor)
    show_feature_importance(model, preprocessor)
    
    print_header("EVALUATION COMPLETE")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"\n✗ Fatal error: {e}")
        import traceback
        traceback.print_exc()
