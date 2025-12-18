#!/usr/bin/env python3
"""
Comprehensive Model Testing & Evaluation Script
Tests the credit scoring model API and evaluates performance
"""

import requests
import json
from datetime import datetime
import sys

# API Configuration
BASE_URL = "http://localhost:8000"

# Color codes for terminal output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

def print_header(text):
    print(f"\n{BLUE}{'=' * 70}{RESET}")
    print(f"{BLUE}{text.center(70)}{RESET}")
    print(f"{BLUE}{'=' * 70}{RESET}")

def print_section(text):
    print(f"\n{YELLOW}{'-' * 70}{RESET}")
    print(f"{YELLOW}{text}{RESET}")
    print(f"{YELLOW}{'-' * 70}{RESET}")

def print_success(text):
    print(f"{GREEN}✓ {text}{RESET}")

def print_error(text):
    print(f"{RED}✗ {text}{RESET}")

def print_info(text):
    print(f"  {text}")

def test_health_check():
    """Test API health check endpoint"""
    print_section("1. Health Check")
    try:
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            data = response.json()
            print_success(f"API Status: {data['status']}")
            print_info(f"Message: {data['message']}")
            print_info(f"Models Loaded: {data['models_loaded']}")
            return True
        else:
            print_error(f"Health check failed: {response.status_code}")
            return False
    except Exception as e:
        print_error(f"Connection error: {str(e)}")
        print_info("Make sure the API server is running on http://localhost:8000")
        return False

