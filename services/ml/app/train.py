import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    roc_auc_score, classification_report, confusion_matrix
)
import joblib
try:
    from .preprocessing import CreditDataPreprocessor, prepare_data
except ImportError:
    from preprocessing import CreditDataPreprocessor, prepare_data
import os


def train_credit_scoring_model(
    data_path='dataset.csv',
    model_type='random_forest',
    test_size=0.2,
    random_state=42
):
    """
    Train credit scoring model with comprehensive evaluation.
    
    Args:
        data_path: Path to dataset CSV
        model_type: 'random_forest' or 'logistic_regression'
        test_size: Proportion of data for testing
        random_state: Random seed for reproducibility
    
    Returns:
        model, preprocessor, metrics
    """
    print("=" * 60)
    print("CREDIT SCORING MODEL TRAINING")
    print("=" * 60)
    
    # Load data
    print(f"\n1. Loading data from {data_path}...")
    df = pd.read_csv(data_path)
    print(f"   ✓ Loaded {len(df)} records with {len(df.columns)} columns")
    
    # Preprocess data
    print("\n2. Preprocessing data...")
    preprocessor = CreditDataPreprocessor()
    X, y, preprocessor = prepare_data(df, preprocessor, fit=True)
    print(f"   ✓ Preprocessed features shape: {X.shape}")
    print(f"   ✓ Target distribution: {dict(zip(*np.unique(y, return_counts=True)))}")
    
    # Split data
    print("\n3. Splitting data...")
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=test_size, random_state=random_state, stratify=y
    )
    print(f"   ✓ Training set: {len(X_train)} samples")
    print(f"   ✓ Test set: {len(X_test)} samples")
    
    # Initialize model
    print(f"\n4. Training {model_type} model...")
    if model_type == 'random_forest':
        model = RandomForestClassifier(
            n_estimators=100,
            max_depth=10,
            min_samples_split=10,
            min_samples_leaf=5,
            random_state=random_state,
            n_jobs=-1
        )
    elif model_type == 'logistic_regression':
        model = LogisticRegression(
            max_iter=1000,
            random_state=random_state,
            n_jobs=-1
        )
    else:
        raise ValueError(f"Unknown model_type: {model_type}")
    
    # Train model
    model.fit(X_train, y_train)
    print("   ✓ Model training complete")
    
    # Cross-validation
    print("\n5. Cross-validation (5-fold)...")
    cv_scores = cross_val_score(model, X_train, y_train, cv=5, scoring='roc_auc')
    print(f"   ✓ CV ROC-AUC: {cv_scores.mean():.4f} (+/- {cv_scores.std() * 2:.4f})")
    
    # Predictions
    print("\n6. Evaluating model...")
    y_pred = model.predict(X_test)
    y_pred_proba = model.predict_proba(X_test)[:, 1]
    
    # Calculate metrics
    metrics = {
        'accuracy': accuracy_score(y_test, y_pred),
        'precision': precision_score(y_test, y_pred),
        'recall': recall_score(y_test, y_pred),
        'f1_score': f1_score(y_test, y_pred),
        'roc_auc': roc_auc_score(y_test, y_pred_proba),
        'cv_roc_auc_mean': cv_scores.mean(),
        'cv_roc_auc_std': cv_scores.std()
    }
    
    # Print metrics
    print("\n" + "=" * 60)
    print("MODEL PERFORMANCE METRICS")
    print("=" * 60)
    for metric, value in metrics.items():
        print(f"   {metric.upper()}: {value:.4f}")
    
    print("\n" + "-" * 60)
    print("CLASSIFICATION REPORT")
    print("-" * 60)
    print(classification_report(y_test, y_pred, target_names=['Rejected (0)', 'Approved (1)']))
    
    print("-" * 60)
    print("CONFUSION MATRIX")
    print("-" * 60)
    cm = confusion_matrix(y_test, y_pred)
    print(f"                Predicted")
    print(f"              Rej (0)  App (1)")
    print(f"Actual Rej (0)  {cm[0][0]:4d}    {cm[0][1]:4d}")
    print(f"       App (1)  {cm[1][0]:4d}    {cm[1][1]:4d}")
    
    # Feature importance (for tree-based models)
    if hasattr(model, 'feature_importances_'):
        print("\n" + "-" * 60)
        print("TOP 5 FEATURE IMPORTANCES")
        print("-" * 60)
        feature_importance = pd.DataFrame({
            'feature': preprocessor.feature_columns,
            'importance': model.feature_importances_
        }).sort_values('importance', ascending=False)
        
        for idx, row in feature_importance.head(5).iterrows():
            print(f"   {row['feature']:20s}: {row['importance']:.4f}")
    
    # Save models
    print("\n7. Saving models...")
    os.makedirs('models', exist_ok=True)
    
    model_path = f'models/model.joblib'
    preprocessor_path = f'models/preprocessor.joblib'
    encoder_path = f'models/encoder.joblib'  # Legacy compatibility
    
    joblib.dump(model, model_path)
    joblib.dump(preprocessor, preprocessor_path)
    joblib.dump(preprocessor, encoder_path)  # Save as encoder for backward compatibility
    
    print(f"   ✓ Model saved to {model_path}")
    print(f"   ✓ Preprocessor saved to {preprocessor_path}")
    
    print("\n" + "=" * 60)
    print("✓ TRAINING COMPLETE")
    print("=" * 60)
    
    return model, preprocessor, metrics


if __name__ == "__main__":
    # Train Random Forest model
    model, preprocessor, metrics = train_credit_scoring_model(
        model_type='random_forest'
    )
    
    print("\n✓ All models trained and saved successfully!")

