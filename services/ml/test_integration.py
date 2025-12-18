#!/usr/bin/env python3
"""
Integration Test Script for CreditXAI ML Service
Tests all API endpoints and verifies model functionality
"""

import requests
import json
import time

BASE_URL = "http://localhost:8000"

def print_header(text):
    print("\n" + "=" * 80)
    print(f"  {text}")
    print("=" * 80)

def print_test(text):
    print(f"\n▶ {text}")

def print_success(text):
    print(f"  ✓ {text}")

def print_error(text):
    print(f"  ✗ {text}")

def test_health():
    """Test health check endpoint"""
    print_test("Testing Health Check Endpoint")
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print_success(f"Status: {data['status']}")
            print_success(f"Models Loaded: {data['models_loaded']}")
            return True
        else:
            print_error(f"Health check failed with status {response.status_code}")
            return False
    except Exception as e:
        print_error(f"Health check error: {str(e)}")
        return False

def test_predict():
    """Test prediction endpoint"""
    print_test("Testing Prediction Endpoint")
    
    test_cases = [
        {
            "name": "Excellent Credit Profile",
            "data": {
                "Age": 55,
                "Sex": "male",
                "Job": 3,
                "Housing": "own",
                "Saving accounts": "rich",
                "Checking account": "rich",
                "Credit_amount": 2000,
                "Duration": 12,
                "Purpose": "car"
            },
            "expected": "Approved"
        },
        {
            "name": "High Risk Profile",
            "data": {
                "Age": 23,
                "Sex": "female",
                "Job": 1,
                "Housing": "rent",
                "Saving accounts": "little",
                "Checking account": "little",
                "Credit_amount": 9000,
                "Duration": 48,
                "Purpose": "business"
            },
            "expected": "Rejected"
        }
    ]
    
    passed = 0
    for test in test_cases:
        try:
            response = requests.post(
                f"{BASE_URL}/predict",
                json=test['data'],
                headers={"Content-Type": "application/json"},
                timeout=10
            )
            
            if response.status_code == 200:
                result = response.json()
                decision = result['prediction_label']
                confidence = result['confidence']
                
                if decision == test['expected']:
                    print_success(f"{test['name']}: {decision} ({confidence:.1%} confidence)")
                    passed += 1
                else:
                    print_error(f"{test['name']}: Expected {test['expected']}, got {decision}")
            else:
                print_error(f"{test['name']}: HTTP {response.status_code}")
                
        except Exception as e:
            print_error(f"{test['name']}: {str(e)}")
    
    return passed == len(test_cases)

def test_score():
    """Test complete scoring endpoint"""
    print_test("Testing Complete Scoring Endpoint (with Explanation)")
    
    test_data = {
        "Age": 40,
        "Sex": "male",
        "Job": 2,
        "Housing": "own",
        "Saving accounts": "moderate",
        "Checking account": "moderate",
        "Credit_amount": 5000,
        "Duration": 24,
        "Purpose": "car"
    }
    
    try:
        response = requests.post(
            f"{BASE_URL}/score",
            json=test_data,
            headers={"Content-Type": "application/json"},
            timeout=15
        )
        
        if response.status_code == 200:
            result = response.json()
            pred = result['prediction']
            exp = result['explanation']
            
            print_success(f"Decision: {pred['prediction_label']}")
            print_success(f"Confidence: {pred['confidence']:.1%}")
            print_success(f"Risk Score: {pred['risk_score']:.1%}")
            
            if 'top_features' in exp and exp['top_features']:
                print_success("Top Features Retrieved:")
                for i, feat in enumerate(exp['top_features'][:3], 1):
                    print(f"      {i}. {feat['feature']}: {feat['abs_importance']:.4f}")
            
            return True
        else:
            print_error(f"Score endpoint failed: HTTP {response.status_code}")
            print_error(f"Response: {response.text}")
            return False
            
    except Exception as e:
        print_error(f"Score endpoint error: {str(e)}")
        return False