def test_prediction(test_case):
    """Test prediction endpoint with a test case"""
    try:
        response = requests.post(
            f"{BASE_URL}/predict",
            json=test_case['data'],
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            result = response.json()
            print_success(f"{test_case['name']}")
            print_info(f"Prediction: {result['prediction_label']}")
            print_info(f"Confidence: {result['confidence']:.2%}")
            print_info(f"Risk Score: {result['risk_score']:.2%}")
            print_info(f"Probability Approved: {result['probability_approved']:.2%}")
            print_info(f"Probability Rejected: {result['probability_rejected']:.2%}")
            return result
        else:
            print_error(f"{test_case['name']} - Status: {response.status_code}")
            print_info(f"Error: {response.text}")
            return None
    except Exception as e:
        print_error(f"{test_case['name']} - Error: {str(e)}")
        return None

def test_complete_scoring(test_case):
    """Test complete scoring endpoint with explanation"""
    try:
        response = requests.post(
            f"{BASE_URL}/score",
            json=test_case['data'],
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            result = response.json()
            print_success(f"{test_case['name']} - Complete Scoring")
            
            # Prediction
            pred = result['prediction']
            print_info(f"Decision: {pred['prediction_label']}")
            print_info(f"Confidence: {pred['confidence']:.2%}")
            
            # Explanation
            exp = result['explanation']
            if 'top_features' in exp and exp['top_features']:
                print_info("Top Influencing Factors:")
                for feat in exp['top_features'][:3]:
                    impact = "↑" if feat['impact'] == 'positive' else "↓"
                    print_info(f"  {impact} {feat['feature']}: {feat['abs_importance']:.4f}")
            
            if 'explanation_summary' in exp:
                print_info(f"Summary: {exp['explanation_summary']}")
            
            return result
        else:
            print_error(f"{test_case['name']} - Status: {response.status_code}")
            return None
    except Exception as e:
        print_error(f"{test_case['name']} - Error: {str(e)}")
        return None

def run_comprehensive_tests():
    """Run comprehensive test suite"""
    
    print_header("CREDITXAI MODEL TESTING & EVALUATION")
    print(f"\nTest Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"API Endpoint: {BASE_URL}")
    
    # Health check first
    if not test_health_check():
        print_error("\nAPI is not available. Exiting...")
        return False
    
    # Test Cases
    test_cases = [
        {
            'name': 'Good Credit Profile - Middle Age Professional',
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
            },
            'expected': 'Approved'
        },
        {
            'name': 'Risky Profile - Young with High Amount',
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
            },
            'expected': 'Rejected'
        },
        {
            'name': 'Moderate Profile - Young Professional',
            'data': {
                'Age': 30,
                'Sex': 'male',
                'Job': 2,
                'Housing': 'own',
                'Saving accounts': 'moderate',
                'Checking account': 'moderate',
                'Credit_amount': 5000,
                'Duration': 24,
                'Purpose': 'car'
            },
            'expected': 'Approved'
        },
        {
            'name': 'Senior with Good Standing',
            'data': {
                'Age': 60,
                'Sex': 'male',
                'Job': 3,
                'Housing': 'own',
                'Saving accounts': 'quite rich',
                'Checking account': 'rich',
                'Credit_amount': 2000,
                'Duration': 12,
                'Purpose': 'radio/TV'
            },
            'expected': 'Approved'
        },
        {
            'name': 'High Risk - Long Duration Low Savings',
            'data': {
                'Age': 25,
                'Sex': 'female',
                'Job': 1,
                'Housing': 'rent',
                'Saving accounts': 'little',
                'Checking account': 'NA',
                'Credit_amount': 10000,
                'Duration': 60,
                'Purpose': 'business'
            },
            'expected': 'Rejected'
        }
    ]
    
    # Test Predictions
    print_section("2. Prediction Tests")
    prediction_results = []
    for i, test_case in enumerate(test_cases, 1):
        print(f"\nTest {i}/{len(test_cases)}:")
        result = test_prediction(test_case)
        if result:
            prediction_results.append({
                'test': test_case['name'],
                'expected': test_case['expected'],
                'actual': result['prediction_label'],
                'confidence': result['confidence']
            })
    
    # Test Complete Scoring (with explanation)
    print_section("3. Complete Scoring Tests (with Explanations)")
    for i, test_case in enumerate(test_cases[:3], 1):  # Test first 3 cases
        print(f"\nScoring Test {i}:")
        test_complete_scoring(test_case)
    
    # Summary
    print_section("4. Test Results Summary")
    if prediction_results:
        correct = sum(1 for r in prediction_results if r['expected'] == r['actual'])
        total = len(prediction_results)
        accuracy = (correct / total * 100) if total > 0 else 0
        
        print_info(f"Total Tests: {total}")
        print_info(f"Correct Predictions: {correct}")
        print_info(f"Test Accuracy: {accuracy:.1f}%")
        
        print("\nDetailed Results:")
        for r in prediction_results:
            status = "✓" if r['expected'] == r['actual'] else "✗"
            print_info(f"{status} {r['test']}")
            print_info(f"   Expected: {r['expected']} | Got: {r['actual']} | Confidence: {r['confidence']:.2%}")
    
    # Model Performance Metrics from Training
    print_section("5. Model Performance Metrics (From Training)")
    print_info("Training Results:")
    print_info("  • Accuracy: 91.0%")
    print_info("  • Precision: 90.2%")
    print_info("  • Recall: 92.0%")
    print_info("  • F1 Score: 91.1%")
    print_info("  • ROC-AUC: 96.4%")
    print_info("  • Cross-Validation ROC-AUC: 94.4% (±1.8%)")
    
    print_info("\nTop Feature Importances:")
    print_info("  1. Age: 40.65%")
    print_info("  2. Duration: 19.53%")
    print_info("  3. Credit amount: 19.24%")
    print_info("  4. Saving accounts: 10.56%")
    print_info("  5. Job: 3.22%")
    
    print_info("\nFairness Analysis:")
    print_info("  ⚠ Gender Disparate Impact: 0.736 (bias detected)")
    print_info("  ⚠ Age Group Disparate Impact: 0.149 (bias detected)")
    print_info("  → Recommendation: Consider reweighting/resampling")
    
    print_header("TEST COMPLETE")
    return True

if __name__ == "__main__":
    try:
        success = run_comprehensive_tests()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print(f"\n{YELLOW}Tests interrupted by user{RESET}")
        sys.exit(1)
    except Exception as e:
        print_error(f"Unexpected error: {str(e)}")
        sys.exit(1)
