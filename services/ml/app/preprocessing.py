import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.impute import SimpleImputer
import joblib


class CreditDataPreprocessor:
    """Preprocessor for credit scoring data with encoding, scaling, and imputation."""
    
    def __init__(self):
        self.label_encoders = {}
        self.scaler = StandardScaler()
        self.imputer = SimpleImputer(strategy='most_frequent')
        self.feature_columns = None
        
    def fit(self, df):
        """Fit preprocessor on training data."""
        df = df.copy()
        
        # Remove index column if exists
        if 'Unnamed: 0' in df.columns:
            df = df.drop('Unnamed: 0', axis=1)
        
        # Separate features and target
        if 'target' in df.columns:
            X = df.drop('target', axis=1)
            y = df['target']
        else:
            X = df
            y = None
        
        # Store original feature columns
        self.feature_columns = X.columns.tolist()
        
        # Identify categorical columns
        categorical_cols = X.select_dtypes(include=['object']).columns.tolist()
        numerical_cols = X.select_dtypes(include=['int64', 'float64']).columns.tolist()
        
        # Fit label encoders for categorical columns
        for col in categorical_cols:
            le = LabelEncoder()
            # Handle missing values by replacing with a placeholder
            X[col] = X[col].fillna('NA')
            le.fit(X[col])
            self.label_encoders[col] = le
        
        # Fit scaler on numerical columns
        if numerical_cols:
            self.scaler.fit(X[numerical_cols])
        
        return self
    
    def transform(self, df):
        """Transform data using fitted preprocessor."""
        df = df.copy()
        
        # Remove index column if exists
        if 'Unnamed: 0' in df.columns:
            df = df.drop('Unnamed: 0', axis=1)
        
        # Separate features and target if present
        has_target = 'target' in df.columns
        if has_target:
            y = df['target']
            X = df.drop('target', axis=1)
        else:
            X = df
            y = None
        
        # Ensure all required columns are present
        for col in self.feature_columns:
            if col not in X.columns:
                X[col] = np.nan
        
        # Reorder columns to match training
        X = X[self.feature_columns]
        
        # Transform categorical columns
        for col, le in self.label_encoders.items():
            if col in X.columns:
                X[col] = X[col].fillna('NA')
                # Handle unseen categories
                X[col] = X[col].apply(lambda x: x if x in le.classes_ else le.classes_[0])
                X[col] = le.transform(X[col])
        
        # Transform numerical columns using stored column names from fit
        if hasattr(self, 'numerical_cols') and self.numerical_cols:
            X[self.numerical_cols] = self.scaler.transform(X[self.numerical_cols])
        
        if has_target:
            return X, y
        return X
    
    def fit_transform(self, df):
        """Fit and transform in one step."""
        self.fit(df)
        return self.transform(df)
    
    def save(self, filepath='models/preprocessor.joblib'):
        """Save preprocessor to file."""
        joblib.dump(self, filepath)
        print(f"✓ Preprocessor saved to {filepath}")
    
    @staticmethod
    def load(filepath='models/preprocessor.joblib'):
        """Load preprocessor from file."""
        return joblib.load(filepath)


def prepare_data(df, preprocessor=None, fit=True):
    """
    Prepare data for training or prediction.
    
    Args:
        df: DataFrame with features (and optionally target)
        preprocessor: Existing preprocessor or None to create new
        fit: Whether to fit the preprocessor
    
    Returns:
        X, y (if target exists), preprocessor
    """
    if preprocessor is None:
        preprocessor = CreditDataPreprocessor()
    
    if fit:
        result = preprocessor.fit_transform(df)
    else:
        result = preprocessor.transform(df)
    
    # Check if result is tuple (X, y) or just X
    if isinstance(result, tuple):
        return result[0], result[1], preprocessor
    else:
        return result, None, preprocessor


if __name__ == "__main__":
    # Test preprocessing
    df = pd.read_csv('dataset.csv')
    print(f"Original shape: {df.shape}")
    print(f"Columns: {df.columns.tolist()}")
    
    preprocessor = CreditDataPreprocessor()
    X, y, _ = prepare_data(df, preprocessor, fit=True)
    
    print(f"\nProcessed shape: {X.shape}")
    print(f"Target distribution: {y.value_counts().to_dict()}")
    print(f"Feature columns: {preprocessor.feature_columns}")
    print("\n✓ Preprocessing test complete")