def test_performance():
    """Test API performance"""
    print_test("Testing API Performance (10 requests)")
    
    test_data = {
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
    
    times = []
    success = 0
    
    for i in range(10):
        try:
            start = time.time()
            response = requests.post(
                f"{BASE_URL}/predict",
                json=test_data,
                timeout=10
            )
            elapsed = time.time() - start
            
            if response.status_code == 200:
                times.append(elapsed)
                success += 1
        except Exception as e:
            print_error(f"Request {i+1} failed: {str(e)}")
    
    if times:
        avg_time = sum(times) / len(times)
        min_time = min(times)
        max_time = max(times)
        
        print_success(f"Successful Requests: {success}/10")
        print_success(f"Average Response Time: {avg_time*1000:.2f}ms")
        print_success(f"Min: {min_time*1000:.2f}ms | Max: {max_time*1000:.2f}ms")
        
        return success >= 8  # At least 80% success rate
    else:
        print_error("No successful requests")
        return False

def test_error_handling():
    """Test error handling"""
    print_test("Testing Error Handling")
    
    # Test with invalid data
    invalid_data = {
        "Age": -5,  # Invalid age
        "Sex": "male",
        "Job": 2
        # Missing required fields
    }
    
    try:
        response = requests.post(
            f"{BASE_URL}/predict",
            json=invalid_data,
            timeout=10
        )
        
        if response.status_code in [400, 422]:  # Validation error expected
            print_success(f"Correctly rejected invalid data (HTTP {response.status_code})")
            return True
        else:
            print_error(f"Unexpected status code: {response.status_code}")
            return False
            
    except Exception as e:
        print_error(f"Error handling test failed: {str(e)}")
        return False

def generate_integration_report(results):
    """Generate final integration report"""
    print_header("INTEGRATION TEST REPORT")
    
    total = len(results)
    passed = sum(results.values())
    percentage = (passed / total * 100) if total > 0 else 0
    
    print(f"\nTotal Tests: {total}")
    print(f"Passed: {passed}")
    print(f"Failed: {total - passed}")
    print(f"Success Rate: {percentage:.1f}%")
    
    print("\nTest Results:")
    for test_name, result in results.items():
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"  {status} - {test_name}")
    
    print("\n" + "=" * 80)
    
    if passed == total:
        print("  🎉 ALL TESTS PASSED - READY FOR INTEGRATION!")
    elif percentage >= 80:
        print("  ⚠️  MOSTLY PASSING - REVIEW FAILED TESTS BEFORE INTEGRATION")
    else:
        print("  ❌ MULTIPLE FAILURES - FIX ISSUES BEFORE INTEGRATION")
    
    print("=" * 80)
    
    return passed == total

def main():
    print_header("CREDITXAI ML SERVICE - INTEGRATION TESTS")
    print(f"\nAPI Endpoint: {BASE_URL}")
    print(f"Test Time: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Wait for server to be ready
    print_test("Waiting for server to be ready...")
    time.sleep(2)
    
    # Run all tests
    results = {}
    
    results["Health Check"] = test_health()
    time.sleep(0.5)
    
    results["Prediction Endpoint"] = test_predict()
    time.sleep(0.5)
    
    results["Complete Scoring"] = test_score()
    time.sleep(0.5)
    
    results["Performance Test"] = test_performance()
    time.sleep(0.5)
    
    results["Error Handling"] = test_error_handling()
    
    # Generate report
    all_passed = generate_integration_report(results)
    
    # Print integration instructions
    if all_passed:
        print_header("INTEGRATION INSTRUCTIONS")
        print("\n1. Spring Boot Backend Integration:")
        print("   - API is running on: http://localhost:8000")
        print("   - Swagger docs: http://localhost:8000/docs")
        print("   - Health check: GET /health")
        print("   - Prediction: POST /predict")
        print("   - Full scoring: POST /score")
        
        print("\n2. Sample Request Body:")
        print("""
   {
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
        """)
        
        print("\n3. Sample Response:")
        print("""
   {
     "prediction": 1,
     "prediction_label": "Approved",
     "probability_approved": 0.88,
     "probability_rejected": 0.12,
     "confidence": 0.88,
     "risk_score": 0.12
   }
        """)
        
        print("\n4. Next Steps:")
        print("   ✓ Update Spring Boot application.properties")
        print("   ✓ Create ML service client in Java")
        print("   ✓ Add API endpoints in Spring controllers")
        print("   ✓ Test end-to-end integration")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    try:
        exit(main())
    except KeyboardInterrupt:
        print("\n\nTests interrupted by user")
        exit(1)
    except Exception as e:
        print(f"\n\nFatal error: {str(e)}")
        exit(1)
