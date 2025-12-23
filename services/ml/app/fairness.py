import pandas as pd
import numpy as np
from sklearn.metrics import accuracy_score, precision_score, recall_score, confusion_matrix
import joblib


class FairnessAnalyzer:
    """Analyze model fairness and detect bias across demographic groups."""
    
    def __init__(self, sensitive_features=None):
        """
        Initialize fairness analyzer.
        
        Args:
            sensitive_features: List of feature names to check for bias (e.g., ['Sex', 'Age'])
        """
        self.sensitive_features = sensitive_features or ['Sex', 'Age']
        self.fairness_metrics = {}
    
    def calculate_group_metrics(self, y_true, y_pred, group_labels):
        """Calculate performance metrics for a specific group."""
        if len(y_true) == 0:
            return None
        
        return {
            'count': len(y_true),
            'accuracy': accuracy_score(y_true, y_pred),
            'precision': precision_score(y_true, y_pred, zero_division=0),
            'recall': recall_score(y_true, y_pred, zero_division=0),
            'approval_rate': np.mean(y_pred),
            'true_approval_rate': np.mean(y_true)
        }
    
    def analyze_fairness(self, model, preprocessor, df):
        """
        Analyze model fairness across sensitive groups.
        
        Args:
            model: Trained ML model
            preprocessor: Fitted preprocessor
            df: DataFrame with features and target
        
        Returns:
            Dictionary with fairness metrics and analysis
        """
        print("\n" + "=" * 60)
        print("FAIRNESS ANALYSIS")
        print("=" * 60)
        
        # Make a copy to avoid modifying original
        df_copy = df.copy()
        
        # Get predictions
        X_transformed = preprocessor.transform(df_copy)
        # Handle both tuple and single return
        if isinstance(X_transformed, tuple):
            X, y_true = X_transformed
        else:
            X = X_transformed
            y_true = df_copy['target'] if 'target' in df_copy.columns else None
        
        if y_true is None:
            raise ValueError("Target column required for fairness analysis")
            
        y_pred = model.predict(X)
        
        fairness_report = {
            'overall_metrics': {
                'accuracy': accuracy_score(y_true, y_pred),
                'approval_rate': np.mean(y_pred),
                'total_samples': len(y_true)
            },
            'group_analysis': {}
        }
        
        # Analyze each sensitive feature
        for feature in self.sensitive_features:
            if feature not in df_copy.columns:
                print(f"WARNING: {feature} not found in data")
                continue
            
            print(f"\n{'-' * 60}")
            print(f"Analyzing: {feature}")
            print(f"{'-' * 60}")
            
            groups = df_copy[feature].unique()
            group_metrics = {}
            
            for group in groups:
                # Skip NA groups
                if pd.isna(group):
                    continue
                
                # Filter data for this group
                mask = df_copy[feature] == group
                group_y_true = y_true[mask]
                group_y_pred = y_pred[mask]
                
                # Calculate metrics
                metrics = self.calculate_group_metrics(
                    group_y_true, group_y_pred, group
                )
                
                if metrics:
                    group_metrics[str(group)] = metrics
                    
                    print(f"\nGroup: {group}")
                    print(f"  Samples: {metrics['count']}")
                    print(f"  Accuracy: {metrics['accuracy']:.4f}")
                    print(f"  Precision: {metrics['precision']:.4f}")
                    print(f"  Recall: {metrics['recall']:.4f}")
                    print(f"  Approval Rate: {metrics['approval_rate']:.4f}")
                    print(f"  True Approval Rate: {metrics['true_approval_rate']:.4f}")
            
            # Calculate disparate impact
            if len(group_metrics) >= 2:
                approval_rates = [m['approval_rate'] for m in group_metrics.values()]
                max_rate = max(approval_rates)
                min_rate = min(approval_rates)
                
                disparate_impact = min_rate / max_rate if max_rate > 0 else 0
                
                print(f"\n{'-' * 40}")
                print(f"Disparate Impact Ratio: {disparate_impact:.4f}")
                
                if disparate_impact < 0.8:
                    print("WARNING: Potential bias detected (DI < 0.8)")
                    bias_level = "HIGH"
                elif disparate_impact < 0.9:
                    print("CAUTION: Possible bias (0.8 <= DI < 0.9)")
                    bias_level = "MODERATE"
                else:
                    print("OK: Fairness check passed (DI >= 0.9)")
                    bias_level = "LOW"
                
                fairness_report['group_analysis'][feature] = {
                    'groups': group_metrics,
                    'disparate_impact': disparate_impact,
                    'bias_level': bias_level,
                    'max_approval_rate': max_rate,
                    'min_approval_rate': min_rate
                }
        
        # Age-based analysis (if Age exists)
        if 'Age' in df_copy.columns:
            print(f"\n{'-' * 60}")
            print("Age Group Analysis")
            print(f"{'-' * 60}")
            
            # Create age groups - convert to numpy array first to avoid issues
            age_values = df_copy['Age'].values
            df_copy['AgeGroup'] = pd.cut(
                age_values,
                bins=[0, 25, 35, 50, 100],
                labels=['18-25', '26-35', '36-50', '50+']
            )
            
            age_group_metrics = {}
            
            for age_group in ['18-25', '26-35', '36-50', '50+']:
                mask = df_copy['AgeGroup'].astype(str) == age_group
                if mask.sum() > 0:
                    group_y_true = y_true[mask]
                    group_y_pred = y_pred[mask]
                    
                    metrics = self.calculate_group_metrics(
                        group_y_true, group_y_pred, age_group
                    )
                    
                    if metrics:
                        age_group_metrics[age_group] = metrics
                        print(f"\n{age_group}: {metrics['count']} samples, "
                              f"Approval: {metrics['approval_rate']:.4f}")
            
            # Calculate age-based disparate impact
            if len(age_group_metrics) >= 2:
                approval_rates = [m['approval_rate'] for m in age_group_metrics.values()]
                max_rate = max(approval_rates)
                min_rate = min(approval_rates)
                age_di = min_rate / max_rate if max_rate > 0 else 0
                
                print(f"\nAge Disparate Impact: {age_di:.4f}")
                
                fairness_report['group_analysis']['AgeGroup'] = {
                    'groups': age_group_metrics,
                    'disparate_impact': age_di,
                    'max_approval_rate': max_rate,
                    'min_approval_rate': min_rate
                }
        
        print("\n" + "=" * 60)
        print("FAIRNESS ANALYSIS COMPLETE")
        print("=" * 60)
        
        return fairness_report
    
    def get_bias_summary(self, fairness_report):
        """Generate a summary of bias findings."""
        summary = {
            'has_bias': False,
            'biased_features': [],
            'recommendations': []
        }
        
        for feature, analysis in fairness_report.get('group_analysis', {}).items():
            di = analysis.get('disparate_impact', 1.0)
            
            if di < 0.8:
                summary['has_bias'] = True
                summary['biased_features'].append({
                    'feature': feature,
                    'disparate_impact': di,
                    'severity': 'HIGH'
                })
                summary['recommendations'].append(
                    f"Consider reweighting or resampling for {feature}"
                )
            elif di < 0.9:
                summary['biased_features'].append({
                    'feature': feature,
                    'disparate_impact': di,
                    'severity': 'MODERATE'
                })
        
        return summary


