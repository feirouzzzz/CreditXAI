from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_predict_credit_score():
    payload = {
        "age": 30,
        "salary": 5000,
        "loan_amount": 10000
    }

    response = client.post("/predict", json=payload)
    assert response.status_code == 200
    result = response.json()
    assert "score" in result
    assert isinstance(result["score"], float)
