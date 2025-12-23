from app.predict import predict_score

def test_prediction_returns_float():
    result = predict_score(age=30, salary=5000, loan_amount=10000)
    assert isinstance(result, float)

def test_prediction_reasonable_range():
    result = predict_score(30, 5000, 10000)
    assert 0 <= result <= 1