def evaluate_model_fairness(
    model_path='../models/model.joblib',
    preprocessor_path='../models/preprocessor.joblib',
    data_path='dataset.csv'
):
    """
    Load model and evaluate fairness.
    
    Args:
        model_path: Path to saved model
        preprocessor_path: Path to saved preprocessor
        data_path: Path to dataset
    
    Returns:
        fairness_report
    """
    # Load model and preprocessor
    model = joblib.load(model_path)
    preprocessor = joblib.load(preprocessor_path)
    
    # Load data
    df = pd.read_csv(data_path)
    
    # Analyze fairness
    analyzer = FairnessAnalyzer(sensitive_features=['Sex', 'Age'])
    fairness_report = analyzer.analyze_fairness(model, preprocessor, df)
    
    # Get bias summary
    bias_summary = analyzer.get_bias_summary(fairness_report)
    
    print("\n" + "=" * 60)
    print("BIAS SUMMARY")
    print("=" * 60)
    print(f"Has Bias: {bias_summary['has_bias']}")
    print(f"Biased Features: {len(bias_summary['biased_features'])}")
    
    for feature in bias_summary['biased_features']:
        print(f"\n  • {feature['feature']}: {feature['severity']} severity")
        print(f"    Disparate Impact: {feature['disparate_impact']:.4f}")
    
    if bias_summary['recommendations']:
        print("\nRecommendations:")
        for rec in bias_summary['recommendations']:
            print(f"  • {rec}")
    
    return fairness_report


if __name__ == "__main__":
    # Run fairness evaluation
    fairness_report = evaluate_model_fairness()
